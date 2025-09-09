import subprocess

def start_stream(video_file):
    # Input RTMP + stream key langsung
    full_url = input("Masukkan RTMP URL + Stream Key (contoh: rtmp://a.rtmp.youtube.com/live2/xxxx-xxxx-xxxx-xxxx): ").strip()

    command = [
        "ffmpeg",
        "-re",
        "-stream_loop", "-1",   # tetap bisa, tapi restart biasanya kelihatan
        "-i", video_file,
        "-c:v", "libx264",
        "-preset", "veryfast",
        "-maxrate", "3000k",
        "-bufsize", "6000k",
        "-pix_fmt", "yuv420p",
        "-c:a", "aac",
        "-b:a", "128k",
        "-f", "flv",
        full_url
    ]

    print(f"[INFO] Mulai streaming {video_file} ke {full_url}")
    subprocess.run(command)


if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Usage: python3 ffmpeg.py <video_file>")
        sys.exit(1)

    video_file = sys.argv[1]
    start_stream(video_file)
