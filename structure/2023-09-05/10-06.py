## 함수
def countDown(n) :
    if n == 0 :
        print('발사 !!')
    else :
        print(n)
        countDown(n-1)

def printStar(n) :
    if n > 0 :
        printStar(n-1)
        print('★' * n)

## 메인
countDown(5)

printStar(5)