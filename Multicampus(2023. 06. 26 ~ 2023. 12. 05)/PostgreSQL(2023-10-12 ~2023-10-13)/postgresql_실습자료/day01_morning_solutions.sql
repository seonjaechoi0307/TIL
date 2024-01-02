DROP TABLE IF EXISTS develop_book;

CREATE TABLE develop_book(
	book_id               INTEGER,
	pub_date              INTEGER,
	-- date               DATE
	book_name             VARCHAR(80), 
	price                 MONEY
);


-- 날짜 및 시간 
CREATE TABLE datetime_study(
	type_ts    TIMESTAMP, 
	type_tstz  TIMESTAMPTZ, 
	type_date  DATE, 
	type_time  TIME
);

-- 다음 데이터 삽입 
INSERT INTO datetime_study(type_ts, type_tstz, type_date, type_time) 
VALUES ('2022-07-26 20:00:25+09', '2022-07-26 20:00:25+09', '2020-07-26', '18:00:00');

-- 데이터 확인 
SELECT * FROM datetime_study;

-- 시간대 조정
SET TIMEZONE = 'America/Los_Angeles';
SET TIMEZONE = 'Asia/Seoul';

-- 배열형
CREATE TABLE contact_info(
	cont_id    NUMERIC(3), 
	name       VARCHAR(15), 
	tel        INTEGER[], 
	Email      VARCHAR
);

-- 데이터 추가 
INSERT INTO contact_info 
VALUES(001, 'evan', Array[01012345678, 01143219876], 'evan@naver.com');

INSERT INTO contact_info 
VALUES(002, 'hong', '{01012345678,01195147856}', 'hong@naver.com');

SELECT * FROM contact_info;

-- JSON형
CREATE TABLE develop_book_order(
	id            NUMERIC(3), 
	order_info    JSON NOT NULL
);

INSERT INTO develop_book_order 
VALUES(001, '{"customer":"evan", "books":{"product":"postgreSQL", "qty":2}}');

SELECT * FROM contact_info;
SELECT * FROM develop_book_order;

-- CAST 연산자
SELECT CAST('3000' AS INTEGER);

-- phone_book
CREATE TABLE phone_book (
	id INTEGER, 
	name VARCHAR, 
	phone NUMERIC(11)
);

-- 데이터 insert
-- 원하는 데이터를 추가하도록 합니다. 
INSERT INTO phone_book VALUES(1, '정지훈', 01011111234); 
SELECT name, CAST (phone AS VARCHAR) FROM phone_book;

-- 다른방식
SELECT '00:15:00'::TIME, '2022-11-22 00:15:00'::TIMESTAMP;


-- 제품정보, 주문, 공장, 고객 테이블 생성
-- Primary Key, Foreign Key 미 기재
CREATE TABLE prod_info(
	prod_no    NUMERIC(5),
	prod_name  VARCHAR(40),
	prod_date  DATE, 
	prod_price MONEY,
	fact_no    NUMERIC(7)
);

CREATE TABLE prod_order(
	ord_no     NUMERIC(6), 
	cust_id    CHAR(8), 
	prod_name  VARCHAR(40), 
	qty        NUMERIC(1000), 
	prod_price MONEY, 
	ord_date   TIMESTAMPTZ
);

CREATE TABLE factory(
	fact_no    NUMERIC(7), 
	fact_name  VARCHAR(45), 
	city       VARCHAR(25), 
	fact_admin VARCHAR(40), 
	fact_tel   NUMERIC(11), 
	prod_name  VARCHAR[], 
	estab_date DATE
);

CREATE TABLE customer(
	cust_id    CHAR(8), 
	cust_name  VARCHAR(40), 
	cust_tel   NUMERIC(11), 
	email      VARCHAR(100), 
	birth      NUMERIC(6), 
	identify   BOOLEAN
);


-- 도메인 무결성 예시
-- 숫자가 0~9의 숫자만 입력되도록 설정
CREATE DOMAIN phoneint AS integer CHECK (VALUE > 0 AND VALUE < 9);

-- 테이블 생성
CREATE TABLE domain_type_study(
	id phoneint
);

