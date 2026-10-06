
/*
CREATE LOGIN NandaSurendra
WITH PASSWORD = 'MI$T353Instructor';

CREATE USER NandaSurendra
FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra;
*/

IF OBJECT_ID('PunterStats', 'U') IS NOT NULL
    DROP TABLE PunterStats;

IF OBJECT_ID('KickerStats', 'U') IS NOT NULL
    DROP TABLE KickerStats;

IF OBJECT_ID('ReturnerStats', 'U') IS NOT NULL
    DROP TABLE ReturnerStats;

IF OBJECT_ID('DefenderStats', 'U') IS NOT NULL
    DROP TABLE DefenderStats;

IF OBJECT_ID('RBStats', 'U') IS NOT NULL
    DROP TABLE RBStats;

IF OBJECT_ID('QBStats', 'U') IS NOT NULL
    DROP TABLE QBStats;

IF OBJECT_ID('PlayerStats', 'U') IS NOT NULL
    DROP TABLE PlayerStats;

IF OBJECT_ID('Roster', 'U') IS NOT NULL
    DROP TABLE Roster;

IF OBJECT_ID('Player', 'U') IS NOT NULL
    DROP TABLE Player;

IF OBJECT_ID('Position', 'U') IS NOT NULL
    DROP TABLE Position;

IF OBJECT_ID('Game', 'U') IS NOT NULL
    DROP TABLE Game;

IF OBJECT_ID('Team', 'U') IS NOT NULL
    DROP TABLE Team;

IF OBJECT_ID('Stadium', 'U') IS NOT NULL
    DROP TABLE Stadium;

go

create table Stadium (
    StadiumID INT NOT NULL IDENTITY(1,1),
    StadiumName VARCHAR(50) NOT NULL,
    StadiumStreetAddress VARCHAR(100) NOT NULL,
    StadiumCity VARCHAR(50) NOT NULL,
    StadiumState VARCHAR(2) NOT NULL,
    StadiumCapacity INT NOT NULL,
    TypeOfField VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Stadium PRIMARY KEY (StadiumID),
    CONSTRAINT UQ_Stadium UNIQUE (StadiumName, StadiumCity, StadiumState),
    CONSTRAINT CK_TypeOfField CHECK (TypeOfField IN ('Grass', 'Artificial Turf'))
);

go

CREATE TABLE Team (
    TeamID INT NOT NULL IDENTITY (1,1),
    UniversityName CHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    StadiumID INT NOT NULL,
    CONSTRAINT PK_Team PRIMARY KEY (TeamID),
    CONSTRAINT UQ_UniversityName UNIQUE (UniversityName),
    CONSTRAINT FK_Team_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)

);

go

create table Game (
    GameID INT NOT NULL IDENTITY(1,1),
    GameDate Date NOT NULL,
    GameTime Time NOT NULL,
    HomeScore INT NULL,
    AwayScore INT NULL,
    HomeTeamID INT NOT NULL,
    AwayTeamID INT NOT NULL,
    WinnerTeamID INT NULL,
    CONSTRAINT PK_Game PRIMARY KEY (GameID),
    CONSTRAINT UQ_Game UNIQUE (GameDate, GameTime),
    CONSTRAINT FK_Game_HomeTeam FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_AwayTeam FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_WinnerTeam FOREIGN KEY (WinnerTeamID) REFERENCES Team(TeamID)
);

create table Position (
    PositionID INT NOT NULL IDENTITY(1,1),
    PositionName VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Position PRIMARY KEY (PositionID),
    CONSTRAINT UQ_Position UNIQUE (PositionName)
);

create table Player (
    PlayerID INT NOT NULL IDENTITY(1,1),
    FirstLastName VARCHAR(50) NOT NULL,
    PlayerDateOfBirth DATE NOT NULL,
    PositionID INT NOT NULL,
    CONSTRAINT PK_Player PRIMARY KEY (PlayerID),
    CONSTRAINT UQ_Player UNIQUE (PlayerID),
    CONSTRAINT FK_Player_Position FOREIGN KEY (PositionID) REFERENCES Position(PositionID)
);

create table Roster (
    RosterID INT NOT NULL IDENTITY(1,1),
    PlayerID INT NOT NULL,
    YearNum INT NOT NULL,
    SeasonWins INT NOT NULL,
    SeasonLosses INT NOT NULL,
    SeasonTies INT NOT NULL,
    TeamID INT NOT NULL,
    CONSTRAINT PK_Roster PRIMARY KEY (RosterID),
    CONSTRAINT UQ_Roster UNIQUE (RosterID),
    CONSTRAINT FK_Roster_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    CONSTRAINT FK_Roster_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
)   

create table PlayerStats (
    PlayerStatsID INT NOT NULL IDENTITY(1,1),
    Position VARCHAR(50) NOT NULL,
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    CONSTRAINT PK_PlayerStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT FK_PlayerStats_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    CONSTRAINT FK_PlayerStats_Roster FOREIGN KEY (RosterID) REFERENCES Roster(RosterID)
);
create table QBStats (
    QBStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    Attempts INT NOT NULL,
    Completions INT NOT NULL,
    PassingYards INT NOT NULL,
    PassingTouchdowns INT NOT NULL,
    Interceptions INT NOT NULL,
    CONSTRAINT PK_QBStats PRIMARY KEY (QBStatsID),
    CONSTRAINT FK_QBStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);
create table RBStats (
    RBStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    RushingAttempts INT NOT NULL,
    RushingYards INT NOT NULL,
    RushingTouchdowns INT NOT NULL,
    LongestRush INT NOT NULL,
    Fumbles INT NOT NULL,
    CONSTRAINT PK_RBStats PRIMARY KEY (RBStatsID),
    CONSTRAINT FK_RBStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);
create table DefenderStats (
    DefenderStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    Tackles INT NOT NULL,
    Sacks INT NOT NULL,
    Interceptions INT NOT NULL,
    Touchdowns INT NOT NULL,
    CONSTRAINT PK_DefenderStats PRIMARY KEY (DefenderStatsID),
    CONSTRAINT FK_DefenderStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);
create table ReturnerStats (
    ReturnerStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    KickAttempts INT NOT NULL,
    KickReturnYards INT NOT NULL,
    KickLongestReturn INT NOT NULL,
    KickReturnTouchdowns INT NOT NULL,
    PuntReturns INT NOT NULL,
    PuntReturnYards INT NOT NULL,
    PuntLongestReturn INT NOT NULL,
    PuntReturnTouchdowns INT NOT NULL,
    CONSTRAINT PK_ReturnerStats PRIMARY KEY (ReturnerStatsID),
    CONSTRAINT FK_ReturnerStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);
create table KickerStats (
    KickerStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    FieldGoalsMade INT NOT NULL,
    FieldGoalsAttempted INT NOT NULL,
    LongestFieldGoal INT NOT NULL,
    ExtraPointsMade INT NOT NULL,
    ExtraPointsAttempted INT NOT NULL,
    CONSTRAINT PK_KickerStats PRIMARY KEY (KickerStatsID),
    CONSTRAINT FK_KickerStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);
create table PunterStats (
    PunterStatsID INT NOT NULL IDENTITY(1,1),
    PlayerStatsID INT NOT NULL,
    Punts INT NOT NULL,
    PuntYards INT NOT NULL,
    LongestPunt INT NOT NULL,
    CONSTRAINT PK_PunterStats PRIMARY KEY (PunterStatsID),
    CONSTRAINT FK_PunterStats_PlayerStats FOREIGN KEY (PlayerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);
