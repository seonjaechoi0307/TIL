## 함수 선언
def add_data(friend) : # 데이터 추가
    # 1단계 : 빈칸 추가
    katok.append(None)
    kLen = len(katok)
    # 2단계 : 데이터 입력
    katok[kLen-1] = friend

def insert_data(position, friend) : # 데이터 삽입
    # 1단계 : 빈칸 추가
    katok.append(None)
    kLen = len(katok)
    # 2단계 : 한칸씩 옆으로.... (반복)
    for i in range(kLen-1, position, -1): #핵심! 어려움
        katok[i] = katok[i-1]
        katok[i-1] = None
    # 3단계 : 데이터 입력
    katok[position] = friend

def delete_data(position): # 데이터 삭제
    # 1단계 : 지우기
    katok[position] = None
    kLen = len(katok)
    print(kLen)
    # 2단계 : 한칸씩 당기기.... (반복)
    for i in range(position+1, kLen, 1): #핵심 !
        katok[i-1] = katok[i]
        katok[i] = None
    # 3단계 : 마지막칸을 제거
    del(katok[kLen-1])

if __name__ == "__main__":ㅇ
    
    while(select != 4):
        
        select = int(input("선택하세요(1:추가,2:삽입,:3:삭제,4:종료)-->"))

        if(select == 1):
            data=input("추가할 데이터-->")
            add_data(data)
            print(katok)
        elif (select == 2):
            pos = int(input("삽입할 위치-->"))
            data = input("추가할 데이터--> ")
            insert_data(pos, data)
            print(katok)
        elif (select == 2):
            pos = int(input("삭제할 위치-->"))
            delete_data(pos)
            print(katok)
        elif(select == 4):
            print(katok)
            exit
        else:
            print("1~4 중 하나를 입력하세요.")
            continue

## 전역 변수
katok = []

## 메인 코드
add_data('다현')
add_data('정현')
add_data('쯔위')
add_data('사나')
add_data('지효')
print(katok)

add_data('모모')
print(katok)

insert_data(3, '미나')
print(katok)

delete_data(4)
print(katok)