-- 데이터 입력
INSERT INTO domain_type_study VALUES(1); -- 성공
INSERT INTO domain_type_study VALUES(5); -- 성공
INSERT INTO domain_type_study VALUES(10); -- 실패
INSERT INTO domain_type_study VALUES(-1); -- 실패

-- 5가지 제약조건
-- NOT NULL
DROP TABLE IF EXISTS contact_info;
CREATE TABLE contact_info(
	cont_id    NUMERIC(3)    NOT NULL,
	name       VARCHAR(15)   NOT NULL,
	tel        INTEGER[]     NOT NULL,
	email      VARCHAR
);

-- UNIQUE
DROP TABLE IF EXISTS contact_info;
CREATE TABLE contact_info(
	cont_id    NUMERIC(3)    UNIQUE NOT NULL,
	name       VARCHAR(15)   NOT NULL,
	tel        INTEGER[]     NOT NULL,
	email      VARCHAR
);

-- 여러 컬럼에 적용
DROP TABLE IF EXISTS contact_info;
CREATE TABLE contact_info(
	cont_id    NUMERIC(3)    NOT NULL,
	name       VARCHAR(15)   NOT NULL,
	tel        INTEGER[]     NOT NULL,
	email      VARCHAR, 
	UNIQUE (cont_id, tel, email)
);

-- Primary Key
DROP TABLE IF EXISTS contact_info;
CREATE TABLE contact_info(
	cont_id    SERIAL    NOT NULL PRIMARY KEY,
	name       VARCHAR(15)   NOT NULL,
	tel        INTEGER[]     NOT NULL,
	email      VARCHAR
);

-- 여러개의 Primary Key
-- 외래키를 지정한다. 
CREATE TABLE book(
	book_id    SERIAL        NOT NULL,
	name       VARCHAR(15)   NOT NULL, 
	admin_no   SERIAL        NOT NULL REFERENCES contact_info(cont_id), 
	email      VARCHAR, 
	PRIMARY KEY (book_id, admin_no)
);

-- 외래키 제약조건 예시
DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS subject;

CREATE TABLE subject(
	subj_id     NUMERIC(5)    NOT NULL PRIMARY KEY,
	subj_name   VARCHAR(60)   NOT NULL
);

INSERT INTO subject VALUES(00001, '수학'), (00002, '과학'), (00003, '사회');


CREATE TABLE teacher(
	teac_id            NUMERIC(5) NOT NULL PRIMARY KEY,
	teac_name          VARCHAR(20) NOT NULL,
	subj_id            NUMERIC(5) REFERENCES subject, 
	teac_certifi_date  DATE
);

INSERT INTO teacher values(00011, '정선생', 00001, '2017-03-11'); -- 성공
INSERT INTO teacher values(00021, '홍선생', 00002, '2017-03-11'); -- 성공
INSERT INTO teacher values(00031, '김선생', 00003, '2017-03-11'); -- 성공
INSERT INTO teacher values(00041, '박선생', 00004, '2017-03-11'); -- 실패

-- 과목 테이블에서 벗어난 과목 코드가 입력되면 외래 키 제약조건 위반 에러 출력

-- 외래 키가 여러개일 경우

DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS subject;

CREATE TABLE subject(
	subj_id     NUMERIC(5)    NOT NULL PRIMARY KEY,
	subj_name   VARCHAR(60)   NOT NULL, 
	stud_count  NUMERIC(20)   NOT NULL,
	UNIQUE (subj_id, subj_name)
);

INSERT INTO subject VALUES(00001, '수학', 60), (00002, '과학', 42), (00003, '사회', 70);

CREATE TABLE teacher(
	teac_id            NUMERIC(5)   NOT NULL PRIMARY KEY,
	teac_name          VARCHAR(20)  NOT NULL,
	subj_code          NUMERIC(5)   NOT NULL,
	subj_name          VARCHAR(60)  NOT NULL,
	teac_certifi_date  DATE         NOT NULL,
	FOREIGN KEY (subj_code, subj_name) REFERENCES subject (subj_id, subj_name)
);

