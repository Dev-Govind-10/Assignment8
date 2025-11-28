
import json
from typing import Dict, Any, List

FILE_PATH = "names.json"

def get_data() -> List[Dict[str, Any]]:
    """Read and return JSON data from names.json"""
    try:
        with open(FILE_PATH, "r") as f:
            return json.load(f)
    except FileNotFoundError:
        return []  # file doesn’t exist yet
    except json.JSONDecodeError:
        return []  # file is empty or invalid


def set_data(data: Dict[str, Any]) -> None:
    """Append a new record into names.json"""
    existing_data = get_data()
    existing_data.append(data)
    with open(FILE_PATH, "w") as f:
        json.dump(existing_data, f, indent=4)
