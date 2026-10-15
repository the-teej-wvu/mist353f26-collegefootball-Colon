IF OBJECT_ID('Coach', 'U') IS NOT NULL
    DROP TABLE Coach;

IF OBJECT_ID('CoachRoster', 'U') IS NOT NULL
    DROP TABLE CoachRoster;

IF OBJECT_ID('WeeklyPredictionResults', 'U') IS NOT NULL
    DROP TABLE WeeklyPredictionResults;

IF OBJECT_ID('GamePrediction', 'U') IS NOT NULL
    DROP TABLE GamePrediction;

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

IF OBJECT_ID('AppUser', 'U') IS NOT NULL
    DROP TABLE AppUser;

IF OBJECT_ID('Confernece', 'U') IS NOT NULL
    DROP TABLE Conference;

IF OBJECT_ID('TestTable', 'U') IS NOT NULL
    DROP TABLE TestTable;

GO

create table Conference (
    ConferenceID INT NOT NULL IDENTITY(1,1),
    ConferenceName VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Conference PRIMARY KEY (ConferenceID),
    CONSTRAINT UQ_Conference UNIQUE (ConferenceName)
);

create table Stadium (
    StadiumID INT NOT NULL IDENTITY(1,1),
    StadiumName VARCHAR(50) NOT NULL,
    StadiumAddress VARCHAR(100) NOT NULL,
    Capacity INT NOT NULL,
    TypeOfField VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Stadium PRIMARY KEY (StadiumID),
    CONSTRAINT UQ_Stadium UNIQUE (StadiumName, StadiumCity, StadiumState),
    CONSTRAINT CK_TypeOfField CHECK (TypeOfField IN ('Grass', 'Artificial Turf'))
);

CREATE TABLE Team (
    TeamID INT NOT NULL IDENTITY (1,1),
    UniversityName CHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    StadiumID INT NOT NULL,
    ConferenceID INT NOT NULL,
    CONSTRAINT PK_Team PRIMARY KEY (TeamID),
    CONSTRAINT UQ_Team_Stadium UNIQUE (StadiumID),
    CONSTRAINT FK_Team_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID),
    CONSTRAINT FK_Team_Conference FOREIGN KEY (ConferenceID) REFERENCES Conference(ConferenceID)
);

go

create table Coach (
    CoachID INT NOT NULL IDENTITY(1,1),
    CoachName VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Coach PRIMARY KEY (CoachID)
);

create table CoachRoster (
    CoachID INT NOT NULL,
    RosterID INT NOT NULL,
    CONSTRAINT PK_CoachRoster PRIMARY KEY (CoachID, RosterID),
    CONSTRAINT FK_CoachRoster_Coach FOREIGN KEY (CoachID) REFERENCES Coach(CoachID),
    CONSTRAINT FK_CoachRoster_Roster FOREIGN KEY (RosterID) REFERENCES Roster(RosterID)
);