INSERT INTO teacher values(00011, '정선생', 00001, '수학', '2017-03-11'); -- 성공
INSERT INTO teacher values(00021, '홍선생', 00002, '과학', '2017-03-11'); -- 성공
INSERT INTO teacher values(00031, '김선생', 00003, '사회', '2017-03-11'); -- 성공

SELECT * FROM subject;
SELECT * FROM teacher;


-- ON DELETE NO ACTION
-- 외래 키에 의해 참조된 컬럼은 지울 수 없다.
DELETE FROM subject WHERE subj_id = 00002; -- 실패

-- ON DELETE RESTRICT
-- 참조된 컬럼은 지울 수 없다
DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS subject;

CREATE TABLE subject(
	subj_id     NUMERIC(5)    NOT NULL PRIMARY KEY,
	subj_name   VARCHAR(60)   NOT NULL
);

INSERT INTO subject VALUES(00001, '수학'), (00002, '과학'), (00003, '사회');

CREATE TABLE teacher(
	teac_id            NUMERIC(5)   NOT NULL PRIMARY KEY,
	teac_name          VARCHAR(20)  NOT NULL,
	subj_code          NUMERIC(5)   NOT NULL REFERENCES subject ON DELETE RESTRICT,
	teac_certifi_date  DATE         NOT NULL
);

INSERT INTO teacher values(00011, '정선생', 00001, '2017-03-11'); -- 성공
INSERT INTO teacher values(00021, '홍선생', 00002, '2017-03-11'); -- 성공
INSERT INTO teacher values(00031, '김선생', 00003, '2017-03-11'); -- 성공

DELETE FROM subject WHERE subj_id = 00002; -- 실패

-- 지워야 하는 상황 발생 시
-- ON DELETE CASCADE 조건
-- 부모 컬럼 값이 지워지면서 그것을 참조하는 자식 테이블의 열이 삭제됨. 

DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS subject;

CREATE TABLE subject(
	subj_id     NUMERIC(5)    NOT NULL PRIMARY KEY,
	subj_name   VARCHAR(60)   NOT NULL
);

INSERT INTO subject VALUES(00001, '수학'), (00002, '과학'), (00003, '사회');

CREATE TABLE teacher(
	teac_id            NUMERIC(5)   NOT NULL PRIMARY KEY,
	teac_name          VARCHAR(20)  NOT NULL,
	subj_code          NUMERIC(5)   NOT NULL REFERENCES subject ON DELETE CASCADE,
	teac_certifi_date  DATE         NOT NULL
);

INSERT INTO teacher values(00011, '정선생', 00001, '2017-03-11'); -- 성공
INSERT INTO teacher values(00021, '홍선생', 00002, '2017-03-11'); -- 성공
INSERT INTO teacher values(00031, '김선생', 00003, '2017-03-11'); -- 성공

SELECT * FROM subject;
SELECT * FROM teacher;

DELETE FROM subject WHERE subj_id = 00002;

SELECT * FROM subject;
SELECT * FROM teacher;

-- 부모 테이블 subj_id 컬럼에 00002값이 지워지고, 참조하는 자식 테이블의 열도 지워짐

-- ON DELETE SET NULL 조건
-- 부모 테이블에서 참조된 행이 삭제될 때 자식 테이블의 참조 행에서 해당 컬럼의 값을 자동으로 NULL로 세팅

DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS subject;

CREATE TABLE subject(
	subj_id     NUMERIC(5)    NOT NULL PRIMARY KEY,
	subj_name   VARCHAR(60)   NOT NULL
);

INSERT INTO subject VALUES(00001, '수학'), (00002, '과학'), (00003, '사회');

CREATE TABLE teacher(
	teac_id            NUMERIC(5)   NOT NULL PRIMARY KEY,
	teac_name          VARCHAR(20)  NOT NULL,
	subj_code          NUMERIC(5)   REFERENCES subject ON DELETE SET NULL,
	teac_certifi_date  DATE         
);

INSERT INTO teacher values(00011, '정선생', 00001, '2017-03-11'); -- 성공
INSERT INTO teacher values(00021, '홍선생', 00002, '2017-03-11'); -- 성공
INSERT INTO teacher values(00031, '김선생', 00003, '2017-03-11'); -- 성공

