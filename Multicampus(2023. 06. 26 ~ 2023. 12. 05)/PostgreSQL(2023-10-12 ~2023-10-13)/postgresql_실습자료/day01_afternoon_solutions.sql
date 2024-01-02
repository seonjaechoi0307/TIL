-- 비교연산자
-- 첫번째 : NULL의 결과를 알 수 없으므로 NULL
-- 두번째 : IS_FALSE는 결과가 FALSE가 아니므로 FALSE가 된다. 
SELECT NULL = 'false' AS equal_false, NULL IS FALSE AS is_false;

-- 조건문 함수
-- CASE 함수
SELECT * FROM student_score;

SELECT
	id
	, name
	, score
	, CASE
		WHEN score <= 100 AND score >= 90 THEN 'A'
		WHEN score <= 89 AND score >= 80 THEN 'B'
		WHEN score <= 79 AND score >= 70 THEN 'C'
		WHEN score <= 70 THEN 'F'
	END grade
FROM student_score;

-- COALESCE 함수
-- NULL값을 다른 기본 값으로 대체할 때 자주 사용
SELECT COALESCE(null, null, null, '빈 값') AS column1;

-- COALESCE 함수 이용하여 score 컬럼이 NULL값 시, 그 값을 0점으로 바꾼다. 
-- CASE 함수를 이용하여 다시 등급 나누기. 
SELECT 
	id
	, name
	, score
	, COALESCE (score, 0)
	, CASE 
		WHEN score <= 100 AND score >= 90 THEN 'A'
		WHEN score <= 89 AND score >= 80 THEN 'B'
		WHEN score <= 79 AND score >= 70 THEN 'C'
		WHEN COALESCE (score, 0) < 70 THEN 'F'
	END grade
FROM student_score;

-- NULLIF 함수
-- NULL을 이용하는 가장 기본적인 조건문 함수
-- NULLIF(<매개변수 1>, <매개변수 2>)
-- 매개변수1과 매개변수2가 같은 경우 NULL을 반환
-- 서로 다른 경우 매개변수 1을 반환
SELECT NULLIF(20, 20) AS column1;
SELECT NULLIF(20, 21) AS column2;

-- 나눗셈
SELECT 12/4 AS share;

-- 에러
SELECT 12/0 AS share;

-- division_by_zero 테이블 활용
SELECT
	students
	, COALESCE((12/NULLIF(students, 0))::char, '나눌 수 없음') AS share
FROM division_by_zero;

-- 배열 연산자와 함수
SELECT ARRAY[5.1, 1.6, 3]::INTEGER[] = ARRAY[5, 2, 3] AS result;
SELECT ARRAY[5, 3, 3] > ARRAY[5, 2, 4] AS result;

-- 두번째 쿼리문을 보면 3번째 원소의 대소관계와는 상관없이 두번째 원소의 대소관계가 영향을 미침

-- 첫번째 array가 두번째 array를 포함하고 있는가?
select array['a', 'b', 'c'] @> array['a', 'b', 'b', 'a'] as contains;
select array['a', 'b', 'c'] @> array['c', 'c', 'c', 'a'] as contains;
select array['a', 'b', 'c'] @> array['c', 'c', 'c', 'd'] as contains;

-- 두번째 array가 첫번째 array를 포함하고 있는가?
select array[1, 1, 4] <@ array[4, 3, 2, 1] as is_contained_by;

-- 2차원 배열 입력
CREATE TABLE td_array(
	id     serial, 
	name   varchar(30), 
	schedule integer[][] -- 2차원 배열 생성
);


-- 2차원 배열 입력받는 방법 : ''중괄호 사용
INSERT INTO td_array(name, schedule)
VALUES('9DAYS', '{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}');

-- 2차원 배열 입력받는 방법 : ARRAY[]
INSERT INTO td_array(name, schedule)
VALUES('10DAYS', ARRAY[[1,2,3],[4,5,6],[7,8,9]]);

