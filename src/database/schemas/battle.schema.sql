-- <!-- [SS-0]: Meta Data ----> --
/*
Version = '3.147'
Date = '4/27/25'
Desc = 'Defines the Database Battle Type Table Schemas for OrnaBot'
Tables = 44
Index = {
    "Map Battles" =     26,
    "Map Wars" =        57,
    "Dungeons" =        95,
    "Monuments" =       151,
    "Towers" =          210,
    "Arena" =           252,
    "Blades" =          273,
    "Coliseum" =        294,
    "Conquer" =         315,
    "Exploration" =     346,
    "Fishing" =         376,              
    "Raids" =           406,
    "Gauntlets" =       436,
    "Kingdom Wars" =    457
}
*/

-- <!-- [SS-1.1]: Single Enemy Battles Table : Battle Data ----->
CREATE TABLE Battles (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Battles stats as a unique ID # --
    Anguish INTEGER DEFAULT 0,                                                          -- # The Anguish Level set during this Battle # --
    Creature TEXT NOT NULL,                                                             -- # The Name of Creature Fought # --
    Creature_Level INTEGER NOT NULL,                                                    -- # The Level of the Creature Fought # --
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                     -- # The DateTime of the start of the Battle # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of the end of the Battle # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Amount of Damage the Player Recieved during this Battle # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Amount of Mana used during this Battle # --
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of the Battle, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-1.2]: Single Enemy Battles Table : Used Consumables Stats ----->
CREATE TABLE Battle_Consumables (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Battles Consumables for each consumable # --  
    BattleID INTEGER NOT NULL,                                                          -- # A symbolic refernce to the Battle's Unique ID that this consumable was used for # --
    Consumable TEXT NOT NULL,                                                           -- # The Name of the Consumable Used # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Number of times this consumable was used during and directly after the battle # --
    FOREIGN KEY (BattleID) REFERENCES Battles (ID)                                      -- # A Full Linkage to the Battle's Unique ID of which this Consumable was used for # --
);

-- <!-- [SS-1.3]: Single Enemy Battles Table : Drop Stats ----->
CREATE TABLE Battle_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique Identifier # --  
    BattleID INTEGER NOT NULL,                                                          -- # A symbolic refernce to the Battle's Unique ID that this Drop was a result of # --
    Item TEXT NOT NULL,                                                                 -- # The Name of the Item Dropped # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the dropped Item # --
    FOREIGN KEY (BattleID) REFERENCES Battles (ID)                                      -- # A Full Linkage to the Battle's Unique ID of which this Drop was a result of # --
);

-- <!-- [SS-2.1]: Multiple Enemies War Table : War Data ----->
CREATE TABLE Wars (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this War's Stats as a Unique Identifier # --
    Anguish INTEGER DEFAULT 0,                                                          -- # The Anguish Level set during this War # --
    Start_Time  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                    -- # The DateTime of the Start of the War # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of the end of the War # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Amount of Damage the Player Recieved during this War # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Amount of Mana used during this War # --
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of the War, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-2.2]: Multiple Enemy War Table : Enemies Stats -----> 
CREATE TABLE War_Enemies (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this War's Enemy List for each Enemy # --
    WarID INTEGER NOT NULL,                                                             -- # A Symbolic referance to the War's Unique ID # --
    Creature TEXT NOT NULL,                                                             -- # The Name of the Creature Fought # --
    Creature_Level INTEGER,                                                             -- # The Level of the Creature Fought # --
    FOREIGN KEY (WarID) REFERENCES Wars(ID)                                             -- # A Full Linkage to the War's Unique ID of which this creature was a part of # --
);

-- <!-- [SS-2.3]: Multiple Enemy War Table : Used Consumable Stats ----->
CREATE TABLE War_Consumables (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this War's Consumables for each consumable # --  
    WarID INTEGER NOT NULL,                                                             -- # A symbolic refernce to the War's Unique ID that this consumable was used for # --
    Consumable TEXT NOT NULL,                                                           -- # The Name of the Consumable Used # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Number of times this consumable was used during and directly after the War # --
    FOREIGN KEY (WarID) REFERENCES Wars (ID)                                            -- # A Full Linkage to the War's Unique ID of which this Consumable was used for # --
);

