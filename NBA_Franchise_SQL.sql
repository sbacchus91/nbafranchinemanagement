--TABLES & SEQUENCES
--Replace this with your table creations.

DROP TABLE IF EXISTS To_be_Delivered_Item;
DROP TABLE IF EXISTS In_Store_Item;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Game;
DROP TABLE IF EXISTS Social_Media_Post;
DROP TABLE IF EXISTS Social_Media_Platform;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Agency;
DROP TABLE IF EXISTS Stadium;
DROP TABLE IF EXISTS Franchise;
DROP SEQUENCE IF EXISTS FranchiseSeq;
DROP SEQUENCE IF EXISTS StadiumSeq;
DROP SEQUENCE IF EXISTS PlayerSeq;
DROP SEQUENCE IF EXISTS AgencySeq;
DROP SEQUENCE IF EXISTS Social_Media_PlatformSeq;
DROP SEQUENCE IF EXISTS Social_Media_PostSeq;
DROP SEQUENCE IF EXISTS GameSeq;
DROP SEQUENCE IF EXISTS ItemSeq;

CREATE TABLE Franchise(
Franchise_ID DECIMAL(12) NOT NULL PRIMARY KEY,
Franchise_Name VARCHAR(50) NOT NULL, 
Franchise_Location VARCHAR(50) NOT NULL, 
Franchise_Assets DECIMAL(12,2) NOT NULL, 
Franchise_Liabilities DECIMAL(12,2) NOT NULL
);


CREATE TABLE Stadium(
Stadium_ID DECIMAL(12) NOT NULL PRIMARY KEY, 
Franchise_ID DECIMAL(12) NOT NULL,
FOREIGN KEY (Franchise_ID) REFERENCES Franchise(Franchise_ID),
Stadium_Name VARCHAR(50) NOT NULL,
Stadium_Seating DECIMAL(7) NOT NULL,
Stadium_Shops DECIMAL(3) NOT NULL,
);

CREATE TABLE Agency(
Agency_ID DECIMAL(12) NOT NULL PRIMARY KEY,
Agency_Name VARCHAR(50) NOT NULL
);

CREATE TABLE Player(
Player_ID DECIMAL(12) NOT NULL PRIMARY KEY, 
Franchise_ID DECIMAL(12), 
Agency_ID DECIMAL(12), 
FOREIGN KEY (Franchise_ID) REFERENCES Franchise(Franchise_ID),
FOREIGN KEY (Agency_ID) REFERENCES Agency(Agency_ID),
First_Name VARCHAR(50) NOT NULL, 
Last_Name VARCHAR(50) NOT NULL, 
Position VARCHAR(50) NOT NULL, 
Contract_Size DECIMAL(10,2) NOT NULL, 
Contract_Start_Date DATE NOT NULL, 
Contract_End_Date DATE NOT NULL
);

CREATE TABLE Social_Media_Platform(
Platform_ID DECIMAL(12) NOT NULL PRIMARY KEY,
Franchise_ID DECIMAL(12), 
Player_ID DECIMAL(12),
FOREIGN KEY (Franchise_ID) REFERENCES Franchise(Franchise_ID),
FOREIGN KEY (Player_ID) REFERENCES Player(Player_ID),
Platform_Name VARCHAR(50)
);


CREATE TABLE Social_Media_Post(
Post_ID DECIMAL(12) NOT NULL PRIMARY KEY, 
Platform_ID DECIMAL(12), 
FOREIGN KEY (PLATFORM_ID) REFERENCES Social_Media_Platform,
Post_Content VARCHAR(255) NOT NULL, 
Post_Date DATE NOT NULL, 
Post_Engagement DECIMAL(12) NOT NULL
);


CREATE TABLE Game(
Game_ID DECIMAL(12) NOT NULL PRIMARY KEY, 
Stadium_ID DECIMAL(12),
FOREIGN KEY (Stadium_ID) REFERENCES Stadium(Stadium_ID),
Game_Date DATE NOT NULL, 
Opposing_Team VARCHAR(50) NOT NULL, 
WinningorLoss VARCHAR(1) NOT NULL, 
Revenue_Generated DECIMAL(12,2),
Home_or_Away VARCHAR(4)
);

CREATE TABLE Item(
Item_ID DECIMAL(12) NOT NULL PRIMARY KEY,
Player_ID DECIMAL(12),
FOREIGN KEY (Player_ID) REFERENCES Player(Player_ID),
Item_Name VARCHAR(255) NOT NULL, 
Item_Description VARCHAR(255) NOT NULL, 
Item_Price DECIMAL(12,2) NOT NULL
);

