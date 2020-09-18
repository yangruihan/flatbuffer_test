#!/usr/bin/env python3
# -*- coding:utf-8 -*-

"""
1. 根据 lua table 生成对应 json
2. 根据 fbs 将 json 转换成 bytes
"""

import os
import sys
import shutil


def main():
    for root, _, files in os.walk(sys.argv[1]):
        for f in files:
            if f.endswith(".lua"):
                fpath = os.path.join(root, f)
                fbsPath = fpath.replace(".lua", ".fbs")
                outputPath = fpath.replace(".lua", ".bin")
                jsonPath = fpath.replace(".lua", ".json")
                print(f"- start generate json {fpath} ...")
                print(f"exec lua table2json.lua {fpath} {jsonPath}")
                os.system(f"lua table2json.lua {fpath} {jsonPath}")
                print(f"- done generate json {fpath} ...")

                print(f"- start generate binary {fpath} ...")
                print(f"exec flatc.exe -b {fbsPath} {jsonPath}")
                os.system(f"flatc.exe -b {fbsPath} {jsonPath}")
                print(f"- done generate binary {fpath} ...\n\n")

                print(f"- start move binary to {outputPath} ...")
                shutil.move(f"./{f.replace('.lua', '.bin')}", outputPath)
                print(f"- done move binary to {outputPath} ...")


if __name__ == "__main__":
    main()