SELECT * FROM td_array;

-- 배열 함수
-- array_append(<배열>, <원소>)
SELECT array_append(ARRAY[1, 2], 3) AS result;

-- array_prepend(<원소>, <배열>)
SELECT array_prepend(1, ARRAY[2, 3]) AS result;

-- array_remove(<배열>, <원소>)
SELECT array_remove(ARRAY[1, 2, 3, 4], 4) AS result;

-- array_replace(<배열>, <기존 원소1>, <새로운 원소2>)
SELECT array_replace(ARRAY[1, 4, 3], 4, 2) AS result;

-- array_cat() 두 배열 병합
SELECT array_cat(ARRAY[1, 2], ARRAY[3, 4]) AS result;

------------------------
-- JSON 연산자와 함수
------------------------

SELECT '{"p": {"1":"postgres"}, "s":{"1":"sql"}}'::json -> 'p' AS result;
SELECT '[{"p":"postgres"}, {"s":"sql"}, {"m":"mongoDB"}]'::json -> 0 AS result;

-- JSON 다층 구조
SELECT 
	'{"i":{"love":{"book":"postgresql"}}}'::json #>> '{"i", "love", "book"}'
AS result;

SELECT 
	'{"post":[{"gre": {"sql": "do it"}}, {"t":"sql"}]}'::json #>
	'{"post", 0, "gre", "sql"}'
AS result;

-- JSONB 연산자
SELECT 
	'{"a":0, "b":1}'::jsonb @> '{"b":1}'::jsonb
AS result;

SELECT 
	'{"username" : "evan", "contents":"hello world"}'::jsonb ? 'username'
AS result;


-- 키 값이 1개 이상 존재시 ?| 연산자 사용
SELECT 
	'{"hello":0, "psql":1, "world":2}'::jsonb ?| array['a', 'psql']
AS result;

-- ?| 연산자와 다르게 가장 바깥 단의 JSONB에 배열 속의 원소가 "키 값"으로 모두 존재하는 지 물어볼 때 
SELECT 
	'{"hello":0, "psql":1, "world":2}'::jsonb ?| array['psql', 'world']
AS result;


-- || 연산자 활용하여 병합
SELECT 
	'{"username":"evan"}'::jsonb || '{"contents":"hello"}'::jsonb
AS result;

-- JSONB 속의 데이터 삭제
SELECT 
	'{"a":"0", "b":"1", "c":"2"}'::jsonb - 'b'
AS result;

-- 복수의 원소 삭제
SELECT 
	'{"a":"0", "b":"1", "c":"2"}'::jsonb - ARRAY['b', 'c']
AS result;

-- JSONB 배열, 인덱스 번호 활용하여 삭제
SELECT '["a", "b", "c"]'::jsonb - -1 AS result;

-- JSON 생성함수
SELECT json_build_object('a', 1, 'b', 2) AS result;
SELECT json_build_object('a', 1, 'b', 2, 'c') AS result; -- 에러
SELECT json_build_array('a', 1, 'b', 2, 'c') AS result; -- 배열

-- JSON 처리함수
SELECT json_array_length('["a", 1, "b", 2, "c"]'::JSON) AS length;

SELECT * FROM
json_each('{"evan":"mysql", "evan2":"oracle"}');

SELECT * FROM json_array_elements('[1,true, {"b":"c"}, [2,false], ["d", 2, 3]]');

------------------------
-- 날짜 및 시간 연산자와 함수
------------------------

-- 날짜 및 시간 연산자
SELECT date '2022-11-15' + integer '7' AS result;
SELECT date '2022-11-15' + time '13:00' AS result;

-- 시간간격
SELECT 60 * interval '1 second' AS result;
SELECT 2 * time '2:00' AS result;

SELECT interval '1 hour' / FLOAT '1.2' AS result;

