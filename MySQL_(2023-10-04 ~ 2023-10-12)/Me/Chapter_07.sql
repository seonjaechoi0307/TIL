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

-- P. 206
USE mydata;

-- RFM : 가치있는 고객을 추론하는 방법론, 고객 세그먼트(Segment)
-- P. 207
-- R : 제일 최근에 구입한 시기
-- F : 어느 정도로 자주 구입했는가?
-- Monetary : 구입한 총 금액은 얼마인가?

-- Recency : 계산해보자, 거래의 최근성을 나타내는 지표
SELECT
	customerid
    -- 고객 별 가장 최근 거래일
    , MAX(invoiceDate) MXDT
FROM dataset3
GROUP BY 1
;

-- 2011-12-02 부터의 Timer Interval 계산                                                                                                                                                                        
SELECT
	customerid
    , datediff('2011-12-02', mxdt) AS RECENCY
FROM (
	SELECT
		customerid
		, MAX(invoiceDate) MXDT
	FROM dataset3
	GROUP BY 1
) A
;

-- Frequency, Monetary를 계산
SELECT
	customerid
    , COUNT(DISTINCT invoiceno) AS frequency
    , SUM(quantity * unitprice) AS monetary
FROM dataset3
GROUP BY 1
;

SELECT 
	customerid
    , datediff('2011-12-02', mxdt) RECENCY 
    , frequency
    , monetary
FROM (
	SELECT 
		customerid
		, MAX(invoiceDate) MXDT 
		, COUNT(DISTINCT invoiceno) AS frequency
		, SUM(quantity * unitprice) AS monetary 
	FROM dataset3
	GROUP BY 1
) A
;

-- RFM 정의(본인 취업 희망 산업군 별) 조사해서 블로그 정리

-- 재구매 Segment
-- 동일한 상품을 2개 연도에 걸쳐서 구매한 고객과 그렇지 않은 고객을 Segment로 나눔
-- 파생변수를 만드는 과정 중 하나 이 부분
-- 데이터가 없습니다 !! 기획력만 좋으면! 파생변수를 유도할 수 있음
-- 먼저 고객별, 상품별 구매 연도를 Unique하게 COUNT
SELECT
	customerid
    , stockcode
    , COUNT(DISTINCT SUBSTR(invoicedate, 1, 4)) AS UNIQUE_YY
FROM dataset3
GROUP BY 1, 2
;

-- unique_yy가 2이상인 고객과 그렇지 않은 고객을 구분한다.
SELECT
	customerid
    , MAX(unique_yy) AS mx_unique_yy
FROM (
	SELECT
		customerid
		, stockcode
		, COUNT(DISTINCT SUBSTR(invoicedate, 1, 4)) AS UNIQUE_YY
	FROM dataset3
	GROUP BY 1, 2 
) A
GROUP BY 1
ORDER BY 2 DESC
;

-- 문제 mx_unique_yy 2 이상이면  1, 그 외에는 0
-- CASE WHEN 사용해서 처리
SELECT
	customerid
    , (CASE WHEN MAX(unique_yy) >= 2 THEN 1 ELSE 0 END) AS R_Segment
FROM (
	SELECT
		customerid
		, stockcode
		, COUNT(DISTINCT SUBSTR(invoicedate, 1, 4)) AS UNIQUE_YY
	FROM dataset3
	GROUP BY 1, 2 
) A
GROUP BY 1
ORDER BY 2 DESC
;

SELECT
	customerid
    , CASE WHEN mx_unique_yy >= 2 THEN 1 ELSE 0 END AS R_Segment
FROM (
	SELECT
		customerid
		, MAX(unique_yy) AS mx_unique_yy
	FROM (
		SELECT
			customerid
			, stockcode
			, COUNT(DISTINCT SUBSTR(invoicedate, 1, 4)) AS UNIQUE_YY
		FROM dataset3
		GROUP BY 1, 2 
	) A
	GROUP BY 1
	ORDER BY 2 DESC
) A
;

