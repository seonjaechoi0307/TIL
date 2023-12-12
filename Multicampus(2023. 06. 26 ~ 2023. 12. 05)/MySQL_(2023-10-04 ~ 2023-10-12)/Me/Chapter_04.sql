USE Classicmodels;

-- [매출액]
-- 주문일자는 orders 테이블에 존재
-- 판매액은 orderdetails 테이블에 존재함
SELECT
	A.orderdate
    , priceeach * quantityordered
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber;

-- 일별 매출액
-- SUM()
-- GROUP BY
-- orders 테이블과 orderdetails 테이블을 조인하여 일별 매출액을 계산하는 쿼리
SELECT
    -- 주문 날짜와 해당 날짜의 매출액을 선택
    A.orderdate,
    SUM(priceeach * quantityordered) AS 매출액
FROM
    -- 주문 정보를 담고 있는 orders 테이블과 주문 상세 정보를 담고 있는 orderdetails 테이블을 조인
    orders A
LEFT JOIN
    orderdetails B
ON
    A.ordernumber = B.ordernumber
GROUP BY
    -- 주문 날짜를 기준으로 결과를 그룹화
    A.orderdate
ORDER BY
    -- 결과를 주문 날짜 오름차순으로 정렬
    A.orderdate;
    
-- 월별 매출액
-- SUBSTR(칼럼, 위치, 길이)
SELECT SUBSTR('ABCDE', 2, 4); -- BCDE 가져옴

SELECT SUBSTR('2023-10-01', 1, 7) MM;

SELECT
	SUBSTR(A.orderdate, 1, 7) MM
    , SUM(priceeach * quantityordered) AS 매출액
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY MM
ORDER BY MM; -- Oracle 에서 이렇게 하면 에러 나옴

SELECT
	SUBSTR(A.orderdate, 1, 4) YYYY
    , SUM(priceeach * quantityordered) AS 매출액
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY YYYY
ORDER BY YYYY; -- Oracle 에서 이렇게 하면 에러 나옴

-- [EXTRACT] 날짜 추출 함수
-- orders 테이블과 orderdetails 테이블을 조인하여 연도별 매출액을 계산하는 쿼리
SELECT
    EXTRACT(YEAR FROM A.orderdate) AS YYYY,
    SUM(priceeach * quantityordered) AS 매출액
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY EXTRACT(YEAR FROM A.orderdate)
ORDER BY EXTRACT(YEAR FROM A.orderdate);

SELECT
    -- 연도를 추출하고 'YYYY' 별칭을 부여
    EXTRACT(YEAR FROM A.orderdate) AS YYYY,
    -- 월을 추출하고 'MM' 별칭을 부여
    EXTRACT(MONTH FROM A.orderdate) AS MM,
    -- 해당 월의 매출액을 계산
    SUM(priceeach * quantityordered) AS 매출액
FROM
    -- 주문 정보를 담고 있는 orders 테이블과 주문 상세 정보를 담고 있는 orderdetails 테이블을 조인
    orders A
LEFT JOIN
    orderdetails B
ON
    A.ordernumber = B.ordernumber
GROUP BY
    -- 연도와 월을 기준으로 결과를 그룹화
    EXTRACT(YEAR FROM A.orderdate),
    EXTRACT(MONTH FROM A.orderdate)
ORDER BY
    -- 연도와 월을 기준으로 결과를 정렬
    EXTRACT(YEAR FROM A.orderdate),
    EXTRACT(MONTH FROM A.orderdate);

-- orders 테이블과 orderdetails 테이블을 조인하여 연도별 매출액을 계산하는 쿼리

SELECT
    -- 연도를 추출하고 'YYYY' 별칭을 부여
    EXTRACT(YEAR FROM A.orderdate) AS Year
    -- 월을 추출하고 'MM' 별칭을 부여
    , EXTRACT(MONTH FROM A.orderdate) AS Month
    -- 월을 추출하고 'MM' 별칭을 부여
    , EXTRACT(DAY FROM A.orderdate) AS DAY
    -- 해당 일의 매출액을 계산
    , SUM(priceeach * quantityordered) AS 매출액

