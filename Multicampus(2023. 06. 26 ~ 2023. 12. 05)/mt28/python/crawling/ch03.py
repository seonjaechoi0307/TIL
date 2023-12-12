# 뮤직 BUGS 순위 차트 리스트 가져오기
import requests
from bs4 import BeautifulSoup
import pandas as pd

def creadDF(result_list):
    result_df = pd.DataFrame({"title" : result_list})
    return result_df

def crawler(soup):
    tbody = soup.find("tbody")
    # print(tbody)
    result = []
    for p in tbody.find_all("p"):
        result.append(p.get_text().replace('\n', ''))
    return result

def main():

    # 요청 url 변수에 담긴 url의 html 문서를 출력한다. 
    custom_header = {
        'user-agent' : 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36'
    }
    
    url = "https://music.bugs.co.kr/chart"
    req = requests.get(url, headers = custom_header)
    soup = BeautifulSoup(req.text, "html.parser")
    result = crawler(soup)
    df = creadDF(result)
    print(df)
    df.to_csv("result.csv", index=False)

if __name__ == "__main__":
    main()