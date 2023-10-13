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

-- p.115 
-- 국가별 Top Product 및 매출
-- 미국의 연도별 Top5 차량 모델 추출을 부탁드립니다. 
-- order 테이블, orderdetails 테이블, customers 테이블
-- products 테이블 
USE classicmodels;

CREATE TABLE product_sales AS 
SELECT 
	D.productname
    , SUM(quantityordered * priceeach) AS sales 
FROM orders A
LEFT 
JOIN customers B
ON A.customernumber = B.customernumber 
LEFT 
JOIN orderdetails C
ON A.ordernumber = C.ordernumber 
LEFT
JOIN products D
On C.productcode = D.productcode 
WHERE B.country = 'USA'
GROUP BY 1
;
-- 매출액 기준) 차량모델을 찾는 것이 핵심코드 
-- ERD 기준, customers      products
-- 1차 제외 : 주문안한 고객 
-- 2차 제외 : 차량모델 코드 중 주문이 없는 차량모델 제외
-- 3차 제외 : USA 제외 customer 테이블 참조

SELECT * 
FROM (
	SELECT *
    , ROW_NUMBER() OVER(ORDER BY sales DESC) RNK
    FROM product_sales) A
WHERE RNK <= 5
ORDER BY RNK;

SELECT * FROM product_sales;

-- [Churn Rate (%)] 
-- Churn : max(구매일, 접속일) 이후 일정 기간 (ex. 3개월)
-- 구매, 접속하지 않은 상태
SELECT 
	MAX(orderdate) mx_order -- 마지막 구매일
    , MIN(orderdate) mn_order -- 최초 구매일
FROM orders;

-- 2005-06-01일 기준으로 각 고객의 마지막 구매일이 며칠 소요되는가?  
SELECT
	customernumber
    , MIN(orderdate) `최초 구매일`
	, MAX(orderdate) `마지막 구매일`
FROM orders
GROUP BY 1;

-- DATEDIFF 사용 (date1, date2) 
SELECT DATEDIFF('2003-01-09', '2004-11-05');
SELECT DATEDIFF('2004-11-05', '2004-11-01');

-- 전체 코드 확인 
SELECT 
	customernumber
    , MAX(orderdate) MX_ORDER -- 이 테이블의 마지막 구매일 (전 고객 기준)
                              -- GROUP BY 마지막 구매일 (각 고객 기준)
FROM orders
GROUP BY 1;

SELECT 
	customernumber
    , MX_ORDER 
    , '2005-06-01' -- 전 고객 대상 마지막 구매일
    , DATEDIFF('2005-06-01', MX_ORDER) DIFF 
FROM (
	SELECT 
		customernumber
		, MAX(orderdate) MX_ORDER 
	FROM orders
	GROUP BY 1
) BASE
;


-- p.119 
-- 조건 DIFF가 90일 이상이면 Churn이라고 가정한다. Churn 또는 Non Churn 
-- IF 조건문, 
-- 메인쿼리 : 90일 이상이면 Churn이라고 가정한다. CHURN 또는 NON-CHURN
-- 서브쿼리 : DIFF를 구하는 것이 서브쿼리
SELECT 
	* 
    , CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END churn_type
FROM (
	SELECT 
		customernumber
		, MX_ORDER 
		, '2005-06-01' -- 전 고객 대상 마지막 구매일
		, DATEDIFF('2005-06-01', MX_ORDER) DIFF 
	FROM (
		SELECT 
			customernumber
			, MAX(orderdate) MX_ORDER 
		FROM orders
		GROUP BY 1
	) BASE 
) BASE2
;

-- CHURN RATE 요약 테이블 집계
SELECT 
    CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END churn_type
    , COUNT(DISTINCT customernumber) N_CUS
FROM (
	SELECT 
		customernumber
		, MX_ORDER 
		, '2005-06-01' -- 전 고객 대상 마지막 구매일
		, DATEDIFF('2005-06-01', MX_ORDER) DIFF 
	FROM (
		SELECT 
			customernumber
			, MAX(orderdate) MX_ORDER 
		FROM orders
		GROUP BY 1
	) BASE 
) BASE2
GROUP BY 1
;

SELECT 69/(69+29);

-- CHURN 고객이 가장 많이 구매한 Productline
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

-- Churn 고객은 어떤 카테고리의 상품을 많이 구매했느냐?
SELECT * FROM productlines;

-- p.122 
SELECT 
	C.productline
    , COUNT(DISTINCT B.customernumber) BU
FROM orderdetails A
LEFT 
JOIN orders B
ON A.ordernumber = B.ordernumber
LEFT 
JOIN products C
ON A.productcode = C.productcode
GROUP BY 1
;

-- Churn Type, Product Line별 구매자 수 
SELECT 
	D.churn_type
	, C.productline
    , COUNT(DISTINCT B.customernumber) BU
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

-- 4교시 : 오전 3교시 배운 내용 복습, 블로그에 잘 정리! 
-- 8교시 : 블로그 초안 포함 링크 공유 (전원 필히 해주세요!) 



