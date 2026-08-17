import sys

sys.stdout.reconfigure(encoding='utf-8')

filepath = r'C:\Users\PC3\Desktop\invoice-flutter\lib\main.dart'

with open(filepath, 'rb') as f:
    raw = f.read()

# The file is UTF-8, but Arabic was double-encoded:
# Original UTF-8 bytes -> read as CP1256 -> re-encoded as UTF-8
# To fix: current UTF-8 text -> encode to CP1256 -> decode as UTF-8

text = raw.decode('utf-8-sig')

# Test on a known corrupted section first
test = text[282*10:282*10+100]  # around line 282
print(f'Before: {repr(test[:80])}')

try:
    # First verify on the known sample
    sample = 'ظ…ظ†ط´ط¦'
    fixed = sample.encode('cp1256').decode('utf-8')
    print(f'Sample fix: {sample} -> {fixed}')
    
    # Now fix the entire file
    # CP1256 is ASCII-compatible for 0x00-0x7F, so ASCII/Dart code won't be affected
    fixed_bytes = text.encode('cp1256')
    result = fixed_bytes.decode('utf-8')
    
    # Verify: check that Dart keywords are still intact
    assert 'import' in result
    assert 'class ' in result
    assert 'Widget' in result
    assert 'BuildContext' in result
    print('Dart keywords intact!')
    
    # Check Arabic was fixed
    assert 'منشئ الفواتير' in result or 'فاتورة' in result
    print('Arabic text fixed!')
    
    # Count Arabic chars before and after
    import unicodedata
    arabic_before = sum(1 for c in text if '\u0600' <= c <= '\u06FF' or '\uFB50' <= c <= '\uFDFF' or '\uFE70' <= c <= '\uFEFF')
    arabic_after = sum(1 for c in result if '\u0600' <= c <= '\u06FF' or '\uFB50' <= c <= '\uFDFF' or '\uFE70' <= c <= '\uFEFF')
    print(f'Arabic chars before: {arabic_before}, after: {arabic_after}')
    
    # Show some fixed lines
    lines = result.split('\n')
    for i, line in enumerate(lines):
        if 'فاتورة' in line or 'منشئ' in line or 'العملاء' in line or 'الرئيسية' in line:
            print(f'  Line {i+1}: {line.strip()[:100]}')
            if i > 300:
                break
    
    # Write the fixed file
    with open(filepath, 'w', encoding='utf-8-sig') as f:
        f.write(result)
    
    print(f'\nFile fixed! Size: {len(result)} chars')
    
except Exception as e:
    print(f'Error: {e}')
    import traceback
    traceback.print_exc()
