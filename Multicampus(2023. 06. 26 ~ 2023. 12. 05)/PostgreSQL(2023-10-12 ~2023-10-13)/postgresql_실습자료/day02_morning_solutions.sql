DROP table if exists retail_sales;
CREATE table retail_sales
(
   sales_month date
  , naics_code varchar
  , kind_of_business varchar
  , reason_for_null varchar
  , sales decimal
);

-- CSV 파일에서 데이터를 읽어 테이블에 채워넣습니다.
-- 본인이 다운로드 한 CSV 파일의 경로로 수정하세요
-- C:\backup> psql -U postgres -d human -c "\copy retail_sales FROM 'us_retail_sales.csv' delimiter ',' csv HEADER;"
-- postgres 사용자의 암호:
-- COPY 22620
-- 데이터 출처 : Census.gov / 월간 소매업 거래 보고서 Monthly Retail Trade Report 데이터셋

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


SELECT * FROM retail_sales;

-- 트렌드 분석
-- 미국 전체 소매업과 외식업의 매출 트렌드 검토하기
SELECT 
	sales_month
	, sales
FROM retail_sales
WHERE kind_of_business = 'Retail and food services sales, total'
ORDER BY 1;

-- 노이즈 제거하여 패턴을 더 명확히 파악한다. 
-- 2009년 소매업 외식업은 하락함 (금융위기)
SELECT 
	date_part('year', sales_month) AS sales_year
	, sum(sales) AS sales
FROM retail_sales
WHERE kind_of_business = 'Retail and food services sales, total'
GROUP BY 1
ORDER BY 1;

-- 요소 비교
-- 서점업(Book stores), 스포츠 용품업(Sporting goods stores), 취미/장난감/게임업(Hobby, toy, and game stores)
-- 연간 매출 트렌드 비교 
SELECT 
	date_part('year', sales_month) AS sales_year
	, kind_of_business
	, sum(sales) AS sales 
FROM retail_sales
WHERE kind_of_business in ('Book stores', 'Sporting goods stores', 'Hobby, toy, and game stores')
GROUP BY 1, 2
ORDER BY 1, 2;

-- 업종별 월간 트렌드를 확인하는 코드 
-- 여성 의류업 매출이 남성 의류업 매출보다 훨씬 큼
-- 2020년에는 코로나 여파로 매출 하락 
SELECT 
	sales_month
	, kind_of_business
	, sales
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
ORDER BY 1, 2;

-- 연별로 다시 집계한다. 
-- 매출 차이는 매년 동일하지 않음
-- 여성 의류업의 경우 금융위기 때 매출이 잠시 감소
-- 2020년에는 코로나 19로 모두 감소
SELECT 
	date_part('year', sales_month) AS sales_year
	, kind_of_business
	, sum(sales) AS sales
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
GROUP BY 1, 2
ORDER BY 1, 2;

-- 두 업종간 매출 차이, 비율, 비율 차이를 계산
-- 2009년, 여성 의류업 매출은 남성 의류업 매출보다 287억만큼 크다. 
-- 피벗 수행
SELECT 
	date_part('year', sales_month) AS sales_year
	, sum(CASE WHEN kind_of_business = 'Women''s clothing stores' THEN sales END) AS women_sales
	, sum(CASE WHEN kind_of_business = 'Men''s clothing stores' THEN sales END) AS mens_sales
FROM retail_sales 
WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
GROUP BY 1
ORDER BY 1;

-- 위 코드를 FROM 절 이하 서브쿼리로 활용한다. 
SELECT 
	sales_year
	, women_sales - mens_sales AS womens_minus_mens
	, mens_sales - women_sales AS mens_minus_womens
FROM (SELECT 
		date_part('year', sales_month) AS sales_year
		, sum(CASE WHEN kind_of_business = 'Women''s clothing stores' THEN sales END) AS women_sales
		, sum(CASE WHEN kind_of_business = 'Men''s clothing stores' THEN sales END) AS mens_sales
	  FROM retail_sales 
	  WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
	  GROUP BY 1) a
	  ORDER BY 1;

-- 서브쿼리 없이 구하기
-- 여성 의류업 매출에서 남성 의류업 매출을 뺀 값을 구한다. 
SELECT 
	date_part('year', sales_month) AS sales_year
	, sum(CASE WHEN kind_of_business = 'Women''s clothing stores' THEN sales END) - sum(CASE WHEN kind_of_business = 'Men''s clothing stores' THEN sales END) AS womens_sales
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
GROUP BY 1
ORDER BY 1;