-- 주문 정보를 담고 있는 orders 테이블과 주문 상세 정보를 담고 있는 orderdetails 테이블을 조인
FROM orders A
    
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY
    -- 연도와 월을 기준으로 결과를 그룹화
    EXTRACT(YEAR FROM A.orderdate)
    , EXTRACT(MONTH FROM A.orderdate)
    , EXTRACT(DAY FROM A.orderdate)
ORDER BY
    -- 연도와 월을 기준으로 결과를 정렬
    EXTRACT(YEAR FROM A.orderdate)
    , EXTRACT(MONTH FROM A.orderdate)
    , EXTRACT(DAY FROM A.orderdate)
;

-- [구매자 수, 구매 건수(일자별, 월별, 연도별)]
-- SUBSTR()
-- GROUP BY
-- COUNT()
-- Orders 테이블에 판매일 (Orderdate), 구매 고객 번호(Customernumber)
SELECT
	orderdate
    , customernumber
    , ordernumber
FROM orders;
-- Evan의 고객번호, 주문번호 중복 되면 안됨 !!
SELECT
	COUNT(DISTINCT customernumber) AS 구매자수
    , COUNT(ordernumber) AS 구매건수
FROM orders;
    
SELECT
	orderdate
	, COUNT(DISTINCT customernumber) AS 구매자수
    , COUNT(ordernumber) AS 구매건수
FROM orders
GROUP BY 1 -- = orderdate(1번열)
ORDER BY 1 -- = orderdate(1번열)
;

-- 구매자 수가 2명 이상인 날짜를 확인하고 싶음
-- 서브쿼리

SELECT *
FROM(
	SELECT
	orderdate
	, COUNT(DISTINCT customernumber) AS 구매자수
    , COUNT(ordernumber) AS 구매건수
	FROM orders
	GROUP BY 1 -- = orderdate(1번열)
	ORDER BY 1 -- = orderdate(1번열)
) A
WHERE A.구매자수 >= 2
;

SELECT
	orderdate
	, COUNT(DISTINCT customernumber) AS 구매자수
    , COUNT(ordernumber) AS 구매건수
FROM orders
GROUP BY 1
HAVING 구매자수 >= 2
ORDER BY 1;

-- P. 93
-- 인당 매출액 (연도별)
-- 먼저 연도별 매출액과 구매자 수를 구한다 !

SELECT
	SUBSTR(A.orderdate, 1, 4) YY
    , COUNT(DISTINCT customernumber) AS 구매자수
    , SUM(priceeach * quantityordered) AS 매출액
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1;

-- 비율 구하기 인당 매출액
-- Logic : 매출액 / 구매자수
SELECT
	SUBSTR(A.orderdate, 1, 4) YY
    , COUNT(DISTINCT customernumber) AS 구매자수
    , SUM(priceeach * quantityordered) AS SALES
    , SUM(priceeach * quantityordered) / COUNT(DISTINCT customernumber) AS ATV
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1;

-- 비율 구하기 인당 매출액
-- Logic : 매출액 / 구매자수
SELECT
	SUBSTR(A.orderdate, 1, 7) MM
    , COUNT(DISTINCT customernumber) AS 구매자수
    , SUM(priceeach * quantityordered) AS SALES
    , SUM(priceeach * quantityordered) / COUNT(DISTINCT customernumber) AS ATV
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1;

SELECT *
FROM (
	SELECT
	SUBSTR(A.orderdate, 1, 7) MM
    , COUNT(DISTINCT customernumber) AS 구매자수
    , SUM(priceeach * quantityordered) AS SALES
    , SUM(priceeach * quantityordered) / COUNT(DISTINCT customernumber) AS AMV
	FROM orders A
    LEFT JOIN orderdetails B
    ON A.ordernumber = B.ordernumber
    GROUP BY 1
    ORDER BY 1
) A
WHERE AMV >= 20000
;

-- 건당 구매 금액(ATV : Average Transcaction Value)
-- 1건의 거래가 평균적으로 얼마의 매출을 일으키는가?
SELECT
	SUBSTR(A.orderdate, 1, 4) YY
    , COUNT(DISTINCT A.ordernumber) AS 구매건수
    , SUM(priceeach * quantityordered) AS 매출액
    , SUM(priceeach * quantityordered) / COUNT(DISTINCT A.ordernumber) AS ATV
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1;

