USE classicmodels;

-- [SELECT]
SELECT customerNumber, phone FROM customers;

-- [COUNT] : 행의 갯수, 각 컬럼의 값의 갯수를 파악할 때
SELECT COUNT(checknumber) FROM payments;
SELECT COUNT(*) FROM payments;

-- 테이블 정의서를 보고 테이블의 형태를 파악 !!
SELECT * FROM payments; -- 실무에서는 이 쿼리 사용하면 사수한태 혼남 !!
SELECT SUM(amount) FROM payments;

--
SELECT productname, productline
FROM products;

-- [특정 컬럼명 변경]
SELECT
	COUNT(productcode) AS n_products
    , COUNT(productcode) n_products
    , COUNT(productcode)
    , COUNT(productcode) AS 갯수
FROM
	products
;

-- [실습]
SELECT
	SUM(productcode) AS SUM
FROM
	products
;

-- [교재 31p]
-- DISTINCT : 중복 제외하고 데이터 조회!
SELECT
	DISTINCT ordernumber
FROM
	orderdetails
;

SELECT
	COUNT(ordernumber) AS 중복포함
	, COUNT(DISTINCT ordernumber) AS 중복제거
FROM orderdetails;

-- [실습 DISTINCT]
SELECT COUNT(orderNumber)
FROM orderdetails;

SELECT COUNT(DISTINCT orderNumber)
FROM orderdetails;

-- [WHERE] SQL 문법에서 WHERE절을 익히는 것이 60%
-- Online 튜토리얼, WHERE 절 집중적으로 익히는 것 추천
-- 참고 사이트 : https://www.mysqltutorial.org/

-- [WHERE, BETWEEN]
-- WHERE : 위치 조건문
-- BETWEEN : 시작점과 끝점 조건문
SELECT *
FROM orderdetails
WHERE priceeach BETWEEN 30 AND 50;

-- [WHERE, 대소관계 연산자] 컬럼명 =, >=, <=, >, <, <>
SELECT *
FROM orderdetails
WHERE priceeach < 30;

SELECT COUNT(*)
FROM orderdetails
WHERE priceeach <= 30;

SELECT *
FROM payments
WHERE amount <= 6000;

SELECT COUNT(*)
FROM offices
WHERE country = 'USA' ;


-- in python : orderdetails.loc[orderdetails['priceeach'] < 30, :]

SELECT * FROM offices;

-- [WHERE, IN]
-- 주의할 점은 칼럼의 값이 "값1" 또는 "값2"인 데이터가 출력된다 !!
-- 서브쿼리 사용할 때 자주 사용되는 연산자!
-- France, Poland, Germany 추가

SELECT country FROM customers;

SELECT
	customernumber
    , country
FROM customers
WHERE country = 'USA' OR country = 'Canada' OR country = 'France'
;

-- IN : 해당하는 범위 조건문
SELECT
	customernumber
    , country
FROM customers
WHERE country IN('USA', 'Canada', 'France')
;

-- NOT IN : 해당하지 않는 범위 조건문
SELECT
	customernumber
    , country
FROM customers
WHERE country NOT IN('USA', 'Canada', 'France')
;

SELECT * FROM orders;

SELECT
	orderNumber
    , customerNumber
    , status
FROM orders
WHERE status IN ('Shipped', 'Resolved')
;

-- [WHERE, IS NULL]

SELECT * FROM employees;

SELECT employeenumber
FROM employees
WHERE reportsto IS NOT NULL;

SELECT
	COUNT(employeenumber)
    , COUNT(reportsto) -- NULL 값이 존재하면 COUNT 하지 않는다 !!!
    , COUNT(*)
FROM employees;

SELECT COUNT(reportsto) FROM employees;

-- [WHERE, LIKE '%TEXT%']
-- %는 문자를 의미한다. 부산 앞, 뒤로 어떤 문자가 와도 상관없다!

SELECT
	addressline1
FROM customers;

SELECT
	addressline1
FROM customers
WHERE addressline1 LIKE '%North%';

SELECT
	addressline1
FROM customers
WHERE addressline1 LIKE '%ST.%';

-- GROUP BY
SELECT *
FROM customers;

SELECT
	country
    , city
    , COUNT(customernumber) AS n_customers
FROM customers
GROUP BY country, city
;

SELECT *
FROM customers;

SELECT
	country -- 문자 칼럼
    , city -- 문자 칼럼
    , SUM(숫자칼럼)
    , AVG(숫자칼럼)
    , COUNT(customernumber) AS n_customers
FROM customers
GROUP BY country, city
;

SELECT * FROM payments;

