-- <!-- [SS-0]: Meta Data ----> --
/*
Version = '4.16'
Date = '4/27/25'
Desc = 'Defines the Database Static Schemas for OrnaBot'
Tables = 1
Index = {
    Coords = 14,

}
*/

-- <!-- [SS-1.1]: Co-Ordinates ----->
CREATE TABLE IF NOT EXISTS Coords (
    ID STRING PRIMARY KEY,
    X INTEGER NOT NULL,
    Y INTEGER NOT NULL,
    HELD INTEGER DEFAULT 0
);
