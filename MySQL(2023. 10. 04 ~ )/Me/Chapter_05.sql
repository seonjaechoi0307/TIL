USE mydata;

SELECT COUNT(*) FROM dataset2;

SELECT * FROM dataset2;

-- Division Name 평균 평점
SELECT
	`Division Name`
    , AVG(RATING) AVG_RATE
FROM dataset2
GROUP BY 1
ORDER BY 2 DESC;

-- b) Department별 평균 평점
SELECT
	`Department Name`
    , AVG(RATING) AVG_RATE
FROM dataset2
GROUP BY 1
ORDER BY 2 DESC;

-- Trend의 평점 이하 리뷰
SELECT *
FROM dataset2
WHERE Rating <= 3;

-- 구간을 그룹으로 나누어서 집계하는 방법
-- CASE WHEN
SELECT
    CASE
        WHEN AGE BETWEEN 0 AND 9 THEN '0009'
        WHEN AGE BETWEEN 10 AND 19 THEN '1019'
        WHEN AGE BETWEEN 20 AND 29 THEN '2029'
        WHEN AGE BETWEEN 30 AND 39 THEN '3039'
        WHEN AGE BETWEEN 40 AND 49 THEN '4049'
        WHEN AGE BETWEEN 50 AND 59 THEN '5059'
        WHEN AGE BETWEEN 60 AND 69 THEN '6069'
        WHEN AGE BETWEEN 70 AND 79 THEN '7079'
        WHEN AGE BETWEEN 80 AND 89 THEN '8089'
        ELSE 'OVER 90'
    END AS Age_Group
    , AGE
FROM dataset2
WHERE `Department Name` = 'trend'
	AND rating <= 3
;

-- FLOOR 메서드 사용
SELECT FLOOR(33/10) * 10;

SELECT
	FLOOR(AGE/10) * 10 AS AGEBAND
    , AGE
FROM dataset2
WHERE `Department Name` = 'trend'
	AND rating <= 3
;

-- 결과 AGEBAND : ~ / CND ~
SELECT
	*
	, RANK() OVER(ORDER BY CNT DESC) AS 'RNK'
FROM(
	SELECT
		FLOOR(AGE/10) * 10 AS AGEBAND
		, COUNT(AGE) AS CNT
	FROM dataset2
	WHERE `Department Name` = 'trend'
		AND rating <= 3
	GROUP BY AGEBAND
	ORDER BY 2 DESC
) AS BASE
;

-- Department별 연령별 리뷰 수
SELECT
	FLOOR(AGE/10) * 10 AS AGEBAND
	, COUNT(AGE) AS CNT
FROM dataset2
WHERE `Department Name` = 'trend'
GROUP BY 1
ORDER BY 2 DESC;

-- 50대 3점 이하 Trend 리뷰를 살펴보기
SELECT *
FROM dataset2
WHERE `Department Name` = 'trend'
	AND RATING <= 3
	AND AGE BETWEEN 50 AND 59
LIMIT 10
;

-- P. 134
-- 리뷰 주 내용이 사이즈가 작은 것에 대한 컴플레인
-- Department Name, Clothing id별 평균 평점 계산
SELECT
	`department Name`
    , `clothing id`
    , AVG(rating) AS AVG_RATE
FROM dataset2
GROUP BY 1, 2
;

-- 각 제품의 평균 평점(`AVG_RATE`)을 계산합니다.
-- Department(부서)내에서 AVG_RATE(평균 평점)을 기준으로 순위를 매긴다.
SELECT
    *
    , ROW_NUMBER() OVER(PARTITION BY `Department Name` ORDER BY AVG_RATE DESC) AS 'Rank'
FROM (
    SELECT
        `Department Name`
        , `clothing id`
        , AVG(rating) AS AVG_RATE
    FROM dataset2
    GROUP BY 1, 2
) AS BASE;

