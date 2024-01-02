-- 테이블 생성
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  name                    VARCHAR   PRIMARY KEY,
  country_code            VARCHAR,
  city_proper_pop         REAL,
  metroarea_pop           REAL,
  urbanarea_pop           REAL
);

DROP TABLE IF EXISTS countries;
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

DROP TABLE IF EXISTS economies;
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

DROP TABLE IF EXISTS populations;
CREATE TABLE populations (
  pop_id                INTEGER     PRIMARY KEY,
  country_code          VARCHAR,
  year                  INTEGER,
  fertility_rate        REAL,
  life_expectancy       REAL,
  size                  REAL
);

DROP TABLE IF EXISTS summer_medals;
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
-- 코드
	
-- countries 테이블에서 Captial 컬럼과 매칭되는 cities 테이블의 필드를 조회한다.
-- urbanarea_pop 내림차순을 기준으로 정렬한다. 
-- 코드

-- countries 테이블과, cities 테이블을 서로 조인하여 국가별 도시 갯수를 계산한다.
-- INNER JOIN을 서브쿼리로 변환하기
-- 코드

-- 서브쿼리로 변환하기
-- 코드

-- 2015년, 각 대륙별 가장 높은 인플레이션을 기록한 국가와 인플레이션을 조회한다.  
-- 코드

----------------------------------
-- WINDOWS FUNCTION
----------------------------------
-- 테이블에서 행집합을 대상으로 하는 함수
-- 집합 단위로 계산하기 때문에, 집계 함수와 비슷
-- 단, 집계 함수는 한 행으로 결괏값을 보여주는 반면, 윈도우 암수는 각 행마다 처리 결과를 출력함
-- 윈도우 함수를 사용하려면 집약함수 뒤에 OVER를 붙이고 윈도 함수를 지정합니다. 

-- 각 운동선수들이 획득한 매달의 갯수를 정렬한 뒤, 순위를 추가한다. 
-- 코드

-- PARTITION BY
-- 각 종목별 현재 챔피언 전년도 챔피언 구하기
-- 코드 

-- 코드

-- PARTITION BY 적용
-- 코드
-- 코드