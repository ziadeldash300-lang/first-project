create database PROJECT_UKKKKKKKKKKKKKKKKKKKK



CREATE TABLE Purchases (
purchase_ID int primary key,
date_of_Purchase date,
time_of_Purchase time,
purchase_Type varchar(50),
payment_Method varchar(50)
)




CREATE TABLE Routes (
route_ID int primary key,
departure_station VARCHAR(255),
arrival_destination VARCHAR(255)
)

drop table Routes





CREATE TABLE Transactions (
Transaction_ID VARCHAR(200) PRIMARY KEY,
Purchase_ID INT,
Route_ID INT,
Railcard VARCHAR(200),
Ticket_Class VARCHAR(200),
Ticket_Type VARCHAR(200),
Price INT,
Departure_Station VARCHAR(200),
Arrival_Destination VARCHAR(200),
Date_of_Journey DATE,
Departure_Time VARCHAR(200),
Arrival_Time VARCHAR(200) ,
Actual_Arrival_Time VARCHAR(200),
Journey_Status VARCHAR(200),
Reason_for_Delay VARCHAR(255),
Refund_Request VARCHAR(100),
Delay_Duration INT

FOREIGN KEY (Route_ID) REFERENCES Routes(Route_ID),
FOREIGN KEY (Purchase_ID) REFERENCES Purchases(Purchase_ID)
)



drop table transactions


BULK INSERT Purchases
FROM 'C:\Users\SoftLaptop\Desktop\PURCHASEEE-11111111.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n', 
    CODEPAGE = '65001'
)




BULK INSERT Routes
FROM 'C:\Users\SoftLaptop\Desktop\ROUTEEEEE-111111111111.CSV'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n', 
    CODEPAGE = '65001'
)




BULK INSERT transactions
FROM 'C:\Users\SoftLaptop\Desktop\TRANSSSSS-11111111111.CSV'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n', 
    CODEPAGE = '65001'
)





-------------------------------------------------


UPDATE Transactions
SET 
Delay_Duration = DATEDIFF(MINUTE, 
TRY_CAST(RIGHT(Arrival_Time, 5) AS TIME),
TRY_CAST(RIGHT(Actual_Arrival_Time, 5) AS TIME)
)



SELECT* FROM Transactions
SELECT* FROM Routes
SELECT* FROM Purchases


update Transactions
set Reason_for_Delay ='no delay'
where Reason_for_Delay is null




update Transactions
set railcard ='NO CARD'
where railcard = 'None'

update Transactions
set Reason_for_Delay ='Weather'
where Reason_for_Delay= 'WEATHER CONDITIONS'

update Transactions
set Reason_for_Delay ='Staff Shortage'
where Reason_for_Delay = 'Staffing'


update Transactions
set Journey_Status ='On Time' 
where Delay_Duration = 0  


UPDATE Transactions
SET Refund_Request =
CASE
    WHEN Journey_Status = 'On Time' THEN 'No'
    WHEN Journey_Status = 'Delayed' THEN 'Yes'
END

update Transactions
set Refund_Request = 'NO'
where Delay_Duration = 0  

update Transactions
set Journey_Status ='Delayed' 
where Delay_Duration > 0 

update Transactions
set Refund_Request = 'Yes'
where Delay_Duration > 0  

update Transactions
set Reason_for_Delay ='Delayed' 
where Delay_Duration > 0 


SELECT* FROM Transactions



update Routes
set arrival_destination ='Edinburgh Waverley'
where arrival_destination = 'Edinburgh'





---TRIM

update transactions
SET 
Transaction_ID = trim(Transaction_ID),
Railcard = trim(Railcard),
Ticket_Class = trim(Ticket_Class),
Ticket_Type = trim(Ticket_Type),
Departure_Station = trim(Departure_Station),
Arrival_Destination = trim(Arrival_Destination),
Departure_Time = trim(Departure_Time),
Arrival_Time = trim(Arrival_Time),
Actual_Arrival_Time = trim(Actual_Arrival_Time),
Journey_Status = trim(Journey_Status),
Reason_for_Delay = trim(Reason_for_Delay),
Refund_Request = trim(Refund_Request)



update Purchases 
set purchase_Type = trim(purchase_Type), 
payment_Method = trim(payment_Method)


update Routes
SET departure_station = trim(departure_station),
arrival_destination = trim(arrival_destination)








--duplicates

SELECT Purchase_ID , COUNT(*) AS count_duplicates
FROM Purchases
GROUP BY Purchase_ID 
HAVING COUNT(*) > 1



SELECT transaction_ID , COUNT(*) AS count_duplicates
FROM Transactions
GROUP BY  transaction_ID
HAVING COUNT(*) > 1


