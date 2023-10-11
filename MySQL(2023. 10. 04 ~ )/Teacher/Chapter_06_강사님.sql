USE instacart;

SELECT * FROM aisles; -- 상품 카테고리
SELECT * FROM departments; -- 상품 카테고리
SELECT * FROM order_products__prior; -- 주문 번호의 상세 내역
SELECT * FROM orders; -- 주문 대표 정보 
SELECT * FROM products; -- 상품 정보

-- p158
-- 지표 추출 : 일반적인 마케팅 관련된 내용 

SELECT * FROM orders;

-- 전체 주문건수
SELECT 
	COUNT(DISTINCT order_id) 
	, COUNT(DISTINCT user_id) 
FROM orders
;

-- 상품별 주문 건수 
-- 주문번호와 상품명이 같이 사용하려면
-- order_products__prior와 products 조인해야 함 
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
    , COUNT(DISTINCT A.order_id) F -- 왜 DISTINCT를 사용했는가? 의미 파악
FROM order_products__prior A
LEFT 
JOIN products B
ON A.product_id = B.product_id
GROUP BY 1
ORDER BY 2 DESC
;

-- 장바구니에 가장 먼저 넣는 상품 10개
SELECT * FROM order_products__prior;

-- 첫번째로 담기는 주문건은 1, 그 외에는 0으로 표시 
SELECT 
	product_id
    , CASE WHEN add_to_cart_order = 1 THEN 1 ELSE 0 END F_1st
FROM order_products__prior
ORDER BY 1
;

-- 첫번째로 가장 많이 담기는 product_id 상위 10개를 추출하자! 
SELECT 
	*
    , ROW_NUMBER() OVER(ORDER BY F_1st DESC) RNK
FROM (
	SELECT 
		product_id
		, SUM(CASE WHEN add_to_cart_order = 1 THEN 1 ELSE 0 END) F_1st
	FROM order_products__prior
	GROUP BY 1
) A
LIMIT 10
;

-- p.166
SELECT * 
FROM (
	SELECT 
		*
		, ROW_NUMBER() OVER(ORDER BY F_1st DESC) RNK
	FROM (
		SELECT 
			product_id
			, SUM(CASE WHEN add_to_cart_order = 1 THEN 1 ELSE 0 END) F_1st
		FROM order_products__prior
		GROUP BY 1
	) A
) BASE
WHERE RNK BETWEEN 1 AND 10
;

-- 시간별 주문 건수 
SELECT * FROM orders;

SELECT 
	order_hour_of_day
    , COUNT(DISTINCT order_id) F 
FROM orders
GROUP BY 1
ORDER BY 1
;

-- 첫 구매 후 다음 구매까지 걸린 평균 일수 
SELECT * FROM orders;
-- order_number 2인 의미 파악 
SELECT 
	AVG(days_since_prior_order) AVG_RECENCY
FROM orders
WHERE order_number = 2
;

-- 주문 건당 평균 구매 상품 수(UPT, Uni Per Transaction) 
SELECT
	COUNT(product_id) / COUNT(DISTINCT order_id) UPT 
FROM order_products__prior
;

-- 인당 평균 주문 건수 : 전체 주문 건수를 구매자 수로 나누어서 계산 
SELECT 
	COUNT(DISTINCT order_id) / COUNT(DISTINCT user_id) AS AVG_F 
FROM orders
;

-- 재구매율이 가장 높은 상품 10개 
-- p.169
-- 상품별로 재구매율을 계산한 뒤, 
-- 재 구매율을 기준으로 랭크를 계산함 (서브쿼리, Windows Function)
-- Rank값으로 1-10 조건 / LIMIT
SELECT * FROM order_products__prior;


-- product_id / RET_RATIO / RNK (~25분까지 실습)
-- 상품별 재구매율 계산
SELECT 
	product_id
    , SUM(reordered) / COUNT(*) AS RET_RATIO
FROM
	order_products__prior
GROUP BY 1
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
			, SUM(reordered) AS 합계
		FROM
			order_products__prior
		GROUP BY 1 
	) A
	WHERE 합계 >= 50
)
;

SELECT product_id 
FROM (
	SELECT 
		product_id
		, SUM(reordered) AS 합계
	FROM
		order_products__prior
	GROUP BY 1 
) A
WHERE 합계 >= 10
;

-- Department별 재 구매율이 가장 높은 상품 10개 
SELECT 
	* 
    , ROW_NUMBER() OVER(PARTITION BY department ORDER BY RET_RATIO DESC) AS RNK
FROM (
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
) BASE
;

-- WHERE 서브쿼리 추가
SELECT * 
FROM (
	SELECT 
		* 
		, ROW_NUMBER() OVER(PARTITION BY department ORDER BY RET_RATIO DESC) AS RNK 
	FROM (
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
	WHERE product_id IN (
		SELECT product_id 
		FROM (
			SELECT 
				product_id
				, SUM(reordered) AS 합계
			FROM
				order_products__prior
			GROUP BY 1 
		) A
		WHERE 합계 >= 10
	)
) BASE
WHERE RNK <= 10
;

-- 4교시 : 오전 3교시 배운 내용 복습, 블로그에 잘 정리! 
-- 8교시 : 블로그 초안 포함 링크 공유 (전원 필히 해주세요!) 5:30분에 모두 제출요망



