create schema game;
select * from game.mta_daily_ridership;

#1. Fetch the Total Subway Ridership on a Specific Date
select `Subways: Total Estimated Ridership`
from game.mta_daily_ridership
where Date = '2020-03-01';

#2. List All Unique Dates in the Dataset
select distinct Date
from game.mta_daily_ridership;

#3. Find the Average Daily Bus Ridership
select Date , avg(`Buses: Total Estimated Ridership`)
from game.mta_daily_ridership
group by Date;

#4. Show the Maximum Subway Ridership Recorded
select max(`Subways: Total Estimated Ridership`) as Relationship
from game.mta_daily_ridership;

#5. Count the Total Number of Days in the Dataset
select distinct count(Date)
from game.mta_daily_ridership;

#6. Calculate the Total Ridership Across All 
#   Transit Modes on a Specific Date
select Date, `Subways: Total Estimated Ridership` 
+ `Buses: Total Estimated Ridership` 
+ `LIRR: Total Estimated Ridership`
+ `Metro-North: Total Estimated Ridership` 
+ `Staten Island Railway: Total Estimated Ridership`
as Total_Ridership from game.mta_daily_ridership
where Date = '2020-03-01';

#7. Find the Day with the Lowest Subway Ridership
select Date , `Subways: Total Estimated Ridership`
   as Min_Relationship_Time
from game.mta_daily_ridership
order by Min_Relationship_Time asc
limit 1;

#8. Rank Days by Total Traffic on Bridges and Tunnels
select Date, `Bridges and Tunnels: Total Traffic` ,
rank() over( order by `Bridges and Tunnels: Total Traffic` desc)
as 'Rank' from game.mta_daily_ridership;

#9. Identify Dates Where Subway Ridership Exceeded Bus Ridership
select Date, `Buses: Total Estimated Ridership`, 
`Subways: Total Estimated Ridership`
from game.mta_daily_ridership
where `Buses: Total Estimated Ridership`
 < `Subways: Total Estimated Ridership`;
 
#10. Calculate the Percentage Change in Subway Ridership from One Day to the Next
select Date, `Subways: Total Estimated Ridership`,
    lag(`Subways: Total Estimated Ridership`) over (order by Date) as Previous_Day_Ridership,
    ((`Subways: Total Estimated Ridership` - lag(`Subways: Total Estimated Ridership`)
    over (order by Date)) / lag(`Subways: Total Estimated Ridership`)
    over (order by Date)) * 100 as Percentage_Change
from game.mta_daily_ridership;

#11.Find Days Where Total Traffic on Bridges and Tunnels Exceeded the Average by 20%
with AvgTraffic as (
    select avg(`Bridges and Tunnels: Total Traffic`) as Avg_Traffic
    from game.mta_daily_ridership
)
select Date, `Bridges and Tunnels: Total Traffic`
from game.mta_daily_ridership, AvgTraffic
where `Bridges and Tunnels: Total Traffic` > Avg_Traffic * 1.2;

#12. Find the Top 5 Days with the Highest Total Ridership
select Date,
    `Subways: Total Estimated Ridership` + `Buses: Total Estimated Ridership` +
    `LIRR: Total Estimated Ridership` + `Metro-North: Total Estimated Ridership` +
    `Staten Island Railway: Total Estimated Ridership` as Total_Ridership
from game.mta_daily_ridership
order by Total_Ridership desc
limit 5;

#13. Analyze the Impact of Pandemic Using Pre-Pandemic Comparisons
select Date,
    `Subways: % of Comparable Pre-Pandemic Day`,
    `Buses: % of Comparable Pre-Pandemic Day`,
    `LIRR: % of Comparable Pre-Pandemic Day`,
    `Metro-North: % of Comparable Pre-Pandemic Day`
from game.mta_daily_ridership
where `Subways: % of Comparable Pre-Pandemic Day` < 50;

#14. Identify the Mode of Transit with the Largest Drop During the Pandemic
select Date,
    `Subways: Total Estimated Ridership`,
    `Buses: Total Estimated Ridership`,
    `LIRR: Total Estimated Ridership`,
    `Metro-North: Total Estimated Ridership`
from game.mta_daily_ridership
where Date between '2020-03-01' and '2020-12-31'
order by `Subways: % of Comparable Pre-Pandemic Day` asc
limit 1;

#15. Highlight Anomalous Days with Extremely Low Ridership
select- Date, `Subways: Total Estimated Ridership`, `Buses: Total Estimated Ridership`
from game.mta_daily_ridership
where `Subways: Total Estimated Ridership` < 1000000;

