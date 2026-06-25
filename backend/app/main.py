from fastapi import FastAPI
from app.core.db import Base, engine
from app.receipts.routes import router as receipts_router
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

Base.metadata.create_all(bind=engine)

app = FastAPI(title="SpendWise API")

app.add_middleware( # allowing cross orgin requests
    CORSMiddleware,
    allow_origins=["*"],  # tighten later
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(receipts_router)

# This is the path that runs right after the API starts running
@app.get("/")
def root():
    return {"message": "SpendWise API is running"}


@app.get("/health")
def health():
    return {"status": "ok, now you're connected"}