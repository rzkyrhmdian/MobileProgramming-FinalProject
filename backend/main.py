import os
import json
import tempfile

from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import google.generativeai as genai

# Load environment variables
load_dotenv()

app = FastAPI(
    title="Si Patuh - Smart Scan API",
    description="Backend API untuk ekstraksi informasi plat kendaraan menggunakan Gemini AI",
    version="1.0.0",
)

# CORS middleware agar Flutter bisa mengakses API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Konfigurasi Gemini API
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if not GEMINI_API_KEY:
    raise ValueError("GEMINI_API_KEY tidak ditemukan di environment variables. Buat file .env berdasarkan .env.example")

genai.configure(api_key=GEMINI_API_KEY)

# System prompt
SYSTEM_PROMPT = """You are an AI specialized in extracting vehicle plate information from images.

Your task is to analyze the given image and extract:
1. Vehicle plate number
2. Registration expiration date (masa berlaku)

IMPORTANT RULES:
- Always return output in JSON format ONLY (no explanation, no additional text).
- If information is not found, return null for that field.
- Do not hallucinate or guess unclear values.
- Normalize the plate format into Indonesian standard (e.g., "L 1234 AB").
- Extract expiration date into format: MM.YY (example: "05.31").
- Ignore unrelated text in the image.

OUTPUT FORMAT:
{
  "plat": string or null,
  "masa_berlaku": string or null
}

EXAMPLES:

Input image contains:
"Police number: L 1234 AB, valid until 05-2027"
Output:
{
  "plat": "L 1234 AB",
  "masa_berlaku": "05.27"
}

Input image contains:
"DK 9876 XY berlaku s.d. 11/2026"
Output:
{
  "plat": "DK 9876 XY",
  "masa_berlaku": "11.26"
}

Input image contains unclear data:
Output:
{
  "plat": null,
  "masa_berlaku": null
}"""


@app.get("/")
async def root():
    """Health check endpoint."""
    return {"status": "ok", "service": "Si Patuh - Smart Scan API"}


@app.post("/api/v1/scan-plate")
async def scan_plate(file: UploadFile = File(...)):
    """
    Endpoint untuk scan plat kendaraan.
    
    Menerima file gambar (JPEG/PNG) via multipart/form-data,
    memproses dengan Gemini AI, dan mengembalikan informasi plat.
    
    Request:
        - Content-Type: multipart/form-data
        - Body: file (gambar JPEG/PNG)
    
    Response:
        {
            "plat": "L 1234 AB" | null,
            "masa_berlaku": "05.31" | null
        }
    """
    # Validasi tipe file
    allowed_types = ["image/jpeg", "image/png", "image/jpg"]
    if file.content_type not in allowed_types:
        raise HTTPException(
            status_code=400,
            detail=f"Tipe file tidak didukung: {file.content_type}. Gunakan JPEG atau PNG.",
        )

    try:
        # Baca file gambar
        image_bytes = await file.read()
        
        if len(image_bytes) == 0:
            raise HTTPException(status_code=400, detail="File gambar kosong.")

        # Simpan ke temp file untuk di-upload ke Gemini
        suffix = ".jpg" if "jpeg" in (file.content_type or "") or "jpg" in (file.content_type or "") else ".png"
        
        with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
            tmp.write(image_bytes)
            tmp_path = tmp.name

        try:
            # Upload gambar ke Gemini
            uploaded_file = genai.upload_file(tmp_path, mime_type=file.content_type)
            
            # Inisialisasi model Gemini
            model = genai.GenerativeModel(
                model_name="gemini-2.0-flash",
                system_instruction=SYSTEM_PROMPT,
            )
            
            # Generate response dari Gemini
            response = model.generate_content(
                [uploaded_file, "Analyze this vehicle plate image and extract the information."],
            )
            
            # Parse response JSON
            response_text = response.text.strip()
            
            # Bersihkan markdown code block jika ada
            if response_text.startswith("```"):
                lines = response_text.split("\n")
                # Hapus baris pertama (```json) dan baris terakhir (```)
                lines = [l for l in lines if not l.strip().startswith("```")]
                response_text = "\n".join(lines).strip()
            
            result = json.loads(response_text)
            
            # Validasi format response
            plate_info = {
                "plat": result.get("plat"),
                "masa_berlaku": result.get("masa_berlaku"),
            }
            
            return plate_info
            
        finally:
            # Bersihkan temp file
            os.unlink(tmp_path)

    except json.JSONDecodeError as e:
        raise HTTPException(
            status_code=500,
            detail=f"Gagal memparsing response dari AI: {str(e)}",
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Terjadi kesalahan saat memproses gambar: {str(e)}",
        )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
