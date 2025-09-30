-- <!-- [SS-0]: Meta Data ----> --
/*
Version = '4.16'
Date = '4/27/25'
Desc = 'Defines the Database User Schemas for OrnaBot'
Tables =2
Index = {
    Personal = 15,
    Accounts = 21,

}
*/

-- <!-- [SS-1.1]: Settings & Accounts ----->
CREATE TABLE IF NOT EXISTS Personal (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    UserName STRING UNIQUE NOT NULL,
    Email STRING NOT NULL,
    Passwrd STRING NOT NULL
);

CREATE TABLE IF NOT EXISTS Accounts (
    UserName STRING PRIMARY KEY,
    SettingKey STRING NOT NULL,
    SettingValue STRING NOT NULL,
    FOREIGN KEY (UserName) REFERENCES Personal(UserName)
);
