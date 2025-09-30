#!/usr/bin/env python3

# <!-- [SS-0]: MetaData ----->
Version = "4.28"
Date = "8.28.2025"
Dev = "AngrySatan666"

Bugs=True

# <!-- [SS-1]: Imports ----->
import os, sys
import datetime, time
import pyautogui
import sqlite3
import json
import subprocess
import threading
import pytesseract

# <!-- [SS-3]: Global Variables ----->
# /3.1/ Directory
_dir = os.path.dirname(os.path.abspath(__file__))
data_dir = os.path.join(_dir, 'data')
img_dir = os.path.join(_dir, 'img')
schema_dir = os.path.join(data_dir, 'schemas')

# /3.2/ File
stdb_path = os.path.join(data_dir, 'static.db')
usrdb_path = os.path.join(data_dir, 'user.db')

# /3.3/ Static
scrcpy_reg = None

# <!-- [SS-4]: Simple Functions ----->
# /4.1/ Logging
def Info (*args):
    if Bugs is True:
        for txt in args:
            print(f"[INFO] {txt}")
            print("")
            time.sleep(0.1)

def Warn (*args):
    if Bugs is True:
        for txt in args:
            print(f"[WARN] {txt}")
            print("")
            time.sleep(0.1)

def Error (*args):
    for txt in args:
        raise Exception(f"[ERROR] {txt}")

# /4.2/ Device Controls
def Click(x,y,r=None):
    if r is None:
        r = 1
    device_x, device_y = Coord(x, y)
    if device_x is None or device_y is None:
        return
    while r > 0:
        os.system(f"adb shell input tap {device_x} {device_y}")
        r -= 1

def Hold(x,y,d=None):
    if d is None:
        d = 1
    device_x, device_y = Coord(x, y)
    if device_x is None or device_y is None:
        return
    os.system(f"adb shell input touchscreen swipe {device_x} {device_y} {device_x} {device_y} {int(d*1000)}")

def Drag(x1, y1, x2, y2, d=None):
    if d is None:
        d = 1
    device_x1, device_y1 = Coord(x1, y1)
    device_x2, device_y2 = Coord(x2, y2)
    if None in [device_x1, device_y1, device_x2, device_y2]:
        return
    os.system(f"adb shell input swipe {device_x1} {device_y1} {device_x2} {device_y2} {int(d*1000)}")

def Pinch(dir=None, dist=None, dur=None):
    if dur is None:
        dur = 0.5
    if dist is None:
        dist = 20
    if dir is None:
        dir = "in"
    if scr_reg is None:
        Error("scr_reg not set. Call Initiate() first.")
        return
    center_x = 1080 // 2
    quarter_y = 2400 // 4
    three_quarter_y = 3 * 2400 // 4
    if dir == "in" or dir == 1:
        os.system(f"adb shell input swipe {center_x} {quarter_y} {center_x} {quarter_y + dist} {int(dur*1000)}")
        os.system(f"adb shell input swipe {center_x} {three_quarter_y} {center_x} {three_quarter_y - dist} {int(dur*1000)}")
    elif dir == "out" or dir == 0:
        os.system(f"adb shell input swipe {center_x} {quarter_y + dist} {center_x} {quarter_y} {int(dur*1000)}")
        os.system(f"adb shell input swipe {center_x} {three_quarter_y - dist} {center_x} {three_quarter_y} {int(dur*1000)}")

def Rotate(dir=None, dist=None, dur=None):
    if dir is None:
        dir = "r"
    if dist is None:
        dist = 100
    if dur is None:
        dur = 0.5
    center_x = 1080 // 2
    center_y = 2400 // 2
    if dir == "r" or dir == "right":
        os.system(f"adb shell input swipe {center_x - dist} {center_y} {center_x} {center_y - dist} {int(dur*1000)}")
        os.system(f"adb shell input swipe {center_x + dist} {center_y} {center_x} {center_y + dist} {int(dur*1000)}")
    elif dir == "l" or dir == "left":
        os.system(f"adb shell input swipe {center_x - dist} {center_y} {center_x} {center_y + dist} {int(dur*1000)}")
        os.system(f"adb shell input swipe {center_x + dist} {center_y} {center_x} {center_y - dist} {int(dur*1000)}")

