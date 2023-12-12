## 함수 선언부

## 전역 변수부
katok = ['다현', '정연', ' 쯔위', '사나', '지효']

## 메인 코드부
print(katok)

## 데이터 추가 (모모에게 카톡 1회)
# 1단계 : 빈칸 추가
katok.append(None)
# 2단계 : 마지막 칸에 데이터 넣기
katok[5] = '모모'
print(katok)

## 데이터 삽입 (미나에게 카톡 40회 연속) --> 미나가 3등
# 1단계 : 빈칸 추가
katok.append(None)
# 2단계 : 한칸씩 옆으로.... (반복)
katok[6] = katok[5]
katok[5] = None
katok[5] = katok[4]
katok[4] = None
katok[4] = katok[3]
katok[3] = None
# 3단계 : 데이터 입력
katok[3] = '미나'
print(katok)

## 데이터 삭제 (사나가 카톡 차단) --> 4등 삭제
# 1단계 : 지우기
katok[4] = None
# 2단계 : 1칸씩 앞으로 이동.. 마지막 친구까지
katok[4] = katok[5]
katok[5] = None
katok[5] = katok[6]
katok[6] = None
# 3단계 : 빈칸 제거
del(katok[6])
print(katok)

katok.append(None)
katok[6] = '선재'
print(katok)