-- 두 업종의 비율을 구한다. 
-- 남성 의류업 매출을 분모로 / 여성 의류업 매출을 분자로 하여 비율 구한다. 
-- 남성 의류업 대비 여성 의류업의 연간 매출 비율
-- 서브쿼리 활용
-- 2009년, 여성 의류업 매출은 남성 의류업 매출의 4.9배다.
SELECT 
	sales_year
	, women_sales / mens_sales AS womens_times_of_mens
FROM (SELECT 
		date_part('year', sales_month) AS sales_year
		, sum(CASE WHEN kind_of_business = 'Women''s clothing stores' THEN sales END) AS women_sales
		, sum(CASE WHEN kind_of_business = 'Men''s clothing stores' THEN sales END) AS mens_sales
	  FROM retail_sales 
	  WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
	  GROUP BY 1) a
	  ORDER BY 1;

-- 두 업종의 비율 차이
-- 2009년, 여성 의류업 매출은 남성 의류업 매출의 390% 만큼 크다.
SELECT 
	sales_year
	, (women_sales / mens_sales - 1) * 100 AS womens_pct_of_mens
FROM (SELECT 
		date_part('year', sales_month) AS sales_year
		, sum(CASE WHEN kind_of_business = 'Women''s clothing stores' THEN sales END) AS women_sales
		, sum(CASE WHEN kind_of_business = 'Men''s clothing stores' THEN sales END) AS mens_sales
	  FROM retail_sales 
	  WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
	  GROUP BY 1) a
	  ORDER BY 1;
	  
-- 전체 대비 비율 계산
-- SELF-JOIN 동일한 테이블에 JOIN을 수행함을 의미함. 
-- 월간 전체 매출 대비 업종별 매출 비율 구하기

SELECT 
	sales_month
	, kind_of_business
	, sales * 100 / total_sales AS pct_total_sales 
FROM (
	SELECT 
		a.sales_month
		, a.kind_of_business
		, a.sales
		, sum(b.sales) AS total_sales
	FROM retail_sales a
	JOIN retail_sales b on a.sales_month = b.sales_month 
	and b.kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
	WHERE a.kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
	GROUP BY 1,2,3
) aa
ORDER BY 1,2;

-- 윈도우 함수를 활용한 방법
SELECT 
	sales_month
	, kind_of_business
	, SUM(sales) OVER (PARTITION BY sales_month) AS total_sales
	, sales * 100 / SUM(sales) OVER (PARTITION BY sales_month) AS pct_total
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
ORDER BY 1, 2;

-- 여성 의류업 매출 비율은 1990년대 후반부터 증가
-- 남성 의류업 매출은 뚜렷한 계절성 (12월 1월 크게 오름)
-- 2010년대 후반에는 패턴이 거의 사라짐


-- 업종별 연 매출 대비 월간 매출 비율
SELECT 
	sales_month
	, kind_of_business
	, sales * 100 / yearly_sales AS pct_yearly
FROM (
	SELECT a.sales_month, a.kind_of_business, a.sales, sum(b.sales) AS yearly_sales
	FROM retail_sales a
	JOIN retail_sales b ON date_part('year', a.sales_month) = date_part('year', b.sales_month)
		AND a.kind_of_business = b.kind_of_business
		AND b.kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
	WHERE a.kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
	GROUP BY 1, 2, 3
) aa
ORDER BY 1, 2;

-- 윈도우 함수 활용
-- 1월에는 남성 의류 매출 비율 > 여성 의류 매출 비율
-- 7월에는 여성 의류 매출 비율 > 남성 의류 매출 비율
SELECT 
	sales_month
	, kind_of_business
	, sales
	, SUM(sales) OVER (PARTITION BY date_part('year', sales_month), kind_of_business) AS yearly_sales
	, sales * 100 / SUM(sales) OVER (PARTITION BY date_part('year', sales_month), kind_of_business) AS pct_yearly
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
	AND sales_month >= '2019-01-01'
ORDER BY 1, 2;

-- 인덱싱으로 시계열 데이터 변화 이해
-- 인덱싱 지표의 대표적인 예 : CPI (Consumer Price Index), 소비자 물가 지수, 인플레이션 측정 시 활용
-- 기본 전제는 베이스 구간 선택, 다음 구간마다 비율 변화 계산
-- 예시, 
-- 1992년 기준으로 여성 의류업 매출을 인덱싱한다. 
-- 1992년의 값이 인덱스로 정확하게 설정됨. 
SELECT 
	sales_year
	, sales
	, first_value(sales) OVER (ORDER BY sales_year) AS index_sales
