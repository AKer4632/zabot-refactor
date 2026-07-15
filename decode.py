#!/usr/bin/env python3
# decode.py - 合并且解码 zabot_single.zip
import base64

b64 = ""
with open("b64_part1.txt") as f: b64 += f.read()
with open("b64_part2.txt") as f: b64 += f.read()
with open("b64_part3.txt") as f: b64 += f.read()

data = base64.b64decode(b64)
with open("zabot_single.zip", "wb") as f:
    f.write(data)
print("zabot_single.zip decoded successfully")
