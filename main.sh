#!/bin/bash
set -e

# Update dan upgrade
sudo apt-get update
sudo apt-get upgrade -y

# Install dependencies
sudo apt-get install -y ffmpeg python3-pip python3-venv

# Buat virtualenv khusus yt-dlp
if [ ! -d "$HOME/yt-dlp-env" ]; then
    python3 -m venv ~/yt-dlp-env
fi

# Install yt-dlp versi tertentu di dalam virtualenv
~/yt-dlp-env/bin/pip install -U yt-dlp==2025.08.22

# Default cookies file
COOKIES_FILE="$HOME/cookies.txt"

# Minta input URL dari user
read -p "Masukkan URL video: " url

# Tampilkan format video (biar user bisa pilih)
if [ -f "$COOKIES_FILE" ]; then
    echo "Menggunakan cookies: $COOKIES_FILE"
    ~/yt-dlp-env/bin/yt-dlp -F --cookies "$COOKIES_FILE" "$url"
else
    echo "Cookies file tidak ditemukan, melanjutkan tanpa cookies..."
    ~/yt-dlp-env/bin/yt-dlp -F "$url"
fi

# Minta input pilihan video
read -p "Masukkan kode format VIDEO (kosongkan jika hanya audio): " video_fmt

# Audio default
audio_fmt="140-9"

# Tentukan kombinasi format
if [ -n "$video_fmt" ]; then
    format="${video_fmt}+${audio_fmt}"
else
    format="${audio_fmt}"
fi

# Download dengan nama file 1.<ekstensi_asli>
if [ -f "$COOKIES_FILE" ]; then
    ~/yt-dlp-env/bin/yt-dlp -f "$format" --cookies "$COOKIES_FILE" -o "1.%(ext)s" "$url"
else
    ~/yt-dlp-env/bin/yt-dlp -f "$format" -o "1.%(ext)s" "$url"
fi

# Cari file hasil download (1.mp4, 1.m4a, 1.webm, dll)
downloaded_file=$(ls 1.* | head -n 1)

# Jalankan ffmpeg.py untuk streaming
python3 ffmpeg.py "$downloaded_file"

