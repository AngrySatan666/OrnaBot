## <!-- [SS-0]: Meta Data -----> ##
Version = '3.3.6'
Release = 'Alpha'
Date = '4/26/25'
Author = 'Ikari No Akuma'
Desc = [
    {"Does" : "Automatically Grinds Orna GPS RPG Gameplay in the most efficent manner possible."},
    {"3rd-Party-Resources" : "Uses Adb & ScrCpy to Screen Mirror the Android Device playing Orna, then uses ADB commands to control the device leaving the PC controls free and running 'in the background'."},
    {"How" : "Uses pyautogui image detection methods and a prebuilt library of images to detect content on the screen and script functions to interact with the content as deemed fit."},
    {"Goal" : "To track everything the bot does from beggining to end and Gets the used Character to Global Rank #1, in most or all ranking systems, LeaderBoards."},
    {"Iteration" : "This is the 3rd Iteration of OrnaBot and will greatly surpass all previous generations in terms of efficency, statistic tracking, and bot knowledge."},
    {"Build-Ops" : "This was originally for Windows only, adding same device support via Autux, and linux support"}
]

## <!-- [SS-1]: Imports -----> ##
import os, sys
import subprocess
import pyautogui
import time
import sqlite3

## <!-- [SS-2]: Variables -----> ##
_dir = None
dat_dir = None
img_dir = None
db_dir = None
mig_dir = None
sch_dir = None
fx = None

## <!-- [SS-3]: Snippet Functions -----> ##
def prints (*args) :
    for txt in args :
        print (f"{txt}")

def base_dir () :
    global _dir, dat_dir, img_dir, db_dir, mig_dir, sch_dir, fx
    if getattr(sys, 'frozen', False) :
        _dir = os.path.dirname(sys.executable)
        prints ("Running as exe")
    else :
        _dir = os.path.dirname(os.path.abspath(__file__))
        prints ("Running as script")
    dat_dir = os.path.join (f'{_dir}', 'data')
    img_dir = os.path.join (f'{dat_dir}', 'images')
    db_dir = os.path.join (f'{_dir}', 'database')
    mig_dir = os.path.join (f'{db_dir}', 'migrations')
    sch_dir = os.path.join (f'{db_dir}', 'schemas')
    fx = os.path.join (f'{img_dir}', 'screen.png')
    os.makedirs(dat_dir, exist_ok=True)
    os.makedirs(img_dir, exist_ok=True)
    os.makedirs(db_dir, exist_ok=True)
    os.makedirs(mig_dir, exist_ok=True)
    os.makedirs(sch_dir, exist_ok=True)

def adb_tap (x, y) :
    cmd = f'adb shell input tap {x} {y}'
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    prints (f'Output: {result.stdout.strip()}')
    if result.stderr :
        prints (f'Error: {result.stderr.strip()}')

def adb_screenshot (fx=fx):
    with open(fx, 'wb') as f:
        subprocess.run ('adb exec-out screencap -p', shell=True, stdout=f)

def adb_run (pkg) :
    cmd = f'adb shell monkey -p {pkg} -c android.intent.category.LAUNCHER 1'
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.stdout:
        prints ("[ADB OUTPUT]")
        prints (result.stdout.strip())
    if result.stderr:
        prints ("[ADB ERROR]")
        prints (result.stderr.strip())

def ScrCpy (x, y) : 
    cmd = f'scrcpy --window-x {x} --window-y {y}'
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    time.sleep (1)

## <!-- [SS-4]: DataBase Functions -----> ##
def Init_dB():
    battle_db = os.path.join(db_dir, "battle.db")
    player_db = os.path.join(db_dir, "player.db")
    creature_db = os.path.join(db_dir, "creature.db")
    shops_db = os.path.join(db_dir, "shops.db")
    stats_db = os.path.join(db_dir, "stats.db")
    items_db = os.path.join(db_dir, "items.db")
    battle_schema = os.path.join(sch_dir, "battle.schema.sql")
    player_schema = os.path.join(sch_dir, "player.schema.sql")
    creature_schema = os.path.join(sch_dir, "creature.schema.sql")
    shops_schema = os.path.join(sch_dir, "shops.schema.sql")
    stats_schema = os.path.join(sch_dir, "stats.schema.sql")
    items_schema = os.path.join(sch_dir, "items.schema.sql")
    db_schema_pairs = [
        (battle_db, battle_schema),
        (player_db, player_schema),
        (creature_db, creature_schema),
        (shops_db, shops_schema),
        (stats_db, stats_schema),
        (items_db, items_schema)
    ]
    for db_path, schema_path in db_schema_pairs:
        if not os.path.exists(db_path):
            prints(f"Initializing {db_path}...")
            with open(schema_path, 'r') as file:
                schema_sql = file.read()
            with sqlite3.connect(db_path) as conn:
                cursor = conn.cursor()
                cursor.executescript(schema_sql)
            prints(f"{db_path} Initialized Successfully")
        else:
            prints(f"{db_path} Already Initialized")

## <!-- [SS-5]: Script Functions -----> ##


## <!-- [SS-6]: Run -----> ##
if __name__ == "__main__" :
    base_dir ()