FROM (
	SELECT 
	date_part('year', sales_month) AS sales_year
	, SUM(sales) AS sales 
	FROM retail_sales
	WHERE kind_of_business = 'Women''s clothing stores'
	GROUP BY 1
) a;

-- 이 베이스 구간을 기준으로 비율 변화를 알아본다. 
-- 비율은 양수가 될 수도 있고, 음수도 될 수 있다. 
SELECT 
	sales_year
	, sales
	, (sales / first_value(sales) OVER (ORDER BY sales_year) - 1) * 100 AS pct_from_index
FROM (
	SELECT 
		date_part('year', sales_month) AS sales_year
		, sum(sales) AS sales
	FROM retail_sales
	WHERE kind_of_business = 'Women''s clothing stores'
	GROUP BY 1
) a;

-- 1992년 매출 기준으로 인덱싱된 남성 의류업 매출과 여성 의류업 매출 변화를 작성한다. 
-- 남성 의류업 매출은 1992년에 최고점을 찍고 떨어지기 시작
-- 여성 의류업 배출은 2003년에 원점 회복, 그 이후 계속 상승
-- 원인 파악 필요
SELECT 
	sales_year
	, kind_of_business
	, sales
	, (sales / first_value(sales) OVER (PARTITION BY kind_of_business ORDER BY sales_year) - 1) * 100 as pct_from_index
FROM (
	SELECT
		date_part('year', sales_month) AS sales_year
		, kind_of_business
		, SUM(sales) AS sales
	FROM retail_sales
	WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
		AND sales_month <= '2019-12-31'
	GROUP BY 1, 2
) a	
ORDER BY 1, 2;

-- 시간 윈도우 롤링 (Rolling Time Window)
-- 이동 계산(Moving Calculation)
-- 주가 분석, 거시경제 트렌드, 시청률 조사 등 다양한 분석에 두루 사용
-- Last Twelve Months(LTM), Trailing Twelve Months(TTM), Year-To-Date(YTD) 등 
-- 12개월을 한 윈도우 구간으로 설정해 1년 매출 단위로 롤링한다. 
-- 12개월 기준으로 이동 평균의 매출을 계산한다. 
-- 데이터에서 시작날짜는 2019년 12월로 한다. 
SELECT
	a.sales_month
	, a.sales
	, b.sales_month as rolling_sales_month
	, b.sales as rolling_sales
	
-- 닻 역할을 수행해 윈도우의 기준이 되는 날짜를 가져옴
FROM retail_sales a 

-- 이동 평균을 계산할 월 매출 12개를 가져옴. 
JOIN retail_sales b on a.kind_of_business = b.kind_of_business
	AND b.sales_month between a.sales_month - interval '11 months'
	AND a.sales_month
	AND b.kind_of_business = 'Women''s clothing stores'
WHERE a.kind_of_business = 'Women''s clothing stores'
	AND a.sales_month = '2019-12-01';
	
-- avg 집계 함수를 사용해 평균을 구한다. 
-- b 테이블에 레코드의 갯수(records_count)를 반환한 이유는 
--- 각 행이 12개 레코드의 평균을 계산한 것이 맞는지 확인하기 위함
-- 2003년부터 2007년까지 증가하다가 2011년까지 잠시 감소하는 변화가 눈에 뛴다. 
-- 매출은 2020년 초반에 급락했다가, 2020년 후반에 다시 회복, 그러나 빠르게 반영하지 못하는 것으로 나타남. 

SELECT
	a.sales_month
	, a.sales
	, AVG(b.sales) AS moving_avg
	, COUNT(b.sales) AS records_count
FROM retail_sales a
JOIN retail_sales b on a.kind_of_business = b.kind_of_business
	AND b.sales_month between a.sales_month - interval '11 months'
	AND a.sales_month
	AND b.kind_of_business = 'Women''s clothing stores'
WHERE a.kind_of_business = 'Women''s clothing stores'
	AND a.sales_month >= '1993-01-01'
GROUP BY 1, 2
ORDER BY 1;

-- 윈도우 함수의 FRAME 절
-- 이동 평균을 윈도우 함수를 사용해 더 짧은 코드로 계산한다. 
SELECT 
	sales_month
	, AVG(sales) OVER (ORDER BY sales_month ROWS BETWEEN 11 PRECEDING and CURRENT ROW) AS moving_avg
	, COUNT(sales) OVER (ORDER BY sales_month ROWS BETWEEN 11 PRECEDING and CURRENT ROW) AS records_count
FROM retail_sales
WHERE kind_of_business = 'Women''s clothing stores';

