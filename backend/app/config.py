import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    ACRCLOUD_ACCESS_KEY: str = os.getenv("ACRCLOUD_ACCESS_KEY", "")
    ACRCLOUD_ACCESS_SECRET: str = os.getenv("ACRCLOUD_ACCESS_SECRET", "")
    ACRCLOUD_HOST: str = os.getenv("ACRCLOUD_HOST", "identify-ap-southeast-1.acrcloud.com")
    DATABASE_URL: str = os.getenv("DATABASE_URL", "postgresql://localhost/vgm_music_db")
    API_HOST: str = os.getenv("API_HOST", "0.0.0.0")
    API_PORT: int = int(os.getenv("API_PORT", "8000"))
    CORS_ORIGINS: list = ["*"]
    
    def validate(self):
        if not self.ACRCLOUD_ACCESS_KEY:
            raise ValueError("ACRCLOUD_ACCESS_KEY is not set in .env file")
        if not self.ACRCLOUD_ACCESS_SECRET:
            raise ValueError("ACRCLOUD_ACCESS_SECRET is not set in .env file")
        return True

settings = Settings()