-- <!-- [SS-2.4]: Multiple Enemy War Table : Drop Stats ----->
CREATE TABLE War_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique Identifier # --  
    WarID INTEGER NOT NULL,                                                             -- # A symbolic refernce to the War's Unique ID that this Drop was a result of # --
    Item TEXT NOT NULL,                                                                 -- # The Name of the Item Dropped # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the dropped Item # --
    FOREIGN KEY (WarID) REFERENCES Wars (ID)                                            -- # A Full Linkage to the War's Unique ID of which this Drop was a result of # --
);

-- <!-- [SS-3.1]: Dungeons Table : Dungeon Data ----->
CREATE TABLE Dungeons (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Dungeon Run as a Unique Identifier # --
    Dungeon_Name TEXT NOT NULL,                                                         -- # The Name Associated with this Dungeon # --
    Anguish INTEGER DEFAULT 0,                                                          -- # The Anguish Level set during this Dungeon # --
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                     -- # The DateTime of this Dungeon Run's Start # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of this Dungeon Run's End # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Total Amount of Damage the Player Recieved during This Dungeon Run # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Total Amount of Mana used during this Dungeon Run # --
    Tier INTEGER NOT NULL,                                                              -- # The Tier Level of this Dungeon Run # --
    Normal_Mode BOOLEAN DEFAULT True,                                                   -- # Was this Dungeon fought in Normal Mode # --
    Hard_Mode BOOLEAN DEFAULT False,                                                    -- # Was this Dungeon fought in Hard Mode # --
    Horde_Mode BOOLEAN DEFAULT False,                                                   -- # Was this Dungeon fought in Horde Mode # --
    Boss_Mode BOOLEAN DEFAULT False,                                                    -- # Was this Dungeon fought in Boss Mode # --
    Endless_Mode BOOLEAN DEFAULT False,                                                 -- # Was this Dungeon fought in Endless Mode # --
    Floors INTEGER NOT NULL,                                                            -- # The Amount of Floors present in this Dungeon Run, OR for Endless_Mode runs, the number completed # --
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of the Dungeon Run, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-3.2]: Dungeons Table : Floor Stats ----->
CREATE TABLE Dungeon_Floor (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Dungeons Floor as a Unique Identifier # --
    DungeonID INTEGER NOT NULL,                                                         -- # A Symbolic reference to the Dungeon Run this floor was a part of # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Amount of Damage the Player Recieved on this Floor # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Amount of Mana Used during this Floor # --
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee')),               -- # The Overall Result of this Dungeon Floor, in either Victory, Defeat, or a Flee # --
    FOREIGN KEY (DungeonID) REFERENCES Dungeons (ID)                                    -- # A Full Linkage to the Dungeon Run's Unique ID of which this floor was a part of # --
);

-- <!-- [SS-3.3]: Dungeons Table : Floor Enemies Stats ----->
CREATE TABLE DunFloor_Enemies (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Floor's Enemy List for each Enemy # --
    FloorID INTEGER NOT NULL,                                                           -- # A Symbolic referance to the Floor's Unique ID # --
    Creature TEXT NOT NULL,                                                             -- # The Name of the Creature Fought # --
    Creature_Level INTEGER,                                                             -- # The Level of the Creature Fought # --
    FOREIGN KEY (FloorID) REFERENCES Dungeon_Floor (ID)                                 -- # A Full Linkage to the Floor's Unique ID of which this creature was a part of # --
);

-- <!-- [SS-3.4]: Dungeons Table : Floor Used Consumable Stats ----->
CREATE TABLE DunFloor_Consumables (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Floor's Consumables for each consumable # --  
    FloorID INTEGER NOT NULL,                                                           -- # A Symbolic refernce to the Floor's Unique ID that this consumable was used for # --
    Consumable TEXT NOT NULL,                                                           -- # The Name of the Consumable Used # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Number of times this consumable was used during and directly after the War # --
    FOREIGN KEY (FloorID) REFERENCES Dungeon_Floor (ID)                                 -- # A Full Linkage to the Floor's Unique ID of which this Consumable was used for # --
);