-- P. 96
-- 그룹별 구매 지표 구하기
SELECT *
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber
LEFT
JOIN customers C
ON A.customernumber = C.customernumber
;

-- 국가별, 도시별 매출액
SELECT
	C. country
    , C. city
    , SUM(B. priceeach * quantityordered) AS 매출액
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber
LEFT
JOIN customers C
ON A.customernumber = C.customernumber
GROUP BY country, city
ORDER BY 1, 3 DESC
;

-- 북미 VS 비북미 매출액 비교
SELECT
	CASE WHEN country IN ('USA', 'Canada') THEN '북미'
	ELSE '비북미'
    END country_grp
    , country
FROM customers;

SELECT
	CASE WHEN country IN ('USA', 'Canada') THEN '북미'
	ELSE '비북미'
    END AS country_grp
	-- , C. country
    -- , C. city
    , SUM(B. priceeach * quantityordered) AS 매출액
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber
LEFT
JOIN customers C
ON A.customernumber = C.customernumber
GROUP BY 1
ORDER BY 1 ASC
;

-- 매출 Top5 국가 및 매출
DROP TABLE stat;

SELECT
	quantityOrdered
	, RANK() OVER(ORDER BY quantityOrdered DESC) AS 'RANK'
    , DENSE_RANK() OVER(ORDER BY quantityOrdered DESC) AS 'DENSE RANK'
    , ROW_NUMBER() OVER(ORDER BY quantityOrdered DESC) AS 'ROW_NUMBER RANK'
FROM orderdetails;

CREATE TABLE STAT AS
SELECT
	C.country
    , SUM(priceeach * quantityordered) AS 매출액
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber
LEFT
JOIN customers C
ON A.customernumber = C.customernumber
GROUP BY 1
ORDER BY 2 DESC
;

SELECT * FROM STAT;

SELECT
	country
    , 매출액
    , DENSE_RANK() OVER(ORDER BY 매출액 DESC) RNK
FROM stat;

-- 교재에서는 새로운 테이블 또 생성 (강사님은 이 방법 싫음)
-- 서브쿼리 통해서 구현
SELECT *
FROM(
	SELECT
		country
		, 매출액
		, DENSE_RANK() OVER(ORDER BY 매출액 DESC) RNK
	FROM stat
) A
WHERE RNK BETWEEN 1 AND 5
;

-- P. 107 서브쿼리
-- P. 111 재구매율 (Retention Rate(%))
-- 매우매우매우매우 중요한 마케팅 개념
-- p. 112 (셀프조인)
-- 쿼리가 의미하는 것은 재구매 고객만 추출하겠다는 뜻
SELECT
	A.customernumber
    , A. orderdate
    , B.customernumber
    , B. orderdate
FROM orders A
LEFT
JOIN orders B
ON A.customernumber = B.customernumber
	AND SUBSTR(A.orderdate, 1, 4) = SUBSTR(B.orderdate, 1, 4) -1;

SELECT SUBSTR('2004-11-05',1 , 4) -1; -- 실제 같은 해에 주문한 이력이 존재하는가?

-- A 국가 거주 구매자 중 다음 연도에서 구매를 한 구매자의 비중으로 정의
SELECT
	C. country
    , SUBSTR(A.orderdate, 1, 4) YY
    , COUNT(DISTINCT A.customernumber) AS BU_1
    , COUNT(DISTINCT B.customernumber) AS BU_2
    
    -- A = 작년 / B = 올해 / 재구매율 = 올해(B) / 작년(A)
	, COUNT(DISTINCT B.customernumber) / COUNT(DISTINCT A.customernumber) AS 재구매율
    
FROM orders A
LEFT
JOIN orders B

-- A와 B가 같을 시 A는 B보다 1년 작은 값을 찾아서 결합시킨다.
ON A.customernumber = B.customernumber
	AND SUBSTR(A.orderdate, 1, 4) = SUBSTR(B.orderdate, 1, 4) -1
LEFT
JOIN customers C
ON A.customernumber = C.customernumber

-- country, YY를 기준으로 집계하기
GROUP BY 1, 2
;

