import logging
from datetime import datetime


class Logger:
    def __init__(self):
        self.logger = logging.getLogger("logger")
        self.logger.setLevel(logging.DEBUG)
        log_formatter = logging.Formatter("%(asctime)s [%(levelname)-5s] %(message)s")

        file_handler = logging.FileHandler(f"./logs/log_{datetime.now().strftime('%Y.%m.%d_%H.%M.%S')}.log")
        file_handler.setFormatter(log_formatter)
        file_handler.setLevel(logging.INFO)
        self.logger.addHandler(file_handler)

        console_handler = logging.StreamHandler()
        console_handler.setFormatter(log_formatter)
        console_handler.setLevel(logging.DEBUG)
        self.logger.addHandler(console_handler)

    def debug(self, msg: str) -> None:
        self.logger.debug(msg)

    def info(self, msg: str) -> None:
        self.logger.info(msg)

    def error(self, msg: str) -> None:
        self.logger.error(msg)
