USE mulcamp;

-- 'tasks' 테이블 생성
CREATE TABLE IF NOT EXISTS tasks (
	task_id INT AUTO_INCREMENT     -- 고유한 작업 아이디로, 정수형 자동 증가
    , title VARCHAR(255) NOT NULL  -- 작업 제목은 최대 255자의 문자열이어야 함
    , start_date DATE              -- 작업 시작 날짜
    , due_date DATE                -- 작업 마감 날짜
    , priority TINYINT NOT NULL DEFAULT 3  -- 우선순위, 기본값은 3
    , DESCRIPTION TEXT             -- 작업 설명을 저장하는 텍스트 필드
    , PRIMARY KEY (task_id)        -- task_id를 기본 키로 설정하여 고유성을 보장
)
;

SELECT *
FROM tasks;

-- 교재 p.71 'tasks' 테이블에 레코드 삽입

-- 'Learn MySQL'라는 작업을 'tasks' 테이블에 추가합니다.
-- 'title' 열에는 'Learn MySQL'라는 작업 제목이 들어가고, 'priority' 열에는 1이라는 우선순위가 할당됩니다.
INSERT INTO tasks(title, priority)
VALUES ('Learn MySQL', 1);

-- SELECT
SELECT * FROM tasks;

INSERT INTO tasks(title, priority)
VALUES ('Learn Oracle', DEFAULT);

SELECT * FROM tasks;

INSERT INTO tasks(title, priority)
VALUES ('Learn Python', 1);

INSERT INTO tasks(title, priority)
VALUES ('Learn Streamlit', 1);

INSERT INTO tasks(title, DESCRIPTION)
VALUES ('한글', 1);

SELECT * FROM tasks;

-- P.73 다중행 추가 INSERT
INSERT INTO tasks(title, priority)
VALUES
	('Learn AWS', 1)
    ,('Learn Python', 2)
    ,('Learn R', 4)
;

INSERT INTO tasks(title, priority)
VALUES
	('Starcraft', 1)
    ,('Warcraft3', 2)
    ,('LostArk', 3)
    ,('BladeSoul', 4)
;

SELECT * FROM tasks;

-- 날짜 추가
INSERT INTO tasks(title, start_date, due_date)
VALUES
	('Learn', '2023-10-05', '2023-10-05')
;

INSERT INTO tasks(title, start_date, due_date)
VALUES
	('Learn DELETE', CURRENT_DATE(), CURRENT_DATE())
; -- CURRENT_DATE() 오늘 날짜 불러오는 함수
    
SELECT * FROM tasks;

CREATE TABLE IF NOT EXISTS notion (
	task_id INT AUTO_INCREMENT
    , title VARCHAR(255) NOT NULL
    , start_date DATE
    , due_date DATE
    , priority TINYINT NOT NULL DEFAULT 3
    , DESCRIPTION TEXT
    , PRIMARY KEY (task_id)
)
;

SELECT * FROM notion;

INSERT notion(title, priority)
VALUES
	('Stacraft', 1)
    , ('Warcraft', 2)
    , ('LostArk', 3)
;

-- [DELETE]
DELETE FROM tasks WHERE task_id = 1;

SELECT * FROM tasks;

DELETE FROM tasks WHERE title = "Learn Oracle";

DELETE FROM tasks WHERE start_date = '2023-10-05';
SELECT * FROM tasks;

-- start_date = DATE('2023-10-05')
DELETE FROM tasks WHERE start_date = DATE('2023-10-05');

DELETE FROM tasks WHERE start_date = '2023-10-05';
SELECT * FROM tasks;

SHOW VARIABLES LIKE 'sql_safe_updates';
SET sql_safe_updates = 0;

-- 주석 처리하여 현재 설정 확인
-- SHOW VARIABLES LIKE 'sql_safe_updates';

-- 주석 처리하여 안전한 업데이트 모드 비활성화
-- SET sql_safe_updates = 0;

-- 다시 주석 처리하여 변경 내용 저장
-- SET sql_safe_updates = 1; -- 이렇게 하면 다시 안전한 업데이트 모드를 활성화할 수 있습니다.

-- 날짜 추가, COMMIT ROLLBACK
-- start_date = DATE('2023-10-05')
INSERT INTO tasks(title, start_date, due_date)
VALUES
	('Learn INSERT', '2023-10-03', '2023-10-04')
;

INSERT INTO tasks(title, start_date, due_date)
VALUES ('Learn DELETE', CURRENT_DATE(), CURRENT_DATE())
;

SELECT * FROM tasks;

-- [Update]
SELECT * FROM tasks WHERE task_id = 5;

UPDATE tasks
SET priority = 10
WHERE task_id = 5;

SELECT * FROM tasks;

UPDATE tasks
SET priority = 11
WHERE task_id = 4;

-- task_id 8, due_date = 10월 5일, priority = 5
UPDATE tasks
SET
	start_date = CURRENT_DATE()
    , due_date = DATE('2023-10-06')
    , priority = 5
WHERE task_id = 8;

SELECT * FROM tasks;

-- Create New Table Name products
CREATE TABLE IF NOT EXISTS products (
	상품번호 INT AUTO_INCREMENT
    , 카테고리 VARCHAR(255) NOT NULL
    , 색상 VARCHAR(255) NOT NULL
    , 성별 VARCHAR(255) NOT NULL
    , 사이즈 VARCHAR(255) NOT NULL
    , 원가 INT
    , PRIMARY KEY (상품번호)
)
;

SELECT * FROM products;

INSERT INTO products (상품번호, 카테고리, 색상, 성별, 사이즈, 원가)
VALUES
	(1, '트레이닝', 'red', 'f', 'xs', 30000)
    , (2, '라이프스타일', 'white', 'm', 'm', 60000)
;

-- Procedure는 트리거 등 일종의 사용자 정의 함수 !
-- PL/SQL이라는 개념을 알고 있어야 한다!
DELIMITER $$
CREATE PROCEDURE mulcamp.GetTasks()
BEGIN
	SELECT *
    FROM tasks
    ORDER BY task_id;
END $$
DELIMITER $$

CALL mulcamp.GetTasks();

-- [VIEW]
DROP VIEW tasksView;

CREATE VIEW tasksView
AS
SELECT *
FROM tasks
WHERE task_id = 4;

SELECT * FROM tasksView;