-- <!-- [SS-3.5]: Dungeons Table : Floor Drop Stats
CREATE TABLE DunFloor_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique Identifier # --  
    FloorID INTEGER NOT NULL,                                                           -- # A Symbolic refernce to the Floor's Unique ID that this Drop was a result of # --
    Item TEXT NOT NULL,                                                                 -- # The Name of the Item Dropped # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the dropped Item # --
    FOREIGN KEY (FloorID) REFERENCES Dungeon_Floor (ID)                                 -- # A Full Linkage to the Floor's Unique ID of which this Drop was a result of # --
);

-- <!-- [SS-4.1]: Momuments Table : Monument Data ----->
CREATE TABLE Monuments (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Monument Run as a Unique Identifier # --
    Monument_Name TEXT NOT NULL,                                                        -- # The Name Associated with this Monument # --
    Anguish INTEGER DEFAULT 0,                                                          -- # The Anguish Level set during this Monument Run # --
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                     -- # The DateTime of this Monument Run's Start # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of this Monument Run's End # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Total Amount of Damage the Player Recieved during this Monument Run # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Total Amount of Mana used during this Monument Run # --
    Floors INTEGER NOT NULL,                                                            -- # The Amount of Floors present in this Monument # --
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of this Monument Run, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-4.2]: Monuments Table : Floor Stats ----->
CREATE TABLE Monument_Floor (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Monument Floor as a Unique Identifier # --  
    MonumentID INTEGER NOT NULL,                                                        -- # A Symbolic refernce to this Monument Run's Unique ID that this Floor is a part of # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Amount of Damage the Player Recived on this Monument Floor # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Amount of Mana used during this Monument Floor # --
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee')),               -- # The Overall Result of this Monument Floor, in either Victory, Defeat, or a Flee # --
    FOREIGN KEY (MonumentID) REFERENCES Monuments (ID)                                  -- # A Full Linkage to the Monument's Unique ID that this Floor was a part pf # --
);

-- <!-- [SS4.3]: Monuments Table : Floor Enemies Stats ===== >
CREATE TABLE MonFloor_Enemies (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Monument Floor Enemies as a Unique Identifier # --  
    MonFloorID INTEGER NOT NULL,                                                        -- # A Symbolic refernce to this Monument Run's Unique ID that this Floor is a part of # --
    Creature TEXT NOT NULL,                                                             -- # The Name of a Creature Fought on this Monument Floor # --
    Creature_Level TEXT NOT NULL,                                                       -- # The Level of the Creature Fought on this Monument Floor # == 
    FOREIGN KEY (MonFloorID) REFERENCES Monument_Floor (ID)                             -- # A Full Linkage to the Monument Floor's Unique ID of which this Creature was a part of # --
);

-- <!-- [SS4.4]: Monuments Table : Used Consumables Stats ----->
CREATE TABLE MonFloor_Consumables (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Monument Floor's Consumables for each consumable # --  
    MonFloorID INTEGER NOT NULL,                                                        -- # A Symbolic refernce to the Monument Floor's Unique ID that this consumable was used for # --
    Consumable TEXT NOT NULL,                                                           -- # The Name of the Consumable Used # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Number of times this consumable was used during the Monument Run # --
    FOREIGN KEY (MonFloorID) REFERENCES Monument_Floor (ID)                             -- # A Full Linkage to the Monument Floor's Unique ID of which this Consumable was used for # --
);

-- <!-- [SS-4.5]: Monuments Table : Floor Found Items Stats ----->
CREATE TABLE MonFloor_Find (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Monument Floor's Found Items as a Unique Identifier # --  
    MonFloorID INTEGER NOT NULL,                                                        -- # A Symbolic refernce to this Monument Floor's Unique ID that this Find is a part of # -- 
    Found TEXT NOT NULL,                                                                -- # The Buff or Item found # --
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quanitity of the Item or Buff Found # --
    FOREIGN KEY (MonFloorID) REFERENCES Monument_Floor (ID)                             -- # A Full Linkage to the Monument Floor's Unique ID of which this Chest was a part of # --
);

