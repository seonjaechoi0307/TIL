USE mulcamp;

-- 테이블 생성 
CREATE TABLE IF NOT EXISTS tasks (
	task_id INT AUTO_INCREMENT
    , title VARCHAR(255) NOT NULL
    , start_date DATE 
    , due_date DATE 
    , priority TINYINT NOT NULL DEFAULT 3 
    , DESCRIPTION TEXT 
    , PRIMARY KEY (task_id)
);

-- 교재 p.72 문법 확인 
INSERT INTO tasks(title, priority)
VALUES ('Learn MySql', 1);

-- [SELECT]
SELECT * FROM tasks;

INSERT INTO tasks(title, priority)
VALUES ('Learn Oracle', DEFAULT);

SELECT * FROM tasks;

-- 다중행 추가 INSERT 
INSERT INTO tasks(title, priority)
VALUES
	('Learn AWS', 1), 
    ('Learn Python', 2), 
    ('Learn R', 4);

SELECT * FROM tasks;

-- 날짜 추가
INSERT INTO tasks(title, start_date, due_date)
VALUES ('Learn INSERT', '2023-10-05', '2023-10-05');

INSERT INTO tasks(title, start_date, due_date)
VALUES ('Learn DELETE', CURRENT_DATE(), CURRENT_DATE());

SELECT * FROM tasks;

-- [DELETE]
DELETE FROM tasks WHERE task_id = 1;
SELECT * FROM tasks;

DELETE FROM tasks WHERE title = "Learn AWS";
SELECT * FROM tasks;

-- start_date = DATE('2023-10-05')
DELETE FROM tasks WHERE start_date = "2023-10-05";
SELECT * FROM tasks;

-- 날짜 추가, COMMIT, ROLLBACK 
INSERT INTO tasks(title, start_date, due_date)
VALUES ('Learn INSERT', '2023-10-03', '2023-10-04');

INSERT INTO tasks(title, start_date, due_date)
VALUES ('Learn DELETE', CURRENT_DATE(), CURRENT_DATE());


SELECT * FROM tasks;

-- [Update] p.75 
SELECT * FROM tasks WHERE task_id = 5;

UPDATE tasks
SET priority = 10 
WHERE task_id = 5;

SELECT * FROM tasks;

-- task_id 8, due_date = 10.5, priority = 5 
UPDATE tasks
SET
	due_date = Date('2023-10-05')
    , priority = 5
WHERE task_id = 8;

SELECT * FROM tasks;

-- 10분 시간 활용 (~35분 까지)
-- 새로운 가상 테이블 생성 (여러분 임의대로 만들어보세요!)
-- 테이블 생성, 추가, 삭제, 수정 한번씩 생각나는대로 적용

-- Procedure, 트리거 등 일종의 사용자 정의함수! 
-- PL/SQL이라는 개념을 알고 있어야 한다! 
DELIMITER $$ 
CREATE PROCEDURE mulcamp.GetTasks()
BEGIN 
	SELECT * 
    FROM tasks
    ORDER BY task_id;
END $$ 
DELIMITER ;

CALL mulcamp.GetTasks();

-- [VIEW]
DROP VIEW tasksView;
CREATE VIEW tasksView 
AS 
SELECT * 
FROM tasks
WHERE task_id = 4;

SELECT * FROM tasksView;