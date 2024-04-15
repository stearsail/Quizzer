from fastapi import FastAPI, UploadFile, File
from pathlib import Path
import uvicorn
import shutil
import split_docs

app = FastAPI()

@app.post("/upload-pdf")
async def upload_pdf(file: UploadFile = File(...)):
    # Ensure the directory exists
    pdf_dir = Path("ragbot_api/pdf_documents")
    pdf_dir.mkdir(parents=True, exist_ok=True)

    # Construct the file path where the file will be saved
    file_path = pdf_dir / Path(file.filename).name

    # Save the uploaded file
    with file_path.open("wb") as buffer:
       while data := await file.read(1024 * 1024):  # Read in chunks of 1MB
            buffer.write(data)

    return {"filename": file.filename, "content-type": file.content_type}

if __name__ == "__main__":

    uvicorn.run(app,host="0.0.0.0", port=8000)