-- <!-- [SS-4.6]: Monuments Table : Floor Drop Stats ----->
CREATE TABLE MonFloor_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Monument Floor Drop's as a Unique Identifier # --  
    MonFloorID INTEGER NOT NULL,                                                        -- # A Symbolic refernce to this Monument Floor's Unique ID that this Drop is a part of # -- 
    Item TEXT NOT NULL,                                                                 -- # The Name of Item Dropped # --
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the Item Dropped # --
    FOREIGN KEY (MonFloorID) REFERENCES Monument_Floor (ID)                             -- # A Full Linkage to the Monument Floor's Unique ID of which this Drop was a part of # --
);

-- <!-- [SS-5.1]: Towers Table : Tower Data ----->
CREATE TABLE Towers (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Tower Run as a Unique Identifier # --
    Tower_Name TEXT NOT NULL,                                                           -- # The Name Associated with this Tower # --
    Anguish INTEGER DEFAULT 0,                                                          -- # The Set Anguish Level during this Tower Run # -- 
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                     -- # The DateTime of the start of the Tower Run # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of the end of the Tower Run # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Total Amount of Damage the Player Recieved during this Tower Run # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Total Amount of Mana used during this Tower Run # -- 
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of the Tower Run, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-5.2]: Towers Table : Floor Stats ----->
CREATE TABLE Tower_Floor (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Tower Run Drop's as a Unique Identifier # --  
    TowerID INTEGER NOT NULL,                                                           -- # A Symbolic refernce to the Tower Run's Unique ID that this Floor is a part of # --
    Creature TEXT NOT NULL,                                                             -- # The Name of the Creature fought on this Tower Run Floor # --
    Creature_Level  INTEGER NOT NULL,                                                   -- # The Level of the Creature fought on this Tower Run Floor # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Amount of Damage the Player Recieved During this Tower Runs Floor # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Amount of Mana used on this Tower Runs Floor # --
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee')),               -- # The Overall Result of this Tower Run's Floor, in either Victory, Defeat, or a Flee # --
    FOREIGN KEY (TowerID) REFERENCES Towers (ID)                                        -- # A Full Linkage to the Tower Run's Unique ID that this Floor is a part of # --
);

-- <!-- [SS-5.3]: Towers Table : Floor Used Consumables Stats ----->
CREATE TABLE TowFloor_Consumables (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Tower Floors Used Consumable for each Consumable # --
    TowFloorID INTEGER NOT NULL,                                                        -- # A Symbolic refernce to this Tower Floor's Unique ID that this Consumable was used for # --
    Consumable TEXT NOT NULL,                                                           -- # The Name of the Used Consumable # --
    Quantity INTEGER DEFAULT 1,                                                         -- # The Amount of times the Consumable was used # --
    FOREIGN KEY (TowFloorID) REFERENCES Tower_Floor (ID)                                -- # A Full Linkage to the Tower Floor's unique ID of which this consumable was for # --
);

-- <!-- [SS-5.4]: Towers Table : Floor Drop Stats ----->
CREATE TABLE TowFloor_Drop (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique Identifier # --  
    TowFloorID INTEGER NOT NULL,                                                        -- # A Symbolic refernce to the Tower Floor's Unique ID that this Drop was a result of # --
    Item TEXT NOT NULL,                                                                 -- # The Name of the Item Dropped # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the dropped Item # --
    FOREIGN KEY (TowFloorID) REFERENCES Tower_Floor (ID)                                -- # A Full Linkage to the Tower Floor's Unique ID of which this Drop was a result of # --
);

-- <!-- [SS-6.1]: Arena Tables : Arena Data ----->
CREATE TABLE Arena (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Arena Battle as a Unique Identifier # --
    Opponent_Level INTEGER NOT NULL,                                                    -- # The Level of the Fought Player # --
    Opponent_Class TEXT,                                                                -- # The Class of the Fought Opponent # --
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                     -- # The DateTime of the start of the Arena Battle # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of the end of the Arena Battle # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Total Amount of Damage the Player Recieved during this Arena Fight # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Total Amount of Mana used during this Arena Fight # -- 
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of the Arena Fight, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-6.2]: Arena Tables : Arena Drops Stats ----->
CREATE TABLE Arena_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique Identifier # --  
    ArenaID INTEGER NOT NULL,                                                           -- # A Symbolic refernce to the Arena's Unique ID that this Drop was a result of # --
    Item TEXT NOT NULL,                                                                 -- # The Name of the Item Dropped # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the dropped Item # --
    FOREIGN KEY (ArenaID) REFERENCES Arena (ID)                                         -- # A Full Linkage to the Arena's Unique ID of which this Drop was a result of # --
);

