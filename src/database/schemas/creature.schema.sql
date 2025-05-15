-- <!-- [SS-0]: Meta Data ----> --
/*
Version = '3.45'
Date = '4/27/25'
Desc = 'Defines the Database Creature Type Table Schemas for OrnaBot'
Tables = 
Index = {
    Creatures =                     24,
    Followers =                     36,
    Bosses =                        54,
    Lists =                         66,
    Mob Skills =                    100,
    Mob Abilities =                 127,
    Mob Resistances =               146,
    Mob Immunities =                164,
    Mob Status Immunities =         182,
    Mob Weaknesses =                200,
    Mob Events =                    218,
    Mob Drops =                     245
}
*/

-- <!-- [SS-1.1]: Regular Creatures : Static Data ----->
CREATE TABLE Creatures (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Creature as a unique ID # --                         
    Creature TEXT NOT NULL UNIQUE,                                                      -- # The Name of the Creature # --
    Tier INTEGER DEFAULT 1,                                                             -- # The Tier level of the Creature # --
    Family TEXT NOT NULL,                                                               -- # The Family classification of the Creature # --                                     
    Spawn_Time  TEXT DEFAULT "Any",                                                     -- # The Time Specification for the spawning of the Creature # --
    Terrain TEXT NOT NULL,                                                              -- # The Terrain Type that the Creature will Spawn on # --
    Rarity TEXT NOT NULL,                                                               -- # The Creature's Rarity as defined by the Codex # --
    Weather TEXT DEFAULT "Any"                                                          -- # The Creature's Prefered Weather for Spawning # --
);

-- <!-- [SS-1.2]: Followers : Static Data ----->
CREATE TABLE Followers (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Follower as a unique ID # --                         
    Creature TEXT NOT NULL UNIQUE,                                                      -- # The Name of the Follower # --
    Tier INTEGER DEFAULT 1,                                                             -- # The Tier level of the Follower # --
    Family TEXT NOT NULL,                                                               -- # The Family classification of the Follower # --                                     
    Rarity TEXT NOT NULL,                                                               -- # The Follower's Rarity as defined by the Codex # --
    Cost INTEGER NOT NULL,                                                              -- # The Cost of the Follower at a Bestiary # -- 
    Heal_Rate INTEGER DEFAULT None                                                      -- # The Follower's Heal Rate # --
    Spell_Rate INTEGER DEFAULT None,                                                    -- # The Follower's Spell Rate # --
    Attack_Rate INTEGER DEFAULT None,                                                   -- # The Follower's Attack Rate # --
    Buff_Rate INTEGER DEFAULT None,                                                     -- # The Follower's Buff Rate # --
    Debuff_Rate INTEGER DEFAULT None,                                                   -- # The Follower's DeBuff Rate # --
    Protect_Chance INTEGER DEFAULT None,                                                -- # The Follower's Protection Chance # -- 
    Bond1 TEXT NOT NULL,                                                                -- # The Follower's Level 1 Bestial Bond Buff # -- 
    Bond2 TEXT NOT NULL,                                                                -- # The Follower's Level 2 Bestial Bond Buff # -- 
    Bond3 TEXT NOT NULL                                                                 -- # The Follower's Level 3 Bestial Bond Buff # -- 
);

-- <!-- [SS-1.3]: Bosses : Static Data ----->
CREATE TABLE Bosses (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Boss as a unique ID # --                         
    Boss TEXT NOT NULL UNIQUE,                                                          -- # The Name of the Boss # --
    Cost INTEGER NOT NULL,                                                              -- # The Cost on a kingdom to Summon this Boss #--
    Summon TEXT NOT NULL,                                                               -- # The Summoning Item used for this Boss # ---
    Tier INTEGER DEFAULT 1,                                                             -- # The Tier level of the Boss # --
    Family TEXT NOT NULL,                                                               -- # The Family classification of the Boss # --        
    Rarity TEXT NOT NULL,                                                               -- # The Boss's Rarity as defined by the Codex # --
);

