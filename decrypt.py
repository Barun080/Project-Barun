import re

with open('d:/สคริป/2k_LootToForge.luau', 'r', encoding='utf-8') as f:
    code = f.read()

k_match = re.search(r'local _2k_k_248468 = "([^"]+)"', code)
key = k_match.group(1).encode('utf-8')
k_len = len(key)

table_start = code.find('local _2k_c_6f9802 = {')
table_end = code.find('local function _2k_d_6b4f23()', table_start)
table_str = code[table_start:table_end]

chunk_matches = re.findall(r'\{([0-9,]+)\}', table_str)
print(f'Found {len(chunk_matches)} chunks')

global_idx = 0
out_bytes = bytearray()

for chunk_str in chunk_matches:
    nums = [int(n.strip()) for n in chunk_str.split(',') if n.strip()]
    for enc_val in nums:
        kb = key[global_idx % k_len]
        offset_sub = (enc_val - (global_idx * 7)) % 256
        orig_byte = offset_sub ^ kb
        out_bytes.append(orig_byte)
        global_idx += 1

decompiled = out_bytes.decode('utf-8', errors='replace')
with open('d:/สคริป/2k_decrypted_LootToForge.lua', 'w', encoding='utf-8') as f:
    f.write(decompiled)

print(f'Successfully decrypted {len(decompiled)} chars ({len(out_bytes)} bytes)')
