## 함수
def openBox() :
    global count
    print('상자를 열기~~~')
    count -= 1
    if (count == 0) :
        print('**선물 넣기**')
        return
    openBox()
    print('상자를 닫기###')

## 메인
count = 10
openBox()