-- <!-- [SS-2.1]: Lists : Skills List Data ----->
CREATE TABLE Skills (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Skill as a Unique ID # -- 
    Skill TEXT NOT NULL UNIQUE,                                                         -- # The Name of the Skill as defined in the Codex # --
    Effect TEXT DEFAULT None,                                                           -- # Any Status effects that this skill has a chance to impose # --
    Turns INTEGER DEFAULT 1                                                             -- # The number of Turns in Battle this Skill requires to be used # --                   
);

-- <!-- [SS-2.2]: Lists : Abilities List Data ----->
CREATE TABLE Abilities (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Ability as a Unique ID # -- 
    Ability TEXT NOT NULL UNIQUE,                                                       -- # The Name of the Ability as defined in the Codex # --
    Effect TEXT DEFAULT None,                                                           -- # Any Status effects that this Ability has a chance to impose # --
    Turns INTEGER DEFAULT 1                                                             -- # The number of Turns in Battle this Ability requires to be used # --                   
);

-- <!-- [SS-2.3]: Lists : Attack Effects List Data -----> # Resistances, Weakness, Immunities #
CREATE TABLE Attack_Effects (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Attack Effect as a Unique ID # --
    Effect TEXT NOT NULL UNIQUE                                                         -- # The Name of the Attack Effect # --
);

-- <!-- [SS-2.4]: Lists : Status Effects List Data -----> # Status Immunities #
CREATE TABLE Status_Effects (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Status Effect as a Unique ID # --
    Effect TEXT NOT NULL UNIQUE                                                         -- # The Name of the Status Effect # --
);

-- <!-- [SS-2.5]: Lists : Events List Data ----->
CREATE TABLE Events (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Event as a Unique ID # --
    EVENTS TEXT NOT NULL UNIQUE                                                         -- # The Name of the Event # --
);

-- <!-- [SS-3.1]: Skills List : Creature Linking ----->
CREATE TABLE Creature_Skills (
    CreatureID INTEGER NOT NULL,                                                        -- # A Symbolic Link to a Creature with a Skill # --
    SkillID INTEGER NOT NULL,                                                           -- # A Symbolic Link to a Skill that the Creature has # --
    PRIMARY KEY (CreatureID, SkillID),                                                  -- # A Many to Many Type Primary Key that ensures a Creature doesnt get listed to the same skill multiple times # -- 
    FOREIGN KEY (CreatureID) REFERENCES Creatures (ID),                                 -- # A Full Linkage of the Creature # --
    FOREIGN KEY (SkillID) REFERENCES Skills (ID)                                        -- # A Full Linkage of the Skill # --
);

-- <!-- [SS-3.2]: Skills List : Follower Linking ----->
CREATE TABLE Follower_Skills (
    FollowerID INTEGER NOT NULL,                                                        -- # A Symbolic Link to a Follower with a Skill # --
    SkillID INTEGER NOT NULL,                                                           -- # A Symbolic Link to a Skill that the Follower has # --
    PRIMARY KEY (FollowerID, SkillID),                                                  -- # A Many to Many Type Primary Key that ensures a Follower doesnt get listed to the same skill multiple times # -- 
    FOREIGN KEY (FollowerID) REFERENCES Followers (ID),                                 -- # A Full Linkage of the Follower # --
    FOREIGN KEY (SkillID) REFERENCES Skills (ID)                                        -- # A Full Linkage of the Skill # --  
);

-- <!-- [SS-3.3]: Skills List : Boss Linking ----->
CREATE TABLE Boss_Skills (
    BossID INTEGER NOT NULL,                                                            -- # A Symbolic Link to a Boss with a Skill # --
    SkillID INTEGER NOT NULL,                                                           -- # A Symbolic Link to a Skill that the Boss has # --
    PRIMARY KEY (BossID, SkillID),                                                      -- # A Many to Many Type Primary Key that ensures a Boss doesnt get listed to the same skill multiple times # -- 
    FOREIGN KEY (BossID) REFERENCES Bosses (ID),                                        -- # A Full Linkage of the Boss # --
    FOREIGN KEY (SkillID) REFERENCES Skills (ID)                                        -- # A Full Linkage of the Skill # --  
);

