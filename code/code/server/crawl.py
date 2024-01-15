import csv
import os
import re
import requests
from typing import List
from bs4 import BeautifulSoup
from datetime import datetime
from server.logger import Logger
from server.models import WebPage


def _save_webpage(webpage: WebPage, logger: Logger):
    logger.info(f"Requesting webpage [{webpage.url}].")
    headers = {
        "Accept": "text/html",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    }
    response = requests.get(url=webpage.url, headers=headers)
    response.encoding = "utf-8"

    if response.status_code != 200:
        logger.error(f"Failed to request webpage.")
        return

    soup = BeautifulSoup(markup=response.text, features="html.parser")
    title = soup.title.string.strip()
    content = soup.text
    content = re.sub(r"\n+", "\n", content)

    for filename in os.listdir("pages"):
        if filename.startswith(f"{webpage.id}_"):
            os.remove(f"pages/{filename}")

    with open(f"pages/{webpage.id}_{title}.txt", "w") as file:
        file.write(content)
    logger.info(f"Saved webpage to file.")

    webpage.title = title
    webpage.updated_time = datetime.now().strftime('%Y.%m.%d %H:%M:%S')
    logger.info(f"Updated webpage record.")


def save_webpages(logger: Logger) -> None:
    webpage_list: List[WebPage] = []
    with open("pages.csv", "r") as file:
        reader = csv.DictReader(file)
        webpage_list = [row for row in reader]

    print()

    for webpage in webpage_list:
        if webpage.is_skip:
            continue
        _save_webpage(webpage, logger)


def demo_save_webpage(logger: Logger) -> None:
    webpage = WebPage()
    webpage.id = 0
    webpage.url = "https://www.gov.cn/xinwen/2020-06/01/content_5516649.htm"
    _save_webpage(webpage, logger)


def main() -> None:
    logger = Logger()
    demo_save_webpage(logger)


if __name__ == '__main__':
    main()
