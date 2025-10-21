import base64
import hashlib
import hmac
import time
import requests
from typing import Dict, Optional
from app.config import settings

class ACRCloudService:
    def __init__(self):
        self.access_key = settings.ACRCLOUD_ACCESS_KEY
        self.access_secret = settings.ACRCLOUD_ACCESS_SECRET
        self.host = settings.ACRCLOUD_HOST
        self.endpoint = "/v1/identify"
        self.signature_version = "1"
        self.data_type = "audio"
        
    def _generate_signature(self, string_to_sign: str) -> str:
        return base64.b64encode(
            hmac.new(
                self.access_secret.encode('utf-8'),
                string_to_sign.encode('utf-8'),
                digestmod=hashlib.sha1
            ).digest()
        ).decode('utf-8')
    
    def recognize_audio(self, audio_data: bytes) -> Dict:
        timestamp = str(int(time.time()))
        string_to_sign = f"POST\n{self.endpoint}\n{self.access_key}\n{self.data_type}\n{self.signature_version}\n{timestamp}"
        signature = self._generate_signature(string_to_sign)
        
        files = {'sample': audio_data}
        data = {
            'access_key': self.access_key,
            'sample_bytes': len(audio_data),
            'timestamp': timestamp,
            'signature': signature,
            'data_type': self.data_type,
            'signature_version': self.signature_version
        }
        
        url = f"https://{self.host}{self.endpoint}"
        
        try:
            response = requests.post(url, files=files, data=data, timeout=10)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            return {"status": {"msg": f"Request failed: {str(e)}", "code": 3000}}
    
    def parse_response(self, response: Dict) -> Optional[Dict]:
        try:
            status = response.get("status", {})
            if status.get("code") != 0:
                return None
            
            metadata = response.get("metadata", {})
            if not metadata or "music" not in metadata:
                return None
            
            music = metadata["music"][0]
            result = {
                "title": music.get("title", "Unknown"),
                "artist": music.get("artists", [{}])[0].get("name", "Unknown") if music.get("artists") else "Unknown",
                "album": music.get("album", {}).get("name", "Unknown"),
                "release_date": music.get("release_date", "Unknown"),
                "duration_ms": music.get("duration_ms", 0),
                "score": music.get("score", 0),
                "external_metadata": {
                    "spotify": music.get("external_metadata", {}).get("spotify", {}),
                    "youtube": music.get("external_metadata", {}).get("youtube", {}),
                },
                "genres": music.get("genres", []),
                "label": music.get("label", "Unknown")
            }
            return result
        except (KeyError, IndexError, TypeError) as e:
            print(f"Error parsing ACRCloud response: {e}")
            return None

acrcloud_service = ACRCloudService()
