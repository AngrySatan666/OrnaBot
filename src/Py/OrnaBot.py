
# <!-- [SS-0]: MetaData ----->
Version = "4.5.03"
Date = "8.28.2025"
Dev = "AngrySatan666"

Bugs=True

# <!-- [SS-1]: Imports ----->
import os
import time as t
from datetime import datetime
import subprocess
import shutil

# <!-- [SS-3]: Global Variables ----->
# /3.1/ Directory
_dir = os.path.dirname(os.path.abspath(__file__))
dat_dir = os.path.join(_dir, 'data')
sch_dir = os.path.join(dat_dir, 'schemas')
img_dir = os.path.join(_dir, 'img')

# /3.2/ File
static_db = os.path.join(dat_dir, 'static.db')
user_db = os.path.join(dat_dir, 'user.db')
testing = os.path.join(dat_dir, 'testing.jsonc')

# /3.3/ Static
environment = ""

# <!-- [SS-4]: Simple Functions ----->
# /4.1/ Console Debugging
def info (*args):
    if Bugs is True:
        for txt in args:
            print(f"[INFO] {txt}")
            print("")
            t.sleep(0.1)

def ok (*args):
    if Bugs is True:
        for txt in args:
            print(f"[OKAY] {txt}")
            print("")
            t.sleep(0.1)

def warn (*args):
    if Bugs is True:
        for txt in args:
            print(f"[WARN] {txt}")
            print("")
            t.sleep(0.1)

def error (*args):
    for txt in args:
        raise Exception(f"[ERROR] {txt}")

# /4.2/ Time Functions
def timer (x:int):
    fx = x
    while x > 0:
        print(f"\r{x} second(s)", end="", flush=True)
        t.sleep(1)
        x -= 1
    print("\r" + " " * 20 + "\r", end="", flush=True)
    print(f"Waited {fx} second(s)")
    print("")

def stamp(fx="min"):
    valid = ["ms", "s", "sec", "m", "min", "hr", "d", "day", "y"]
    if fx not in valid:
        error(f"'{fx}' is not a valid time format. Available options: {', '.join(valid)}")
    now = datetime.now()
    if fx == "ms":
        return now.strftime("%d-%m-%Y %H:%M:%S.%f")[:-3]
    elif fx in ["s", "sec"]:
        return now.strftime("%d-%m-%Y %H:%M:%S")
    elif fx in ["m", "min"]:
        return now.strftime("%d-%m-%Y %H:%M")
    elif fx == "hr":
        return now.strftime("%d-%m-%Y %H")
    elif fx in ["d", "day"]:
        return now.strftime("%d-%m-%Y")
    elif fx == "y":
        return now.strftime("%Y")

# /4.3/

# <!-- [SS-5]: Functions ----->
def start():
    info("Detecting Environment")
    global environment
    script_dir = _dir.lower()
    if '/data/data/com.termux/' in script_dir:
        environment = "Termux"
    elif script_dir[1:3] == ':\\' or script_dir.startswith('c:'):
        environment = "Windows"
    elif script_dir.startswith('/'):
        environment = "Linux"
    else:
        environment = "Unknown"
    ok(f"Environment detected: {environment}")
    info("Checking for Dependencies")
    if environment == "Windows" or environment == "Linux":
        scr = shutil.which("scrcpy")
        if scr:
            ok("scrcpy is installed.")
    if environment == "Termux":
        scr = shutil.which("adb")
        if scr:
            ok("adb is installed.")

# <!-- [SS-10]: Main ----->
def main():
    start()

if __name__ == "__main__":
    main()
