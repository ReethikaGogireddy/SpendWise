from fastapi import FastAPI
from app.core.db import Base, engine
from app.receipts.routes import router as receipts_router

Base.metadata.create_all(bind=engine)

app = FastAPI(title="SpendWise API")

app.include_router(receipts_router)

# This is the path that runs right after the API starts running
@app.get("/")
def root():
    return {"message": "SpendWise API is running"}