create table Game (
    GameID INT NOT NULL IDENTITY(1,1),
    GameDate Date NOT NULL,
    GameTime Time NOT NULL,
    HomeScore INT NULL,
    AwayScore INT NULL,
    HomeTeamID INT NOT NULL,
    AwayTeamID INT NOT NULL,
    WinnerTeamID INT NULL,
    StadiumID INT NOT NULL,
    CONSTRAINT PK_Game PRIMARY KEY (GameID),
    CONSTRAINT FK_Game_HomeTeam FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_AwayTeam FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_WinnerTeam FOREIGN KEY (WinnerTeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Game_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);

GO

CREATE TABLE AppUser (
    AppUserId INT IDENTITY(1,1) NOT NULL,
    AppUserFirstName VARCHAR(100) NOT NULL,
    AppUserLastName VARCHAR(100) NOT NULL,
    AppUserEmail VARCHAR(100) NOT NULL,
    AppUserPassword VARCHAR(100) NOT NULL,
    CONSTRAINT PK_AppUser PRIMARY KEY (AppUserId)
);


create table Position (
    PositionID INT NOT NULL IDENTITY(1,1),
    PositionName VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Position PRIMARY KEY (PositionID),
    CONSTRAINT UQ_Position UNIQUE (PositionName)
);

GO

create table Player (
    PlayerID INT NOT NULL IDENTITY(1,1),
    FirstLastName VARCHAR(50) NOT NULL,
    PlayerDateOfBirth DATE NOT NULL,
    PositionID INT NOT NULL,
    CONSTRAINT PK_Player PRIMARY KEY (PlayerID),
    CONSTRAINT FK_Player_Position FOREIGN KEY (PositionID) REFERENCES Position(PositionID)
);

create table Roster (
    RosterID INT NOT NULL IDENTITY(1,1),
    YearNum INT NOT NULL,
    SeasonWins INT NOT NULL,
    SeasonLosses INT NOT NULL,
    SeasonTies INT NOT NULL,
    TeamID INT NOT NULL,
    CoachID INT NOT NULL,
    CONSTRAINT PK_Roster PRIMARY KEY (RosterID),
    CONSTRAINT FK_Roster_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    CONSTRAINT FK_Roster_Coach FOREIGN KEY (CoachID) REFERENCES Coach(CoachID)
);

GO

create table PlayerStats (
    PlayerStatsID INT NOT NULL IDENTITY(1,1),
    PlayerID INT NOT NULL,
    RosterID INT NOT NULL,
    CONSTRAINT PK_PlayerStats PRIMARY KEY (PlayerStatsID),
    CONSTRAINT UQ_PlayerStats UNIQUE (PlayerID, RosterID),
    CONSTRAINT FK_PlayerStats_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    CONSTRAINT FK_PlayerStats_Roster FOREIGN KEY (RosterID) REFERENCES Roster(RosterID)
);

GO

create table QBStats (
    QBStatsID INT NOT NULL,
    Attempts INT NOT NULL,
    Completions INT NOT NULL,
    PassingYards INT NOT NULL,
    PassingTouchdowns INT NOT NULL,
    Interceptions INT NOT NULL,
    CONSTRAINT PK_QBStats PRIMARY KEY (QBStatsID),
    CONSTRAINT FK_QBStats_PlayerStats FOREIGN KEY (QBStatsID) REFERENCES PlayerStats(PlayerStatsID)
);

create table RBStats (
    RBStatsID INT NOT NULL,
    Carries INT NOT NULL,
    RushingYards INT NOT NULL,
    RushingTouchdowns INT NOT NULL,
    LongestRush INT NOT NULL,
    Fumbles INT NOT NULL,
    CONSTRAINT PK_RBStats PRIMARY KEY (RBStatsID),
    CONSTRAINT FK_RBStats_PlayerStats FOREIGN KEY (RBStatsID) REFERENCES PlayerStats(PlayerStatsID)
);

go

create table DefenderStats (
    DefenderStatsID INT NOT NULL,
    Tackles INT NOT NULL,
    Sacks INT NOT NULL,
    Interceptions INT NOT NULL,
    Touchdowns INT NOT NULL,
    CONSTRAINT PK_DefenderStats PRIMARY KEY (DefenderStatsID),
    CONSTRAINT FK_DefenderStats_PlayerStats FOREIGN KEY (DefenderStatsID) REFERENCES PlayerStats(PlayerStatsID)
);


create table ReturnerStats (
    ReturnerStatsID INT NOT NULL,
    KickAttempts INT NOT NULL,
    KickReturnYards INT NOT NULL,
    KickLongestReturn INT NOT NULL,
    KickReturnTouchdowns INT NOT NULL,
    PuntReturns INT NOT NULL,
    PuntReturnYards INT NOT NULL,
    PuntLongestReturn INT NOT NULL,
    PuntReturnTouchdowns INT NOT NULL,
    CONSTRAINT PK_ReturnerStats PRIMARY KEY (ReturnerStatsID),
    CONSTRAINT FK_ReturnerStats_PlayerStats FOREIGN KEY (ReturnerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);

go

create table KickerStats (
    KickerStatsID INT NOT NULL,
    FieldGoalsMade INT NOT NULL,
    FieldGoalsAttempted INT NOT NULL,
    LongestFieldGoal INT NOT NULL,
    ExtraPointsMade INT NOT NULL,
    ExtraPointsAttempted INT NOT NULL,
    CONSTRAINT PK_KickerStats PRIMARY KEY (KickerStatsID),
    CONSTRAINT FK_KickerStats_PlayerStats FOREIGN KEY (KickerStatsID) REFERENCES PlayerStats(PlayerStatsID)
);

create table PunterStats (
    PunterStatsID INT NOT NULL,
    Punts INT NOT NULL,
    PuntYards INT NOT NULL,
    LongestPunt INT NOT NULL,
    CONSTRAINT PK_PunterStats PRIMARY KEY (PunterStatsID),
    CONSTRAINT FK_PunterStats_PlayerStats FOREIGN KEY (PunterStatsID) REFERENCES PlayerStats(PlayerStatsID)
);

GO

CREATE TABLE GamePrediction (
    GamePredictionId INT NOT NULL IDENTITY(1,1),
    AppUserID INT NOT NULL,
    GameId INT NOT NULL,
    WinningTeamId INT NULL,
    PredictedScore INT NULL,
   CONSTRAINT PK_GamePrediction PRIMARY KEY (GamePredictionID),
   CONSTRAINT UQ_GamePrediction_UserGame UNIQUE (AppUserID, GameID),
   CONSTRAINT FK_GamePrediction_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID),
   CONSTRAINT FK_GamePrediction_Game FOREIGN KEY (GameID) REFERENCES Game(GameID),
   CONSTRAINT FK_GamePrediction_Team FOREIGN KEY (WinningTeamID) REFERENCES Team(TeamID)
);

CREATE TABLE WeeklyPredictionResults (
    WeeklyPredictionResultsId INT NOT NULL IDENTITY(1,1),
    StartDate DATE NOT NULL,
    NumOfCorrectPredictions INT NOT NULL,
    AppUserID INT NOT NULL,
    CONSTRAINT PK_WeeklyPredictionResults PRIMARY KEY (WeeklyPredictionResultsId),
    CONSTRAINT FK_WeeklyPredictionResults_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID)
);

GO