-- <!-- [SS-4.1]: Abilities List : Creature Linking ----->
CREATE TABLE Creature_Abilities (
    CreatrueID INTEGER NOT NULL,                                                        -- # A Symbolic Link to a Creature with an Ability # --
    AbilityID INTEGER NOT NULL,                                                         -- # A Symbolic Link to an Ability that the Creature has # --
    PRIMARY KEY (CreatureID, AbilityID),                                                -- # A Many to Many Type Primary Key that ensures a Creature doesnt get listed to the same Ability multiple times # -- 
    FOREIGN KEY (CreatureID) REFERENCES Creatures (ID),                                 -- # A Full Linkage of the Creature # --
    FOREIGN KEY (AbilitiesID) REFERENCES Abilities (ID)                                 -- # A Full Linkage of the Ability # --  
);

-- <!-- [SS-4.2]: Abilities List : Boss Linkiing ----->
CREATE TABLE Boss_Abilities (
    BossID INTEGER NOT NULL,                                                            -- # A Symbolic Link to a Boss with an Ability # --
    AbilitiesID INTEGER NOT NULL,                                                       -- # A Symbolic Link to an Ability that the Boss has # --
    PRIMARY KEY (BossID, AbilitiesID),                                                  -- # A Many to Many Type Primary Key that ensures a Boss doesnt get listed to the same Ability multiple times # -- 
    FOREIGN KEY (BossID) REFERENCES Bosses (ID),                                        -- # A Full Linkage of the Boss # --
    FOREIGN KEY (AbilitiesID) REFERENCES Abilities (ID)                                 -- # A Full Linkage of the Ability # --  
);


-- <!-- [SS-4.1]: Resistances List : Creature Linking ----->
CREATE TABLE Creature_Resistances (
    CreatureID INTEGER NOT NULL,                                                        -- # A Symbolic Link to a Creature with a Resistance # --
    ResistanceID INTEGER NOT NULL,                                                      -- # A Symbolic Link to a Resistance that the Creature has # --
    PRIMARY KEY (CreatureID, ResistanceID),                                             -- # A Many to Many Type Primary Key that ensures a Creature doesn't get listed to the same resistance multiple times # --
    FOREIGN KEY (CreatureID) REFERENCES Creatures (ID),                                 -- # A Full Linkage of the Creature # --
    FOREIGN KEY (ResistanceID) REFERENCES Attack_Effects (ID)                           -- # A Full Linkage of the Resistance # --
);

-- <!-- [SS-4.2]: Resistances List : Boss Linking ----->
CREATE TABLE Boss_Resistances (
    BossID INTEGER NOT NULL,                                                            -- # A Symbolic Link to a Boss with a Resistance # --
    ResistanceID INTEGER NOT NULL,                                                      -- # A Symbolic Link to a Resistance that the Boss has # --
    PRIMARY KEY (BossID, ResistanceID),                                                 -- # A Many to Many Type Primary Key that ensures a Boss doesn't get listed to the same resistance multiple times # --
    FOREIGN KEY (BossID) REFERENCES Bosses (ID),                                        -- # A Full Linkage of the Boss # --
    FOREIGN KEY (ResistanceID) REFERENCES Attack_Effects (ID)                           -- # A Full Linkage of the Resistance # --
);

