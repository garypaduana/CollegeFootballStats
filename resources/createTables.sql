DROP TABLE IF EXISTS Drives;
DROP TABLE IF EXISTS Kickoffs;
DROP TABLE IF EXISTS Kickoff_Returns;
DROP TABLE IF EXISTS Game_Statistics;
DROP TABLE IF EXISTS Passes;
DROP TABLE IF EXISTS Rushes;
DROP TABLE IF EXISTS Punts;
DROP TABLE IF EXISTS Punt_Returns;
DROP TABLE IF EXISTS Receptions;
DROP TABLE IF EXISTS Plays;
DROP TABLE IF EXISTS Player_Game_Statistics;
DROP TABLE IF EXISTS Team_Game_Statistics;
DROP TABLE IF EXISTS Games;
DROP TABLE IF EXISTS Players;
DROP TABLE IF EXISTS Stadiums;
DROP TABLE IF EXISTS Teams;
DROP TABLE IF EXISTS Conferences;

CREATE TABLE Conferences
(
	Conference_Code INTEGER,
	Year INTEGER,
	Name TEXT,
	Subdivision TEXT,
	PRIMARY KEY (Conference_Code, Year)
);

CREATE TABLE Games
(
	Game_Code TEXT,
	Date TEXT,
	Visit_Team_Code INTEGER,
	Home_Team_Code INTEGER,
	Stadium_Code INTEGER,
	Site TEXT,
	PRIMARY KEY (Game_Code),
	FOREIGN KEY (Stadium_Code) REFERENCES Stadiums(Stadium_Code)
);

CREATE TABLE Drives
(
	Game_Code TEXT,
	Drive_Number INTEGER,
	Team_Code INTEGER,
	Start_Period INTEGER,
	Start_Clock INTEGER,
	Start_Spot INTEGER,
	Start_Reason TEXT,
	End_Period INTEGER,
	End_Clock INTEGER,
	End_Spot INTEGER,
	End_Reason TEXT,
	Plays INTEGER,
	Yards INTEGER,
	Time_Of_Possession INTEGER,
	Red_Zone_Attempt INTEGER,
	PRIMARY KEY (Game_Code, Drive_Number),
	FOREIGN KEY (Game_Code) REFERENCES Games(Game_Code)
);

CREATE TABLE Game_Statistics
(
	Game_Code TEXT,
	Attendance INTEGER,
	Duration INTEGER,
	PRIMARY KEY (Game_Code),
	FOREIGN KEY (Game_Code) REFERENCES Games(Game_Code)
);

CREATE TABLE Kickoffs
(
	Game_Code TEXT,
	Play_Number INTEGER,
	Team_Code INTEGER,
	Player_Code INTEGER,
	Attempt INTEGER,
	Yards INTEGER,
	Fair_Catch INTEGER,
	Touchback INTEGER,
	Downed INTEGER,
	Out_Of_Bounds INTEGER,
	Onside INTEGER,
	Onside_Success INTEGER,
	PRIMARY KEY (Game_Code, Play_Number),
	FOREIGN KEY (Game_Code) REFERENCES Games(Game_Code)
);

CREATE TABLE Kickoff_Returns
(
	Game_Code TEXT,
	Play_Number INTEGER,
	Team_Code INTEGER,
	Player_Code INTEGER,
	Attempt INTEGER,
	Yards INTEGER,
	Touchdown INTEGER,
	Fumble INTEGER,
	Fumble_Lost INTEGER,
	Safety INTEGER,
	Fair_Catch INTEGER,
	FOREIGN KEY (Game_Code) REFERENCES Games(Game_Code)
);

CREATE TABLE Passes
(
	Game_Code TEXT,
	Play_Number INTEGER,
	Team_Code INTEGER,
	Passer_Player_Code INTEGER,
	Receiver_Player_Code INTEGER,
	Attempt INTEGER,
	Completion INTEGER,
	Yards INTEGER,
	Touchdown INTEGER,
	Interception INTEGER,
	First_Down INTEGER,
	Dropped INTEGER,
	PRIMARY KEY (Game_Code, Play_Number),
	FOREIGN KEY (Game_Code) REFERENCES Game(Game_Code)
);

CREATE TABLE Plays
(
	Game_Code TEXT,
	Play_Number INTEGER,
	Period_Number INTEGER,
	Clock INTEGER,
	Offense_Team_Code INTEGER,
	Defense_Team_Code INTEGER,
	Offense_Points INTEGER,
	Defense_Points INTEGER,
	Down INTEGER,
	Distance INTEGER,
	Spot INTEGER,
	Play_Type INTEGER,
	Drive_Number INTEGER,
	Drive_Play INTEGER,
	PRIMARY KEY (Game_Code, Play_Number),
	FOREIGN KEY (Game_Code) REFERENCES Game(Game_Code)
);