-- <!-- [SS-7.1]: Blades of Finesse Table : Blades Data ----->
CREATE TABLE Blades (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Blades Battle as a Unique Identifier # --
    Opponent_Level INTEGER NOT NULL,                                                    -- # The Level of the Fought Player # --
    Opponent_Class TEXT,                                                                -- # The Class of the Fought Opponent # --
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                     -- # The DateTime of the start of the Blades Battle # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of the end of the Blades Battle # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Total Amount of Damage the Player Recieved during this Blades Battle # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Total Amount of Mana used during this Blades Battle # -- 
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of the Blades Battle, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-7.2]: Blades of Finesse Table : Blades Drop Stats ----->
CREATE TABLE Blades_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique Identifier # --  
    BladesID INTEGER NOT NULL,                                                          -- # A Symbolic refernce to the Blade Battle's Unique ID that this Drop was a result of # --
    Item TEXT NOT NULL,                                                                 -- # The Name of the Item Dropped # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the dropped Item # --
    FOREIGN KEY (BladesID) REFERENCES Blades (ID)                                       -- # A Full Linkage to the Blade Battle's Unique ID of which this Drop was a result of # --
);

-- <!-- [SS-8.1]: Coliseum Table : Coliseum Data ----->
CREATE TABLE Coliseum (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Coliseum as a Unique Identifier # --
    Opponent_Level INTEGER NOT NULL,                                                    -- # The Level of the Fought Player # --
    Opponent_Class TEXT,                                                                -- # The Class of the Fought Opponent # --
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                     -- # The DateTime of the start of the Coliseum Battle # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of the end of the Coliseum Battle # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Total Amount of Damage the Player Recieved during this Coliseum # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Total Amount of Mana used during this Coliseum # -- 
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of the Coliseum, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-8.2]: Coliseum Table : Coliseum Drops Stats ------>
CREATE TABLE Coliseum_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique Identifier # --  
    ColiseumID INTEGER NOT NULL,                                                        -- # A Symbolic refernce to the Coliseum's Unique ID that this Drop was a result of # --
    Item TEXT NOT NULL,                                                                 -- # The Name of the Item Dropped # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the dropped Item # --
    FOREIGN KEY (ColiseumID) REFERENCES Coliseum (ID)                                   -- # A Full Linkage to the Coliseum's Unique ID of which this Drop was a result of # --
);

-- <!-- [SS-9.1]: Conquer Table : Conquer Data ----->
CREATE TABLE Conquer (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Conquer as a Unique Identifier # --
    Latitude INTEGER NOT NULL,                                                          -- # The Latitude of this Conquer Location # -- 
    Longitude INTEGER NOT NULL,                                                         -- # The Longitude of this Conquer Location # --
    Sprite TEXT DEFAULT 'Player',                                                       -- # The Character used for this Fight # --
    Opponent_Level INTEGER NOT NULL,                                                    -- # The Level of the Fought Player # --
    Opponent_Class TEXT,                                                                -- # The Class of the Fought Opponent # --
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                     -- # The DateTime of the start of the Conquer # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of the end of the Conquer # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Total Amount of Damage the Player Recieved during this Conquer # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Total Amount of Mana used during this Conquer # -- 
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of the Conquer, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-9.2]: Conquer Table : Conquer Drops Stats ----->
CREATE TABLE Conquer_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique Identifier # --  
    ConquerID INTEGER NOT NULL,                                                         -- # A Symbolic refernce to the Conquer's Unique ID that this Drop was a result of # --
    Item TEXT NOT NULL,                                                                 -- # The Name of the Item Dropped # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the dropped Item # --
    FOREIGN KEY (ConquerID) REFERENCES Conquer (ID)                                     -- # A Full Linkage to the Conquers's Unique ID of which this Drop was a result of # --
);

-- <!-- [SS-9.3]: Conquer Table : Heads or Tails ----->
CREATE TABLE HOT (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this HOT as a Unique Identifier # --
    Picked TEXT NOT NULL,                                                               -- # The Choice Picked # --
    Result TEXT NO NULL CHECK (Result IN ('Win', 'Loss'))                               -- # The Overall Result, in either a Win, or a Loss # -- 
);