-- 일자별 첫 구매자 수
-- 일자별 첫 구매자 수를 계산한다.
-- 예) 2006-01-01에 첫 구매한 고객수는 몇명인지
-- 신규 유저를 확인하는 것
-- 고객별 첫 구매일
SELECT
	customerid
    , MIN(invoicedate) AS MNDT
FROM dataset3
GROUP BY customerid
;

-- 일자별로 고객 수를 CNT 일자별 첫 구매 고객수를 계산할 수 있음
SELECT
	MNDT
    , COUNT(DISTINCT customerid) AS BU
FROM (
	SELECT
		customerid
		, MIN(invoicedate) AS MNDT
	FROM dataset3
    GROUP BY 1
) A
GROUP BY 1
;

-- 고객별 구매와 기준 순위 생성(랭크)
SELECT
	customerid
    , stockcode
    , MIN(invoicedate) AS MNDT
FROM dataset3
GROUP BY 1, 2
;

SELECT
	*,
    ROW_NUMBER() OVER(PARTITION BY customerid ORDER BY MNDT) AS RNK
FROM (
	SELECT
		customerid
		, stockcode
		, MIN(invoicedate) AS MNDT
	FROM dataset3
	GROUP BY 1, 2
) A
;

-- 고객별 첫 구매 내역 조회
SELECT
	*
FROM (
	SELECT
		*,
		ROW_NUMBER() OVER(PARTITION BY customerid ORDER BY MNDT) AS RNK
	FROM (
		SELECT
			customerid
			, stockcode
			, MIN(invoicedate) AS MNDT
		FROM dataset3
		GROUP BY 1, 2
	) A
) A
WHERE RNK = 1
;

-- 상품별 첫 구매 고객 수 집계
SELECT
	stockcode
    , COUNT(DISTINCT customerid) AS FIRST_BU
FROM (
	SELECT
		*
	FROM (
		SELECT
			*,
			ROW_NUMBER() OVER(PARTITION BY customerid ORDER BY MNDT) AS RNK
		FROM (
			SELECT
				customerid
				, stockcode
				, MIN(invoicedate) AS MNDT
			FROM dataset3
			GROUP BY 1, 2
		) A
	) A
	WHERE RNK = 1
) A
GROUP BY stockcode
ORDER BY FIRST_BU DESC
;

-- 219p Bounce Rate
-- 첫 구매 후 이탈하는 고객의 비중
-- 첫 구매 고객의 이탈율 계산
-- 고객 별로 구매일자의 중복 제거 하고 CNT

SELECT
	customerid
    , COUNT(DISTINCT invoicedate) F_DATE
FROM dataset3
GROUP BY 1
;

-- 숫자 1의 의미는 첫 구매 후 이탈한 고객이 됨
SELECT
	SUM(CASE WHEN F_DATE = 1 THEN 1 ELSE 0 END) / SUM(1) AS BOUNC_RATE
FROM (
	SELECT
		customerid
		, COUNT(DISTINCT invoicedate) F_DATE
	FROM dataset3
	GROUP BY 1
) A
;

-- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- 
-- 고객별 국가별 구매일 CNT
SELECT
	customerid
    , country
    , COUNT(DISTINCT invoicedate) AS F_DATE
FROM dataset3
GROUP BY 1, 2
;

-- 국가별 고객 이탈율 계산하기
SELECT
	country
    , SUM(CASE WHEN F_DATE = 1 THEN 1 ELSE 0 END) / SUM(1) AS BOUNC_RATE
FROM (
	SELECT
		customerid
		, country
		, COUNT(DISTINCT invoicedate) AS F_DATE
	FROM dataset3
	GROUP BY 1, 2
) A
GROUP BY 1
ORDER BY 1
;

-- 판매 수량이 20% 이상 증가한 상품 리스트(YTD)
-- 해당 데이터 세트의 판매 기간은 2010~2011년으로 구성되어 있다.
SELECT DISTINCT SUBSTR(invoicedate, 1, 4) AS YY
FROM dataset3;

-- 2011년도 상품별 판매 수량
SELECT
	stockcode
    , SUM(quantity) AS QTY
FROM dataset3
WHERE SUBSTR(invoicedate,1 ,4) = '2011'
GROUP BY 1
;