-- <!-- [SS-5.1]: Immunities List : Creature Linking ----->
CREATE TABLE Creature_Immunity (
    CreatureID INTEGER NOT NULL,                                                        -- # A Symbolic Link to a Creature with an Immunity # --
    ImmuneID INTEGER NOT NULL,                                                          -- # A Symbolic Link to an Immunity the Creature has # --
    PRIMARY KEY (CreatureID, ImmuneID),                                                 -- # A Many to Many Type Primary Key that ensures a Creature doesn't get listed to the same Immunity multiple times # --
    FOREIGN KEY (CreatreID) REFERENCES Creatures (ID),                                  -- # A Full Linkage of the Creature # --
    FOREIGN KEY (ImmuneID) REFERENCES Attack_Effects (ID)                               -- # A Full Linkage of the Immunity
);

-- <!-- [SS-5.2]: Immunities List : Boss Linking ----->
CREATE TABLE Boss_Immunity (
    BossID INTEGER NOT NULL,                                                            -- # A Symbolic Link to a Boss with an Immunity # --
    ImmuneID INTEGER NOT NULL,                                                          -- # A Symbolic Link to an Immunity the Boss has # --
    PRIMARY KEY (BossID, ImmuneID),                                                     -- # A Many to Many Type Primary Key that ensures a Boss doesn't get listed to the same Immunity multiple times # --
    FOREIGN KEY (BossID) REFERENCES Bosses (ID),                                        -- # A Full Linkage of the Boss # --
    FOREIGN KEY (ImmuneID) REFERENCES Attack_Effects (ID)                               -- # A Full Linkage of the Immunity
);

-- <!-- [SS-6.1]: Status Immunities List : Creature Linking ----->
CREATE TABLE Creature_StatImmune (
    CreatureID INTEGER NOT NULL,                                                        -- # A Symbolic Link to a Creature with a Status Immunity # --
    ImmuneID INTEGER NOT NULL,                                                          -- # A Symbolic Link to an Status Immunity the Creature has # --
    PRIMARY KEY (CreatureID, ImmuneID),                                                 -- # A Many to Many Type Primary Key that ensures a Creature doesn't get listed to the same Status Immunity multiple times # --
    FOREIGN KEY (CreatreID) REFERENCES Creatures (ID),                                  -- # A Full Linkage of the Creature # --
    FOREIGN KEY (ImmuneID) REFERENCES Satus_Effects (ID)                                -- # A Full Linkage of the Status Immunity
);

-- <!-- [SS-6.2]: Status Immunities List : Boss Linking ----->
CREATE TABLE Boss_StatImmune (
    BossID INTEGER NOT NULL,                                                            -- # A Symbolic Link to a Boss with a Status Immunity # --
    ImmuneID INTEGER NOT NULL,                                                          -- # A Symbolic Link to an Status Immunity the Boss has # --
    PRIMARY KEY (BossID, ImmuneID),                                                     -- # A Many to Many Type Primary Key that ensures a Boss doesn't get listed to the same Status Immunity multiple times # --
    FOREIGN KEY (CreatreID) REFERENCES Bosses (ID),                                     -- # A Full Linkage of the Boss # --
    FOREIGN KEY (ImmuneID) REFERENCES Satus_Effects (ID)                                -- # A Full Linkage of the Status Immunity
);

-- <!-- [SS-7.1]: Weakness List : Creature Linking ----->
CREATE TABLE Creature_Weakness (
    CreatureID INTEGER NOT NULL,                                                        -- # A Symbolic Link to a Creature with a Weakness # --
    WeaknessID INTEGER NOT NULL,                                                        -- # A Symbolic Link to a Weakness the Creature has # --
    PRIMARY KEY (CreatureID, WeaknessID),                                               -- # A Many to Many Type Primary Key that ensures a Creature doesn't get listed to the same Weakness multiple times # --
    FOREIGN KEY (CreatureID) REFERENCES Creatures (ID),                                 -- # A FUll Linkage to the Creature # --
    FOREIGN KEY (WeaknessID) REFERENCES Attack_Effects (ID)                             -- # A Full Linkage to the Weakness # --
);

