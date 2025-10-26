# This Python file uses the following encoding: utf-8
from PySide6.QtCore import QObject, Slot, Signal, QUrl
import instaloader
import os

class Downloader(QObject):
    # signal qml
    downloadProgress = Signal(str)
    mediaListReady = Signal(list)

    def __init__(self, parent=None):
        super().__init__(parent)
        self.home_path = os.path.expanduser("~")
        self.download_dir = os.path.join(self.home_path, "Downloads", "InstaDownloader")

        self.L = instaloader.Instaloader(
            dirname_pattern=self.download_dir, # custom directory for output download
           post_metadata_txt_pattern="", # ignore caption.txt file
           compress_json=False, # ignore *.json file
           save_metadata=False, # ignore download file *.json.xz
           filename_pattern="{owner_username}-{date_utc:%Y%m%d_%H%M%S}", # custom format filename donwload
           quiet=True, # silent verbose
           download_video_thumbnails=False # ignore thumbnail when download video post
        )

        self.list_media()

        print("downloader is ready1")

    @Slot(str)
    def downloader(self, url):
        self.downloadProgress.emit(f"Downloading: {url}")

        os.makedirs(self.download_dir, exist_ok=True)
        post_short_code = self.parse_url(url)

        if (not post_short_code):
            self.downloadProgress.emit("Please insert url")
            return

        try:
            post = instaloader.Post.from_shortcode(self.L.context, post_short_code)
            self.L.download_post(post, target=post_short_code)
            self.downloadProgress.emit(f"Success download {url}")
            self.list_media()

        except Exception as err:
            print(err)
            self.downloadProgress.emit("Failed download post")


    def parse_url(self, url):
        parts = url.strip('/').split('/')
        return parts[-1] if parts else None

    @Slot(result=list)
    def list_media(self):
        file_data = []

        if not os.path.exists(self.download_dir):
            self.mediaListReady.emit([])
            return

        for item in os.listdir(self.download_dir):
            path = os.path.join(self.download_dir, item)

            file_type = "file"
            if item.lower().endswith(('.jpg', '.jpeg', '.png', '.gif')):
                file_type = "image"
            else:
                file_type = "video"

            file_url_qml = QUrl.fromLocalFile(path).toString()
            file_data.append({
                            "name": item,
                            "type": file_type,
                            "url": file_url_qml
                        })
        self.mediaListReady.emit(file_data)