CREATE TABLE In_Store_Item(
Item_ID DECIMAL(12) NOT NULL PRIMARY KEY,
FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID),
StorageCostPerUnit DECIMAL(4,2) NOT NULL
);

CREATE TABLE PriceChange (
PriceChangeID DECIMAL(12) NOT NULL PRIMARY KEY,
OldPrice DECIMAL(8,2) NOT NULL,
NewPrice DECIMAL(8,2) NOT NULL,
Item_ID DECIMAL(12) NOT NULL,
ChangeDate DATE NOT NULL,
FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID)
);

CREATE TABLE To_be_Delivered_Item(
Item_ID DECIMAL(12) NOT NULL PRIMARY KEY,
FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID)
);

CREATE SEQUENCE FranchiseSeq START WITH 1;
CREATE SEQUENCE StadiumSeq START WITH 1;
CREATE SEQUENCE PlayerSeq START WITH 1;
CREATE SEQUENCE AgencySeq START WITH 1;
CREATE SEQUENCE Social_Media_PlatformSeq START WITH 1;
CREATE SEQUENCE Social_Media_PostSeq START WITH 1;
CREATE SEQUENCE GameSeq START WITH 1;
CREATE SEQUENCE ItemSeq START WITH 1;
CREATE SEQUENCE PriceChangeSeq START WITH 1;



--INDEXES
--Replace this with your index creations.

--Foreign Key Indexes
CREATE UNIQUE INDEX StadiumFranchiseIdx
ON Stadium(Franchise_ID);

CREATE INDEX PlatformFranchiseIdx
ON Social_Media_Platform(Franchise_ID);

CREATE INDEX PlatformPlayerIdx
ON Social_Media_Platform(Player_ID);

CREATE INDEX PostPlatformIdx
ON Social_Media_Post(Platform_ID);

CREATE INDEX PlayerFranchiseIdx
ON Player(Franchise_ID);

CREATE INDEX PlayerAgencyIdx
ON Player(Agency_ID);

CREATE INDEX ItemPlayerIdx
ON Item(Player_ID);

CREATE INDEX GameStadiumIdx
ON Game(Stadium_ID);

--Query Indexes
--Helpful for Query 1
CREATE INDEX PostDateIdx
ON Social_Media_Post(Post_Date);

--Helpful for Query 2
CREATE UNIQUE INDEX ItemDescIdx
ON Item(Item_Description);

--Helpful for Query 3
CREATE INDEX PlayerContractSizeIdx
ON Player(Contract_Size);

--STORED PROCEDURES
--Replace this with your stored procedure definitions.

CREATE OR ALTER PROCEDURE AddFranchise @Franchise_ID DECIMAL(12), @Franchise_Name VARCHAR(50), @Franchise_Location VARCHAR(50),
@Franchise_Assets DECIMAL(12,2), @Franchise_Liabilities DECIMAL(12,2)
AS
BEGIN
INSERT INTO Franchise(Franchise_ID, Franchise_Name, Franchise_Location, Franchise_Assets, Franchise_Liabilities)
VALUES(@Franchise_ID, @Franchise_Name, @Franchise_Location, @Franchise_Assets, @Franchise_Liabilities);
INSERT INTO Franchise(Franchise_ID)
VALUES(@Franchise_ID);
END;

CREATE OR ALTER PROCEDURE AddStadium @Stadium_ID DECIMAL(12), @Franchise_ID DECIMAL(12), @Stadium_Name VARCHAR(50), @Stadium_Seating DECIMAL(7),
@Stadium_Shops DECIMAL(3)
AS
BEGIN

INSERT INTO Stadium(Stadium_ID, Franchise_ID, Stadium_Name, Stadium_Seating, Stadium_Shops)
VALUES(@Stadium_ID, @Franchise_ID, @Stadium_Name, @Stadium_Seating, @Stadium_Shops);
INSERT INTO Stadium(Stadium_ID)
VALUES(@Stadium_ID);
END;

CREATE OR ALTER PROCEDURE AddAgency @Agency_ID DECIMAL(12), @Agency_Name VARCHAR(50)
AS
BEGIN
INSERT INTO Agency(Agency_ID, Agency_Name)
VALUES(@Agency_ID, @Agency_Name);
INSERT INTO Agency(Agency_ID)
VALUES(@Agency_ID);
END;

--INSERTS
--Replace this with the inserts necessary to populate your tables.
--Some of these inserts will come from executing the stored procedures.