-- <!-- [SS-10.1]: Exploration Table : Explorers Data ----->
CREATE TABLE Explore (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Exploration as a Unique Identifier # --
    Creature TEXT NOT NULL,                                                             -- # The Name of the fought Creature # --
    Creature_Level INTEGER NOT NULL,                                                    -- # The Level of the Fought Creature # --
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                     -- # The DateTime of the start of the Exploration # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of the end of the Exploration # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Total Amount of Damage the Player Recieved during this Exploration # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Total Amount of Mana used during this Explploration # -- 
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of the Exploration, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-10.2]: Exploration Table : Used Consumable Stats ----->
CREATE TABLE Explore_Consumables (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Exploration's Used Consumable for each Consumable # --
    ExploreID INTEGER NOT NULL,                                                         -- # A Symbolic refernce to this Exploration's Unique ID that this Consumable was used for # --
    Consumable TEXT NOT NULL,                                                           -- # The Name of the Used Consumable # --
    Quantity INTEGER DEFAULT 1,                                                         -- # The Amount of times the Consumable was used # --
    FOREIGN KEY (ExploreID) REFERENCES Explore (ID)                                     -- # A Full Linkage to the Exploration's unique ID of which this consumable was for # --
); 

-- <!-- [SS-10.3]: Exploration Table : Explorer Drops Stats ----->
CREATE TABLE Explore_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique Identifier # --  
    ExploreID INTEGER NOT NULL,                                                         -- # A Symbolic refernce to the Exploration's Unique ID that this Drop was a result of # --
    Item TEXT NOT NULL,                                                                 -- # The Name of the Item Dropped # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the dropped Item # --
    FOREIGN KEY (ExploreID) REFERENCES Explore (ID)                                     -- # A Full Linkage to the Exploration's Unique ID of which this Drop was a result of # --
);

-- <!-- [SS-11.1]: Fishing Table : Fishing Data ----->
CREATE TABLE Fishing (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Fishing Battle as a Unique Identifier # --
    Creature TEXT NOT NULL,                                                             -- # The Name of the Creature fought # --
    Creature_Level INTEGER NOT NULL,                                                    -- # The Level of the Fought Creature # --
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                     -- # The DateTime of the start of the Fishing Battle # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of the end of the Fishing Battle # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Total Amount of Damage the Player Recieved during this Fishing Battle # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Total Amount of Mana used during this Fishing Battle # -- 
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of the Fishing Battle, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-11.2]: Fishing Table : Used Consumables Stats ----->
CREATE TABLE Fishing_Consumables (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Fishing Battle's Used Consumable for each Consumable # --
    FishingID INTEGER NOT NULL,                                                         -- # A Symbolic refernce to this Fishing Battle's Unique ID that this Consumable was used for # --
    Consumable TEXT NOT NULL,                                                           -- # The Name of the Used Consumable # --
    Quantity INTEGER DEFAULT 1,                                                         -- # The Amount of times the Consumable was used # --
    FOREIGN KEY (FishingID) REFERENCES Fishing (ID)                                     -- # A Full Linkage to the Fishing Battles's unique ID of which this consumable was for # --
);

-- <!-- [SS-11.3]: Fishing Table : Fishing Drops ----->
CREATE TABLE Fishing_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique Identifier # --  
    FishingID INTEGER NOT NULL,                                                         -- # A Symbolic refernce to the Fishing Battle's Unique ID that this Drop was a result of # --
    Item TEXT NOT NULL,                                                                 -- # The Name of the Item Dropped # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the dropped Item # --
    FOREIGN KEY (FishingID) REFERENCES Fishing (ID)                                     -- # A Full Linkage to the Fishing Battle's Unique ID of which this Drop was a result of # --
);