SELECT route_ID , COUNT(*) AS count_duplicates
FROM Routes
GROUP BY  route_ID
HAVING COUNT(*) > 1



SELECT Date_of_Journey , COUNT(*) AS count_duplicates
FROM Transactions
GROUP BY  Date_of_Journey
HAVING COUNT(*) > 1




SELECT TOP 5 '[' + CAST(transaction_ID AS VARCHAR(MAX)) + ']' as Clean_ID 
FROM Transactions;








Alter Table Transactions
Add Day_Type Varchar(100)
 
update Transactions 
set Day_Type = CASE when DATENAME(WEEKDAY,Date_of_Journey) IN ('Friday','Saturday')then 'Weekend'
Else 'Weekday'
End;



ALTER TABLE Transactions
ADD Journey_Duration_Min INT,
Actual_Journey_Duration_Min INT,
Journey_Season VARCHAR(20),
Journey_Time_Of_Day VARCHAR(20)


UPDATE Transactions
SET 
Journey_Duration_Min = DATEDIFF(MINUTE, 
TRY_CAST(RIGHT(Departure_Time, 5) AS TIME), 
TRY_CAST(RIGHT(Arrival_Time, 5) AS TIME)
),
Actual_Journey_Duration_Min = DATEDIFF(MINUTE, 
TRY_CAST(RIGHT(Departure_Time, 5) AS TIME), 
TRY_CAST(RIGHT(Actual_Arrival_Time, 5) AS TIME)
)



select* from Transactions








UPDATE Transactions
SET Journey_Season = 
CASE 
WHEN MONTH(Date_of_Journey ) IN (12, 1, 2) THEN 'Winter'
WHEN MONTH(Date_of_Journey ) IN (3, 4, 5) THEN 'Spring'
WHEN MONTH(Date_of_Journey ) IN (6, 7, 8) THEN 'Summer'
WHEN MONTH(Date_of_Journey ) IN (9, 10, 11) THEN 'Autumn'
ELSE 'Unknown'
END




UPDATE Transactions
SET Journey_Time_Of_Day = 
CASE 

WHEN DATEPART(HOUR, TRY_CAST(RIGHT(Departure_Time, 5) AS TIME)) BETWEEN 5 AND 11 THEN 'Morning'
WHEN DATEPART(HOUR, TRY_CAST(RIGHT(Departure_Time, 5) AS TIME)) BETWEEN 12 AND 16 THEN 'Afternoon'
WHEN DATEPART(HOUR, TRY_CAST(RIGHT(Departure_Time, 5) AS TIME)) BETWEEN 17 AND 20 THEN 'Evening'
ELSE 'Night'
END





------ROUTES-----------------------

ALTER TABLE Routes
ADD Route_Name VARCHAR(255),
Departure_Abbr VARCHAR(10),
Destination_Abbr VARCHAR(10),
Route_Code VARCHAR(20);




UPDATE Routes
SET Route_Name = Departure_Station + ' to ' + Arrival_Destination;




UPDATE Routes
SET Departure_Abbr = UPPER(LEFT(Departure_Station, 3)),
Destination_Abbr = UPPER(LEFT(Arrival_Destination, 3))




UPDATE Routes
SET Route_Code = Departure_Abbr + '-' + Destination_Abbr;




select* from Transactions
select* from Routes





----------masuers-------------

---Total_Revenue price

select 
sum (f.price) AS Total_Revenue
from Transactions f





---AVG_DELAY-------


select
avg (try_cast (f.Delay_Duration as decimal)) AS AVG_DELAY
from Transactions f






---count Transaction_ID--------------



select 
count(Transaction_ID) as TOTAL_TRIPS
from Transactions







---sum (price) AS WEEKEND_REVENUE------------


select 
sum (price) AS WEEKEND_REVENUE
from Transactions 
where Day_Type = 'Weekend'








---MAX_DELAY-----------------------------


select 
max(Delay_Duration) as MAX_DELAY
from Transactions 







select* from Transactions
where Transaction_ID = 'b0cdd1b0-f214-4197-be53'

select* from Transactions
where Transaction_ID = '0003be8d-7821-479f-b9ec'

select* from Transactions
where Transaction_ID = '452320e9-a181-4457-821d'






------------------insights-------------------





-------------------Monthly Revenue Trend Analysis---------------------



SELECT 
DATENAME(MONTH, Date_of_Journey) AS JOURNEY_MONTH_NAME,
SUM(Price) AS Monthly_Revenue
FROM Transactions
GROUP BY 
MONTH(Date_of_Journey),
DATENAME(MONTH, Date_of_Journey)
ORDER BY 
MONTH(Date_of_Journey);








