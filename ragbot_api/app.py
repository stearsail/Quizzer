from fastapi import FastAPI, UploadFile, File
from pathlib import Path
import uvicorn
import shutil
import process_pdf

app = FastAPI()

@app.post("/upload-pdf")
async def upload_pdf(file: UploadFile = File(...)):
    questions_json = await process_pdf.process_text(file)
    return questions_json

if __name__ == "__main__":

    uvicorn.run(app,host="0.0.0.0", port=8000)