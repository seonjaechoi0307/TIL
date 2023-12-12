# -*- coding:utf-8 -*-
from bs4 import BeautifulSoup

def main():
    # index.html을 불러와서 BeautifulSoup 객체 초기화
    # 웹에서 응답을 할 때, HTML, XML, JSON, 그외 여러가지 방식들이 존재
    soup = BeautifulSoup(open("html/index.html", encoding="utf-8"), "html.parser")
    print(type(soup))
    print(soup.title)
    print(soup.title.string)
    
    fake_str = soup.find('div', class_ = "fakecampus").find('p').get_text()
    print(fake_str[2].get_text())
    
    '''
    fakecampus = soup.find("div", class_="fakecampus")
    print(fakecampus.get_text())
    '''

    print(soup.find("div", class_="fakecampus").get_text())
    
if __name__ == "__main__":
    main()