#!/usr/bin/env python3
#-*- coding:utf-8 -*-

"""
使用 fbs 生成对应的 lua 脚本
"""

import os
import sys

def main():
    for root, _, files in os.walk(sys.argv[1]):
        for f in files:
            if f.endswith(".fbs"):
                fpath = os.path.join(root, f)
                print(f"- start handle {fpath} ...")
                print(f"exec flatc.exe --lua {fpath}")
                os.system(f"flatc.exe --lua {fpath}")
                print(f"- done handle {fpath} ...")

if __name__ == "__main__":
    main()
