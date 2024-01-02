-- 코호트 분석
-- 분석을 시작하는 시간 기준으로 동일한 특징을 지닌 집단 의미 
-- 시간에 따른 개체 그룹 간 차이를 비교하는 방법
-- 집단 특성과 장기간 트렌드의 상관관계 파악 위한 분석 방법
-- 예) 신규 고객 중 광고를 통해 유입된 고객과 지인 추천으로 접속한 고객은 서로 다른 장기 구매 패턴
-- 코호트 그룹화, 코호트 시계열 데이터, 코호트 행동 집계 지표
-- 데이터셋 미국 의회 입법가
-- https://github.com/unitedstates/congress-legislators

-- 데이터 가져오기 
-- 테이블을 생성합니다.
DROP table if exists legislators;
CREATE table legislators(
	full_name varchar
	, first_name varchar
	, last_name varchar
	, middle_name varchar
	, nickname varchar
	, suffix varchar
	, other_names_end date
	, other_names_middle varchar
	, other_names_last varchar
	, birthday date
	, gender varchar
	, id_bioguide varchar primary key
	, id_bioguide_previous_0 varchar
	, id_govtrack int
	, id_icpsr int
	, id_wikipedia varchar
	, id_wikidata varchar
	, id_google_entity_id varchar
	, id_house_history bigint
	, id_house_history_alternate int
	, id_thomas int
	, id_cspan int
	, id_votesmart int
	, id_lis varchar
	, id_ballotpedia varchar
	, id_opensecrets varchar
	, id_fec_0 varchar
	, id_fec_1 varchar
	, id_fec_2 varchar
);

DROP table if exists legislators_terms;
CREATE table legislators_terms(
	id_bioguide varchar
	, term_number int 
	, term_id varchar primary key
	, term_type varchar
	, term_start date
	, term_end date
	, state varchar
	, district int
	, class int
	, party varchar
	, how varchar
	, url varchar--terms_1_url
	, address varchar
	, phone varchar
	, fax varchar
	, contact_form varchar
	, office varchar
	, state_rank varchar
	, rss_url varchar
	, caucus varchar);

CREATE TABLE date_dim
as
SELECT date::date
,to_char(date,'yyyymmdd')::int as date_key
,date_part('day',date)::int as day_of_month
,date_part('doy',date)::int as day_of_year
,date_part('dow',date)::int as day_of_week
,trim(to_char(date, 'Day')) as day_name
,trim(to_char(date, 'Dy')) as day_short_name
,date_part('week',date)::int as week_number
,to_char(date,'W')::int as week_of_month
,date_trunc('week',date)::date as week
,date_part('month',date)::int as month_number
,trim(to_char(date, 'Month')) as month_name
,trim(to_char(date, 'Mon')) as month_short_name
,date_trunc('month',date)::date as first_day_of_month
,(date_trunc('month',date) + interval '1 month' - interval '1 day')::date as last_day_of_month
,date_part('quarter',date)::int as quarter_number
,trim('Q' || date_part('quarter',date)::int) as quarter_name
,date_trunc('quarter',date)::date as first_day_of_quarter
,(date_trunc('quarter',date) + interval '3 months' - interval '1 day')::date as last_day_of_quarter
,date_part('year',date)::int as year 
,date_part('decade',date)::int * 10 as decade
,date_part('century',date)::int as centurys
FROM generate_series('1770-01-01'::date, '2020-12-31'::date, '1 day') as date
;

-- 리턴션 분석(Retention Analysis)
-- 무언가를 계속 유지 또는 지속하는 것
-- 리텐션 분석에서는 코호트 크기(구독자 수, 직원 수, 소비 금액 )가 시간이 흐를수록 유지되는지, 감소하는지, 증가하는지 확인한다. 
-- 기본 리텐션 계산하기 
-- 코호트 멤버는 의원, 시계열 데이터는 각 의원의 임기, 집계 연산은 시작 날짜부터 구간별로 재임 중인 의원 수
-- 코드

-- 위 쿼리를 서브쿼리로 사용
-- 연도를 period의 값으로 사용한 이유 : 의원 선거 주기가 2년 또는 6년임
-- COUNT 함수를 사용해 계산한 cohort_retained는 각 구간마다 재임 중의 의원 수 의미
-- 코드

