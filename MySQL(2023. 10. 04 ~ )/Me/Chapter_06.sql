USE instacart;

-- 상품 카테고리
SELECT * FROM aisles;
SELECT * FROM departments;

-- 주문번호 상세내역
SELECT * FROM order_products__prior;

-- 주문 대표번호
SELECT * FROM orders;

-- 상품 정보
SELECT * FROM products;

-- p. 158
-- 지표 추출 : 일반적인 마케팅 관련된 내용
-- 전체 주문건수
SELECT
	COUNT(DISTINCT order_id),
	COUNT(DISTINCT user_id)
FROM orders
;

-- 상품별 주문 건수
-- 주문번호와 상품명이 같이 사용하려면
-- order_products__prior와 products 조인 해야함
SELECT
	*
FROM order_products__prior A
LEFT
JOIN products B
ON A.product_id = B.product_id
;

-- 제품별 주문건수
SELECT
	B.product_name
    -- 주문번호 중복제거
    , COUNT(DISTINCT A.order_id) F
FROM order_products__prior A
LEFT
JOIN products B
ON A.product_id = B.product_id
GROUP BY 1
ORDER BY 2 DESC
;

-- 장바구니에 가장 먼저 넣는 상품 10개
SELECT * FROM order_products__prior;

-- 첫번쨰로 담기는 주문건은 1, 그 외에는 0으로 표시
SELECT
	product_id
    , CASE WHEN add_to_cart_order = 1 THEN 1 ELSE 0 END F_1st
FROM order_products__prior
;

-- 첫번쨰로 가장 많이 담기는 product_id 상위 10개를 추출하자
SELECT
	*
    , RANK() OVER(ORDER BY F_1st DESC) AS RNK
FROM(
SELECT
	product_id
		, COUNT(CASE WHEN add_to_cart_order = 1 THEN 1 ELSE NULL END) F_1st
	FROM order_products__prior
	GROUP BY 1
) A
ORDER BY 2 DESC
LIMIT 10
;

SELECT
	*
    , ROW_NUMBER() OVER(ORDER BY F_1st DESC) AS RNK
FROM(
SELECT
	product_id
	, SUM(CASE WHEN add_to_cart_order = 1 THEN 1 ELSE 0 END) F_1st
	FROM order_products__prior
	GROUP BY 1
) A
LIMIT 10
;

-- 쿼리의 순서 FROM >> WHERE >> GROUP BY >> HAVING >> SELECT >> ORDER BY

SELECT * 
FROM (
    SELECT
        product_id,
        SUM(CASE WHEN add_to_cart_order = 1 THEN 1 ELSE 0 END) AS F_1st,
        ROW_NUMBER() OVER(ORDER BY SUM(CASE WHEN add_to_cart_order = 1 THEN 1 ELSE 0 END) DESC) AS RNK
    FROM order_products__prior
    GROUP BY product_id
) A
WHERE RNK <= 10;

SELECT
	*
FROM(
SELECT
	*
    , ROW_NUMBER() OVER(ORDER BY F_1st DESC) AS RNK
FROM(
	SELECT
		product_id
		, SUM(CASE WHEN add_to_cart_order = 1 THEN 1 ELSE 0 END) F_1st
		FROM order_products__prior
		GROUP BY 1
	) BASE
) BASE2
WHERE RNK BETWEEN 1 AND 10
;

-- 시간별 주문 건수 파악하기
SELECT * FROM orders;

SELECT
	-- 시간대 별 주문 건수
	order_hour_of_day
    , COUNT(DISTINCT order_id) F
FROM orders
GROUP BY 1
ORDER BY 1
;

-- 첫 구매 후 다음 구매까지 걸린 평균 일수
-- days_since_prior_order == 이전 구매일 대비 현재 구매일까지 걸린 일수
SELECT * FROM orders;
-- order_number 2인 의미 파악

SELECT
	AVG(days_since_prior_order) AS AVG_RECENCY
FROM orders
WHERE order_number = 2
;

-- 주문 건당 평균 구매 상품 수(UPT, Uni Per Transaction)
SELECT
	COUNT(product_id) / COUNT(DISTINCT order_id) AS UPT
FROM order_products__prior
;

-- 인당 평균 주문 건수 : 전체 주문 건수를 구매자 수로 나누어서 계산
SELECT
	COUNT(DISTINCT order_id) / Count(DISTINCT user_id) AS AVG_OPU
FROM orders
;