-- 1위 ~ 10위 데이터 조회
-- 평균 평점이 낮은 데이터를 추출 하기 위해서 (상위 10개)

SELECT *
FROM (
	SELECT
		*
		, ROW_NUMBER() OVER(PARTITION BY `Department Name` ORDER BY AVG_RATE DESC) AS 'Rank'
	FROM (
		SELECT
			`Department Name`
			, `clothing id`
			, AVG(rating) AS AVG_RATE
		FROM dataset2
		GROUP BY 1, 2
	) A
) A
WHERE `Rank` <= 10
;

-- clothing ID만 추출한 뒤, 각 부서별 리뷰 텍스트를 추출
-- 임시 테이블 생성
CREATE TEMPORARY TABLE stat AS
SELECT *
FROM (
	SELECT
		*
		, ROW_NUMBER() OVER(PARTITION BY `Department Name` ORDER BY AVG_RATE DESC) AS 'Rank'
	FROM (
		SELECT
			`Department Name`
			, `clothing id`
			, AVG(rating) AS AVG_RATE
		FROM dataset2
		GROUP BY 1, 2
	) A
) A
WHERE `Rank` <= 10
;

SELECT * FROM stat;

-- P. 138
-- 부서명 : Bottoms
-- 18, 588, 1039, 1058
SELECT * FROM dataset2;

-- Clothing ID와 Review Text 컬럼을 선택합니다.
SELECT
	`Clothing ID`
    , `Review Text`
FROM dataset2

-- Department Name이 'Bottoms'인 행을 필터링하고,
-- Clothing ID가 18, 588, 1039, 1058 중 하나인 행을 선택합니다.
WHERE `Department Name` = 'Bottoms'
	AND `Clothing ID` IN (18, 588, 1039, 1058)
ORDER BY 1
;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- stat 테이블의 Clothing ID 컬럼의 값을 기준으로 받아오기
SELECT
	`Department Name`
	, `Clothing ID`
    , `Review Text`
FROM dataset2

-- stat 테이블의 Clothing ID 컬럼의 값을 기준으로 받아오기
-- Department Name이 'Bottoms'인 행만을 필터링 하여 추출하기
WHERE `Clothing ID` IN (
	SELECT `Clothing id`
    FROM stat
    WHERE `Department Name` = 'Bottoms'
        )
ORDER BY `Clothing ID`
;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- P. 139
-- 연령대별 Worst department
-- 각 연령대별로 가장 낮은 점수를 준 Department를 구하고,
-- 해당 Department의 할인 쿠폰을 발송한다.

-- 마케팅
-- 1. 연령대 별로 가장 낮은 점수를 준 department를 구한다.
-- 2. 연령대 별로 가장 낮은 점수를 준 department에 혜택을 준다.

SELECT
	`Department Name`
	, FLOOR(AGE/10)*10 AGEBAND
	, AVG(Rating) AVG_Rating
FROM dataset2
GROUP BY 1, 2
;

SELECT
	*
	, ROW_NUMBER() OVER(PARTITION BY AGEBAND ORDER BY AVG_Rating) AS RNK 
FROM (
	SELECT
		`Department Name`
		, FLOOR(AGE/10)*10 AGEBAND
		, AVG(Rating) AVG_Rating
	FROM dataset2
	GROUP BY 1, 2
) A
;

SELECT *
FROM (
	SELECT
		*
		, ROW_NUMBER() OVER(PARTITION BY AGEBAND ORDER BY AVG_Rating) AS RNK 
	FROM (
		SELECT
			`Department Name`
			, FLOOR(AGE/10)*10 AGEBAND
			, AVG(Rating) AVG_Rating
		FROM dataset2
		GROUP BY 1, 2
	) A
) A
WHERE RNK = 1
;

SELECT
	*
	, ROW_NUMBER() OVER(PARTITION BY `Department Name` ORDER BY AVG_Rating) AS RNK 