-- 구간별로 재임 중의 의원수를 계산한 후, 전체 cohort_size를 구해 새로운 열로 추가
-- 첫 구간 대비 구간별 코호트 크기 비율이 나옴
-- 그래프로 그려보면, 결국에는 아주 오래 재임한 의마저 오래 모두 사망
-- 또는 은퇴해 아무도 남지 않게 됨
-- 코드

-- 코호트 리텐션 결과를 표 형식으로 정리해 출력
-- 처음 몇 년간의 리텐션 비율은 들쭉날쭉함. 
-- 하원의원은 임기가 2년, 상원의원은 임기가 6년
-- 조금 더 구체적으로 주기를 맞춰서 리텐션 분석을 수행한다. 
-- 코드
	
-- 시계열을 조절해 리텐션 정확도 향상하기 
-- 시계열 데이터 다룰 시, 데이터가 현재를 정확하게 반영하는지, 각 시간 구간에서 손실된 개체는 없는지 확인
-- 현재, 입법가 데이터셋에 의원의 임기 시작 날짜는 저장,
-- 2년 또는 6년과 같이 의원직을 수행할 자격이 부여된 "기간"에 대한 데이터가 손실된 상태
-- 결측 값 채우고, 종료 날짜가 없는 것도 임의로 설정하는 방법도 확인
-- 코드

-- 임기가 1월에 시작해 12월 31일까지 무려 11개월 넘게 유지 되어도
-- 다음 해로 넘어가지 않았다면 period는 0이다. 

-- 이제 새로 계산한 재임 연도를 구간으로 삼아 id_bioguide의 갯수를 세고 cohort_retained 계산
-- period의 값이 NULL인 경우 coalesce 함수 사용해 기본값을 0으로 설정
-- 아래 예시를 통해 Coalesce 함수를 이해한다. 
DROP TABLE IF EXISTS items;
CREATE TABLE items (
	ID serial PRIMARY KEY,
	product VARCHAR (100) NOT NULL,
	price NUMERIC NOT NULL,
	discount NUMERIC
);

INSERT INTO items (product, price, discount)
VALUES
	('A', 1000 ,10),
	('B', 1500 ,20),
	('C', 800 ,5),
	('D', 500, NULL);
	
SELECT * FROM items;
SELECT
	product,
	(price - discount) AS net_price
FROM
	items;

SELECT
	product,
	(price - COALESCE(discount,0)) AS net_price
FROM
	items;
	
-- 
SELECT
	product,
	(
		price - CASE
		WHEN discount IS NULL THEN
			0
		ELSE
			discount
		END
	) AS net_price
FROM
	items;
	
-- 12월 31일을 기준, 의원별 재임 연도를 date 필드에 출력
-- 재임 연도를 구간으로 삼아 id_bioguide의 갯수를 세고, cohort_retained 계산한다. 
-- 코드

-- first_value 윈도우 함수를 사용한 방법으로 코호트의 크기(Cohort Size)와 리텐션 비율(pct_retained)을 구한다. 
-- 임기가 2년 또는 6년이므로 의원들은 대부분 선출 다음 해인 1번 구간까지 재임함
-- 2번 구간부터 그래프가 급락하는 이유는 재선에 실패 또는 도전하지 않는 사람이 많기 때문
-- 코드

-- 데이터셋에 종료 날짜 데이터가 없을 때 대신하는 방법 
-- 서비스 구독 기간이나 의원 임기처럼 분석하려는 이벤트의 유지 기간
-- CASE문 사용해, 상원의원 및 하원의원 임기를 각각 6년, 2년
-- 단, 정해진 임기를 다 채운다고 가정하므로, 의원이 사망하거나 다른 자리에 임명돼 정해진 임기를 다 채우지 못하는 경우를 고려하지 못할 수 있다. 
-- 코드

-- 다음 시작 날짜에서 하루를 뺀 값을 종료 날짜로 사용 
-- 시작 날짜인 term_start에 lead를 사용해 바로 다음 행(다음 임기 시작 날짜)의 값을 가져오고 하루를 빼서 종료 날짜로 사용
-- 코드