-- 재구매율이 가장 높은 상품 10개
-- P. 169
-- 상품별로 재구매율을 계산한 뒤
-- 재 구매율을 기준으로 랭크를 계산함 (서브쿼리, Windows Function)
-- Rank 값으로 1-10 조건 / LIMIT

-- reordered = 1 = 재구매함 // 0 = 재구매 안함

SELECT * FROM order_products__prior;

-- product_id / RET_RATIO / RNK
-- 상품별 재구매율 계산

SELECT
	product_id
	, SUM(reordered) / Count(*) AS RET_RATIO
FROM order_products__prior
GROUP BY 1
;


-- 재구매율로 랭크(순위) 열 생성하기
SELECT
	*
    , ROW_NUMBER() OVER(ORDER BY RET_RATIO DESC) AS RNK
FROM(
	SELECT
		product_id
		, SUM(reordered) / Count(*) AS RET_RATIO
	FROM order_products__prior
	GROUP BY 1
) A
;

-- 외부 쿼리 없이 작성하기 & 상위 10개 출력하기
SELECT
	*
FROM(
	SELECT
		product_id,
		SUM(reordered) / Count(*) AS RET_RATIO,
        -- 재구매 건수 / 총 구매 건수 비율을 랭킹화
		ROW_NUMBER() OVER(ORDER BY SUM(reordered) / Count(*) DESC) AS RNK
	FROM order_products__prior
	GROUP BY product_id
) A
WHERE RNK <= 10
;

-- 재구매율로 랭크(순위) 열 생성하기 
SELECT 
	*
    , ROW_NUMBER() OVER(ORDER BY RET_RATIO DESC) RNK
FROM (
	SELECT 
		product_id
		, SUM(reordered) / COUNT(*) AS RET_RATIO
	FROM
		order_products__prior
	GROUP BY 1
) A 
WHERE product_id IN (
SELECT product_id 
	FROM (
		SELECT 
			product_id
            -- 제품번호 별 재구매 횟수 합계
			, SUM(reordered) AS 합계
		FROM
			order_products__prior
		GROUP BY 1 
	) A
	WHERE 합계 >= 50
)
;

SELECT
	product_id 
    , 합계
FROM (
	SELECT 
		product_id
        -- 제품번호 별 재구매 횟수 합계
		, SUM(reordered) AS 합계
	FROM
		order_products__prior
	GROUP BY 1 
) A
WHERE 합계 >= 50
;

-- Department 별 재구매율이 가장 높은
-- order_products__prior <-> products <-> departments
SELECT
	A.product_id
    , SUM(reordered) / COUNT(*) AS RET_RATIO
FROM order_products__prior A
LEFT
JOIN products B
ON A.product_id = B.product_id
GROUP BY 1
;

-- Department별 재 구매율 및 순위 구하기
SELECT
	*
    , ROW_NUMBER() OVER(PARTITION BY department ORDER BY RET_RATIO DESC) AS RNK
FROM(
	SELECT
		department
		, A.product_id
		, SUM(reordered) / COUNT(*) AS RET_RATIO
	FROM order_products__prior A
	LEFT
	JOIN products B
	ON A.product_id = B.product_id
	LEFT
	JOIN departments C
	ON B.department_id = C.department_id
	GROUP BY 1, 2
) A
;

-- WHERE 서브 쿼리 추가
SELECT
	*
    , ROW_NUMBER() OVER(PARTITION BY department ORDER BY RET_RATIO DESC) AS RNK
FROM(
	SELECT
		department
		, A.product_id
		, SUM(reordered) / COUNT(*) AS RET_RATIO
	FROM order_products__prior A
	LEFT
	JOIN products B
	ON A.product_id = B.product_id
	LEFT
	JOIN departments C
	ON B.department_id = C.department_id
	GROUP BY 1, 2
) A
-- 조건문 해석 : 제품번호 별 재구매 횟수가 10개가 넘는것만 데이터를 출력해라
WHERE product_id IN(
	SELECT
		product_id 
	FROM (
		SELECT 
			product_id
			-- 제품번호 별 재구매 횟수 합계
			, SUM(reordered) AS 합계
		FROM
			order_products__prior
		GROUP BY 1 
	) A
	WHERE 합계 >= 10
)
;

SELECT
	product_id 
FROM (
	SELECT 
		product_id
        -- 제품번호 별 재구매 횟수 합계
		, SUM(reordered) AS 합계
	FROM
		order_products__prior
	GROUP BY 1 
) A
WHERE 합계 >= 10
;

