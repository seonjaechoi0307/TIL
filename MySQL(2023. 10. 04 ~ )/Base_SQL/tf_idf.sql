-- calculate td/idf
create or replace view scratch.v_elt_calculate_tf_idf
as
with
  params as (
    select 3 as MIN_TOK, 
    5 as MAX_RNK,
    CURRENT_DATETIME() as added_ts,
    100 as MIN_TF
  ),
  t as ( -- table
    select item_id, review 
    from scratch.reviews
    where status = 'READY'
  ),
  n as ( -- normalize
    select *,
    lower(review) as normalized
    from t
  ),
  tt as ( --token table
    select item_id, token
    from n
      cross join unnest(regexp_extract_all(normalized, r'\w*')) as token
  ),
  bt as ( -- base table
    select *
    from tt
      cross join params
    where
      length(token) > MIN_TOK
  ),
  tf_num as ( -- tf numerator
    select item_id, token, count(1) as item_tok_cnt
    from bt
    group by 1, 2
  ),
  tf_den as ( -- tf denominator
    select item_id, sum(item_tok_cnt) as item_tot_sum
    from tf_num
    group by 1
  ),
  idf_den as ( -- idf denominator
    select token, count(1) tok_cnt
    from bt
    group by 1
  ),
  idf_num as ( -- idf numerator
    select sum(tok_cnt) tok_cnt_sum
    from idf_den
  ),
  idf as (
    select token, ln(tok_cnt_sum / tok_cnt) as idf_score
    from idf_den 
      cross join idf_num
      cross join params
    where tok_cnt > params.MIN_TF
  ),
  tf_idf as (
    select
      tf_num.item_id, tf_num.token, 
      (tf_num.item_tok_cnt / tf_den.item_tot_sum) 
        * idf_score as score
    from tf_num 
      inner join tf_den using (item_id)
      inner join idf using (token)
  ),
  tf_idf_rnk as (
    select *, 
      dense_rank() over(partition by item_id order by score desc) tf_idf_rnk
    from tf_idf
  ),
  tf_idf_lim as (
    select *
    from tf_idf_rnk
    cross join params
    where tf_idf_rnk.tf_idf_rnk < params.MAX_RNK
  )
  select *
  from tf_idf_lim;