CREATE TABLE Players
(
	Year INTEGER,
	Player_Code INTEGER,
	Team_Code INTEGER,
	Last_Name TEXT,
	First_Name TEXT,
	Uniform_Number TEXT,
	Class TEXT,
	Position TEXT,
	Height INTEGER,
	Weight INTEGER,
	Home_Town TEXT,
	Home_State TEXT,
	Home_Country TEXT,
	Last_School TEXT,
	PRIMARY KEY (Year, Player_Code, Team_Code, Class, Position),
	FOREIGN KEY (Team_Code) REFERENCES Teams(Team_Code)
);

CREATE TABLE Player_Game_Statistics
(
	Player_Code INTEGER,
	Game_Code INTEGER,
	Rush_Att INTEGER,
	Rush_Yard INTEGER,
	Rush_TD INTEGER,
	Pass_Att INTEGER,
	Pass_Comp INTEGER,
	Pass_Yard INTEGER,
	Pass_TD INTEGER,
	Pass_Int INTEGER,
	Pass_Conv INTEGER,
	Rec INTEGER,
	Rec_Yards INTEGER,
	Rec_TD INTEGER,
	Kickoff_Ret INTEGER,
	Kickoff_Ret_Yard INTEGER,
	Kickoff_Ret_TD INTEGER,
	Punt_Ret INTEGER,
	Punt_Ret_Yard INTEGER,
	Punt_Ret_TD INTEGER,
	Fum_Ret INTEGER,
	Fum_Ret_Yard INTEGER,
	Fum_Ret_TD INTEGER,
	Int_Ret INTEGER,
	Int_Ret_Yard INTEGER,
	Int_Ret_TD INTEGER,
	Misc_Ret INTEGER,
	Misc_Ret_Yard INTEGER,
	Misc_Ret_TD INTEGER,
	Field_Goal_Att INTEGER,
	Field_Goal_Made INTEGER,
	Off_XP_Kick_Att INTEGER,
	Off_XP_Kick_Made INTEGER,
	Off_2XP_Att INTEGER,
	Off_2XP_Made INTEGER,
	Def_2XP_Att INTEGER,
	Def_2XP_Made INTEGER,
	Safety INTEGER,
	Points INTEGER,
	Punt INTEGER,
	Punt_Yard INTEGER,
	Kickoff INTEGER,
	Kickoff_Yard INTEGER,
	Kickoff_Touchback INTEGER,
	Kickoff_Out_Of_Bounds INTEGER,
	Kickoff_Onside INTEGER,
	Fumble INTEGER,
	Fumble_Lost INTEGER,
	Tackle_Solo INTEGER,
	Tackle_Assist INTEGER,
	Tackle_For_Loss INTEGER,
	Tackle_For_Loss_Yard INTEGER,
	Sack INTEGER,
	Sack_Yard INTEGER,
	QB_Hurry INTEGER,
	Fumble_Forced INTEGER,
	Pass_Broken_Up INTEGER,
	Kick_Punt_Blocked INTEGER,
	PRIMARY KEY (Player_Code, Game_Code),
	FOREIGN KEY (Player_Code) REFERENCES Players(Player_Code),
	FOREIGN KEY (Game_Code) REFERENCES Games(Game_Code)
);

CREATE TABLE Punts
(
	Game_Code TEXT,
	Play_Number INTEGER,
	Team_Code INTEGER,
	Player_Code INTEGER,
	Attempt INTEGER,
	Yards INTEGER,
	Blocked INTEGER,
	Fair_Catch INTEGER,
	Touchback INTEGER,
	Downed INTEGER,
	Out_Of_Bounds INTEGER,
	PRIMARY KEY (Game_Code, Play_Number),
	FOREIGN KEY (Game_Code) REFERENCES Games(Game_Code),
	FOREIGN KEY (Team_Code) REFERENCES Teams(Team_Code),
	FOREIGN KEY (Player_Code) REFERENCES Players(Player_Code),
	FOREIGN KEY (Play_Number) REFERENCES Plays(Play_Number)
);

CREATE TABLE Punt_Returns
(
	Game_Code TEXT,
	Play_Number INTEGER,
	Team_Code INTEGER,
	Player_Code INTEGER,
	Attempt INTEGER,
	Yards INTEGER,
	Touchdown INTEGER,
	Fumble INTEGER,
	Fumble_Lost INTEGER,
	Safety INTEGER,
	Fair_Catch INTEGER,
	FOREIGN KEY (Game_Code) REFERENCES Games(Game_Code),
	FOREIGN KEY (Game_Code, Play_Number) REFERENCES Games(Game_Code, Play_Number),
	FOREIGN KEY (Team_Code) REFERENCES Teams(Team_Code),
	FOREIGN KEY (Player_Code) REFERENCES Players(Player_Code)
);