-- 현재 날짜와 시간
SELECT CURRENT_DATE;
SELECT CURRENT_TIME(2);

SELECT now(), timeofday();

-- 날짜 및 시간 기본함수
SELECT age(timestamp '2022-12-11');

-- 날짜 및 시간 응용 함수
SELECT EXTRACT(MONTH FROM TIMESTAMP '2022-12-13');

-- 현재 날짜 분기
SELECT date_part('quarter', now());

-- date_trunc 함수
SELECT * FROM timebox;

-- 연도, 월 정보만을 남기고 나머지 모든 정보를 0으로 없앰
SELECT id, date_trunc('month', times) FROM timebox;

------------------------
-- 자주 쓰이는 연산자와 함수
------------------------

SELECT * FROM real_amount
WHERE EXISTS (
	SELECT * FROM assumption_amount
);

-- 두 번째 코드는 exception 테이블에 아무런 데이터가 없기 때문에 false를 입력 받음
SELECT * FROM real_amount
WHERE EXISTS (
	SELECT * FROM exception
);

SELECT * FROM real_amount
WHERE amount IN (10, 20, 30);

SELECT * FROM real_amount
WHERE amount NOT IN (10, 20, 30);

-- ANY와 SOME 연산자 : 의미상 서로 같음
-- amount 컬럼 중에서 10이라는 행이 존재
SELECT * FROM real_amount
WHERE 10 = ANY (
	SELECT amount FROM assumption_amount
);

-- amount 컬럼 중에서 11이라는 행이 존재하지 않음
SELECT * FROM real_amount
WHERE 11 = ANY (
	SELECT amount FROM assumption_amount
);

-- amount 컬럼 로우 값 하나하나 10과 크거나 같은지 비교
SELECT * FROM real_amount
WHERE 10 <= ANY (
	SELECT amount FROM assumption_amount
);


------------------------
-- 패턴 매칭 연산자
------------------------
SELECT 
	'pink' LIKE '_in_', -- '_'가 한글자를 나타내기 때뭄
	'pink' LIKE 'p%k', -- 첫번째와 마지막 글자가 'p'와 'k'인 참
	'pink' LIKE 'p__'; -- `p__`는 세글자를 나타냄. 
	
-- Similar to 연산자
SELECT * FROM student_score;
SELECT * FROM student_score WHERE name SIMILAR TO '(Heewon|Sabin)';


-- 병합 연산자
SELECT 'postgre' || 'sql' AS result, 
	   'price: ' || 300 || 'won' AS result;
	   
-- 문자열 함수
SELECT length('postgresql') AS length;

-- Substring
SELECT 
	substring('evan_01012345678' FROM 1 for 5), 
	substring('evan_01012345678' FROM 7 for 16);
	
-- 앞 5글자만 표시되도록 한다. 
SELECT left('a 123 dadfaf', 5);

-- 문자열 결합
SELECT concat('my sql ', 'language', 'is ', null, 'postgresql ');

-- 문자열 위치 찾기
SELECT position('postgre' in 'my sql language is postgresql');

------------------------------------------------
-- (실습) 고등학교 졸업생들의 진로 분석
------------------------------------------------
SELECT * FROM graduates;

-- 1. 한해 동안 특수학교에서 졸업한 학생의 수가 25명 이상이었던 학교 이름과 남, 여 졸업생 수를 출력하라
SELECT 기준년도, 학교명, 졸업남자수, 졸업여자수
FROM graduates
WHERE 학교급명='특수학교' AND (졸업남자수 + 졸업여자수) >= 25;


-- 2. 2015년에 남, 여 통학 취업률이 50%가 넘은 학교의 지역명, 이름과 취업률(%)를 출력하라
SELECT 
	학교명
	, 지역명
	, 100 * (취업남자수 + 취업여자수) / (졸업남자수 + 졸업여자수) AS 취업률