-- P. 115    
-- 국가별 Top Product 및 매출
-- 미국의 연도별 Top5 차량 모델 추출을 부탁드립니다.
-- (매출액 기준)
-- order 테이블, orderdetails 테이블, customers 테이블
-- 차량 모델을 뽑으려면 products 테이블을 사용해야됨

USE classicmodels;

SELECT
	quantityordered
    , priceeach
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber
;

-- 4교시 : 오전 배운 내용 복습 및 블로그 정리 !!
-- 8교시 : 블로그 초안 포함 링크 공유(전원 必)

-- 매출액 기준 차량 모델을 찾는 것이 핵심코드
-- ERD 기준 : customers, products
-- 1차 제외 : 주문안한 고객
-- 2차 제외 : 차량모델 코드 중 주문고객
-- 3차 제외 : USA 제외 customer 테이블 참조

-- 'product_sales' 테이블을 생성하고, 미국에서 주문된 제품의 판매량을 계산하여 저장합니다.
CREATE TABLE product_sales AS
SELECT
    D.productname,  -- 제품 이름을 선택합니다.
    SUM(quantityordered * priceeach) AS sales  -- 판매량과 가격을 곱한 총 판매액을 계산합니다.
FROM orders A
LEFT JOIN customers B
ON A.customernumber = B.customernumber
LEFT JOIN orderdetails C
ON A.ordernumber = C.ordernumber
LEFT JOIN products D
ON C.productcode = D.productcode
WHERE B.country = 'USA'  -- 고객이 미국에서 주문한 경우만 필터링합니다.
GROUP BY 1;  -- 제품 이름을 기준으로 그룹화합니다.

-- 'product_sales' 테이블에서 판매량 기준으로 상위 5개 제품을 선택합니다.
SELECT * 
FROM (
    SELECT *
    , ROW_NUMBER() OVER (ORDER BY sales DESC) AS RNK  -- 판매량을 기준으로 순위를 부여합니다.
    FROM product_sales
) A
WHERE RNK <= 5  -- 순위가 5 이하인 제품만 선택합니다.
ORDER BY RNK;  -- 순위 순으로 결과를 정렬합니다.

-- [Churn Rate (%)]
-- Churn : max(구매일, 접속일) 이후 일정 기간 (ex. 3개월)
-- 구매, 접속하지 않은 상태를 의미함
SELECT
	MAX(orderdate) mx_order -- 마지막 구매일
    , MIN(orderdate) mn_order -- 최초 구매일
FROM orders;

-- 2005-06-01일 기준으로 각 고객의 마지막 구매일이 며칠 소요되느냐?
SELECT
	customernumber
	, MIN(orderdate) '최초 구매일'
    , MAX(orderdate) '마지막 구매일'
FROM orders
GROUP BY 1;

-- DATEDIFF 사용 (date1, date2)
SELECT DATEDIFF('2003-01-09', '2004-11-05');

SELECT DATEDIFF(MAX(orderdate), MIN(orderdate))
FROM orders;

-- 전체 코드 확인
-- 각 고객의 고객번호(customernumber)와 해당 고객의 마지막 주문일(MX_ORDER)을 선택합니다.
SELECT
	customernumber,            -- 고객 번호
    MX_ORDER,                  -- 해당 고객의 마지막 주문일
    '2005-06-01' AS REF_DATE,  -- 고정된 참조 날짜 '2005-06-01' (전체 고객 대상의 마지막 구매일 기준)
    DATEDIFF('2005-06-01', MX_ORDER) AS DIFF  -- REF_DATE와 MX_ORDER 간의 일자 차이를 계산합니다.
FROM (
	-- orders 테이블을 기준으로 각 고객별로 그룹화하고, 각 고객의 마지막 주문일을 구합니다.
	SELECT
		customernumber,            -- 고객 번호
        MAX(orderdate) AS MX_ORDER -- 각 고객별로 가장 최근의 주문일을 찾습니다.
	FROM orders
	GROUP BY 1  -- 고객 번호를 기준으로 그룹화합니다.
) BASE
;

-- P. 119
-- CASE WHEN = IF 조건문 >>> 조건 DIFF가 90일 이상이면 Churn이라고 가정한다. Churn 또는 Non Churn
-- 
-- 메인쿼리 : 조건 DIFF가 90일 이상이면 Churn이라고 가정한다. Churn 또는 Non Churn
-- 서브쿼리 :