DELETE FROM subject WHERE subj_id = 00002;

SELECT * FROM subject;
SELECT * FROM teacher;

-- 결과 확인, 부모 컬럼은 삭제되고, 자식 컬럼 값은 NULL이 되었다. 
DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS subject;

CREATE TABLE subject(
	subj_id     NUMERIC(5)    NOT NULL PRIMARY KEY,
	subj_name   VARCHAR(60)   NOT NULL
);

INSERT INTO subject VALUES(00001, '수학'), (00002, '과학'), (00003, '사회');

CREATE TABLE teacher(
	teac_id            NUMERIC(5)   NOT NULL PRIMARY KEY,
	teac_name          VARCHAR(20)  NOT NULL,
	subj_code          NUMERIC(5)   DEFAULT 1 REFERENCES subject ON DELETE SET DEFAULT,
	teac_certifi_date  DATE         
);

INSERT INTO teacher values(00011, '정선생', 00001, '2017-03-11'); -- 성공
INSERT INTO teacher values(00021, '홍선생', 00002, '2017-03-11'); -- 성공
INSERT INTO teacher values(00031, '김선생', 00003, '2017-03-11'); -- 성공

DELETE FROM subject WHERE subj_id = 00002;

SELECT * FROM subject;
SELECT * FROM teacher;


-- 부모테이블의 과학 과목이 사라지고, 자식테이블의 과목 코드는 수학으로 대체가 되었다. 
-- 하나 조심해야 할 것은 Default로 설정된 값도 외래 키 제약조건을 만족해야 한다는 것. 
-- 만약, Default를 5로 설정 했으면, 에러 발생 : 외래 키 제약조건 위배

-- CHECK 제약 조건
DROP TABLE IF EXISTS order_info;

CREATE TABLE order_info(
	order_no   INTEGER NOT NULL PRIMARY KEY, 
	cust_name  VARCHAR(100), 
	price      MONEY, 
	order_qty  INTEGER CHECK (order_qty > 0)
);

-- 도메인 무결성 예시
-- 숫자가 0~9의 숫자만 입력되도록 설정
DROP TABLE IF EXISTS domain_type_study;
DROP DOMAIN phoneint;
CREATE DOMAIN phoneint AS integer CHECK (VALUE > 0 AND VALUE < 9);

-- 테이블 생성
CREATE TABLE domain_type_study(
	id phoneint
);

-- (1) 테이블에 컬럼 추가
CREATE TABLE book_info(
	id      INTEGER     NOT NULL PRIMARY KEY, 
	name    VARCHAR(20) NOT NULL
);

INSERT INTO book_info VALUES(1, 'POSTGRESQL'), (2, 'MONGODB');

-- 새로운 컬럼 추가 시, 기존에 있던 열들은 모두 NULL값 갖음
-- 다시, NOT NULL 제약 조건 추가시 에러 발생
ALTER TABLE book_info
ADD COLUMN published_date DATE;

SELECT * FROM book_info;

-- 기존 열 값 수정
UPDATE book_info
SET published_date = '2020.12.25'
WHERE id = 1;

UPDATE book_info
SET published_date = '2022.11.25'
WHERE id = 2;

-- NOT NULL 제약조건 추가 
ALTER TABLE book_info
ALTER COLUMN published_date SET NOT NULL;

-- 정보 확인
SELECT 
	*
FROM 
   information_schema.columns
WHERE 
   table_name = 'book_info';
   
-- (2) 만들어진 테이블에 컬럼 삭제하기
-- published_date 컬럼 삭제
ALTER TABLE book_info
DROP COLUMN published_date;


-- 제약조건에 의해 published_date를 참조하는 컬럼이 있다면 지울 수 없다. 
-- 그런 경우, CASCADE 속성을 활용한다. 
-- 외래 키 제약조건 관계를 갖는 book_info 테이블과 library 테이블을 생성
DROP TABLE IF EXISTS book_info;

CREATE TABLE book_info(
	book_id   INTEGER         NOT NULL PRIMARY KEY, 
	book_name VARCHAR(20)     NOT NULL UNIQUE
);