CREATE TABLE Receptions
(
	Game_Code TEXT,
	Play_Number INTEGER,
	Team_Code INTEGER,
	Player_Code INTEGER,
	Reception INTEGER,
	Yards INTEGER,
	Touchdown INTEGER,
	First_Down INTEGER,
	Fumble INTEGER,
	Fumble_Lost INTEGER,
	Safety INTEGER,
	FOREIGN KEY (Team_Code) REFERENCES Teams(Team_Code),
	FOREIGN KEY (Player_Code) REFERENCES Players(Player_Code),
	FOREIGN KEY (Game_Code, Play_Number) REFERENCES Plays(Game_Code, Play_Number),
	FOREIGN KEY (Game_Code) REFERENCES Games(Game_Code)
);

CREATE TABLE Rushes
(
	Game_Code TEXT,
	Play_Number INTEGER,
	Team_Code INTEGER,
	Player_Code INTEGER,
	Attempt INTEGER,
	Yards INTEGER,
	Touchdown INTEGER,
	First_Down INTEGER,
	Sack INTEGER,
	Fumble INTEGER,
	Fumble_Lost INTEGER,
	Safety INTEGER,
	FOREIGN KEY (Game_Code) REFERENCES Games(Game_Code),
	FOREIGN KEY (Game_Code, Play_Number) REFERENCES Plays(Game_Code, Play_Number),
	FOREIGN KEY (Team_Code) REFERENCES Teams(Team_Code),
	FOREIGN KEY (Player_Code) REFERENCES Players(Player_Code)
);

CREATE TABLE Stadiums
(
	Year INTEGER,
	Stadium_Code INTEGER,
	Name TEXT,
	City TEXT,
	State TEXT,
	Capacity INTEGER,
	Surface TEXT,
	Year_Opened INTEGER,
	PRIMARY KEY (Year, Stadium_Code)
);

CREATE TABLE Teams
(
	Team_Code INTEGER,
	Year INTEGER,
	Name TEXT,
	Conference_Code INTEGER,
	PRIMARY KEY (Team_Code, Year),
	FOREIGN KEY (Conference_Code, Year) REFERENCES Conferences(Conference_Code, Year)
);

CREATE TABLE Team_Game_Statistics
(
	Team_Code INTEGER,
	Game_Code INTEGER,
	Rush_Att INTEGER,
	Rush_Yard INTEGER,
	Rush_TD INTEGER,
	Pass_Att INTEGER,
	Pass_Comp INTEGER,
	Pass_Yard INTEGER,
	Pass_TD INTEGER,
	Pass_Int INTEGER,
	Pass_Conv INTEGER,
	Kickoff_Ret INTEGER,
	Kickoff_Ret_Yard INTEGER,
	Kickoff_Ret_TD INTEGER,
	Punt_Ret INTEGER,
	Punt_Ret_Yard INTEGER,
	Punt_Ret_TD INTEGER,
	Fum_Ret INTEGER,
	Fum_Ret_Yard INTEGER,
	Fum_Ret_TD INTEGER,
	Int_Ret INTEGER,
	Int_Ret_Yard INTEGER,
	Int_Ret_TD INTEGER,
	Misc_Ret INTEGER,
	Misc_Ret_Yard INTEGER,
	Misc_Ret_TD INTEGER,
	Field_Goal_Att INTEGER,
	Field_Goal_Made INTEGER,
	Off_XP_Kick_Att INTEGER,
	Off_XP_Kick_Made INTEGER,
	Off_2XP_Att INTEGER,
	Off_2XP_Made INTEGER,
	Def_2XP_Att INTEGER,
	Def_2XP_Made INTEGER,
	Safety INTEGER,
	Points INTEGER,
	Punt INTEGER,
	Punt_Yard INTEGER,
	Kickoff INTEGER,
	Kickoff_Yard INTEGER,
	Kickoff_Touchback INTEGER,
	Kickoff_Out_Of_Bounds INTEGER,
	Kickoff_Onside INTEGER,
	Fumble INTEGER,
	Fumble_Lost INTEGER,
	Tackle_Solo INTEGER,
	Tackle_Assist INTEGER,
	Tackle_For_Loss INTEGER,
	Tackle_For_Loss_Yard INTEGER,
	Sack INTEGER,
	Sack_Yard INTEGER,
	QB_Hurry INTEGER,
	Fumble_Forced INTEGER,
	Pass_Broken_Up INTEGER,
	Kick_Punt_Blocked INTEGER,
	First_Down_Rush INTEGER,
	First_Down_Pass INTEGER,
	First_Down_Penalty INTEGER,
	Time_Of_Possession INTEGER,
	Penalty INTEGER,
	Penalty_Yard INTEGER,
	Third_Down_Att INTEGER,
	Third_Down_Conv INTEGER,
	Fourth_Down_Att INTEGER,
	Fourth_Down_Conv INTEGER,
	Red_Zone_Att INTEGER,
	Red_Zone_TD INTEGER,
	Red_Zone_Field_Goal,
	PRIMARY KEY (Team_Code, Game_Code),
	FOREIGN KEY (Team_Code) REFERENCES Teams(Team_Code),
	FOREIGN KEY (Game_Code) REFERENCES Games(Game_Code)
);