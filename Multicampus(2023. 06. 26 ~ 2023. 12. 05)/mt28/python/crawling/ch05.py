# 네이버 증권 삼성전자 일별시세
# 날짜 종가 전일비 시가 고가 저가 거래량
# 날짜: Date = span.tah.p10.gray03
# 종가: Closing Price = CP = tah p11
# 전일비: Price Change from Previous Day = PCPD
# 시가: Opening Price = OP
# 고가: Highest Price = HP
# 저가: Lowest Price = LP
# 거래량: Volume (Trading Volume) = TV

import requests
import pandas as pd
from bs4 import BeautifulSoup
from fake_useragent import UserAgent

def crawler(url, com_code):
  url = url + com_code
  ua = UserAgent()
  headers = { 'user-agent': ua.ie }
  response = requests.get(url, headers=headers)
  soup = BeautifulSoup(response.content, "html.parser")
  return url, soup

def getLastPage(soup):
  # 여기가 핵심 포인트
  last_page = int(soup.select_one('td.pgRR').a['href'].split('=')[-1])
  return last_page

def getData(url, com_code, soup, page):
    df = None
    count = 0
    for page in range(1, page + 1):
      headers = { 'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36' }
      req = requests.get(f'{url}&page={page}', headers=headers)
      # 테이블이 있는  html은 매우 다행스럽게도 매우 쉽게 접근이 가능하다.
      # read_html 메서드를 활용한다.
      df = pd.concat([df, pd.read_html(req.text, encoding = "euc-kr")[0]], ignore_index=True)
      if count > 10:
        break
      count += 1
    data = df.dropna().reset_index(drop=True)
    return data

def main():
    url = "https://finance.naver.com/item/sise_day.nhn?code="
    com_code = '005930' # 삼성전자 다른 종목을 이용할 때 활용
    com_url, soup = crawler(url, com_code)
    last_page = getLastPage(soup)
    result = getData(com_url, com_code, soup, last_page)
    print(result)
    
if __name__ == "__main__":
    main()