-- <!-- [SS-7.2]: Weakness List : Boss Linking ----->
CREATE TABLE Boss_Weakness (
    BossID INTEGER NOT NULL,                                                            -- # A Symbolic Link to a Boss with a Weakness # --
    WeaknessID INTEGER NOT NULL,                                                        -- # A Symbolic Link to a Weakness the Boss has # --
    PRIMARY KEY (BossID, WeaknessID),                                                   -- # A Many to Many Type Primary Key that ensures a Boss doesn't get listed to the same Weakness multiple times # --
    FOREIGN KEY (BossID) REFERENCES Bosses (ID),                                        -- # A FUll Linkage to the Boss # --
    FOREIGN KEY (WeaknessID) REFERENCES Attack_Effects (ID)                             -- # A Full Linkage to the Weakness # --
);

-- <!-- [SS-8.1]: Events List : Creature Linking ----->
CREATE TABLE Creature_Events (
    CreatureID INTEGER NOT NULL,                                                        -- # A Symbolic Link to a Creature with an Event # --
    EventsID INTEGER NOT NULL,                                                          -- # A Symbolic Link to an Event the Creature is from # --
    PRIMARY KEY (CreatureID, EventsID),                                                 -- # A Many to Many Type Primary Key that ensures a Creature doesn't get listed to the same Event multiple times # --
    FOREIGN KEY (CreatureID) REFERENCES Creatures (ID),                                 -- # A FUll Linkage to the Creature # --
    FOREIGN KEY (EventsID) REFERENCES Events (ID)                                       -- # A Full Linkage to the Event # --
),

-- <!-- [SS-8.2]: Events List : Follower Linking ----->
CREATE TABLE Follower_Events (
    FollowerID INTEGER NOT NULL,                                                        -- # A Symbolic Link to a Follower with an Event # --
    EventsID INTEGER NOT NULL,                                                          -- # A Symbolic Link to an Event that the Follower is from # --
    PRIMARY KEY (FollowerID, EventsID),                                                 -- # A Many to Many Type Primary Key that ensures a Follower doesnt get listed to the same Event multiple times # -- 
    FOREIGN KEY (FollowerID) REFERENCES Followers (ID),                                 -- # A Full Linkage of the Follower # --
    FOREIGN KEY (EventsID) REFERENCES Events (ID)                                       -- # A Full Linkage of the Event # --      
);

-- <!-- [SS-8.3]: Events List : Boss Linking ----->
CREATE TABLE Boss_Events (
    BossID INTEGER NOT NULL,                                                            -- # A Symbolic Link to a Boss with an Event # --
    EventsID INTEGER NOT NULL,                                                          -- # A Symbolic Link to an Event that the Boss is from # --
    PRIMARY KEY (BossID, EventsID),                                                     -- # A Many to Many Type Primary Key that ensures a Boss doesnt get listed to the same Event multiple times # -- 
    FOREIGN KEY (BossID) REFERENCES Bosses (ID),                                        -- # A Full Linkage of the Boss # --
    FOREIGN KEY (EventsID) REFERENCES Events (ID)                                       -- # A Full Linkage of the Event # --      
);

-- <!-- [SS-X.2]: Regular Creatures : Drops  ----->
CREATE TABLE Creature_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique ID # --
    CreatureID INTEGER NOT NULL,                                                        -- # A Symbolic Link to a Creature # --
    Item INTEGER NOT NULL,                                                              -- # The Name of the possible Drop # --
    FOREIGN KEY (CreatureID) REFERENCES Creatures (ID),                                 -- # A FUll Linkage to the Creature # --
);

-- <!-- [SS-X.2]: Regular Bosss : Drops  ----->
CREATE TABLE Boss_Drops (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,                                               -- # A Number given to this Drop as a Unique ID # --
    BossID INTEGER NOT NULL,                                                            -- # A Symbolic Link to a Boss # --
    Item INTEGER NOT NULL,                                                              -- # The Name of the possible Drop # --
    FOREIGN KEY (BossID) REFERENCES Bosses (ID),                                         -- # A FUll Linkage to the Boss # --
);