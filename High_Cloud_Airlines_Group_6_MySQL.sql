alter table maindata rename column `%Distance Group ID` to `Distance_Groupo_ID`;
alter table maindata rename column `# Available Seats` to `Available_Seats`;
alter table maindata rename column `From - To City` to`From_To_City`;
alter table maindata rename column `Carrier Name` to `Carrier_Name`;
alter table maindata rename column `# Transported Passengers` to `Transported_Passengers`;
alter table distancegroups rename column `ï»¿%Distance Group ID` to `Distance_Group_ID`;
alter table distancegroups rename column `Distance Interval` to `Distance_Intervals`;
alter table maindata rename column `%Airline ID` to `airline_id`;
select * from distancegroups;

create view data_0 as
select 
	concat(year, '-' , `Month (#)` , '-' , day )  as data_0,
	Transported_Passengers,
    Available_Seats,
    From_To_City,
    Carrier_Name,
	Distance_Groupo_ID
    From maindata; 
    
select * from data_0 limit 15;

#Q1
Create view Q1 as select year(data_0) as year_number,
month(data_0) as month_number,
day(data_0) as day_number,
monthname(data_0) as month_name,
concat("Q",quarter(data_0)) as quarter_number,
concat(year(data_0),'-' , monthname(data_0)) as yyyy_mmm,
weekday(data_0) as weekday_number,
dayname(data_0) as day_name,
case
when quarter(data_0) = 1 then "FQ4"
when quarter(data_0) = 2 then "FQ1"
when quarter(data_0) = 3 then "FQ2"
when quarter(data_0) = 4 then "FQ3"
end as finantial_Quarter,
case 
when month(data_0) = 1 then "10"
when month(data_0) = 2 then "11"
when month(data_0) = 3 then "12"
when month(data_0) = 4 then "1"
when month(data_0) = 5 then "2"
when month(data_0) = 6 then "3"
when month(data_0) = 7 then "4"
when month(data_0) = 8 then "5"
when month(data_0) = 9 then "6"
when month(data_0) = 10 then "7"
when month(data_0) = 11 then "8"
when month(data_0) = 12 then "9"
end as finatial_month,
case 
when weekday(data_0) in (5,6) then "Weekend"
when weekday(data_0) in (0,1,2,3,4) then "Weekday"
end as weektype,
Transported_Passengers,
Available_Seats,
From_To_City,
Carrier_Name,
Distance_Groupo_ID
from data_0;

Select * from Q1 ;

#Q2
#Load Factor
SELECT 
    (SUM(Transported_Passengers) * 100.0) / NULLIF(SUM(Available_Seats), 0) AS Load_Factor
FROM
    data_0;
    
#Q2)Load_Factor_Yearly    
SELECT 
    Year,
    sum(transported_Passengers) as Total_Transported_Passengers,
    sum(Available_Seats) as Total_Available_Seats,
    (SUM(Transported_Passengers) * 100.0) / NULLIF(SUM(Available_Seats), 0) AS Load_Factor
FROM
    maindata
GROUP BY year
ORDER BY year;

#Q2)Load_Factor_Monthly
SELECT 
    `Month (#)`,
    SUM(transported_Passengers) AS Total_Transported_Passengers,
    SUM(Available_Seats) AS Total_Available_Seats,
    (SUM(Transported_Passengers) * 100.0) / NULLIF(SUM(Available_Seats), 0) AS Load_Factor
FROM
    maindata
GROUP BY `Month (#)`
ORDER BY `Month (#)`;

#Q2)Load_Factor_Quarterly
SELECT 
    QUARTER(data_0),
    SUM(transported_Passengers) AS Total_Transported_Passengers,
    SUM(Available_Seats) AS Total_Available_Seats,
    (SUM(Transported_Passengers) * 100.0) / NULLIF(SUM(Available_Seats), 0) AS Load_Factor
FROM
    data_0
GROUP BY QUARTER(data_0)
ORDER BY QUARTER(data_0);

#Q3) Carrier Name based on Load Factor
SELECT 
    Carrier_Name,
    SUM(transported_Passengers) AS Total_Transported_Passengers,
    SUM(Available_Seats) AS Total_Available_Seats,
    (SUM(Transported_Passengers) * 100.0) / NULLIF(SUM(Available_Seats), 0) AS Load_Factor
FROM
    maindata
GROUP BY Carrier_Name
ORDER BY Load_Factor DESC;

#Q4)Top 10 Carrier Name based on Passengers Preference
SELECT 
    Carrier_Name,
    COUNT(transported_Passengers) AS Passengers_Preference
FROM
    maindata
GROUP BY Carrier_Name
ORDER BY COUNT(transported_Passengers) DESC
LIMIT 10;

#Q5 Top Routes Based on Number of Flights 
SELECT 
    From_To_City,
    COUNT(`# Departures Performed`) AS No_of_Flights
FROM
    maindata
GROUP BY From_To_City
ORDER BY No_of_Flights DESC
LIMIT 15;

#Q6 Weekend V/S Weekdays Load Factor
CREATE VIEW Q6_new AS
    SELECT 
        CASE
            WHEN WEEKDAY(data_0) IN (5 , 6) THEN 'Weekend'
            WHEN WEEKDAY(data_0) IN (0 , 1, 2, 3, 4) THEN 'Weekday'
        END AS weektype,
        (SUM(Transported_Passengers) * 100.0) / NULLIF(SUM(Available_Seats), 0) AS Load_Factor
    FROM
        data_0
    GROUP BY Weektype;

SELECT 
    *
FROM
    Q6_new;

#Q7) no of flights based on distance group
select `Distance Interval`,count(Transported_Passengers) as No_of_Flights
from `distance groups` as dg
inner join maindata as m
	on dg.`ï»¿%Distance Group ID` = m.Distance_Groupo_ID
group by `Distance Interval`
order by count(Transported_Passengers) desc;

#Q10). Use the filter to provide a search capability to find the flights between Source Country, Source State, 
#Source City to Destination Country, Destination State, Destination City
SELECT DISTINCT
    `Origin Country`,
    `Origin State`,
    `Origin City`,
    `Destination Country`,
    `Destination State`
FROM
    maindata;

SELECT 
    Carrier_Name,
    `Origin City`,
    `Origin Country`,
    `Destination City`,
    `Destination Country`,
    Distance,
    Available_Seats
FROM
    maindata
WHERE
    `Origin Country` = 'United States'
        AND `Destination Country` = 'Angola';


