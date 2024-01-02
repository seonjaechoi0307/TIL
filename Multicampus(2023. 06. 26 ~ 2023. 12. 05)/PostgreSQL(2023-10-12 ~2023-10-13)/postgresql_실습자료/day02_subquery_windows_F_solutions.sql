-- 테이블 생성

CREATE TABLE cities (
  name                    VARCHAR   PRIMARY KEY,
  country_code            VARCHAR,
  city_proper_pop         REAL,
  metroarea_pop           REAL,
  urbanarea_pop           REAL
);

CREATE TABLE countries (
  code                  VARCHAR     PRIMARY KEY,
  name                  VARCHAR,
  continent             VARCHAR,
  region                VARCHAR,
  surface_area          REAL,
  indep_year            INTEGER,
  local_name            VARCHAR,
  gov_form              VARCHAR,
  capital               VARCHAR,
  cap_long              REAL,
  cap_lat               REAL
);

CREATE TABLE economies (
  econ_id               INTEGER     PRIMARY KEY,
  code                  VARCHAR,
  year                  INTEGER,
  income_group          VARCHAR,
  gdp_percapita         REAL,
  gross_savings         REAL,
  inflation_rate        REAL,
  total_investment      REAL,
  unemployment_rate     REAL,
  exports               REAL,
  imports               REAL
);

CREATE TABLE populations (
  pop_id                INTEGER     PRIMARY KEY,
  country_code          VARCHAR,
  year                  INTEGER,
  fertility_rate        REAL,
  life_expectancy       REAL,
  size                  REAL
);

CREATE TABLE summer_medals
(
    year integer,
    city character varying(42),
    sport character varying(34),
    discipline character varying(34),
    athlete character varying(94),
    country character(6),
    gender character varying(10),
    event character varying(98),
    medal character varying(12)
);

----------------------------------
-- SubQuery
----------------------------------

-- 2015년 평균 기대수명 보다 1.15배보다 높은 모든 데이터를 조회한다.
SELECT *
FROM populations
WHERE life_expectancy > 1.15 * (
		SELECT 
			AVG(life_expectancy) 
		FROM populations 
		WHERE year = 2015) 
	AND year = 2015;
	
-- countries 테이블에서 Captial 컬럼과 매칭되는 cities 테이블의 필드를 조회한다.
-- urbanarea_pop 내림차순을 기준으로 정렬한다. 
SELECT 
	name 
	, country_code
	, urbanarea_pop::INTEGER
FROM cities
WHERE name IN
  (SELECT 
  		capital
   FROM countries)
ORDER BY urbanarea_pop DESC;

-- countries 테이블과, cities 테이블을 서로 조인하여 국가별 도시 갯수를 계산한다.
-- INNER JOIN을 서브쿼리로 변환하기
SELECT 
	co.name AS country
	, COUNT(*) AS cities_num
FROM cities ci
INNER JOIN countries co 
	ON co.code = ci.country_code
GROUP BY country
ORDER BY cities_num DESC, country;

-- 서브쿼리로 변환하기
SELECT countries.name AS country,
  (SELECT COUNT(*)
   FROM cities
   WHERE countries.code = cities.country_code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country;

-- 2015년, 각 대륙별 가장 높은 인플레이션을 기록한 국가와 인플레이션을 조회한다.  
SELECT 
	name
	, continent
	, inflation_rate
FROM countries
INNER JOIN economies
	ON countries.code = economies.code
WHERE year = 2015
    AND inflation_rate IN (
        SELECT 
			MAX(inflation_rate) AS max_inf
        FROM (
             	SELECT 
					name
					, continent
					, inflation_rate
             	FROM countries
             	INNER JOIN economies
             	ON countries.code = economies.code
             	WHERE year = 2015) AS subquery
        GROUP BY continent
	);

----------------------------------
-- WINDOWS FUNCTION
----------------------------------
-- 테이블에서 행집합을 대상으로 하는 함수
-- 집합 단위로 계산하기 때문에, 집계 함수와 비슷
-- 단, 집계 함수는 한 행으로 결괏값을 보여주는 반면, 윈도우 암수는 각 행마다 처리 결과를 출력함
-- 윈도우 함수를 사용하려면 집약함수 뒤에 OVER를 붙이고 윈도 함수를 지정합니다. 

-- 각 운동선수들이 획득한 매달의 갯수를 정렬한 뒤, 순위를 추가한다. 
SELECT 
	athlete
	, medals
	, ROW_NUMBER() OVER (ORDER BY medals DESC) AS ranking
FROM (
	SELECT 
		athlete
		, COUNT(*) AS medals
	FROM summer_medals
	GROUP BY athlete
) AS medal_cnt;

-- PARTITION BY
-- 각 종목별 현재 챔피언 전년도 챔피언 구하기
SELECT DISTINCT event FROM summer_medals;
WITH Discus_Gold_Medal AS (
	SELECT 
		Year
		, Event
		, athlete
		, country
	FROM summer_medals
	WHERE 
		Year IN (2004, 2008, 2012)
		AND Gender = 'Men' AND Medal = 'Gold'
	    AND Event IN ('100M', '400M')
		AND Gender = 'Men')
			
SELECT 
	year
	, Event
	, athlete
	, country
	, LAG(athlete) OVER (ORDER BY Event ASC, Year ASC) AS Last_athlete
	, LAG(country) OVER (ORDER BY Event ASC, Year ASC) AS Last_Country
FROM Discus_Gold_Medal
ORDER BY Event ASC, Year ASC;

-- PARTITION BY 적용
SELECT DISTINCT event FROM summer_medals;
WITH Discus_Gold_Medal AS (
	SELECT 
		Year
		, Event
		, athlete
		, country
	FROM summer_medals
	WHERE 
		Year IN (2004, 2008, 2012)
		AND Gender = 'Men' AND Medal = 'Gold'
	    AND Event IN ('100M', '400M')
		AND Gender = 'Men')
		
SELECT 
	year
	, Event
	, athlete
	, country
	, LAG(athlete) OVER (PARTITION BY Event ORDER BY Event ASC, Year ASC) AS Last_athlete
	, LAG(country) OVER (PARTITION BY Event ORDER BY Event ASC, Year ASC) AS Last_Country
FROM Discus_Gold_Medal
ORDER BY Event ASC, Year ASC;