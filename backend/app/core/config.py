from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    app_name: str = "SpendWise"
    database_url: str = "sqlite:///./spendwise.db"
    upload_dir: str = "uploads"

    class Config:
        env_file = ".env"


settings = Settings()