-- Department별 재 구매율 및 Top 10 순위 구하기
SELECT
	*
FROM(
	SELECT
		*
		, ROW_NUMBER() OVER(ORDER BY RET_RATIO DESC) AS RNK
	FROM(
		SELECT
			department
			, A.product_id
			, SUM(reordered) / COUNT(*) AS RET_RATIO
		FROM order_products__prior A
		LEFT
		JOIN products B
		ON A.product_id = B.product_id
		LEFT
		JOIN departments C
		ON B.department_id = C.department_id
		GROUP BY 1, 2
	) A
) B
WHERE RNK BETWEEN 1 AND 10
;

-- P. 174 구매자 분석 2023. 10. 11
USE instacart;

SELECT * FROM orders;

SELECT
	user_id
    -- 사용자 별 주문 횟수 구하기
    , COUNT(DISTINCT order_id) AS F
FROM
	orders
GROUP BY 1;

SELECT
	*
    , RANK() OVER(ORDER BY F DESC) AS RNK
FROM(
	SELECT
		user_id
		, COUNT(DISTINCT order_id) AS F
	FROM
		orders
	GROUP BY 1
) A
;

-- 총 사용자 수 구하기
SELECT COUNT(DISTINCT user_id)
FROM(
	SELECT
		user_id
		, COUNT(DISTINCT order_id) AS F
	FROM
		orders
	GROUP BY 1
) A
;

-- 10분위 수 지정
SELECT
	*,
    CASE WHEN RNK BETWEEN 1 AND 316 THEN 'Quantile_1'
    WHEN RNK BETWEEN 317 AND 632 THEN 'Quantile_2' 
    WHEN RNK BETWEEN 633 AND 948 THEN 'Quantile_3' 
    WHEN RNK BETWEEN 949 AND 1264 THEN 'Quantile_4' 
    WHEN RNK BETWEEN 1265 AND 1580 THEN 'Quantile_5' 
    WHEN RNK BETWEEN 1581 AND 1895 THEN 'Quantile_6' 
    WHEN RNK BETWEEN 1896 AND 2211 THEN 'Quantile_7' 
    WHEN RNK BETWEEN 2212 AND 2527 THEN 'Quantile_8' 
    WHEN RNK BETWEEN 2528 AND 2843 THEN 'Quantile_9' 
    WHEN RNK BETWEEN 2844 AND 3159 THEN 'Quantile_10' END quantile
FROM(
	SELECT
		*
		, ROW_NUMBER() OVER(ORDER BY F DESC) AS RNK
	FROM(
		SELECT
			user_id
			, COUNT(DISTINCT order_id) AS F
		FROM
			orders
		GROUP BY 1
	) A
) B
;

-- 177~178 의 가장 큰 단점 = 상수로 처리하기에 코드 자동화가 안됨
SELECT 
	*, 
    CASE WHEN RNK <= (SELECT COUNT(DISTINCT user_id)
						FROM 
							(SELECT 
								user_id
								, COUNT(DISTINCT order_id) F 
							 FROM orders
							 GROUP BY 1
							) A
					  ) / 10 THEN 'Quantile_1' 
        WHEN RNK <= ((SELECT COUNT(DISTINCT user_id)
						FROM 
							(SELECT 
								user_id
								, COUNT(DISTINCT order_id) F 
							 FROM orders
							 GROUP BY 1
							) A
					  ) / 10) * 2 THEN 'Quantile_2' 
END quantile
FROM (
	SELECT 
		*
		, ROW_NUMBER() OVER(ORDER BY F DESC) RNK
	FROM (
		SELECT 
			user_id
			, COUNT(DISTINCT order_id) AS F
		FROM 
			orders
		GROUP BY 1
	) A
) A 
;

-- 서브쿼리
-- FROM, WHERE, SELECT

-- From Chat GPT 4
-- RankedOrders: 각 사용자별로 주문 횟수를 계산하고, 주문 횟수에 따라 순위를 매깁니다.
WITH RankedOrders AS (
    SELECT
        user_id -- 사용자 ID
        , COUNT(DISTINCT order_id) AS F -- 각 사용자별 고유 주문 횟수
        , ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_id) DESC) AS RNK  -- 주문 횟수에 따라 내림차순으로 순위를 매김
	
    -- orders 테이블에서 데이터를 가져옴
    FROM orders  
    
    -- 사용자 ID 별로 그룹화
    GROUP BY user_id  
),