# /4.3/ Calculation Functions
def Coord(x,y):
    if scr_reg is None:
        Error("scr_reg not set. Call Initiate() first.")
        return None, None
    window_x = x - scr_reg['x']
    window_y = y - scr_reg['y']
    scale_x = 1080 / 270
    scale_y = 2400 / 600
    device_x = int(window_x * scale_x)
    device_y = int(window_y * scale_y)
    return device_x, device_y

# <!-- [SS-5]: Databasing Functions ----->
# /5.1/ Startup
def Initiate():
    # /5.1.1/ Create Directory and Files
    if not os.path.exists(data_dir):
        os.makedirs(data_dir)
    if not os.path.exists(img_dir):
        os.makedirs(img_dir)

    # /5.1.2/ Create Schema Directory and Process Databases
    if not os.path.exists(schema_dir):
        os.makedirs(schema_dir)
    schema_config = {
        'static.schema.sql': {
            'db_name': 'static.db',
            'expected_tables': ['Coords']
        },
        'user.schema.sql': {
            'db_name': 'user.db',
            'expected_tables': ['Personal', 'Accounts']
        }
    }
    for schema_file, config in schema_config.items():
        schema_path = os.path.join(schema_dir, schema_file)
        db_path = os.path.join(data_dir, config['db_name'])
        Info(f"Processing {schema_file} -> {config['db_name']}")
        Info(f"Schema path: {schema_path}")
        Info(f"Schema exists: {os.path.exists(schema_path)}")
        Info(f"DB path: {db_path}")
        Info(f"DB exists: {os.path.isfile(db_path)}")
        if not os.path.isfile(db_path):
            Info(f"Creating {config['db_name']}...")
            conn = sqlite3.connect(db_path)
            conn.close()
        if os.path.exists(schema_path):
            schema_needed = True
            try:
                conn = sqlite3.connect(db_path)
                cursor = conn.cursor()
                cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
                existing_tables = {row[0] for row in cursor.fetchall()}
                conn.close()
                Info(f"Existing tables in {config['db_name']}: {list(existing_tables)}")
                Info(f"Expected tables: {config['expected_tables']}")

                if config['expected_tables'] and all(table in existing_tables for table in config['expected_tables']):
                    Info(f"{config['db_name']} exists with all required tables: {config['expected_tables']}")
                    schema_needed = False
                else:
                    missing = [t for t in config['expected_tables'] if t not in existing_tables]
                    if missing:
                        Info(f"{config['db_name']} missing tables: {missing}")
                    else:
                        Info(f"No expected tables defined or checking logic issue")
            except Exception as e:
                Warn(f"Could not check tables in {config['db_name']}: {e}")
            if schema_needed:
                Info(f"Applying schema to {config['db_name']}...")
                try:
                    with open(schema_path, 'r') as schema_file_handle:
                        schema_sql = schema_file_handle.read()
                    Info(f"Raw schema content length: {len(schema_sql)}")
                    Info(f"First 200 chars: {schema_sql[:200]}")
                    import re
                    clean_sql = re.sub(r'/\*.*?\*/', '', schema_sql, flags=re.DOTALL)
                    clean_sql = re.sub(r'--.*$', '', clean_sql, flags=re.MULTILINE)
                    clean_sql = '\n'.join(line.strip() for line in clean_sql.split('\n') if line.strip())
                    Info(f"After all comment removal: '{clean_sql[:200]}...'")
                    conn = sqlite3.connect(db_path)
                    cursor = conn.cursor()
                    statements = clean_sql.split(';')
                    Info(f"Found {len(statements)} statements after split")
                    executed_count = 0
                    for i, statement in enumerate(statements):
                        statement = statement.strip()
                        Info(f"Statement {i+1}: length {len(statement)}")
                        if statement and len(statement) > 10 and statement.upper().startswith('CREATE'):
                            Info(f"EXECUTING Statement {i+1}: {statement[:60]}...")
                            try:
                                cursor.execute(statement)
                                executed_count += 1
                                Info(f"✓ Statement {i+1} executed successfully")
                            except Exception as stmt_error:
                                Warn(f"✗ Failed to execute statement {i+1}: {stmt_error}")
                        else:
                            Info(f"SKIPPING Statement {i+1} (not a CREATE statement or too short)")
                    conn.commit()
                    conn.close()
                    Info(f"Schema application completed. Executed {executed_count} statements for {config['db_name']}")
                    conn = sqlite3.connect(db_path)
                    cursor = conn.cursor()
                    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
                    final_tables = {row[0] for row in cursor.fetchall()}
                    conn.close()
                    Info(f"Final tables in {config['db_name']}: {list(final_tables)}")
                except Exception as e:
                    Error(f"Failed to apply schema to {config['db_name']}: {e}")
        else:
            Info(f"No schema file found for {config['db_name']} at {schema_path}")
            Info(f"{config['db_name']} will remain as empty database")

    # /5.1.3/ Scrcpy & Region Setup
    global scr_reg
    scr_reg = {
        'x': 10,
        'y': 50,
        'width': 270,
        'height': 600
    }

    def launch_scrcpy():
        Info("Launching Scrcpy in Background...")
        subprocess.Popen([
            'scrcpy',
            '--window-x', '10',
            '--window-y', '50',
            '--window-width', '270',
            '--window-height', '600',
            '--always-on-top',
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        Info("Scrcpy Launched Successfully")

    # /5.1.4/ Device Preparation Function
    def Prep():
        Info("Preparing Android Device")
        try:
            result = subprocess.run(['adb', 'devices'], capture_output=True, text=True)
            if result.returncode != 0:
                Warn("ADB is not available or not in PATH")
                return False
            devices = [line for line in result.stdout.split('\n') if 'device' in line and 'List' not in line]
            if not devices:
                Warn("No Android device connected via ADB")
                return False
            Info(f"Found {len(devices)} connected device(s)")
        except Exception as e:
            Warn(f"Failed to check ADB devices: {e}")
        And("location_on")
        Info("Opening Orna application")
        try:
            orna_packages = [
                'playorna.com.orna',
                'com.northernforge.orna',
                'com.orna.game'
            ]
            orna_opened = False
            for package in orna_packages:
                try:
                    result = subprocess.run(['adb', 'shell', 'monkey', '-p', package, '-c', 'android.intent.category.LAUNCHER', '1'], capture_output=True, text=True)
                    if result.returncode == 0 and 'Events injected: 1' in result.stdout:
                        Info(f"Successfully opened Orna with package: {package}")
                        orna_opened = True
                        break
                except Exception:
                    continue
            if not orna_opened:
                Info("Trying alternative method to open Orna...")
                subprocess.run(['adb', 'shell', 'am', 'start', '-n',
                              'playorna.com.orna/.MainActivity'],
                              capture_output=True, text=True)
                Info("Attempted to open Orna using activity method")
            time.sleep(3)
            Info("Orna application launch completed")
            return True
        except Exception as e:
            Warn(f"Failed to open Orna application: {e}")
            return False

    # /5.1.5/ Check and Install Scrcpy
    scrcpy_available = False
    try:
        result = subprocess.run(['scrcpy', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            Info("Scrcpy is already installed and available.")
            scrcpy_available = True
    except FileNotFoundError:
        Info("Scrcpy is not installed or not found in PATH.")
        Info("Attempting to install scrcpy...")
        try:
            install_result = subprocess.run(['pacman', '-Syu', 'scrcpy', '--noconfirm'], capture_output=True, text=True)
            if install_result.returncode == 0:
                Info("Scrcpy installed successfully!")
                scrcpy_available = True
            else:
                Warn(f"Failed to install scrcpy: {install_result.stderr}")
                scrcpy_available = False
        except Exception as e:
            Warn(f"Error during scrcpy installation: {e}")
            scrcpy_available = False

    # /5.1.6/ Launch Scrcpy and Prep Device
    if scrcpy_available:
        launch_scrcpy()
        time.sleep(2)
        prep_success = Prep()
        if prep_success:
            Info("Device preparation completed successfully!")
        else:
            Warn("Device preparation encountered issues")
        return True
    else:
        Warn("Scrcpy is not available - continuing without screen mirroring")
        prep_success = Prep()
        return prep_success

# /5.2/ Insert Coords into Database
def Static_Coords(coord_data=None):
    if coord_data is None:
        ini_path = os.path.join(_dir, 'Req.ini')
        Info(f"Loading coordinates from {ini_path}")
        if os.path.exists(ini_path):
            import configparser
            config = configparser.ConfigParser()
            config.read(ini_path)
            if 'Coords' in config:
                coord_data = []
                for coord_id, coord_value in config['Coords'].items():
                    try:
                        x, y = map(int, coord_value.split(','))
                        coord_data.append((coord_id, x, y))
                        Info(f"Loaded coordinate from INI: {coord_id} = ({x}, {y})")
                    except ValueError:
                        Warn(f"Invalid coordinate format in INI for '{coord_id}': {coord_value}. Expected 'x,y'")
                Info(f"Loaded {len(coord_data)} coordinates from Req.ini")
            else:
                Warn("No [Coords] section found in Req.ini")
                coord_data = []
        else:
            Warn(f"Req.ini not found at {ini_path}")
            Info("Creating example Req.ini file...")
            import configparser
            config = configparser.ConfigParser()
            config['Coords'] = {
                'menu_button': '50,100',
                'inventory_btn': '200,150',
                'settings_gear': '250,50',
                'attack_button': '135,450',
                'defend_button': '200,450',
                'magic_button': '100,500',
                'quest_log': '25,250',
                'world_map': '225,250'
            }
            with open(ini_path, 'w') as configfile:
                config.write(configfile)
            Info(f"Created example Req.ini at {ini_path}")
            Info("Please edit the [Coords] section with your actual coordinates")
            coord_data = []
    try:
        conn = sqlite3.connect(stdb_path)
        cursor = conn.cursor()
        if isinstance(coord_data, tuple) and len(coord_data) == 3:
            coord_data = [coord_data]
        inserted_count = 0
        for coord in coord_data:
            if len(coord) != 3:
                Warn(f"Invalid coordinate format: {coord}. Expected (id, x, y)")
                continue
            coord_id, x, y = coord
            cursor.execute("SELECT ID FROM Coords WHERE ID = ?", (coord_id,))
            if cursor.fetchone():
                Info(f"Coordinate '{coord_id}' already exists, updating...")
                cursor.execute("UPDATE Coords SET X = ?, Y = ? WHERE ID = ?", (x, y, coord_id))
            else:
                Info(f"Inserting new coordinate: {coord_id} at ({x}, {y})")
                cursor.execute("INSERT INTO Coords (ID, X, Y) VALUES (?, ?, ?)", (coord_id, x, y))
            inserted_count += 1
        conn.commit()
        conn.close()
        Info(f"Successfully processed {inserted_count} coordinates in static.db")
        Static_Coords_List()
    except Exception as e:
        Error(f"Failed to insert coordinates into static.db: {e}")

# /5.3/ List Coords
def Static_Coords_List():
    try:
        conn = sqlite3.connect(stdb_path)
        cursor = conn.cursor()
        cursor.execute("SELECT ID, X, Y FROM Coords ORDER BY ID")
        coords = cursor.fetchall()
        conn.close()
        if coords:
            Info(f"Current coordinates in static.db ({len(coords)} total):")
            for coord_id, x, y in coords:
                print(f"  - {coord_id}: ({x}, {y})")
        else:
            Info("No coordinates found in static.db")
    except Exception as e:
        Warn(f"Could not list coordinates: {e}")

# /5.4/ Get Coord
def Static_Coords_Get(coord_id):
    try:
        conn = sqlite3.connect(stdb_path)
        cursor = conn.cursor()
        cursor.execute("SELECT X, Y FROM Coords WHERE ID = ?", (coord_id,))
        result = cursor.fetchone()
        conn.close()
        if result:
            x, y = result
            Info(f"Found coordinate '{coord_id}': ({x}, {y})")
            return (x, y)
        else:
            Warn(f"Coordinate '{coord_id}' not found in database")
            return None
    except Exception as e:
        Error(f"Failed to get coordinate '{coord_id}': {e}")
        return None

# <!-- [SS-6]: Android Functions ----->
def And(fx):
    if not isinstance(fx, str):
        Warn(f"And() expects a string, got {type(fx)}")
        return False
    fx = fx.lower().strip()
    Info(f"Executing Android system command: {fx}")
    try:
        if fx == "home":
            subprocess.run(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_HOME'], capture_output=True, text=True)
            Info("Home button pressed")
        elif fx == "back":
            subprocess.run(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_BACK'], capture_output=True, text=True)
            Info("Back button pressed")
        elif fx == "recent" or fx == "recents":
            subprocess.run(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_APP_SWITCH'], capture_output=True, text=True)
            Info("Recent apps opened")
        elif fx == "menu":
            subprocess.run(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_MENU'], capture_output=True, text=True)
            Info("Menu button pressed")
        elif fx == "power":
            subprocess.run(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_POWER'], capture_output=True, text=True)
            Info("Power button pressed")
        elif fx == "volume_up":
            subprocess.run(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_VOLUME_UP'], capture_output=True, text=True)
            Info("Volume up pressed")
        elif fx == "volume_down":
            subprocess.run(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_VOLUME_DOWN'], capture_output=True, text=True)
            Info("Volume down pressed")
        elif fx == "mute":
            subprocess.run(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_VOLUME_MUTE'], capture_output=True, text=True)
            Info("Volume mute toggled")
        elif fx == "screenshot":
            timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
            screenshot_path = f"/sdcard/screenshot_{timestamp}.png"
            subprocess.run(['adb', 'shell', 'screencap', '-p', screenshot_path], capture_output=True, text=True)
            Info(f"Screenshot saved to device: {screenshot_path}")
        elif fx == "unlock":
            subprocess.run(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_WAKEUP'], capture_output=True, text=True)
            time.sleep(0.5)
            subprocess.run(['adb', 'shell', 'input', 'swipe', '300', '1000', '300', '500'], capture_output=True, text=True)
            Info("Device unlocked (basic swipe)")
        elif fx == "lock":
            subprocess.run(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_POWER'], capture_output=True, text=True)
            Info("Device locked")
        elif fx == "wifi_on":
            subprocess.run(['adb', 'shell', 'svc', 'wifi', 'enable'], capture_output=True, text=True)
            Info("WiFi enabled")
        elif fx == "wifi_off":
            subprocess.run(['adb', 'shell', 'svc', 'wifi', 'disable'], capture_output=True, text=True)
            Info("WiFi disabled")
        elif fx == "data_on":
            subprocess.run(['adb', 'shell', 'svc', 'data', 'enable'], capture_output=True, text=True)
            Info("Mobile data enabled")
        elif fx == "data_off":
            subprocess.run(['adb', 'shell', 'svc', 'data', 'disable'], capture_output=True, text=True)
            Info("Mobile data disabled")
        elif fx == "airplane_on":
            subprocess.run(['adb', 'shell', 'settings', 'put', 'global', 'airplane_mode_on', '1'], capture_output=True, text=True)
            subprocess.run(['adb', 'shell', 'am', 'broadcast', '-a', 'android.intent.action.AIRPLANE_MODE', '--ez', 'state', 'true'], capture_output=True, text=True)
            Info("Airplane mode enabled")
        elif fx == "airplane_off":
            subprocess.run(['adb', 'shell', 'settings', 'put', 'global', 'airplane_mode_on', '0'], capture_output=True, text=True)
            subprocess.run(['adb', 'shell', 'am', 'broadcast', '-a', 'android.intent.action.AIRPLANE_MODE', '--ez', 'state', 'false'], capture_output=True, text=True)
            Info("Airplane mode disabled")
        elif fx == "brightness_max":
            subprocess.run(['adb', 'shell', 'settings', 'put', 'system', 'screen_brightness', '255'], capture_output=True, text=True)
            Info("Brightness set to maximum")
        elif fx == "brightness_min":
            subprocess.run(['adb', 'shell', 'settings', 'put', 'system', 'screen_brightness', '10'], capture_output=True, text=True)
            Info("Brightness set to minimum")
        elif fx == "rotation_on":
            subprocess.run(['adb', 'shell', 'settings', 'put', 'system', 'accelerometer_rotation', '1'], capture_output=True, text=True)
            Info("Auto rotation enabled")
        elif fx == "rotation_off":
            subprocess.run(['adb', 'shell', 'settings', 'put', 'system', 'accelerometer_rotation', '0'], capture_output=True, text=True)
            Info("Auto rotation disabled")
        elif fx == "location_on":
            subprocess.run(['adb', 'shell', 'settings', 'put', 'secure', 'location_mode', '3'], capture_output=True, text=True)
            Info("Location services enabled")
            result = subprocess.run(['adb', 'shell', 'settings', 'get', 'secure', 'location_mode'], capture_output=True, text=True)
            if result.stdout.strip() == '3':
                Info("Location services confirmed enabled")
            else:
                Warn("Location services may not be properly enabled")
        elif fx == "location_off":
            subprocess.run(['adb', 'shell', 'settings', 'put', 'secure', 'location_mode', '0'], capture_output=True, text=True)
            Info("Location services disabled")
            result = subprocess.run(['adb', 'shell', 'settings', 'get', 'secure', 'location_mode'], capture_output=True, text=True)
            if result.stdout.strip() == '0':
                Info("Location services confirmed disabled")
            else:
                Warn("Location services may not be properly disabled")
        elif fx == "notification_panel":
            subprocess.run(['adb', 'shell', 'cmd', 'statusbar', 'expand-notifications'], capture_output=True, text=True)
            Info("Notification panel opened")
        elif fx == "quick_settings":
            subprocess.run(['adb', 'shell', 'cmd', 'statusbar', 'expand-settings'], capture_output=True, text=True)
            Info("Quick settings opened")
        elif fx == "close_panels":
            subprocess.run(['adb', 'shell', 'cmd', 'statusbar', 'collapse'], capture_output=True, text=True)
            Info("System panels closed")
        elif fx == "reboot":
            Info("WARNING: Rebooting device in 3 seconds...")
            time.sleep(3)
            subprocess.run(['adb', 'shell', 'reboot'], capture_output=True, text=True)
            Info("Device reboot initiated")
        else:
            Warn(f"Unknown Android command: '{fx}'")
            Info("Available commands: home, back, recent, menu, power, volume_up, volume_down, mute, screenshot, unlock, lock, wifi_on, wifi_off, data_on, data_off, airplane_on, airplane_off, brightness_max, brightness_min, rotation_on, rotation_off, location_on, location_off, notification_panel, quick_settings, close_panels, reboot")
            return False
        return True
    except Exception as e:
        Error(f"Failed to execute Android command '{fx}': {e}")
        return False

# <!-- [SS-7]: Orna Simple Logic ----->
def Nav():
    pass

def Heal():
    pass

# <!--- [SS-8]: Orna Major Functions ----->
def Attack ():
    pass

def Search () :
    pass

# <!-- [SS-9]: OrnaBot Functions ----->
def Farm ():
    pass

def Daily ():
    pass

def Quest ():
    pass

def Fish ():
    pass

def Explore ():
    pass

# <!-- [SS-10]: Main ----->
def main ():
    Initiate()

if __name__ == "__main__":
    main()
