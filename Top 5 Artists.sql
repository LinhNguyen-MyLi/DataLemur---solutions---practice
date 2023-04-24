--Query Top 5 Artists 


--------------------Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table. Display the top 5 artist names in ascending order, along with their song appearance ranking. Note that if two artists have the same number of song appearances, they should have the same ranking, and the rank numbers should be continuous (i.e. 1, 2, 2, 3, 4, 5).
For instance, if Ed Sheeran appears in the Top 10 five times and Bad Bunning four times, Ed Sheeran should be ranked 1st, and Bad Bunny should be ranked 2nd.


artists Table:
Column Name Type
artist_id integer
artist_name varchar

artists Example Input:
artist_id artist_name
101         Ed Sheeran
120         Drake

songs Table:
Column Name Type
song_id     integer
artist_id integer

songs Example Input:
song_id artist_id
45202 101
19960 120

global_song_rank Table:
Column Name Type
day         integer (1-52)
song_id     integer
rank      integer (1-1,000,000)

global_song_rank Example Input:
day song_id rank
1 45202 5
3 45202 2
1 19960 3
9 19960 15

------------------

WITH top_artists AS 
(
  SELECT artist_name, 
         COUNT(*) AS sum_top10
  FROM global_song_rank
  INNER JOIN songs AS s USING (song_id)
  INNER JOIN artists AS a USING (artist_id)
  WHERE rank <= 10
  GROUP BY artist_name
  ORDER BY sum_top10 DESC
),

final AS 
(
SELECT artist_name,
       DENSE_RANK() OVER (ORDER BY sum_top10 DESC) AS artist_rank
FROM top_artists
)
  
SELECT 
  artist_name,
  artist_rank
FROM final
WHERE artist_rank <= 5;