-- Quantiles: RankedOrders 결과를 기반으로 데이터를 10개의 동일한 크기의 구간으로 나눕니다 (10분위 수 생성).
Quantiles AS (
    SELECT
        *
        -- 10분위 수를 생성하기 위해 NTILE 함수 사용
        , NTILE(10) OVER(ORDER BY F DESC) AS Quantile
        
	-- RankedOrders CTE 결과를 가져옴
    FROM RankedOrders  
)

-- 최종 결과 선택: 사용자 ID, 주문 횟수, 순위, 그리고 해당하는 10분위 수 레이블을 출력합니다.
SELECT 
    *
    -- 10분위 수 값을 'Quantile_x' 형태의 문자열로 변환
    , CONCAT('Quantile_', Quantile) AS Quantile_Label  
    
-- Quantiles CTE 결과를 가져옴
FROM Quantiles;  

DROP TABLE user_quantile;

CREATE TEMPORARY TABLE user_quantile
SELECT
	*,
    CASE WHEN RNK BETWEEN 1 AND 316 THEN 'Quantile_1'
    WHEN RNK BETWEEN 317 AND 632 THEN 'Quantile_2' 
    WHEN RNK BETWEEN 633 AND 948 THEN 'Quantile_3' 
    WHEN RNK BETWEEN 949 AND 1264 THEN 'Quantile_4' 
    WHEN RNK BETWEEN 1265 AND 1580 THEN 'Quantile_5' 
    WHEN RNK BETWEEN 1581 AND 1895 THEN 'Quantile_6' 
    WHEN RNK BETWEEN 1896 AND 2211 THEN 'Quantile_7' 
    WHEN RNK BETWEEN 2212 AND 2527 THEN 'Quantile_8' 
    WHEN RNK BETWEEN 2528 AND 2843 THEN 'Quantile_9' 
    WHEN RNK BETWEEN 2844 AND 3159 THEN 'Quantile_10' END quantile
FROM(
	SELECT
		*
		, ROW_NUMBER() OVER(ORDER BY F DESC) AS RNK
	FROM(
		SELECT
			user_id
			, COUNT(DISTINCT order_id) AS F
		FROM
			orders
		GROUP BY 1
	) A
) B
;

SELECT *
FROM user_quantile;

-- 서브쿼리
-- FROM, WHERE, SELECT
-- 각 분위수별 전체 주문 건수의 합을 구한다.

SELECT
	quantile
    , SUM(F)
FROM user_quantile
GROUP BY 1
;

SELECT SUM(F) FROM user_quantile;

SELECT
	quantile AS 분위수
    , SUM(F) AS 주문건수
    , SUM(F) / 3220 AS 비율
FROM user_quantile
GROUP BY 1
;

-- P. 181
-- 재구매 / 재방문 비중이 높은 상품을 찾아본다!
-- 테이블 : order_products__prior

SELECT
	A.product_id
    -- 재방문율을 소수점 둘째 자리까지만 표현
    , ROUND(SUM(reordered) / SUM(1), 2) AS reorder_rate
    -- 구매 횟수
    , COUNT(DISTINCT order_id) AS F
FROM order_products__prior A
LEFT
JOIN products B
ON A.product_id = B.product_id
GROUP BY product_id
HAVING COUNT(DISTINCT order_id) > 10
;

-- p. 183
-- SELECT문에서 새롭게 생성한 컬럼에 조건을 걸 때
-- 새롭게 생성한 컬럼을 WHERE절에 사용하는 실수
-- 쿼리 순서(중요 !!!) : FROM >> WHERE >> GROUP BY >> HAVING >> SELECT >> ORDER BY

SELECT
	A.product_id
    , B.product_name
    -- 재방문율을 소수점 둘째 자리까지만 표현
    , ROUND(SUM(reordered) / SUM(1), 2) AS reorder_rate
    -- 구매 횟수
    , COUNT(DISTINCT order_id) AS F
FROM order_products__prior A
-- order_products__prior A 와 products B를 조인
LEFT
JOIN products B
-- LEFT JOIN 조건 A와 B의 공통 컬럼인 product_id를 기준으로 조인
ON A.product_id = B.product_id
GROUP BY A.product_id, B.product_name
HAVING COUNT(DISTINCT order_id) > 10
ORDER BY reorder_rate DESC
;