-- 2010년도 상품별 판매 수량
SELECT
	stockcode
    , SUM(quantity) AS QTY
FROM dataset3
WHERE SUBSTR(invoicedate,1 ,4) = '2010'
GROUP BY 1
;

-- 2011년도 상품별 판매 수량 테이블에 2010년도 상품별 판매 수량 테이블을 결합
SELECT *
FROM (
	SELECT
		stockcode
		, SUM(quantity) AS QTY
	FROM dataset3
	WHERE SUBSTR(invoicedate,1 ,4) = '2011'
	GROUP BY 1
) A
LEFT
JOIN
(
SELECT
	stockcode
    , SUM(quantity) AS QTY
FROM dataset3
WHERE SUBSTR(invoicedate,1 ,4) = '2010'
GROUP BY 1
) B
ON A.stockcode = B.stockcode
;

-- 출력 내용 정리: 두 년도의 판매수량을 구하여 작년 대비 증가율을 계산하자
SELECT
	A.stockcode
    , A.QTY AS QTY_2011
    , B.QTY AS QTY_2010
    , A.QTY/B.QTY-1 AS QTY_INCREASE_RATE
FROM (
	SELECT
		stockcode
		, SUM(quantity) AS QTY
	FROM dataset3
	WHERE SUBSTR(invoicedate,1 ,4) = '2011'
	GROUP BY 1
) A
LEFT
JOIN
(
SELECT
	stockcode
    , SUM(quantity) AS QTY
FROM dataset3
WHERE SUBSTR(invoicedate,1 ,4) = '2010'
GROUP BY 1
) B
ON A.stockcode = B.stockcode
;

-- 2010년 대비 2011년 증가율(QTY_INCREASE_RATE)이 0.2 이상인 경우를 조건으로 생성하기
SELECT *
FROM (
	SELECT
		A.stockcode
		, A.QTY AS QTY_2011
		, B.QTY AS QTY_2010
		, A.QTY/B.QTY-1 AS QTY_INCREASE_RATE
	FROM (
		SELECT
			stockcode
			, SUM(quantity) AS QTY
		FROM dataset3
		WHERE SUBSTR(invoicedate,1 ,4) = '2011'
		GROUP BY 1
	) A
	LEFT
	JOIN
	(
	SELECT
		stockcode
		, SUM(quantity) AS QTY
	FROM dataset3
	WHERE SUBSTR(invoicedate,1 ,4) = '2010'
	GROUP BY 1
	) B
	ON A.stockcode = B.stockcode
) B
WHERE QTY_INCREASE_RATE >= 1.2
;

-- 주차별 매출액
-- 주차별 지표들을 계산하는 법을 익혀보자
-- WEEKOFYEAR : 일자의 주차를 숫자로 반환한다.
-- SELECT WEEKOFYEAR('2017-01-01')

SELECT WEEKOFYEAR('2018-01-01');

SELECT * FROM dataset3;

-- 2011년 주차별 매출액 계산하기
SELECT
	WEEKOFYEAR(invoicedate) AS WK
    , SUM(quantity*unitprice) AS SALES
FROM dataset3
WHERE SUBSTR(invoicedate, 1, 4) = '2011'
GROUP BY 1
ORDER BY 1
;

-- 최초 구매가 2011년이면 신규 고객, 2010년이면 기존 고객으로 분류하자
SELECT
	CASE WHEN SUBSTR(MNDT, 1, 4) = '2011' THEN 'NEW' ELSE 'EXI' END NEW_EXI
    , customerid
FROM (
	SELECT
		customerid
        , MIN(invoicedate) AS MNDT
	FROM dataset3
    GROUP BY 1
) A
;

-- 각 고객을 신규, 기존으로 구분한 테이블을 매출 테이블에 JOIN 하기
SELECT
	A.customerid
    , B.new_exi
    , A.invoicedate
    , A.unitprice
    , A.quantity
FROM dataset3 A
LEFT
JOIN (
	SELECT
		CASE WHEN SUBSTR(MNDT, 1, 4) = '2011' THEN 'NEW' ELSE 'EXI' END NEW_EXI
		, customerid
	FROM (
		SELECT
			customerid
			, MIN(invoicedate) AS MNDT
		FROM dataset3
		GROUP BY 1
	) A
) B
ON A.customerid = B.customerid
WHERE SUBSTR(A.invoicedate, 1, 4) = '2011'
;

