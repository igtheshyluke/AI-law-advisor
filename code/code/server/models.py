from typing import Dict, Any


class WebPage:
    def __init__(self):
        self.id: int = 0
        self.is_skip: bool = False
        self.url: str = ""
        self.title: str = ""
        self.updated_time = ""

    def from_dict(self, d: Dict[str, Any]) -> None:
        self.id: int = d["id"]
        self.is_skip: bool = bool(d["is_skip"])
        self.url: str = d["url"]
        self.title: str = d["title"]
        self.updated_time = d["updated_time"]

    def to_dict(self) -> Dict[str, Any]:
        return {
            "id": self.id,
            "is_skip": self.is_skip,
            "url": self.url,
            "title": self.title,
            "updated_time": self.updated_time,
        }
