USE classicmodels;

-- [매출액]
-- 주문일자는 orders 테이블에 존재
-- 판매액은 orderdetails에 존재함
SELECT 
	A.orderdate
    , priceeach * quantityordered 
FROM orders A
LEFT 
JOIN orderdetails B
ON A.ordernumber = B.ordernumber;

-- 일별 매출액
-- SUM()
SELECT 
	A.orderdate
    , SUM(priceeach * quantityordered) AS 매출액
FROM orders A
LEFT 
JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY A.orderdate
ORDER BY A.orderdate;

-- [월별 매출액 조회]
-- SUBSTR(칼럼, 위치, 길이)
SELECT SUBSTR('ABCDE', 2, 2);

SELECT SUBSTR('2003-01-06', 1, 7) MM;

SELECT 
	SUBSTR(A.orderdate, 1, 7) MM
    , SUM(priceeach * quantityordered) AS 매출액
FROM orders A
LEFT 
JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY MM   
ORDER BY MM; -- Oracle에서 이렇게 하면 에러 남

-- 연도별 매출액 조회 
SELECT 
	SUBSTR(A.orderdate, 1, 4) YY
    , SUM(priceeach * quantityordered) AS 매출액
FROM orders A
LEFT 
JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY YY   
ORDER BY YY; 

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

-- Evan의 고객번호, 주문번호 중복 되면 큰일남
SELECT
	COUNT(DISTINCT customernumber) AS 구매자수
    , COUNT(ordernumber) AS 구매건수
FROM orders;

SELECT
	orderdate
	, COUNT(DISTINCT customernumber) AS 구매자수
    , COUNT(ordernumber) AS 구매건수
FROM orders
GROUP BY 1
ORDER BY 1
;

-- 구매자수가 2명 이상인 날짜를 확인하고 싶음
-- 서브쿼리 

SELECT A.* 
FROM (
	SELECT
		orderdate
		, COUNT(DISTINCT customernumber) AS 구매자수
		, COUNT(ordernumber) AS 구매건수
	FROM orders
	GROUP BY 1
	ORDER BY 1
) A
WHERE A.구매자수 = 4
;

-- p.93 
-- 인당 매출액 (연도별)
-- 먼저 연도별 매출액과 구매자 수를 구한다! 
-- 컬럼은 3개가 출력되어야 합니다. 
SELECT 
	SUBSTR(A.orderdate, 1, 4) YY
    , COUNT(DISTINCT A.customernumber) AS 구매자수
    , SUM(priceeach * quantityordered) AS 매출액
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber 
GROUP BY 1
ORDER BY 1;

-- 인당 매출액을 구한다 = 비율 구하기 
-- Logic : 매출액 / 구매자수
SELECT 
	SUBSTR(A.orderdate, 1, 7) MM
    , COUNT(DISTINCT A.customernumber) AS 구매자수
    , SUM(priceeach * quantityordered) AS 매출액
    , SUM(priceeach * quantityordered) / COUNT(DISTINCT A.customernumber) AS AMV
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber 
GROUP BY 1
ORDER BY 1;

-- 서브쿼리는 정말 실무에서 자주 사용하니, 의도적으로 자주 Try 해주세요. 
-- 예) AMV >= 30000 이상 추출하기 등 

-- 건당 구매 금액(ATV: Average Transaction Value) 
-- 1건의 거래가 평균적으로 얼마의 매출을 일으키는가? 
SELECT 
	SUBSTR(A.orderdate, 1, 4) YY
    , COUNT(DISTINCT A.ordernumber) AS 구매건수 
    , SUM(priceeach * quantityordered) AS 매출액
    , SUM(priceeach * quantityordered) / COUNT(DISTINCT A.ordernumber) AS ATV
FROM orders A
LEFT 
JOIN orderdetails B 
ON A.ordernumber = B.ordernumber
GROUP BY 1
ORDER BY 1
;

-- 96p
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

SELECT 
	C.country
    , C.city
    , B.priceeach * B.quantityordered
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber 
LEFT 
JOIN customers C
ON A.customernumber = C.customernumber
;

-- 국가별, 도시별 매출액 계산
SELECT 
	C.country
    , C.city
    , SUM(B.priceeach * B.quantityordered) AS 매출액
FROM orders A
LEFT
JOIN orderdetails B
ON A.ordernumber = B.ordernumber 
LEFT 
JOIN customers C
ON A.customernumber = C.customernumber
GROUP BY 1, 2
ORDER BY 1, 2
;

-- 북미 vs 비북미 매출액 비교 
SELECT 
	CASE WHEN country IN ('USA', 'Canada') THEN '북미'
    ELSE '비북미' 
    END country_grp
    , country
FROM customers;

-- 
SELECT 
	CASE WHEN country IN ('USA', 'Canada') THEN '북미'
    ELSE '비북미' 
    END country_grp
    , SUM(B.priceeach * B.quantityordered) AS 매출액
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
	quantityordered
    , RANK() OVER(ORDER BY quantityordered DESC) AS 'RANK'
    , DENSE_RANK() OVER(ORDER BY quantityordered DESC) AS 'DENSE RANK'
    , ROW_NUMBER() OVER(ORDER BY quantityordered DESC) AS 'ROW NUMBER'
FROM orderdetails;

CREATE TABLE stat AS 
SELECT 
	C.country
    , SUM(priceeach * quantityordered) 매출액
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

SELECT * FROM stat;

SELECT
	country
    , 매출액
    , DENSE_RANK() OVER(ORDER BY 매출액 DESC) RNK
FROM stat;

-- 교재에서는 새로운 테이블을 또 생성 (강사는 이 방법 싫음)
-- 서브쿼리 통해서 구현
SELECT A.*
FROM (
	SELECT
		country
		, 매출액
		, DENSE_RANK() OVER(ORDER BY 매출액 DESC) RNK
	FROM stat
) A
WHERE RNK BETWEEN 1 AND 5
;

-- p.107 서브쿼리
-- p.111 재구매율 (Retention Rate(%))
-- 매우 매우 매우 중요한 마케팅 개념
-- p.112 (셀프조인)
-- 쿼리가 의미하는 것은 재구매 고객만 추출하겠다는 뜻. 
SELECT 
	A.customernumber
    , A.orderdate
	, B.customernumber
    , B.orderdate
FROM orders A
LEFT 
JOIN orders B 
ON A.customernumber = B.customernumber 
	AND SUBSTR(A.orderdate, 1, 4) = SUBSTR(B.orderdate, 1, 4) - 1;

SELECT SUBSTR('2004-11-05', 1, 4) - 1; -- 실제 같은해에 주문한 이력이 존재하는가?

-- A 국가 거주 구매자 중 다음 연도에서 구매를 한 구매자의 비중으로 정의 
SELECT 
	C.country
    , SUBSTR(A.orderdate, 1, 4) YY
    , COUNT(DISTINCT A.customernumber) BU_1
    , COUNT(DISTINCT B.customernumber) BU_2
	, COUNT(DISTINCT B.customernumber) / COUNT(DISTINCT A.customernumber) AS 재구매율
FROM orders A 
LEFT 
JOIN orders B
ON A.customernumber = B.customernumber 
	AND SUBSTR(A.orderdate, 1, 4) = SUBSTR(B.orderdate, 1, 4) - 1
LEFT
JOIN customers C
ON A.customernumber = C.customernumber
GROUP BY 1, 2
;


-- 국가별 Top Product 및 매출


-- 4교시 : 오전 3교시 배운 내용 복습, 블로그에 잘 정리! 
-- 8교시 : 블로그 초안 포함 링크 공유 (전원 필히 해주세요!) 