FROM graduates
WHERE EXTRACT(YEAR FROM 기준년도) = 2015
	AND (졸업남자수 + 졸업여자수) > 0
	AND 100 * (취업남자수 + 취업여자수) / (졸업남자수 + 졸업여자수) >= 50;
	
-- 경기도 고양시 일산 지역에 있는 고등학교의 각 연도별 졸업생 정보를 다음의 조건을 만족하도록 출력하라
--- 진학률을 기준으로 내림차순으로 출력하라
--- 졸업생이 없으면 진학률은 0%로 표시한다. 
--- 지역명에 “고양시 일산”이 포함되어 있는 로우를 검색해야 한다. 
--- 출력될 때 다음 예시와 같이 기준연도는 연도 숫자로, 지역명에는 “경기도 고양시＂라는 문자열을 뺀 뒷부분만 보이도록 한다. 

SELECT 
	EXTRACT (YEAR FROM 기준년도) AS 기준연도
	, 학교명
	, REPLACE(지역명, '경기도 고양시 ', '') AS 지역명
	, CASE WHEN (졸업남자수 + 졸업여자수) = 0 THEN 0
		ELSE 100 * (진학남자수 + 진학여자수) / (졸업남자수 + 졸업여자수)
	  END AS 진학률
FROM graduates
WHERE 지역명 LIKE '경기도 고양시 일산%'
ORDER BY 4 DESC;

-- 데이터 그룹화
SELECT DISTINCT item_type, item_id FROM rating ORDER BY item_type;

-- GROUP BY
SELECT * FROM rating;
SELECT item_type FROM rating GROUP BY item_type;
SELECT item_type, item_id, count(*) FROM rating GROUP BY item_type, item_id;
SELECT item_type, item_id, count(*) FROM rating GROUP BY 1, 2;

-- HAVING절 
SELECT item_type, count(*)
FROM rating
GROUP BY item_type
HAVING count(*) > 3;

SELECT item_type, count(*)
FROM rating
WHERE item_type LIKE 'r%'
GROUP BY item_type
HAVING count(*) > 3;

------------------------------------------------
-- 집계함수
------------------------------------------------
SELECT avg(rating) FROM rating;
SELECT count(rating) FROM rating;
SELECT max(rating) FROM rating;
SELECT min(rating) FROM rating;
SELECT sum(rating) FROM rating;

-- 가장 높은 점수인 상품은 무엇인가?
-- 오류 코드
SELECT item_type, item_id FROM rating
WHERE rating = max(rating);

-- 서브쿼리 필요
SELECT item_type, item_id FROM rating
WHERE rating = (
	SELECT max(rating) FROM rating
);


------------------------------------------------
-- 불리언 연산 집계함수
------------------------------------------------
SELECT * FROM ramen;
SELECT bool_and(is_spicy) FROM ramen;
SELECT every(is_spicy) FROM ramen;
SELECT bool_or(is_spicy) FROM ramen;

-- 짜장면 관련 상품 중에서 매운 상품이 있는지 찾아보기
-- 짜장면 상품 중 매운 것은 없다. 
SELECT bool_or(is_spicy)
FROM ramen
WHERE name LIKE '%짜장면';

-- 배열을 담는 집계함수
SELECT * FROM canned_food;
SELECT array_agg(name) FROM canned_food;

-- GROUP BY와 함께 사용
SELECT id, weight, array_agg(name) FROM canned_food GROUP BY 1, 2 ORDER BY 1;


------------------------------------------------
-- JSON 집계함수
------------------------------------------------

-- 출력하기 
SELECT * FROM company_json;

-- json_agg 함수 활용
-- 출력결과를 비교한다. 
SELECT id, json_agg(information)
FROM company_json
GROUP BY 1;

SELECT id, json_agg(name)
FROM ramen
GROUP BY 1
ORDER BY 1;

