import os
from datetime import datetime
from logging.handlers import TimedRotatingFileHandler


def get_log_dir():
    now = datetime.now()  # Get the current date dynamically at runtime
    # today = datetime.today()

    # base_log_dir = os.path.join("logs", f"{now.year}", f"{now.month:02d}", f"{now.day:02d}")

    base_log_dir = os.path.join("/home", "mall-logs", f"{now.year}")
    log_dir_path = os.path.join(base_log_dir, f"{now.month:02d}", f"{now.day:02d}")
    os.makedirs(log_dir_path, exist_ok=True)  # Ensure directory exists
    return log_dir_path


class CustomTimedRotatingFileHandler(TimedRotatingFileHandler):
    def __init__(self, filename_prefix, **kwargs):
        self.filename_prefix = filename_prefix
        log_dir = get_log_dir()  # Get fresh log directory
        filename = os.path.join(log_dir, f"{filename_prefix}-{datetime.now().strftime('%d-%m-%Y')}.log")
        super().__init__(filename, **kwargs)

    def emit(self, record):
        self.baseFilename = os.path.join(get_log_dir(), f"{self.filename_prefix}-{datetime.now().strftime('%d-%m-%Y')}.log")
        super().emit(record)