-- <!-- [SS-12.1]: Raids Table : Raid Data ----->
CREATE TABLE Raids (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Raids stats as a unique Identifier # -- 
    Boss TEXT NOT NULL,                                                                 -- # The Name of the Boss Fought during this Raid # -- 
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                     -- # The DateTime of the Start of the Raid # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of the End of the Raid # --
    Damage INTEGER NOT NULL,                                                            -- # The Amount of Damage Inflicted to the Boss by the Player # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Amount of Damage the Player Recieved during this Raid # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Amount of Mana used during this Raid # --
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of the Raid, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-12.2]: Raids Table : Used Consumables Stats ----->
CREATE TABLE Raid_Consumables (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Raids consumables for each consumable # --  
    RaidID INTEGER NOT NULL,                                                            -- # A symbolic refernce to the Raid's Unique ID that this consumable was used for # --
    Consumable TEXT NOT NULL,                                                           -- # The Name of the Consumable Used # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Number of times this consumable was used during and directly after the battle # --
    FOREIGN KEY (RaidID) REFERENCES Raids (ID)                                          -- # A Full Linkage to the Raid's Unique ID of which this Consumable was used for # --
);

-- <!-- [SS-12.3]: Raids Table : Raid Drops Stats ----->
CREATE TABLE Raid_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique Identifier # --  
    RaidID INTEGER NOT NULL,                                                            -- # A Symbolic refernce to the Raids's Unique ID that this Drop was a result of # --
    Item TEXT NOT NULL,                                                                 -- # The Name of the Item Dropped # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the dropped Item # --
    FOREIGN KEY (RaidID) REFERENCES Raids (ID)                                          -- # A Full Linkage to the Raid's Unique ID of which this Drop was a result of # --
);

-- <!-- [SS-13.1]: Kingdom Gauntlets Table : Gauntlet Data ----->
CREATE TABLE Gauntlets (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Gauntlet as a Unique Identifier # --
    Opponent_Level INTEGER NOT NULL,                                                    -- # The Level of the Fought Player # --
    Opponent_Class TEXT,                                                                -- # The Class of the Fought Opponent # --
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                     -- # The DateTime of the start of the Gauntlet # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of the end of the Gauntlet # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Total Amount of Damage the Player Recieved during this Gauntlet # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Total Amount of Mana used during this Gauntlet # -- 
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of the Gauntlet, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-13.2]: Kingdom Gauntlets Table : Drops Stats ----->
CREATE TABLE Gauntlet_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique Identifier # --  
    GauntletID INTEGER NOT NULL,                                                        -- # A Symbolic refernce to the Gauntlet's Unique ID that this Drop was a result of # --
    Item TEXT NOT NULL,                                                                 -- # The Name of the Item Dropped # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the dropped Item # --
    FOREIGN KEY (GauntletID) REFERENCES Gauntlets (ID)                                  -- # A Full Linkage to the Gauntlet's Unique ID of which this Drop was a result of # --
);

-- <!-- [SS-14.1]: Kingdom Wars Table : Wars Data ----->
CREATE TABLE KingdomWars (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this War as a Unique Identifier # --
    Opponent_Level INTEGER NOT NULL,                                                    -- # The Level of the Fought Player # --
    Opponent_Class TEXT,                                                                -- # The Class of the Fought Opponent # --
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                     -- # The DateTime of the start of the War # --
    End_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                                       -- # The DateTime of the end of the War # --
    Hurt INTEGER DEFAULT 0,                                                             -- # The Total Amount of Damage the Player Recieved during this War # --
    Magic INTEGER DEFAULT 0,                                                            -- # The Total Amount of Mana used during this War # -- 
    Result TEXT NOT NULL CHECK (Result IN ('Victory', 'Defeat', 'Flee'))                -- # The Overall Result of the War, in either Victory, Defeat, or a Flee # --
);

-- <!-- [SS-14.2]: Kingdom Wars Table : Drops Stats ----->
CREATE TABLE KingdomWars_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique Identifier # --  
    KingdomWarsID INTEGER NOT NULL,                                                     -- # A Symbolic refernce to the War's Unique ID that this Drop was a result of # --
    Item TEXT NOT NULL,                                                                 -- # The Name of the Item Dropped # -- 
    Quantity INTEGER DEFAULT 1,                                                         -- # The Quantity of the dropped Item # --
    FOREIGN KEY (KingdomWarsID) REFERENCES KingdomWars (ID)                             -- # A Full Linkage to the War's Unique ID of which this Drop was a result of # --
);