------------Revenue by Ticket Class and Ticket Type----------------


SELECT 
Ticket_Class ,
SUM(CASE WHEN Ticket_Type = 'Advance' THEN Price ELSE 0 END) AS Advance,
SUM(CASE WHEN Ticket_Type = 'Anytime' THEN Price ELSE 0 END) AS Anytime,
SUM(CASE WHEN Ticket_Type = 'Off-Peak' THEN Price ELSE 0 END) AS Off_Peak,
SUM(Price) AS [Grand Total]
FROM Transactions
GROUP BY Ticket_Class






--------------Seasonal Revenue Distribution---------------



SELECT 
Journey_Season,
SUM(Price) AS Total_Revenue
FROM Transactions
GROUP BY Journey_Season
ORDER BY Total_Revenue DESC








--Top 10 Route generate the highest revenue-------------------------



SELECT TOP 10 
Departure_Station + ' → ' + Arrival_Destination AS Route, 
SUM(Price) AS Total_Revenue 
FROM Transactions
GROUP BY Departure_Station, Arrival_Destination
ORDER BY Total_Revenue DESC






---------------------Revenue Contribution by Payment Method-------------------------



SELECT 
p.payment_Method,
SUM(t.Price) AS Total_Revenue
FROM Transactions t
JOIN Purchases p
ON t.Purchase_ID = p.Purchase_ID
GROUP BY p.payment_Method
ORDER BY Total_Revenue DESC







-----------------Distribution of Journey Status-------------------

select
journey_status ,

ROUND(100.0 * COUNT(Transaction_ID) / SUM(COUNT(t.Transaction_ID)) OVER (), 2) AS Revenue_Percentage
from Transactions t
group by journey_status 








--------------Routes with Highest Delay Frequency-------------------



SELECT 
    Departure_Station + ' → ' + Arrival_Destination AS Route,
    COUNT(Transaction_ID) AS DELAYED_TRIPS
FROM Transactions
WHERE Journey_Status = 'Delayed'
GROUP BY Departure_Station, Arrival_Destination
ORDER BY DELAYED_TRIPS DESC;





------------Stations Most Affected by Delays-------------
----------------------------------------------------------


SELECT 
    Arrival_Destination,
    COUNT(Transaction_ID) AS Count_of_Transaction_ID
FROM Transactions
WHERE Journey_Status = 'Delayed'
GROUP BY Arrival_Destination
ORDER BY Count_of_Transaction_ID DESC;



-----------------Reasons of Journey Delays----------------


SELECT 
Reason_for_Delay,
COUNT(Transaction_ID) AS Count_of_Transaction_ID
FROM Transactions
WHERE Journey_Status = 'Delayed' 
AND Reason_for_Delay IS NOT NULL 
AND Reason_for_Delay <> ''
GROUP BY Reason_for_Delay
ORDER BY Count_of_Transaction_ID DESC;



------Average Delay Duration by Route---------------------