FROM (
	SELECT
		`Department Name`
		, FLOOR(AGE/10)*10 AS AGEBAND
		, AVG(Rating) AS AVG_Rating
	FROM dataset2
	GROUP BY 1, 2
) A
;

USE mydata;
SELECT
	`REVIEW TEXT`
    , CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END AS SIZE_YN
FROM dataset2
;

-- SIZE가 있는 REVIEW TEXT 합계
SELECT
	A.*
    , ROUND(N_SIZE / N_TOTAL, 2) AS RATE
FROM(
	SELECT
		SUM( CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) AS N_SIZE
		, COUNT(*) AS N_TOTAL
	FROM dataset2
) A
;

-- P. 145 그림 5-19
SELECT
	SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) AS N_SIZE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) AS N_LARGE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) AS N_LOOSE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) AS N_SMALL
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) AS N_TIGHT
    , SUM(1) AS N_TOTAL
FROM dataset2
;

-- P. 146 그림 5-20
SELECT
	`Department Name`
	, SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) AS N_SIZE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) AS N_LARGE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) AS N_LOOSE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) AS N_SMALL
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) AS N_TIGHT
    , SUM(1) AS N_TOTAL
FROM dataset2
GROUP BY 1
;

-- P. 146 그림 5-21
SELECT
	FLOOR(age/10)*10 AGEBAND
	, `Department Name`
	, SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) AS N_SIZE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) AS N_LARGE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) AS N_LOOSE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) AS N_SMALL
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) AS N_TIGHT
    , SUM(1) AS N_TOTAL
FROM dataset2
-- 서브쿼리를 주지 않으려면 파생변수 계산식 그대로 조건문으로 사용하면 됨
WHERE FLOOR(age/10)*10 = 20
GROUP BY 1, 2
ORDER BY 1, 2
;

SELECT
	FLOOR(age/10)*10 AGEBAND
	, `Department Name`
	, SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) AS N_SIZE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) AS N_LARGE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) AS N_LOOSE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) AS N_SMALL
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) AS N_TIGHT
    , SUM(1) AS N_TOTAL
FROM dataset2
GROUP BY 1, 2
ORDER BY 1, 2
;

SELECT
    FLOOR(age/10)*10 AS AGEBAND
    , `Department Name`
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) AS N_SIZE
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_SIZE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) AS N_LARGE
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_LARGE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) AS N_LOOSE
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_LOOSE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) AS N_SMALL
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_SMALL
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) AS N_TIGHT
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_TIGHT
    , COUNT(*) AS N_TOTAL
FROM dataset2
GROUP BY FLOOR(age/10)*10, `Department Name`
ORDER BY 1, 2;

-- Clothing ID(옷 고유번호)별 SIZE Review
-- 각 제품 Size Complaning 분석
SELECT
	`clothing ID`
    , SUM(CASE WHEN `Review Text` LIKE '%SIZE%' THEN 1 ELSE 0 END) AS N_SIZE
FROM dataset2
GROUP BY 1
;

-- Size 타입 추가
SELECT
	`clothing ID`
	, SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) AS N_SIZE
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_SIZE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) AS N_LARGE
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_LARGE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) AS N_LOOSE
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_LOOSE
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) AS N_SMALL
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_SMALL
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) AS N_TIGHT
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_TIGHT
    , COUNT(*) AS N_TOTAL
FROM dataset2
WHERE `Department name` = 'bottoms'
GROUP BY 1
;

-- 테이블 삭제 시 DROP TABLES SIZE_STAT_AS
DROP TABLES SIZE_STAT_AS;

CREATE TABLE SIZE_STAT_AS
SELECT
	`clothing ID`
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_SIZE
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_LARGE
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_LOOSE
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_SMALL
    , ROUND(SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RATE_TIGHT
    , COUNT(*) AS N_TOTAL
FROM dataset2
WHERE `Department name` = 'bottoms'
GROUP BY 1
;

SELECT * FROM SIZE_STAT_AS;