-- JOIN 한 결과를 신규/기존으로 구분해 매출 집계하기
SELECT
	B.new_exi
    , SUBSTR(A.invoicedate, 1, 7) AS MM
    , ROUND(SUM(A.unitprice * A.quantity), 2) AS SALES
FROM dataset3 A
LEFT
JOIN (
	SELECT
		CASE WHEN SUBSTR(MNDT, 1, 4) = '2011' THEN 'NEW' ELSE 'EXI' END NEW_EXI
		, customerid
	FROM (
		SELECT
			customerid
			, MIN(invoicedate) AS MNDT
		FROM dataset3
		GROUP BY 1
	) A
) B
ON A.customerid = B.customerid
WHERE SUBSTR(A.invoicedate, 1, 4) = '2011'
GROUP BY 1, 2
;

-- 기존 고객의 2011년 월 누적 리텐션
-- 기존 고객(최초 구매 연도가 2010년인 고객) 리스트 만들기
SELECT customerid
FROM dataset3
GROUP BY 1
HAVING MIN(SUBSTR(invoicedate,1 ,4)) = '2010'
;

-- 기존 고객들의 2011년 구매 내역을 조회해 보자
SELECT *
FROM dataset3
WHERE CUSTOMERID IN (
	SELECT customerid
	FROM dataset3
	GROUP BY 1
	HAVING MIN(SUBSTR(invoicedate,1 ,4)) = '2010'
)
AND SUBSTR(invoicedate, 1, 4) = '2011'
;

-- 해당 쿼리는 2010년에 구매한 고객들 중에서 2011년의 첫 구매 월을 찾는 것을 목적으로 합니다.
-- 주요 필드를 선택: 고객 ID와 2011년 첫 구매 월
SELECT
    customerid,
    MIN(SUBSTR(invoicedate, 1, 7)) AS MM
FROM dataset3

-- 2010년에 구매한 고객의 목록을 서브쿼리를 통해 필터링
WHERE customerid IN (
    -- 2010년에 구매한 고객의 목록을 가져오는 서브쿼리
    SELECT DISTINCT customerid
    FROM dataset3
    WHERE SUBSTR(invoicedate, 1, 4) = '2010'
)

-- 2011년의 구매 데이터만을 대상으로 함
AND SUBSTR(invoicedate, 1, 4) = '2011'

-- 고객 ID를 기준으로 그룹화하고, 각 고객별로 가장 빠른 구매 월을 찾음
GROUP BY customerid
;

-- 첫구매 월 기준으로 집계 및 오름차순 정렬
SELECT
	MM
    , COUNT(customerid) AS N_customerid
FROM (
	SELECT
		customerid,
		MIN(SUBSTR(invoicedate, 1, 7)) AS MM
	FROM dataset3

	WHERE customerid IN (
		-- 2010년에 구매한 고객의 목록을 가져오는 서브쿼리
		SELECT DISTINCT customerid
		FROM dataset3
		WHERE SUBSTR(invoicedate, 1, 4) = '2010'
	)
	AND SUBSTR(invoicedate, 1, 4) = '2011'
	GROUP BY customerid
) A
GROUP BY MM
ORDER BY MM
;

-- 기존 고객의 수 합계 구하기
SELECT COUNT(*) AS N_CUSTOMERS
FROM (
	SELECT customerid
    FROM dataset3
    GROUP BY 1
    HAVING MIN(SUBSTR(invoicedate, 1, 4)) = '2010'
) A
;