-- 희소 데이터와 시간 윈도우 롤링
-- 모든 시간 구간에 레코드가 제대로 채워져 있지 않은 데이터
-- 서브쿼리로 1월과 7월의 sales_month 값만 가져와 희소 데이터를 시물레이션 함
SELECT 
	a.date
	, b.sales_month
	, b.sales
FROM date_dim a -- 날짜 차원 테이블
JOIN (
	SELECT 
		sales_month
		, sales
	FROM retail_sales
	WHERE kind_of_business = 'Women''s clothing stores'
		AND date_part('month', sales_month) in (1, 7)
) b ON b.sales_month BETWEEN a.date - INTERVAL '11 months' AND a.date
WHERE a.date = a.first_day_of_month
	AND a.date BETWEEN '1993-01-01' AND '2020-12-01'
ORDER BY 1, 2;

-- 잘못된 쿼리
-- 1월 7월이 될 때까지 계속 동일한 값으로 유지됨
SELECT 
	a.date
	, AVG(b.sales) AS moving_avg
	, COUNT(b.sales) AS records
FROM date_dim a
JOIN (
	SELECT 
		sales_month
		, sales
	FROM retail_sales
	WHERE kind_of_business = 'Women''s clothing stores'
		AND date_part('month', sales_month) in (1, 7)
) b ON b.sales_month BETWEEN a.date - INTERVAL '11 months' AND a.date
WHERE a.date = a.first_day_of_month
	AND a.date BETWEEN '1993-01-01' AND '2020-12-01'
GROUP BY 1
ORDER BY 1;

-- 권장 쿼리
SELECT 
	a.sales_month
	, AVG(b.sales) AS moving_avg
FROM (
	SELECT DISTINCT sales_month
	FROM retail_sales
	WHERE sales_month BETWEEN '1993-01-01' AND '2020-12-01'
) a
JOIN retail_sales b ON b.sales_month BETWEEN a.sales_month - INTERVAL '11 months' 
	AND a.sales_month
	AND b.kind_of_business = 'Women''s clothing stores'
GROUP BY 1
ORDER BY 1;

-- 누적값 계산
-- YTD(Year to Date), QTD(Quater to Date), MTD(Month to Date) 등의 누적값 활용하여 시계열 분석
-- SUM 집계 함수를 사용해 총 YTD를 계산한다.
-- sales_month에서 월 매출 sales와 sales_ytd를 반환함
SELECT 
	sales_month
	, sales
	, SUM(sales) OVER (PARTITION BY date_part('year', sales_month) ORDER BY sales_month) AS sales_ytd
FROM
	retail_sales
WHERE kind_of_business = 'Women''s clothing stores';

-- Self Join으로 위 쿼리 표현하기
SELECT 
	a.sales_month
	, a.sales
	, SUM(b.sales) AS sales_ytd
FROM retail_sales a
JOIN retail_sales b ON date_part('year', a.sales_month) = date_part('year', b.sales_month)
	AND b.sales_month <= a.sales_month
	AND b.kind_of_business = 'Women''s clothing stores'
WHERE a.kind_of_business = 'Women''s clothing stores'
GROUP BY 1, 2;

-- 계절성 분석(Seasonality) : 일정한 간격을 두고 규칙적으로 반복되는 패턴 의미
-- 소매업 매출 데이터, 
-- 예) 귀금속업은 명확한 계절성 패턴을 보임 / 보통 12월
-- 미국기준 서점은 봄학기 개강 시기인 12월 ~ 1월 / 가을학기 개강시기인 8월에 높음
-- 구간 비교(Period Over Period)
-- 전년대비증감률(Year Over Year) / 전월대비증감률(Month Over Month), 전일대비증감률(Day Over Day)
-- lag 함수 활용, 어떻게 출력되는지 확인한다. 
SELECT
	kind_of_business
	, sales_month
	, sales
	, LAG(sales_month) OVER (PARTITION BY kind_of_business ORDER BY sales_month) AS prev_month
	, LAG(sales) OVER (PARTITION BY kind_of_business ORDER BY sales_month) AS prev_month_sales
FROM retail_sales
WHERE kind_of_business = 'Book stores';

-- 이전 값 대비 비율 변화 코드 작성
SELECT 
	kind_of_business
	, sales_month
	, sales
	, (sales / LAG(sales) OVER (PARTITION BY kind_of_business ORDER BY sales_month) - 1) * 100 as pct_growth_from_previous
FROM retail_sales
WHERE kind_of_business = 'Book stores';