-- jsonb_agg 함수 활용
-- 출력결과를 비교한다.
SELECT id, jsonb_agg(information)
FROM company_json
GROUP BY 1;

SELECT id, jsonb_agg(name)
FROM ramen
GROUP BY 1
ORDER BY 1;

-- json_object_agg
SELECT json_object_agg(id, name) FROM ramen;

-- jsonb_object_agg
SELECT jsonb_object_agg(id, name) FROM ramen;

-- ramen 테이블의 id-name 컬럼의 row를 각각 키-값 형태로 지정한 json 타입 데이터가 된다. 
-- GROUP BY 코드 입력
SELECT
	id
	, quantity
	, shelf_life
	, json_object_agg(name, is_spicy)
FROM ramen
GROUP BY 1, 2, 3
ORDER BY 1;

-- 기존 쿼리 대비 공백이 사라짐. 
SELECT
	id
	, quantity
	, shelf_life
	, jsonb_object_agg(name, is_spicy)
FROM ramen
GROUP BY 1, 2, 3
ORDER BY 1;

------------------------------------------------
-- 다수의 집계함수 사용하기
------------------------------------------------

-- 총 행의 갯수와 최대 점수 구하기
SELECT count(*), max(rating) FROM rating;

-- GROUP BY 활용, 각 아이템의 최대점수, 최소점수 동시에 출력
SELECT 
	item_id
	, item_type
	, max(rating)
	, min(rating)
FROM rating
GROUP BY 1, 2
ORDER BY 1;

-- 각 아이템의 최대 및 최소 점수가 아닌 사용자가 준 점수 중 개개인의 최대로 매긴 점수, 최소로 매긴 점수를 집계한다. 
SELECT 
	user_id
	, max(rating)
	, min(rating)
FROM rating
GROUP BY 1
ORDER BY 1;

-- 평균을 추가한다. 
SELECT 
	user_id
	, max(rating)
	, min(rating)
	, avg(rating)
FROM rating
GROUP BY 1
ORDER BY 1;

-- HAVING 절을 통해 avg(rating) > 2가 되도록 쿼리를 작성한다. 
SELECT
	item_id
	, item_type
	, max(rating)
	, min(rating)
	, avg(rating)
FROM rating
GROUP BY 1, 2
HAVING avg(rating) > 2
ORDER BY 1;

-- JSON 집계함수를 이용해 데이터 추출
SELECT 
	item_type
	, item_id
	, json_object_agg(user_id, rating)
FROM rating
GROUP BY 1, 2;

-- HAVING 절 사용
SELECT 
	item_type
	, item_id
	, json_object_agg(user_id, rating)
FROM rating
GROUP BY 1, 2;

-- 평균점수가 2점 보다 큰 '유저와 평가점수' 쌍을 포함한 그룹만 출력하도록 한다. 
SELECT 
	item_type
	, item_id
	, json_object_agg(user_id, rating)
FROM rating
GROUP BY 1, 2
HAVING avg(rating) > 2;

------------------------------------------------
-- 시군구별 인구 통계 분석
------------------------------------------------

-- 전국의 인구수 총합을 연도별로 표시한다. 
SELECT * FROM population_by_year;
SELECT
	년도
	, sum(총인구수) AS 총인구수
FROM population_by_year
GROUP BY 년도
ORDER BY 년도;

-- 최근 5년간 전국의 한 세대당 평균 인구수(총인구수/세대수)를 출력하라. 
SELECT 
	년도
	, avg(총인구수::numeric/세대수) AS "세대별 인구수"
FROM population_by_year
WHERE 년도 > 2014
GROUP BY 년도
ORDER BY 년도;

-- 최근 5년간 (남자 인구수)/(여자 인구수) 성비의 평균을 행정구역별로 출력하고 가장 높은 지역이 어디인지 알아내라. 매 연도마다 성비 가중치는 같다. 
SELECT 
	행정구역
	, avg(남자_인구수::numeric/여자_인구수) AS 성비
