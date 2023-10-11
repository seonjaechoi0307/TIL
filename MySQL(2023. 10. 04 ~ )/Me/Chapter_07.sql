USE mydata;

SELECT * FROM dataset3;

-- p. 196 가장 많이 판매된 2개 상품 조회

SELECT
	stockcode AS 판매번호
    , SUM(quantity) AS 판매수
FROM dataset3
GROUP BY 1
ORDER BY 2 DESC
LIMIT 2
;

-- 순위 지정 (ROW_NUMBER 사용)
SELECT
	*
    , ROW_NUMBER() OVER(ORDER BY QTY DESC) AS RNK
FROM (
	SELECT
		stockcode AS 판매번호
		, SUM(quantity) AS QTY
	FROM dataset3
	GROUP BY 1
	LIMIT 2
) A
;

-- 순위 지정 (ROW_NUMBER 사용)
-- WHERE 문으로 조건 주기
SELECT
	*
FROM (
	SELECT
		*
		, ROW_NUMBER() OVER(ORDER BY QTY DESC) AS RNK
	FROM (
		SELECT
			stockcode AS 판매번호
			, SUM(quantity) AS QTY
		FROM dataset3
		GROUP BY 1
		LIMIT 2
	) A
) A
WHERE RNK <= 2
;

-- (2) 가장 많이 판매된 2개 상품을 모두 구매한 구매자가 구매한 상품

SELECT * FROM dataset3;

SELECT * FROM dataset3 ORDER BY stockcode, customerid ;

CREATE TABLE BU_LIST AS
SELECT
	customerid
FROM dataset3
GROUP BY 1
-- '84077'에 해당하면 1이다. 아니면 0. 1일 시 TRUEM, 둘다 TRUE일 시 출력해라
HAVING MAX(CASE WHEN stockcode = '84077' THEN 1 ELSE 0 END) = 1 -- TRUE
	AND MAX(CASE WHEN stockcode = '85123A' THEN 1 ELSE 0 END) = 1 -- TRUE
;

SELECT * FROM bu_list;

SELECT *
FROM dataset3
-- 조건문: 'customerid'가 'bu_list' 테이블에 있는 'customerid'와 일치하는 행만 선택합니다.
WHERE customerid IN (SELECT customerid FROM bu_list)
-- 조건문: 'stockcode'가 '84077' 또는 '85123A'가 아닌 행만 선택합니다.
	AND stockcode NOT IN ('84077', '85123A')
;

SELECT customerid, stockcode, quantity
FROM dataset3
-- 조건문: 'customerid'가 'bu_list' 테이블에 있는 'customerid'와 일치하는 행만 선택합니다.
WHERE customerid IN (SELECT customerid FROM bu_list)
-- 조건문: 'stockcode'가 '84077' 또는 '85123A'가 아닌 행만 선택합니다.
	AND stockcode NOT IN ('84077', '85123A')
;

-- !! 국가별, 상품별 구매 지표 추출 !!
-- 200p
-- A 고객 2018년 구매, 2019년 구매,
-- B 고객 2018년 구매
-- C 고객 2017년 구매, 2019년 구매

-- 연도별 국가별 고객 재구매율을 계산하기 위한 쿼리
SELECT
    A.country, -- 국가
    SUBSTR(A.invoicedate, 1, 4) AS YY, -- 연도
    -- 전년도에 구매한 고객 수를 해당 연도의 고객 수로 나눈 재구매율 계산
    COUNT(DISTINCT B.customerid) / COUNT(DISTINCT A.customerid) AS R_Rate 
FROM (
    -- 국가, 송장 날짜, 고객 아이디의 고유한 조합을 선택
    SELECT
        DISTINCT country,
        invoicedate,
        customerid
    FROM dataset3
) A
-- 전년도와 해당 연도의 고객 아이디, 국가를 기반으로 조인
LEFT JOIN (
    -- 국가, 송장 날짜, 고객 아이디의 고유한 조합을 선택
    SELECT DISTINCT country, invoicedate, customerid 
    FROM dataset3
) B
ON SUBSTR(A.invoicedate, 1, 4) = SUBSTR(B.invoicedate, 1, 4) - 1
    AND A.country = B.country
    AND A.customerid = B.customerid
GROUP BY 1, 2 -- 국가와 연도별로 그룹화
ORDER BY 1, 2; -- 국가와 연도별로 정렬

-- 특정 상품 구매자가 구매한 다른 상품은?
-- 국가별 재구매율 계산

-- 코호트 분석 (Retention)
-- 디지털 마케팅: 코호트 분석(Retention) 정의, SQL 쿼리
-- Google Analytics 자동으로 만들어줌
-- 코흐트 분석을 통해 특정 기간에 구매한 또는 가입한 고객들의 이후 구매액 및 리텐션
-- GA / SQL, Python(R), 엑셀(스프레드시트)

SELECT
	customerid
    , MIN(invoicedate) AS MNDT
FROM dataset3
GROUP BY 1
;

SELECT * FROM dataset3;

-- 각 고객의 주문 일자, 구매액을 조회
SELECT
	customerid
    , invoiceno
    , invoicedate
    , unitprice * quantity AS Sales -- 구매금액(매출)
FROM dataset3
;

-- 첫 번째로 구매했던 고객별 첫 구매일 테이블에 고객의 구매 내역을 join 한다.

SELECT *
FROM (
	SELECT
		customerid
		, MIN(invoicedate) MNDT -- 최초 구매일자
		-- , MAX(invoicedate) MXDT -- 마지막 구매일자
	FROM dataset3
	GROUP BY 1
) A
LEFT
JOIN (SELECT
	customerid
	, invoicedate
	, unitprice * quantity AS Sales
	FROM dataset3
	) B
ON A.customerid = B.customerid 
;

-- P. 205
-- MNDT는 각 고객의 최초 구매월 의미
-- 몇 개월 후에 재 구매가 이루어졌는지 파악
-- TIMESTAMPDIFF(month/days, start, end)

SELECT
	SUBSTR(MNDT, 1, 7) MM
    , TIMESTAMPDIFF(month, MNDT, invoicedate) AS Datediff
    , COUNT(DISTINCT A.customerid) AS BU
    , SUM(SALES) AS SALES
FROM(
	SELECT
		customerid
		, MIN(invoicedate) MNDT -- 최초 구매일자
		-- , MAX(invoicedate) MXDT -- 마지막 구매일자
	FROM dataset3
	GROUP BY 1
	) A
	LEFT
	JOIN (SELECT
		customerid
		, invoicedate
		, unitprice * quantity AS SALES
		FROM dataset3
		) B
ON A.customerid = B.customerid 
GROUP BY MM, Datediff
;

-- 고객 Segment