SELECT
	customernumber
    , checknumber
    , SUM(amount)
FROM
	payments
GROUP BY customernumber, checknumber
;

USE instacart;

SELECT * FROM products;

USE classicmodels;

-- [CASE WHEN] : IF 조건문
-- p.46, USA 거주자의 수 계산, 그 비중을 구하자 !

SELECT * FROM customers;

SELECT
	country
	, CASE WHEN country = 'USA' THEN 1 ELSE 0 END N_USA
FROM
	customers;
    
SELECT
	sum(CASE WHEN country = 'USA' THEN 1 ELSE 0 END) N_USA
FROM
	customers
;
    
-- 비율 같이 구해보면
SELECT
	sum(CASE WHEN country = 'USA' THEN 1 ELSE 0 END) N_USA
    , COUNT(*)
    , sum(CASE WHEN country = 'USA' THEN 1 ELSE 0 END) / COUNT(*) AS USA_PORTION
FROM
	customers
;


-- [JOIN]
-- 실무에서는 ERD를 활용함 그림을 보면서 어떻게 JOIN 할 것인지 계획을 짬

SELECT
	A.ordernumber
    , B.country
FROM orders A
LEFT
JOIN customers B
ON A.customernumber = B.customernumber;

SELECT
	COUNT(*)
FROM orders A
LEFT
JOIN customers B
ON A.customernumber = B.customernumber
WHERE B.country = 'USA'
;

-- INNER JOIN
SELECT
	COUNT(*)
FROM orders A
INNER
JOIN customers B
ON A.customernumber = B.customernumber
WHERE B.country = 'USA'
;

-- PL/SQL 개발이나 분석 쪽으로는 이 검색어로 알아보자
-- A 테이블 갯수 1000개, B 테이블 갯수 100개
-- 1억개, 천만개
-- FULL JOIN
SELECT
	*
FROM orders A
LEFT
JOIN customers B
ON A.customernumber = B.customernumber

UNION
-- UNION : 중복제거
-- UNION ALL : 중복 제거안함

SELECT
	*
FROM orders A
RIGHT
JOIN customers B
ON A.customernumber = B.customernumber
;


-- 58p
-- 윈도우 함수 : RANK, DENSE_RANK, ROW_NUMBER
-- 중요함!

SELECT
	buyprice
    , ROW_NUMBER() OVER(ORDER BY buyprice) ROWNUMBER -- ROW_NUMBER = 행 순번
    , RANK() OVER(ORDER BY buyprice) RNK -- RANK = 동일 값 동일 랭크, 다음 순번 생략
    , DENSE_RANK() OVER(ORDER BY buyprice) DENSERANK -- DENSERANK = 동일 값 동일 랭크, 다음 순번 생략안함
FROM products;

-- p. 61 PARTITION BY
SELECT
	productline
    , buyprice
    , ROW_NUMBER() OVER(PARTITION BY productline ORDER BY buyprice) ROWNUMBER -- ROW_NUMBER = 행 순번
    , RANK() OVER(PARTITION BY productline ORDER BY buyprice) RNK -- RANK = 동일 값 동일 랭크, 다음 순번 생략
    , DENSE_RANK() OVER(PARTITION BY productline ORDER BY buyprice ) DENSERANK -- DENSERANK = 동일 값 동일 랭크, 다음 순번 생략안함
    -- PARTITION BY : 클래스 별로 파티션을 나눈다.
    -- ORDER BY : 나눠진 파티션 별로 가격 비례해서 오름차순 정렬 ( ORDER BY [컬럼명] DESC : 내림차순 )
FROM products;

-- 62P
-- SubQuery : 매우매우매우매우 중요함 !!!
-- 서브쿼리 : 쿼리 안에 또 다른 쿼리를 사용하는 것 ( 갯수는 무제한 ! )

SELECT ordernumber
FROM classicmodels.orders
WHERE customerNumber IN (select customernumber
FROM classicmodels.customers
WHERE city = 'NYC')
;

SELECT customernumber
FROM (SELECT customernumber
FROM classicmodels.customers
WHERE city = 'NYC') A;

SELECT *
FROM classicmodels.customers;

SELECT *
FROM classicmodels.orders;

SELECT ordernumber
FROM classicmodels.orders
-- classicmodels 스키마에서 orders 테이블 선택하여 불러오기
WHERE customernumber IN (SELECT customernumber
-- classicmodels 스키마에서 customer 테이블의 customernumber를 country는 USA를 조건으로
FROM classicmodels.customers
WHERE country = 'USA');
-- 위 조건에 해당하는 데이터 classicmodels 스키마에서 orders 테이블에서 불러오기