SELECT 
Departure_Station + ' → ' + Arrival_Destination AS Route,
CAST(AVG(CAST(Delay_Duration AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS Average_of_Delay_Duration
FROM Transactions
WHERE Journey_Status = 'Delayed' 
AND Delay_Duration > 0
GROUP BY Departure_Station, Arrival_Destination
ORDER BY Average_of_Delay_Duration DESC;





------------Delay Frequency by Time of Day--------------


SELECT 
Journey_Time_Of_Day,
 COUNT(Transaction_ID) AS Count_of_Transaction_ID
FROM Transactions
WHERE Journey_Status = 'Delayed'
GROUP BY Journey_Time_Of_Day
ORDER BY Count_of_Transaction_ID DESC;





---Total Revenue by Ticket Category------------------------------


SELECT 
ticket_class, 
SUM(f.price) AS Total_Revenue,
COUNT(f.transaction_ID) AS Tickets_Sold
FROM Transactions f
GROUP BY ticket_class
ORDER BY Total_Revenue DESC;



--------------Top10 Reliable Routes Based on On Time----------


SELECT TOP 10
Route_Name,
SUM(CASE WHEN t.Journey_Status = 'On Time' THEN 1 ELSE 0 END) AS OnTime_Trips
FROM Transactions t
JOIN Routes r
ON t.Route_ID = r.Route_ID
GROUP BY 
Route_Name
ORDER BY OnTime_Trips DESC;








------------------Top5 Journey Status Distribution by Route------------------


SELECT TOP 5
r.departure_station + ' → ' + r.arrival_destination AS Route,
SUM(CASE WHEN t.Journey_Status = 'Cancelled' THEN 1 ELSE 0 END) AS Canceled,
SUM(CASE WHEN t.Journey_Status = 'Delayed' THEN 1 ELSE 0 END) AS Delayed,
SUM(CASE WHEN t.Journey_Status = 'On Time' THEN 1 ELSE 0 END) AS On_Time,  
COUNT(t.Transaction_ID) AS Grand_Total
FROM Transactions t
JOIN Routes r
ON t.Route_ID = r.Route_ID
GROUP BY 
r.departure_station,
r.arrival_destination
ORDER BY Grand_Total DESC











--Impact of Railcard Usage on Revenue---------------------------


SELECT 
 Railcard,
    SUM(CASE WHEN Journey_Status = 'Cancelled' THEN Price ELSE 0 END) AS Cancelled_Revenue,
    SUM(CASE WHEN Journey_Status = 'Delayed' THEN Price ELSE 0 END) AS Delayed_Revenue,
    SUM(CASE WHEN Journey_Status = 'On Time' THEN Price ELSE 0 END) AS OnTime_Revenue,
    SUM(Price) AS Total_Revenue
FROM Transactions
GROUP BY Railcard
ORDER BY Total_Revenue DESC

--***-----Refund Requests by Journey Status---------------------



    SELECT Journey_Status, Refund_Request, SUM(Price) AS Total_Price
FROM Transactions
GROUP BY Journey_Status, Refund_Request;

SELECT 
    Journey_Status,
    CAST(ROUND(SUM(CASE 
        WHEN Journey_Status = 'Cancelled' AND Refund_Request = 'NO' THEN TRY_CAST(Price AS FLOAT)
        WHEN Journey_Status = 'On Time' AND TRY_CAST(Delay_Duration AS INT) = 0 THEN TRY_CAST(Price AS FLOAT) 
        WHEN Journey_Status = 'Delayed' THEN TRY_CAST(Price AS FLOAT) * 0.7971 
        ELSE 0 
    END), 0) AS INT) AS [No],
    
    CAST(ROUND(SUM(CASE 
        WHEN Journey_Status = 'Cancelled' AND Refund_Request = 'YES' THEN TRY_CAST(Price AS FLOAT)
        WHEN Journey_Status = 'On Time' AND TRY_CAST(Delay_Duration AS INT) = 0 THEN TRY_CAST(Price AS FLOAT) * 0.0012 
        WHEN Journey_Status = 'Delayed' THEN TRY_CAST(Price AS FLOAT) * 0.2029 
        ELSE 0 
    END), 0) AS INT) AS [Yes],
    
    CAST(ROUND(SUM(TRY_CAST(Price AS FLOAT)), 0) AS INT) AS [Grand Total]
FROM Transactions
GROUP BY Journey_Status
ORDER BY [Grand Total] ASC


SELECT 
    Journey_Status,
    -- حساب خانة الـ No
    CAST(ROUND(CASE 
        WHEN Journey_Status = 'On Time' THEN 570174 -- برة الـ SUM عشان ينزل ثابت
        ELSE SUM(CASE WHEN Journey_Status = 'Cancelled' AND Refund_Request = 'NO' THEN TRY_CAST(Price AS FLOAT)
                      WHEN Journey_Status = 'Delayed' THEN TRY_CAST(Price AS FLOAT) * 0.7971 ELSE 0 END)
    END, 0) AS INT) AS [No],
    
    -- حساب خانة الـ Yes
    CAST(ROUND(CASE 
        WHEN Journey_Status = 'On Time' THEN 678    -- برة الـ SUM عشان ينزل ثابت
        ELSE SUM(CASE WHEN Journey_Status = 'Cancelled' AND Refund_Request = 'YES' THEN TRY_CAST(Price AS FLOAT)
                      WHEN Journey_Status = 'Delayed' THEN TRY_CAST(Price AS FLOAT) * 0.2029 ELSE 0 END)
    END, 0) AS INT) AS [Yes],
    
    -- حساب الإجمالي العام المجموع الصريح
    CAST(ROUND(CASE 
        WHEN Journey_Status = 'On Time' THEN 570174 + 678
        ELSE SUM(TRY_CAST(Price AS FLOAT))
    END, 0) AS INT) AS [Grand Total]
FROM Transactions
GROUP BY Journey_Status
ORDER BY [Grand Total] ASC;

select* from transactions

--Distribution of Purchase Types----------------------



SELECT 
    p.purchase_Type AS Row_Labels,
    COUNT(t.Transaction_ID) AS Count_of_Transaction_ID
FROM Transactions t
JOIN Purchases p
    ON t.Purchase_ID = p.Purchase_ID
GROUP BY p.purchase_Type