-- 다음 구매까지의 소요 기간과 재구매 관계
-- 고객이 자주 재구매하는 상품 vs 그렇지 않은 상품보다 일정한 주기를 가질 것이다.
-- 가정을 세우고 수치를 살펴보자
-- 기초 통계로 적용하면?
CREATE TEMPORARY TABLE product_repurchase_quantile AS
SELECT
	A.product_id,
    CASE WHEN RNK <= 929 THEN 'Q_1'
    WHEN RNK <= 1858 THEN 'Q_2'
    WHEN RNK <= 2786 THEN 'Q_3'
    WHEN RNK <= 3715 THEN 'Q_4'
    WHEN RNK <= 4644 THEN 'Q_5'
    WHEN RNK <= 5573 THEN 'Q_6'
    WHEN RNK <= 6502 THEN 'Q_7'
    WHEN RNK <= 7430 THEN 'Q_8'
    WHEN RNK <= 8359 THEN 'Q_9'
    WHEN RNK <= 9288 THEN 'Q_10' END RNK_GRP
FROM (
	SELECT
		*
		, ROW_NUMBER() OVER(ORDER BY RET_RATIO DESC) AS RNK
	FROM (
		SELECT
			product_id
			, SUM(reordered) / COUNT(*) AS RET_RATIO
		FROM order_products__prior
		GROUP BY 1
	) A
) A
GROUP BY 1, 2
;

SELECT * FROM product_repurchase_quantile;

-- P. 188
-- 각 분위 수별 재구매 소요 기간의 분산을 구하려면 다음과 같은 정보를 결합해 구해야 함
-- 상품별 분위 수 테이블
-- 주문 소요 시간 : orders 테이블
-- 주문 번호 상품번호 : order_products__prior

CREATE TEMPORARY TABLE order_products__pior2 AS
SELECT
	product_id
    , days_since_prior_order
FROM order_products__prior A
INNER --
JOIN orders B
ON A.order_id = B.order_id
;

-- 32290개
SELECT COUNT(*) FROM order_products__prior;

-- 30121개
SELECT COUNT(*) FROM order_products__pior2;

-- 분위수, 상품별 구매 소요 기간의 분산 계산
SELECT
	A.rnk_grp
    , A.product_id
    -- VARIANCE 함수는 주어진 집합의 분산을 계산합니다. 
    -- 여기에서는 상품별 구매 소요 기간(days_since_prior_order)의 분산을 계산합니다.
    -- 분산은 데이터가 평균으로부터 얼마나 퍼져 있는지를 나타내는 측정치입니다.
    -- 값이 높을수록 분산도 높음, 낮을 수록 분산도 낮음
    , VARIANCE(days_since_prior_order) AS var_days
FROM product_repurchase_quantile A
LEFT
JOIN order_products__pior2 B
ON A.product_id = B.product_id
GROUP BY 1, 2
ORDER BY 1
;

-- 가정 : 재구매율이 높은 상품군은 구매 주기가 일정할 것이다!
-- 재구매율에 따라 상품을 10가지 그룹으로 분할 했고, 각 분위 수의 상품별 구매 소요 기간의 분산을
-- median 함수를 이용하겠다! (문제: mysql은 제공하지 않음)

-- 1) SQL에 함수가 존재하지 않음 ===> 사용자 정의 함수 (PL/SQL)
-- 2) Python 또는 R이랑 연동을 해서, DB에서 Python으로 데이터를 가져와서 통계 처리

SELECT RNK_GRP,
AVG(VAR_DAYS) AVG_VAR_DAYS
FROM
(SELECT A.RNK_GRP,
A.PRODUCT_ID,
VARIANCE(days_since_prior_order) VAR_DAYS
FROM PRODUCT_REPURCHASE_QUANTILE A
LEFT
JOIN INSTACART.ORDER_PRODUCTS__PRIOR B
ON A.PRODUCT_ID = B.PRODUCT_ID
LEFT
JOIN INSTACART.ORDERS C
ON B.ORDER_ID = C.ORDER_ID
GROUP
BY 1,2) A
GROUP
BY 1
ORDER
BY 1
;

-- 분산분석
-- 3개 이상의 그룹 비교
-- p.value 0.05 이하일 시(유의할 시) ==> 대립가설 채택
-- 사후분석 ==> 두개 그룹으로 쪼개서, 두 그룹간의 평균 비교
-- Q_1, vs Q_2 , Q_3 ... Q_10 비교
-- Q_2, vs Q_3, Q_4 ... Q_10 비교
-- ...
-- Q_9 vs Q_10