--Franchise Insert
DECLARE	@current_franchise_seq INT = NEXT VALUE FOR FranchiseSeq;
BEGIN TRANSACTION AddFranchise;
EXECUTE AddFranchise @current_franchise_seq, 'New York Knicks', 'New York', 1000000000, 50000000;
COMMIT TRANSACTION AddFranchise;

SELECT * FROM Franchise;


--Stadium Insert
DECLARE	@current_stadium_seq INT = NEXT VALUE FOR StadiumSeq;
BEGIN TRANSACTION AddStadium;
EXECUTE AddStadium @current_stadium_seq, '1', 'Madison Square Garden', 21000, 10;
COMMIT TRANSACTION AddStadium;

SELECT * FROM Stadium;

--Agency Inserts
DECLARE	@current_agency_seq INT = NEXT VALUE FOR AgencySeq;
BEGIN TRANSACTION AddAgency;
EXECUTE AddAgency @current_agency_seq, 'Klutch Sports';
COMMIT TRANSACTION AddAgency;


INSERT INTO Agency(Agency_ID,Agency_Name)
VALUES(NEXT VALUE FOR AgencySeq, 'Gifted Talents');
INSERT INTO Agency(Agency_ID,Agency_Name)
VALUES(NEXT VALUE FOR AgencySeq, 'All Star Agency');
INSERT INTO Agency(Agency_ID,Agency_Name)
VALUES(NEXT VALUE FOR AgencySeq, 'Grove Street');
INSERT INTO Agency(Agency_ID,Agency_Name)
VALUES(NEXT VALUE FOR AgencySeq, 'Ballas Agency');

SELECT * FROM Agency;

--Player Inserts
DECLARE	@current_player_seq INT = NEXT VALUE FOR PlayerSeq;
INSERT INTO Player(Player_ID,Franchise_ID,Agency_ID,First_Name,Last_Name,Position,Contract_Size,Contract_Start_Date,Contract_End_Date)
VALUES(@current_player_seq,1,1,'Julius', 'Randle','PF',20000000, CAST('1-1-2022' AS DATE), CAST('12-1-2022' AS DATE));
INSERT INTO Player(Player_ID,Franchise_ID,Agency_ID,First_Name,Last_Name,Position,Contract_Size,Contract_Start_Date,Contract_End_Date)
VALUES(NEXT VALUE FOR PlayerSeq,1,1,'Carmelo', 'Anthony','SF',50000000, CAST('1-1-2022' AS DATE), CAST('12-1-2022' AS DATE));
INSERT INTO Player(Player_ID,Franchise_ID,Agency_ID,First_Name,Last_Name,Position,Contract_Size,Contract_Start_Date,Contract_End_Date)
VALUES(NEXT VALUE FOR PlayerSeq,1,2,'Dereck', 'Rose','PG',15000000, CAST('1-1-2022' AS DATE), CAST('12-1-2022' AS DATE));
INSERT INTO Player(Player_ID,Franchise_ID,Agency_ID,First_Name,Last_Name,Position,Contract_Size,Contract_Start_Date,Contract_End_Date)
VALUES(NEXT VALUE FOR PlayerSeq,1,2,'Bernard', 'King','SG',25000000, CAST('1-1-2022' AS DATE), CAST('12-1-2022' AS DATE));
INSERT INTO Player(Player_ID,Franchise_ID,Agency_ID,First_Name,Last_Name,Position,Contract_Size,Contract_Start_Date,Contract_End_Date)
VALUES(NEXT VALUE FOR PlayerSeq,1,3,'Walt', 'Frazier','PF',15000000, CAST('1-1-2022' AS DATE), CAST('12-1-2022' AS DATE));

SELECT * FROM Player;

--Platform Inserts
DECLARE	@current_platform_seq INT = NEXT VALUE FOR Social_Media_PlatformSeq;
INSERT INTO Social_Media_Platform(Platform_ID,Franchise_ID,Player_ID,Platform_Name)
VALUES(@current_platform_seq,1,null,'Facebook');
INSERT INTO Social_Media_Platform(Platform_ID,Franchise_ID,Player_ID,Platform_Name)
VALUES(NEXT VALUE FOR Social_Media_PlatformSeq,1,null,'Instagram');
INSERT INTO Social_Media_Platform(Platform_ID,Franchise_ID,Player_ID,Platform_Name)
VALUES(NEXT VALUE FOR Social_Media_PlatformSeq,1,null,'YouTube');
INSERT INTO Social_Media_Platform(Platform_ID,Franchise_ID,Player_ID,Platform_Name)
VALUES(NEXT VALUE FOR Social_Media_PlatformSeq,null,1,'Facebook');
INSERT INTO Social_Media_Platform(Platform_ID,Franchise_ID,Player_ID,Platform_Name)
VALUES(NEXT VALUE FOR Social_Media_PlatformSeq,null,1,'Instagram');