-- 전체 코드 확인
-- 각 고객의 고객번호(customernumber)와 해당 고객의 마지막 주문일(MX_ORDER)을 선택합니다.

SELECT
	* ,
	CASE WHEN DIFF >= 90 THEN 'Churn'
    ELSE 'Non Churn'
    END AS Churn_Type
FROM(
	SELECT
	customernumber,            -- 고객 번호
    MX_ORDER,                  -- 해당 고객의 마지막 주문일
    '2005-06-01' AS REF_DATE,  -- 고정된 참조 날짜 '2005-06-01' (전체 고객 대상의 마지막 구매일 기준)
    DATEDIFF('2005-06-01', MX_ORDER) AS DIFF  -- REF_DATE와 MX_ORDER 간의 일자 차이를 계산합니다.
	FROM (
		-- orders 테이블을 기준으로 각 고객별로 그룹화하고, 각 고객의 마지막 주문일을 구합니다.
		SELECT
			customernumber,            -- 고객 번호
			MAX(orderdate) AS MX_ORDER -- 각 고객별로 가장 최근의 주문일을 찾습니다.
		FROM orders
		GROUP BY 1  -- 고객 번호를 기준으로 그룹화합니다.
	) BASE
) BASE2
GROUP BY 1
;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

SELECT
	CASE WHEN DIFF >= 90 THEN 'Churn'
    ELSE 'Non Churn'
    END AS Churn_Type
    , COUNT(DISTINCT customernumber) N_CUS
FROM(
	SELECT
	customernumber,            -- 고객 번호
    MX_ORDER,                  -- 해당 고객의 마지막 주문일
    '2005-06-01' AS REF_DATE,  -- 고정된 참조 날짜 '2005-06-01' (전체 고객 대상의 마지막 구매일 기준)
    DATEDIFF('2005-06-01', MX_ORDER) AS DIFF  -- REF_DATE와 MX_ORDER 간의 일자 차이를 계산합니다.
	FROM (
		-- orders 테이블을 기준으로 각 고객별로 그룹화하고, 각 고객의 마지막 주문일을 구합니다.
		SELECT
			customernumber,            -- 고객 번호
			MAX(orderdate) AS MX_ORDER -- 각 고객별로 가장 최근의 주문일을 찾습니다.
		FROM orders
		GROUP BY 1  -- 고객 번호를 기준으로 그룹화합니다.
	) BASE
) BASE2
GROUP BY 1
;

-- Churn = 69 / Non Churn = 29
SELECT 69/(69+29);

-- Churn 고객이 가장 많이 구매한 Productline
CREATE TABLE churn_list AS 
SELECT 
	CASE WHEN DIFF >= 90 THEN 'CHURN ' ELSE 'NON-CHURN' END CHURN_TYPE
    , customernumber
FROM 
	(
		SELECT 
			customernumber
			, mx_order
			, '2005-06-01' END_POINT
			, DATEDIFF('2005-06-01', mx_order) DIFF
		FROM
			(
				SELECT 
					customernumber
					, max(orderdate) mx_order
				FROM orders
				GROUP BY 1
			) BASE
    ) BASE
;

SELECT * FROM churn_list;

-- Churn 고객은 어떤 카테고리의 상품을 많이 구매 했는가?
SELECT * FROM productlines;

-- P. 122
SELECT
	C.productline
    , COUNT(DISTINCT B.customernumber) AS BU
FROM orderdetails A
LEFT
JOIN orders B
ON A.ordernumber = B.ordernumber
LEFT
JOIN products C
ON A.productcode = C.productcode
GROUP BY 1
;

-- Churn Type, Product Line 별 구매자 수 파악하기
SELECT
	D.churn_type
	, C.productline
    , COUNT(DISTINCT B.customernumber) AS BU
FROM orderdetails A
LEFT
JOIN orders B
ON A.ordernumber = B.ordernumber
LEFT
JOIN products C
ON A.productcode = C.productcode
LEFT
JOIN churn_list D
ON B.customernumber = D.customernumber
GROUP BY 1, 2
ORDER BY 1, 3 DESC
;

-- 4교시 : 오전 배운 내용 복습 및 블로그 정리 !!
-- 8교시 : 블로그 초안 포함 링크 공유(전원 必)