-- 시계열 데이터에서 코호트 분석하기 
-- 개체를 코호트로 나누는 방법
-- 개체가 처음 등장한 날짜를 기준으로 하는 시간 기반 코호트를 알아본다. 
-- 시간 이외의 속성을 기반으로 한 코호트를 만드는 방법을 살펴본다. 
-- 연도 기준 코호트를 계산하기 위해 period와 cohort_retained를 반환하는 쿼리에 앞서 사용한 first_term 연도 값을 가져오는 코드를 추가함. 
-- 코드

-- 위 쿼리를 서브쿼리로 활용하여, cohort_size와 pct_retained를 계산함. 
-- 서브쿼리의 결과 데이터셋 전체에서 FIRST_VALUE를 계산하지 않고 PARTITION BY first_year 기준으로 나눠진 파티션별로 first_value를 계산함
-- 코드


-- 위 결과는 시작 연도를 200개 이상 포함한다. 
-- 따라서 first_term에서 연도보다 조금 더 큰 Interval인 'century'로 계산한다. 
-- 1700년 ~ 1799년 18세기, 19세기, etc
-- 코드

-- 코호트는 첫 임기 시작 날짜뿐 아니라 테이블에 저장된 시계열의 다른 속성 기준으로 나눔
-- legislators_terms 테이블에서 state 필드는 각 의원이 담당하는 주 의미
-- state 속성 기준으로 코호트 나눌 시, 의원이 두 개 이상의 주에서 의원직을 수행하더라도, 첫 임기를 수행한 state에 소속되도록 분석
-- 의원별로, 첫 임기를 수행한 주를 찾는 데 first_value 윈도우 함수 사용
-- 코드

-- 위 쿼리를 리텐션 코드에 붙여 넣어 리텐션 구한다. 
-- 코드

-- 다른 테이블에 저장된 속성으로 코호트 분석하기 
-- 의원의 성별이 리텐션과 관련이 있는지 확인
-- 이번에는 legislators 테이블의 gender 필드에 저장된 의원의 성별로 코호트를 나누고 리텐션 분석을 한다. 
-- 남성 의원수가 여성 의원수보다 훨씬 더 많음
-- 코드

-- 성별 차이에 따른 리텐션 비율 비교 
-- 코드

-- 구간 2 ~ 29구간 여성 입법가의 리텐션이 남성보다 높음. 
-- 더 정확한 분석 위해 여성 의원도 활동한 기간만을 first_term으로 가져와서 분석
-- 최소 20년 이상의 연임 여부까지 분석 위해 2000년 이전에 임기를 시작한 의원의 데이터만 가져옴
-- 수정된 코호트 분석
-- 남성 의원이 여성 의원보다 많지만 앞선 결과보다는 차이가 줄어듬
-- 코드

-- 생존 분석
-- 생본 분석은 고객 이탈이나 탈퇴 같은 특정 이벤트가 발생하기까지의 기간 등을 파악하는 데 활용
-- 생존 분석에서는 해당 구간 및 그 이후 구간 내 지속적인 개체 존재 여부가 중요
-- 예) 게임에서 일주일 이상 살아남은 플레이어의 비율을 구할 때, 일주일이 지난 뒤에도 액션이 발생했다면, 여전히 살아 있는 것. 
-- 구간 길이는 개체의 평균 수명 주기 또는 일반 수명 주기를 고려해 선택, 
-- 첫 임기 시작일로부터 10년이 지난 후에도 재임한 의원의 비율을 계산한다. 
-- 코드

-- 첫 임기 시작부터 마지막 임기 종료까지의 기간 tenure를 구한다. 
-- 코드

-- COUNT 함수로 세기의 의원 수 cohort_size를 계산하고 CASE문으로 첫 임기 시작일로부터 
-- 10년 뒤에도 재임한 의원 수를 계산함
-- 살아 남은 의원의 비율 pct_survived_10 계산
-- 코드

-- 세기별로 5회 이상 재임한 의원의 비율을 계산한다. 
-- 서브쿼리에서 COUNT 함수를 사용해 의원별 전체 재임 횟수 계산 
-- 외부쿼리에서 5회 이상 재임한 입법가 수를 전체 cohort_size로 나눠 pct_survived_5_terms 계산 
-- 코드

-- 세기마다 최대 20회까지의 재임 횟수별 생존자 수 계산하기
-- generate_series 함수를 사용해 1~20까지의 정수를 반환하는 서브쿼리에 카티션 JOIN을 수행함. 
-- 생존 분석은 20세기에 가장 높은 것으로 나타남
-- 코드

