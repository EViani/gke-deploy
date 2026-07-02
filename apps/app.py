from datetime import datetime, time
from fastapi import FastAPI

app = FastAPI()

@app.get("/status")
def health():
    return {"status":"OK"}

@app.get("/data")
def get_data():
    return {"date":datetime.now()}