---Post Inserts

DECLARE	@current_post_seq INT = NEXT VALUE FOR Social_Media_PostSeq;
INSERT INTO Social_Media_Post(Post_ID, Platform_ID, Post_Content,Post_Date,Post_Engagement)
VALUES(@current_post_seq,4,'The Christmas game is tonight! Tune in',CAST('12-25-2022' AS DATE),100000)
INSERT INTO Social_Media_Post(Post_ID, Platform_ID, Post_Content,Post_Date,Post_Engagement)
VALUES(NEXT VALUE FOR Social_Media_PostSeq,4,'Gonna drop 60!!!',CAST('11-25-2022' AS DATE),100000)
INSERT INTO Social_Media_Post(Post_ID, Platform_ID, Post_Content,Post_Date,Post_Engagement)
VALUES(NEXT VALUE FOR Social_Media_PostSeq,4,'Back in the line up tonight',CAST('10-25-2022' AS DATE),100000)
INSERT INTO Social_Media_Post(Post_ID, Platform_ID, Post_Content,Post_Date,Post_Engagement)
VALUES(NEXT VALUE FOR Social_Media_PostSeq,4,'Still hurt',CAST('9-25-2022' AS DATE),100000)
INSERT INTO Social_Media_Post(Post_ID, Platform_ID, Post_Content,Post_Date,Post_Engagement)
VALUES(NEXT VALUE FOR Social_Media_PostSeq,4,'Im Hurt!',CAST('8-25-2022' AS DATE),100000)

--Games
DECLARE	@current_game_seq INT = NEXT VALUE FOR GameSeq;
INSERT INTO Game(Game_ID, Stadium_ID, Game_Date,Opposing_Team,WinningorLoss,Revenue_Generated,Home_or_Away)
VALUES(@current_game_seq, 1, CAST('8-25-2022' AS DATE), 'Boston Celtics', 'W', 5000000, 'Home' );
INSERT INTO Game(Game_ID, Stadium_ID, Game_Date,Opposing_Team,WinningorLoss,Revenue_Generated,Home_or_Away)
VALUES(NEXT VALUE FOR GameSeq, null, CAST('9-25-2022' AS DATE), 'Atlanta Hawks', 'L', 2500000, 'Away' );
INSERT INTO Game(Game_ID, Stadium_ID, Game_Date,Opposing_Team,WinningorLoss,Revenue_Generated,Home_or_Away)
VALUES(NEXT VALUE FOR GameSeq, null, CAST('10-25-2022' AS DATE), 'Miami Heat', 'L', 2500000, 'Away' );
INSERT INTO Game(Game_ID, Stadium_ID, Game_Date,Opposing_Team,WinningorLoss,Revenue_Generated,Home_or_Away)
VALUES(NEXT VALUE FOR GameSeq, null, CAST('11-25-2022' AS DATE), 'Los Angeles Lakers', 'L', 2500000, 'Away' );
INSERT INTO Game(Game_ID, Stadium_ID, Game_Date,Opposing_Team,WinningorLoss,Revenue_Generated,Home_or_Away)
VALUES(NEXT VALUE FOR GameSeq, 1, CAST('12-25-2022' AS DATE), 'Brooklyn Nets', 'W', 6000000, 'Home' );

--Items
DECLARE	@current_item_seq INT = NEXT VALUE FOR ItemSeq;
INSERT INTO Item(item_ID,Player_ID, Item_Name,Item_Description,Item_Price)
VALUES(@current_item_seq, 1, 'Julius Randle Home Jersey', 'Julius Randle Home Jersey', 79.99);
INSERT INTO Item(item_ID,Player_ID, Item_Name,Item_Description,Item_Price)
VALUES(NEXT VALUE FOR ItemSeq, 1, 'Julius Randle Away Jersey', 'Julius Randle Away Jersey', 79.99);
INSERT INTO Item(item_ID,Player_ID, Item_Name,Item_Description,Item_Price)
VALUES(NEXT VALUE FOR ItemSeq, null, 'Shot Glass Set', 'Shot Glass Set', 9.99);
INSERT INTO Item(item_ID,Player_ID, Item_Name,Item_Description,Item_Price)
VALUES(NEXT VALUE FOR ItemSeq, null, 'NYK Shrine Set', 'NYK Shrine Set', 799.99);
INSERT INTO Item(item_ID,Player_ID, Item_Name,Item_Description,Item_Price)
VALUES(NEXT VALUE FOR ItemSeq, null, 'NYK Trophy Set', 'NYK Trophy Set', 1500.99);