FROM population_by_year
WHERE 년도 > 2014
GROUP BY 행정구역
ORDER BY 성비 DESC;

------------------------------------------------
-- 여러 개의 테이블을 로우로 연결하기
------------------------------------------------

-- 명령어의 전제조건 : (1) 컬럼의 갯수가 동일해야 한다. / (2) 같은 위치에 동일한 형식과 의미의 정보가 담겨야 한다. 
-- 아래 두개의 명령어를 비교한다. 
SELECT * FROM drink
UNION ALL
SELECT * FROM drink;

SELECT * FROM drink
UNION
SELECT * FROM drink;


-- UNION 명령어의 중복 제거 
-- 두 테이블에 공통되는 행만 남기는 명령어 

(SELECT * FROM drink
UNION ALL
SELECT * FROM drink)
INTERSECT 
(SELECT * FROM drink
UNION ALL
SELECT * FROM drink);

-- EXCEPT 명령어
-- EXCEPT ALL 명령어
(SELECT id, name, quantity 
 FROM drink
 UNION ALL
 SELECT id, name, quantity
 FROM ramen
)
EXCEPT ALL
(SELECT id, name, quantity 
 FROM drink
 UNION ALL
 SELECT id, name, quantity
 FROM canned_food
);

-- 다양한 상황에서 데이터 결합하기 
-- 상황 1. 어디 소속 테이블인지 확인하며 표현하기 
(SELECT name, quantity, 'drink' AS item_type FROM drink)
UNION ALL
(SELECT name, quantity, 'ramen' AS item_type FROM ramen)
UNION ALL
(SELECT name, quantity, 'canned_food' AS item_type FROM canned_food) 
ORDER BY quantity DESC;

-- 상황 2. 라면과 통조림, 음료는 수량이 20개 이하기 되면 주문 발주를 넣는다. 
-- 각각의 상품 종류, 발주 넣어야 할 상품 배열 두 컬럼이 나타나도록 작성한다. 
SELECT 
	item_type
	, array_agg(name)
FROM (
	(
		SELECT name, quantity, 'drink' AS item_type
		FROM drink
	)
	UNION ALL
	(
		SELECT name, quantity, 'ramen' AS item_type
		FROM ramen
	)
	UNION ALL
	(
		SELECT name, quantity, 'canned_food' AS item_type
		FROM canned_food
	)
) item_list
WHERE quantity <= 20
GROUP BY 1;

------------------------------------------------
-- FROM과 WHERE 절을 이용한 데이터 결합
------------------------------------------------
SELECT * 
FROM rating, ramen;

-- CROSS JOIN
-- 위 코드와 비교한다. 
-- 두 테이블의 각각의 행이 서로 한번씩 결합시키는 것을 교차 조인이라고 함. 
SELECT *
FROM rating CROSS JOIN ramen;

-- WHERE절로 결합된 데이터 고르기
SELECT 
	rating.user_id
	, rating.rating
	, ramen.name
	, ramen.quantity
	, ramen.is_spicy
FROM rating, ramen
WHERE ramen.id = rating.item_id AND rating.item_type = 'ramen';

------------------------------------------------
-- JOIN을 이용한 데이터 결합
------------------------------------------------

EXPLAIN
SELECT 
	rating.user_id
	, rating.rating
	, ramen.name
	, ramen.quantity
	, ramen.is_spicy
FROM 
	rating, ramen
WHERE 
	ramen.id = rating.item_id AND rating.item_type = 'ramen';

-- 이 쿼리문을 JOIN문으로 이용하여 변경한다. 
EXPLAIN
SELECT 
	rating.user_id
	, rating.rating
	, ramen.name
	, ramen.quantity
	, ramen.is_spicy
FROM (
	rating JOIN ramen
	ON ramen.id = rating.item_id AND rating.item_type = 'ramen'
);