-- 첫 구매 월 기준으로 집계 및 오름차순 정렬
WITH MonthlyCustomers AS (
    SELECT
        MM,
        COUNT(customerid) AS N_customerid
    FROM (
        SELECT
            customerid,
            MIN(SUBSTR(invoicedate, 1, 7)) AS MM
        FROM dataset3
        WHERE customerid IN (
            -- 2010년에 구매한 고객의 목록을 가져오는 서브쿼리
            SELECT DISTINCT customerid
            FROM dataset3
            WHERE SUBSTR(invoicedate, 1, 4) = '2010'
        )
        AND SUBSTR(invoicedate, 1, 4) = '2011'
        GROUP BY customerid
    ) A
    GROUP BY MM
)
, TotalCustomers AS(
	SELECT COUNT(DISTINCT customerid) AS Total_N_cus
    FROM dataset3
    WHERE SUBSTR(invoicedate, 1, 4) = '2010'
)

SELECT
    MM,
    N_customerid,
    SUM(N_customerid) OVER (ORDER BY MM ASC) AS `누적 기존 고객 수`,
    ROUND((SUM(N_customerid) OVER (ORDER BY MM ASC) / Total_N_cus) * 100, 2) AS 누적리텐션
FROM MonthlyCustomers, TotalCustomers
ORDER BY MM;

-- Retention Rate는 2010년 구매자 중 2011년에 구매한 고객의 비율로 계산할 수 있다.
-- 결과 : 2010년 구매자 중 2011년에도 구매한 구매 고객 비율은 35.09% 입니다.
SELECT
	COUNT(B.customerid) / COUNT(A.customerid) AS Retention_Rate
FROM (
	SELECT DISTINCT customerid
    FROM dataset3
    WHERE SUBSTR(invoicedate, 1, 4) = '2010'
) A
LEFT
JOIN (
SELECT DISTINCT customerid
FROM dataset3
WHERE SUBSTR(invoicedate, 1, 4) = '2011'
) B
ON A.customerid = B.customerid
;


-- AMV는 전체 매출을 구매자 수로 나누어 계산합니다.
-- 결과: AMV는 약 690으로 평균 690의 금액을 지출한다는 의미
SELECT SUM(unitprice * quantity) / COUNT(DISTINCT customerid) AS AMV
FROM dataset3
WHERE SUBSTR(invoicedate, 1, 4) = '2011'
;

-- 2011년도 구매자 수를 계산하여 예상 구매자 수를 파악해보자
-- 결과: N_BU = 765 = 2011년 총 구매자 수는 765명 이다.
SELECT COUNT(DISTINCT customerid) AS N_BU
FROM dataset3
WHERE SUBSTR(invoicedate, 1, 4) = '2011'
;

-- 2011년도 기준으로 총 매출액 계산하기
-- 결과: Sales_2011 = 528535.41000000198 = 2011년 매출액은 528535.41000000198 이다.
SELECT SUM(unitprice * quantity) AS Sales_2011
FROM dataset3
WHERE SUBSTR(invoicedate, 1, 4) = '2011'
;

-- LTV = 2011년 구매자의 가치 계산 방법
-- 매출액 + 구매자
-- PCF2012 = a potential customer for 2012 = 2012년 잠재 구매고객
-- PRF2012 = potential revenue for 2012 = 2012년 잠재 매출액
-- CVF2011 = Customer Value for 2011 = 2011년 고객의 가치 = 인당 933의 가치
SELECT
	*
    , ROUND(Sales_2011 + PRF2012, 2) AS LTV
    , ROUND((Sales_2011 + PRF2012) / N_BU, 2) AS CVF2011
FROM (
	SELECT
		*
		, ROUND(PCF2012 * AMV, 2) AS PRF2012
	FROM(
		SELECT
			COUNT(DISTINCT customerid) AS N_BU
			, ROUND(SUM(unitprice * quantity), 2) AS Sales_2011
			, ROUND(COUNT(DISTINCT customerid) * 0.3509, 2) AS PCF2012
			, ROUND(SUM(unitprice * quantity) / COUNT(DISTINCT customerid), 2) AS AMV
		FROM dataset3
		WHERE SUBSTR(invoicedate, 1, 4) = '2011'
	) A
) B
;



-- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- -- (예습) -- 

-- 4교시 : 오전 3교시 배운 내용 복습, 블로그에 잘 정리 !
-- 오후에는 PostgreSQL 설치 진행합니다. (이력서 기재용 !)
-- 8교시 : 블로그 초안 포함 링크 공유 (전원 필히 해주세요!) 5:30분에 모두 제출 요망