INSERT INTO book_info VALUES(1, 'POSTGRESQL'), (2, 'MONGODB');

CREATE TABLE library(
	id        INTEGER         NOT NULL PRIMARY KEY, 
	name      VARCHAR(40)     NOT NULL, 
	book_name VARCHAR(20)     NOT NULL REFERENCES book_info(book_name)
);

INSERT INTO library VALUES (1, '국립도서관', 'POSTGRESQL');

SELECT * FROM book_info;
SELECT * FROM library;

ALTER TABLE book_info DROP COLUMN book_name CASCADE;

SELECT * FROM book_info;

-- CASCADE 속성을 이용하여 지울 수 없었던 book_name 컬럼이 지워진 것 확인

-- (3) 만들어진 테이블에 컬럼명 바꾸기 
DROP TABLE book_info;
DROP TABLE library;

CREATE TABLE book_info(
	book_id   INTEGER         NOT NULL PRIMARY KEY, 
	book_name VARCHAR(20)     NOT NULL UNIQUE
);

INSERT INTO book_info VALUES(1, 'POSTGRESQL'), (2, 'MONGODB');

CREATE TABLE library(
	id        INTEGER         NOT NULL PRIMARY KEY, 
	name      VARCHAR(40)     NOT NULL, 
	book_name VARCHAR(20)     NOT NULL REFERENCES book_info(book_name)
);

INSERT INTO library VALUES (1, '국립도서관', 'POSTGRESQL');

ALTER TABLE book_info RENAME book_name TO name;

-- 정보 확인
-- 부모 테이블의 정보를 확인한다. 
SELECT conrelid::regclass AS table_name, 
       conname AS foreign_key, 
       pg_get_constraintdef(oid) 
FROM   pg_constraint 
WHERE  contype = 'f'
AND    connamespace = 'public'::regnamespace   
ORDER  BY conrelid::regclass::text, contype DESC;

ALTER TABLE book_info
DROP COLUMN book_name;

-- (4) 만들어진 테이블에 제약조건 추가하기
-- NOT NULL 제약조건 추가 및 제거 
DROP TABLE IF EXISTS library;
DROP TABLE IF EXISTS book_info;

CREATE TABLE book_info(
	book_id   INTEGER         NOT NULL PRIMARY KEY, 
	book_name VARCHAR(20)     NOT NULL UNIQUE
);

INSERT INTO book_info VALUES(1, 'POSTGRESQL'), (2, 'MONGODB');

ALTER TABLE book_info
ALTER COLUMN book_name DROP NOT NULL;


-- (5) Primary Key 제약조건 추가 
DROP TABLE IF EXISTS book;

CREATE TABLE book(
	id    INTEGER          NOT NULL, 
	name  VARCHAR(20)      NOT NULL
);

ALTER TABLE book ADD PRIMARY KEY (id);

-- (6) 외래키 제약조건 추가
CREATE TABLE library(
	lib_id     INTEGER       NOT NULL PRIMARY KEY, 
	lib_name   VARCHAR(30)   NOT NULL, 
	book_id    INTEGER       NOT NULL
);

ALTER TABLE library
ADD FOREIGN KEY (book_id) REFERENCES book(id);

-- (7) 만들어진 테이블에 데이터 타입 변경하기
DROP TABLE IF EXISTS water;

CREATE TABLE water(
	id            SMALLINT   NOT NULL PRIMARY KEY, 
	name          TEXT       NOT NULL, 
	location_no   VARCHAR    NOT NULL, 
	description   TEXT
);

INSERT INTO water VALUES(01, '천지', '02', '백두산 천지');

ALTER TABLE water
ALTER COLUMN id            TYPE INTEGER, -- 성공
ALTER COLUMN description   TYPE VARCHAR; -- 성공

ALTER TABLE water
ALTER COLUMN location_no   TYPE INTEGER; -- 실패

-- USING 절은 데이터 값을 형변환을 하는 동시에 컬럼의 데이터 타입을 변경하도록 도와줌
ALTER TABLE water
ALTER COLUMN location_no   TYPE INTEGER USING location_no::INTEGER; -- 성공


