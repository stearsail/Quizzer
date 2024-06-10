from fastapi import FastAPI, HTTPException, UploadFile, File
import uvicorn
import process_pdf
import uuid
from pydantic import BaseModel
from cachetools import TTLCache

app = FastAPI()
cache = TTLCache(ttl=3600, maxsize=1000)

class GenerateQuizRequest(BaseModel):
    cache_key: str
    question_count: int

@app.get("/health-check")
async def health_check():
    return {'Status' : 'Running'}

@app.post("/upload-pdf") #Used to determine number of possible questions
async def upload_pdf(file: UploadFile = File(...)):
    texts = await process_pdf.determine_questions(file)
    cache_key = str(uuid.uuid4()) #universal unique identifier
    cache[cache_key] = texts
    return {'cache_key': cache_key,
            'available_texts': len(texts)}



@app.post("/process-text")
async def process_text(request: GenerateQuizRequest):   
    texts = cache.get(request.cache_key)
    print(request.question_count)
    if texts is None:
        raise HTTPException(status_code=404, detail="Session has expired or is invalid")
    questions_json = await process_pdf.process_text(texts, request.question_count)
    return questions_json

if __name__ == "__main__":

    uvicorn.run(app,host="0.0.0.0", port=8000)