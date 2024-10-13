
/*Find the room types that are searched most no of times.
Output the room type alongside the number of searches for it.
If the filter for room types has more than one room type,
consider each unique room type as a separate row.
Sort the result based on th number of searches in descending order.
*/
create table #airbnb_searches 
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);
delete from #airbnb_searches;
insert into #airbnb_searches values
(1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room')

Select * from #airbnb_searches 

Select *
from #airbnb_searches 
CROSS APPLY string_split(filter_room_types,',')
 

Select value as room_type, count(1) as no_of_searches 
from #airbnb_searches 
CROSS APPLY string_split(filter_room_types,',')
group by value order by  no_of_searches desc


-- Solution 2
;with room as
(select sum(case when filter_room_types like '%entire%' then 1 else 0 end) as en,
sum(case when filter_room_types like '%private%' then 1 else 0 end) as pr,
sum(case when filter_room_types like '%shared%' then 1 else 0 end) as sh
from #airbnb_searches)
select 'entire home' as  value,en cnt from room
union all
select 'private room' as value,pr cnt from room
union all
select 'shared room' as value,sh cnt from room
order by cnt desc;


-- Solution 3
;with cte_table as 
(select count(case when filter_room_types like '%entire home%' then 1 End) as 'entire home',
count(case when filter_room_types like '%private room%' then 1 End) as 'private room',
count(case when filter_room_types like '%shared room%' then 1 End) as 'shared room'
from 
#airbnb_searches)
Select value, i as count_room_type from cte_table
unpivot
(
 i for value in ([entire home],[private room],[shared room])
) as unpivot_table
ORDER By i DESC;


-- Solution 4
;WITH cte AS (
  SELECT
    user_id,
    SUM(CASE WHEN filter_room_types LIKE '%entire%' THEN 1 ELSE 0 END) AS Entire_home,
    SUM(CASE WHEN filter_room_types LIKE '%shared%' THEN 1 ELSE 0 END) AS Shared,
    SUM(CASE WHEN filter_room_types LIKE '%private%' THEN 1 ELSE 0 END) AS Private
  FROM
    #airbnb_searches
  GROUP BY
    user_id
)
select value, count(value) as no_of_searches from
(
SELECT
  CASE WHEN Entire_home = 1 THEN 'Entire_home' END AS value
FROM
  cte
union all
SELECT
  CASE WHEN Shared = 1 THEN 'Shared' END AS value
FROM
  cte
union all
SELECT
  CASE WHEN private = 1 THEN 'private' END AS value
FROM
  cte) as A
  where value is not null
  group by value;


  -- Solution 5

;with mycte as
(
select user_id, date_searched, 
LEFT(filter_room_types, NULLIF(CHARINDEX(',', filter_room_types), 0) - 1) as room_type1
from #airbnb_searches
UNION ALL
select user_id, date_searched, 
SUBSTRING(filter_room_types, CHARINDEX(',',filter_room_types)+1, len(filter_room_types)) as room_type2
from #airbnb_searches
) 

select room_type1 as value, count(1) as cnt from mycte
where room_type1 is not null
group by room_type1
ORDER BY 2 desc


--  Solution 6
WITH room_rows AS (
    SELECT
        user_id,
        filter_room_types,
        0 as previous_delim_pos,
        CHARINDEX(',', filter_room_types) AS delim_pos  
    FROM #airbnb_searches

    UNION ALL

    SELECT
        user_id,
        filter_room_types,
        delim_pos as previous_delim_pos,
        CHARINDEX(',', filter_room_types, delim_pos + 1) as delim_pos
    FROM room_rows
    WHERE delim_pos > 0
),
split_rooms as (
SELECT 
user_id,
CASE when delim_pos > 0 
then substring(filter_room_types, previous_delim_pos + 1, delim_pos - (previous_delim_pos + 1) )
else substring(filter_room_types, previous_delim_pos + 1, len(filter_room_types) - previous_delim_pos) 
end as room_types from room_rows)

select room_types, count(*) as cnt from split_rooms 
group by room_types
order by cnt desc;


-- --  Solution 7
SELECT COUNT(USER_ID)CNT,ROOM FROM (
SELECT *,CASE WHEN filter_room_types LIKE '%private room%' THEN 'private room'
END ROOM  FROM #airbnb_searches

UNION ALL

SELECT *,CASE WHEN filter_room_types LIKE '%shared room%' THEN 'shared room'
END  FROM #airbnb_searches

UNION ALL

SELECT *,CASE WHEN filter_room_types LIKE '%entire HOME%' THEN 'entire room' 
END   FROM #airbnb_searches )X 
WHERE ROOM IS NOT NULL GROUP BY ROOM






/*
SELECT ',' + filter_room_types FROM #airbnb_searches FOR XML PATH ('')
	
Select user_id, Stuff((
SELECT  N'@ ' + filter_room_types
FROM #airbnb_searches
FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(max)'),1,0,N'') 
FROM #airbnb_searches


SELECT user_id, stuff((  
SELECT ','+ filter_room_types FROM #airbnb_searches WHERE user_id = t.user_id FOR XML PATH('') ),1,1,'')  
FROM (SELECT DISTINCT user_id FROM #airbnb_searches ) t

*/