SELECT * FROM Item;

--In Store Items
INSERT INTO In_Store_Item(Item_ID, StorageCostPerUnit)
VALUES(1,5.00);
INSERT INTO In_Store_Item(Item_ID, StorageCostPerUnit)
VALUES(2,15.00);
INSERT INTO In_Store_Item(Item_ID, StorageCostPerUnit)
VALUES(3,15.00);


--To be Delivered Items
INSERT INTO To_be_Delivered_Item(Item_ID)
VALUES(3);
INSERT INTO To_be_Delivered_Item(Item_ID)
VALUES(4);
INSERT INTO To_be_Delivered_Item(Item_ID)
VALUES(5);



--QUERIES

--Query 1 - Did Julius Randle promote the Xmas Game this year on Facebook? What was the content and engagement
SELECT Platform_Name, First_Name, Last_Name, Franchise_Name, Post_Content, Post_Date FROM Social_Media_Platform
JOIN Player 
ON Player.Player_ID = Social_Media_Platform.Player_ID
JOIN Social_Media_Post
ON Social_Media_Platform.Platform_ID = Social_Media_Post.Platform_ID
JOIN Franchise
ON Player.Franchise_ID = Franchise.Franchise_ID
WHERE Platform_Name='Facebook' AND Post_Date = '12-25-2022';

--Query 2 -Find the Description, Price, Storage Costs of Items that are in Stadium that are relevant to Julius Randle
SELECT Item_Name, Item_Price, StorageCostPerUnit, First_Name, Last_Name
FROM 
Item 
JOIN
In_Store_Item on Item.Item_ID = In_Store_Item.Item_ID
JOIN 
Player ON Item.Player_ID = Player.Player_ID 
WHERE First_Name = 'Julius'
;

--Query 3 - Find Players on our Roster not managed by Klutch Sports
CREATE OR ALTER VIEW Klutch_Sports_Players AS
SELECT First_Name, Last_Name, Contract_Size, Contract_Start_Date, Contract_End_Date, Agency_Name, Agency.Agency_ID
FROM Player
JOIN Agency
ON Player.Agency_ID = Agency.Agency_ID
WHERE Agency_Name = 'Klutch Sports';

SELECT * FROM Klutch_Sports_Players;

SELECT First_Name, Last_Name, Contract_Size, Contract_Start_Date, Contract_End_Date, Agency_Name
FROM Player
JOIN Agency
ON Player.Agency_ID = Agency.Agency_ID WHERE NOT EXISTS (
SELECT * FROM Klutch_Sports_Players Klutch_Players
WHERE Klutch_Players.Agency_ID = Player.Agency_ID
);

--TRIGGERS
--Replace this with your history table trigger.
CREATE TRIGGER PriceChangeTrigger
ON Item
AFTER UPDATE
AS
BEGIN
	DECLARE @OldPrice DECIMAL(8,2) = (SELECT Item_Price FROM DELETED);
	DECLARE @NewPrice DECIMAL(8,2) = (SELECT Item_Price FROM INSERTED);

	IF (@OldPrice <> @NewPrice)
		INSERT INTO PriceChange(PriceChangeID, OldPrice, NewPrice, Item_ID, ChangeDate)
		VALUES(NEXT VALUE FOR PriceChangeSeq, @OldPrice, @NewPrice,(SELECT Item_ID FROM INSERTED), GETDATE());
END;

SELECT * FROM Item;
UPDATE Item
SET Item_Price = 89.99
WHERE Item_ID = 1;

UPDATE Item
SET Item_Price = 99.99
WHERE Item_ID = 1;

UPDATE Item
SET Item_Price = 109.99
WHERE Item_ID = 1;

SELECT * FROM PriceChange;



--Visualization Queries 
--2023 Assets & Liabilities
SELECT Franchise_Assets, Franchise_Liabilities
FROM Franchise;

--W or L, Home or Away, & Revene Generated against Opposing Teams
SELECT Opposing_Team, WinningorLoss, Home_or_Away, Revenue_Generated
FROM Game;

--Line Chart - Game Date and Revenue Generated
SELECT Game_Date, Opposing_Team, Revenue_Generated 
FROM Game;

--Klutch Players vs Non-Klutch Players
SELECT CONCAT(First_Name, ' ', Last_Name) AS Player_Name, Contract_Size, 
CASE 
	WHEN Agency_Name = 'Klutch Sports' THEN 'Klutch'
	ELSE 'Other Agency'
	END AS Player_Representation
FROM Player
JOIN Agency
ON Player.Agency_ID = Agency.Agency_ID;