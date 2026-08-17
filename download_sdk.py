import urllib.request
import os
import io
import zipfile
import shutil

url = 'https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip'
sdk = r'C:\Users\PC3\AppData\Local\Android\Sdk'
zip_path = os.path.join(sdk, 'cmdline-tools.zip')
dest = os.path.join(sdk, 'cmdline-tools', 'latest')

print(f'Downloading from {url}...')
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})

resp = urllib.request.urlopen(req, timeout=300)
total = int(resp.headers.get('Content-Length', 0))
print(f'Expected size: {total / 1024 / 1024:.1f} MB')

data = bytearray()
chunk_size = 1024 * 1024  # 1MB chunks
downloaded = 0

while True:
    chunk = resp.read(chunk_size)
    if not chunk:
        break
    data.extend(chunk)
    downloaded += len(chunk)
    if total > 0:
        pct = downloaded / total * 100
        print(f'\r  {downloaded / 1024 / 1024:.1f} / {total / 1024 / 1024:.1f} MB ({pct:.0f}%)', end='', flush=True)

print(f'\nTotal downloaded: {len(data)} bytes')

# Save zip
with open(zip_path, 'wb') as f:
    f.write(data)

# Extract
print('Extracting...')
buf = io.BytesIO(bytes(data))
with zipfile.ZipFile(buf) as z:
    entries = z.namelist()
    has_bat = any('sdkmanager.bat' in e for e in entries)
    print(f'Entries: {len(entries)}, Has sdkmanager.bat: {has_bat}')
    
    temp = os.path.join(sdk, 'cmdline-tools-temp')
    if os.path.exists(temp):
        shutil.rmtree(temp)
    z.extractall(temp)
    
    src = os.path.join(temp, 'cmdline-tools')
    if os.path.exists(dest):
        shutil.rmtree(dest)
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    shutil.move(src, dest)
    shutil.rmtree(temp, ignore_errors=True)
    
    bat = os.path.join(dest, 'bin', 'sdkmanager.bat')
    print(f'sdkmanager.bat exists: {os.path.exists(bat)}')

print('Done!')