-- 연도별로 작성
-- 그러나 데이터셋의 계절성을 분석하기에는 적절하지 않음
SELECT 
	sales_year
	, yearly_sales
	, LAG(yearly_sales) OVER (ORDER BY sales_year) as prev_year_sales
	, (yearly_sales / LAG(yearly_sales) OVER (ORDER BY sales_year) - 1) * 100 as pct_growth_from_previous
FROM (
	SELECT 
		date_part('year', sales_month) AS sales_year
		, SUM(sales) AS yearly_sales
	FROM retail_sales
	WHERE kind_of_business = 'Book stores'
	GROUP BY 1
) a;

-- 구간 비교 : 작년과 올해 비교
SELECT 
	sales_month
	, sales
	, LAG(sales_month) OVER (PARTITION BY date_part('month', sales_month) ORDER BY sales_month) AS prev_year_month
	, LAG(sales) OVER (PARTITION BY date_part('month', sales_month) ORDER BY sales_month) AS prev_year_sales
FROM retail_sales
WHERE kind_of_business = 'Book stores';

-- 전년 대비 매출의 절댓값 차이와 비율 차이를 계산한다. 
-- 2022년 1월에 유독 전년 대비 매출 성장률이 높음
SELECT 
	sales_month
	, sales
	, sales - LAG(sales) OVER (PARTITION BY date_part('month', sales_month) ORDER BY sales_month) AS absolute_diff
	, (sales / LAG(sales) OVER (PARTITION BY date_part('month', sales_month) ORDER BY sales_month) - 1 ) * 100 AS pcf_diff
FROM retail_sales
WHERE kind_of_business = 'Book stores';

-- 1992년 ~ 1994년 월별 피벗 테이블 만들기
-- SUM, MIN, MAX 결과는 동일함
-- CASE WHEN을 쓰기 위한 경우임
SELECT 
	date_part('month', sales_month) AS month_number
	, TO_CHAR(sales_month, 'Month') AS month_name
	, MIN(CASE WHEN date_part('year', sales_month) = 1992 THEN sales END) AS sales_1992
	, MIN(CASE WHEN date_part('year', sales_month) = 1993 THEN sales END) AS sales_1993
	, MIN(CASE WHEN date_part('year', sales_month) = 1994 THEN sales END) AS sales_1994
FROM retail_sales
WHERE kind_of_business = 'Book stores'
	AND sales_month BETWEEN '1992-01-01' AND '1994-12-01'
GROUP BY 1, 2;

-- 다중 구간 비교
-- 현재 월의 매출을 최근 3년간의 동월 데이터와 비교한다. 
SELECT 
	sales_month
	, sales
	, LAG(sales, 1) OVER (PARTITION BY date_part('month', sales_month) ORDER BY sales_month) AS prev_sales_1
	, LAG(sales, 2) OVER (PARTITION BY date_part('month', sales_month) ORDER BY sales_month) AS prev_sales_2
	, LAG(sales, 3) OVER (PARTITION BY date_part('month', sales_month) ORDER BY sales_month) AS prev_sales_3
FROM retail_sales
WHERE kind_of_business = 'Book stores';

-- 최근 3년의 월 매출 평균 대비 올해 월 매출 비율을 계산한다. 
-- 서점업 매출 평균은 1990년대 중반에는 최근 3년대비 높았다가 2010년대 후반에는 다시 감소함. 
SELECT 
	sales_month
	, sales
	, sales / ((prev_sales_1 + prev_sales_2 + prev_sales_3) / 3) * 100 AS pct_of_3_prev
FROM (
	SELECT 
		sales_month
		, sales
		, LAG(sales, 1) OVER (PARTITION BY date_part('month', sales_month) ORDER BY sales_month) AS prev_sales_1
		, LAG(sales, 2) OVER (PARTITION BY date_part('month', sales_month) ORDER BY sales_month) AS prev_sales_2
		, LAG(sales, 3) OVER (PARTITION BY date_part('month', sales_month) ORDER BY sales_month) AS prev_sales_3
	FROM retail_sales
	WHERE kind_of_business = 'Book stores'
) a;

-- FRAME 절을 사용하여 구해보기
-- 최근 3년의 값이 모두 NULL이 아닌 경우에만 정상적으로 계산함. 
-- 따라서, 위 결과는 NULL이 하나 있기 때문에, NULL이고, 이번 쿼리는 아님.
SELECT 
	sales_month
	, sales
	, sales / AVG(sales) OVER (PARTITION BY date_part('month', sales_month) ORDER BY sales_month ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) * 100 AS pct_of_prev_3
FROM retail_sales
WHERE kind_of_business = 'Book stores';