-- 두 쿼리문 모두 동일한 계산 방식 사용. 
SELECT 
	rating.user_id
	, rating.rating
	, ramen.name
	, ramen.quantity
	, ramen.is_spicy
FROM 
	(rating LEFT JOIN ramen
		ON ramen.id = rating.item_id AND rating.item_type = 'ramen');
		
-- 연결된 정보가 없다면 NULL값으로 출력함. 
-- RIGHT JOIN은 LEFT JOIN으로 바꾸면 반대 상황이 나온다. 
SELECT 
	rating.user_id
	, rating.rating
	, ramen.name
	, ramen.quantity
	, ramen.is_spicy
FROM 
	(rating RIGHT JOIN ramen
		ON ramen.id = rating.item_id AND rating.item_type = 'ramen');

-- FULL OUTER JOIN
SELECT 
	rating.user_id
	, rating.rating
	, ramen.name
	, ramen.quantity
	, ramen.is_spicy
FROM (
	rating FULL JOIN ramen
	ON ramen.id = rating.item_id AND rating.item_type = 'ramen');
	
-- 실습
SELECT * FROM accident;
SELECT * FROM population;
SELECT * FROM road_type;

-- 문제 1. 교차로에서 사고자가 5명인 이상인 대형 사고는 어느 시도, 시군구에서 발생했는지 사고자 수로 내림차순하여 출력한다. 
SELECT 시도, 시군구, count(*) AS 사고횟수
FROM accident JOIN road_type USING(도로형태id)
WHERE road_type.대분류 = '교차로'
	AND (사망자수 + 부상자수 + 중상자수 + 경상자수 + 부상신고자수) >= 5
GROUP BY 시도, 시군구
ORDER BY 사고횟수 DESC;

-- 문제 2. 세대수 대비 사망자수가 많은 순으로 시도, 시군구를 출력한다. 
SELECT 
	population.시도, 
	population.시군구, 
	시군구별_사고.사망자수::decimal/population.세대수 AS 세대당_사망자수
FROM population
JOIN (
	SELECT 시군구, 시도, sum(사망자수) AS 사망자수
	FROM accident
	GROUP BY 시군구, 시도
	ORDER BY 사망자수 DESC
) 시군구별_사고
ON 시군구별_사고.시군구 = population.시군구
	AND 시군구별_사고.시도 = population.시도
ORDER BY 세대당_사망자수 DESC;

-- 문제 3. 광역단체(시도)의 각 시군구 평균 사고 횟수 대비 각 시군구가 얼만큼 사고가 더 나는지 증감을 표로 표시한다. 
-- 1단계 : 각 시도의 시, 군, 구별 평균 사고횟수가 출력되는 쿼리문 작성
-- 2단계 : 시군구구의 사고 횟수가 표현된 쿼리문을 JOIN으로 연결하여 평균 대비 사고 횟수 구하기
-- 시도 평균 대비 사고횟수가 가장 많은 시군구는 경남 창원시
SELECT 
	시군구_사고횟수.시도
	, 시군구_사고횟수.시군구
	, 시군구_사고횟수.사고횟수
	, (시군구_사고횟수.사고횟수 - 시도_평균_사고횟수.평균_사고횟수) AS 평균대비_사고횟수_증감
FROM (
	SELECT 시군구, 시도, count(*) AS 사고횟수
	FROM accident
	GROUP BY 시군구, 시도
) 시군구_사고횟수 JOIN
(
	SELECT 시도, avg(사고횟수) AS 평균_사고횟수
	FROM (
		SELECT 시군구, 시도, count(*) AS 사고횟수
		FROM accident
		GROUP BY 시군구, 시도
	) 시군구_사고횟수
	GROUP BY 시도
) 시도_평균_사고횟수
ON 시군구_사고횟수.시도 = 시도_평균_사고횟수.시도
ORDER BY 평균대비_사고횟수_증감 DESC;


