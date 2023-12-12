a = '!@#$%^&*('
b = '\'"<>?:;'
print(a+"\\"+b)

# 문자 개수 세기

# 문자열 모듈 임포트
import string

def solution(my_string):
    
    # 솔루션 정의
    # 알파벳 대소문자로만 이루어진 문자열 my_string이 주어질 때
    # my_string에서 'A'의 개수, my_string에서 'B'의 개수,..., my_string에서 'Z'의 개수
    # my_string에서 'a'의 개수, my_string에서 'b'의 개수,..., my_string에서 'z'의 개수를
    # 순서대로 담은 길이 52의 정수 배열을 return 하는 solution 함수를 작성해 주세요.
    
    # 알파벳 순서가 배열의 순서가 되도록 맞춰야하고
    # 문자열의 순번에 따라 해당 배열의 순번 0값 증가
    
    # 알파벳 대문자, 소문자 가져오기
    all_letters = string.ascii_uppercase + string.ascii_lowercase
    
    # 알파벳 순번 값으로 매핑하기
    alphabet_mapping = {letter: index for index, letter in enumerate(all_letters)}
    
    # 배열 값 0으로 초기화
    answer = [0] * 52
    
    for char in my_string :
        if char in alphabet_mapping :
            answer[alphabet_mapping[char]] += 1
    
    return answer

# 배열 만들기 4
def solution(arr):
    
    # 솔루션 정의
    # 정수 배열 arr가 주어집니다. arr를 이용해 새로운 배열 stk를 만드려고 합니다.

    # 변수 i를 만들어 초기값을 0으로 설정한 후 i가 arr의 길이보다 작으면 다음 작업을 반복합니다.

    # 만약 stk가 빈 배열이라면 arr[i]를 stk에 추가하고 i에 1을 더합니다.
    # stk에 원소가 있고, stk의 마지막 원소가 arr[i]보다 작으면 arr[i]를 stk의 뒤에 추가하고 i에 1을 더합니다.
    # stk에 원소가 있는데 stk의 마지막 원소가 arr[i]보다 크거나 같으면 stk의 마지막 원소를 stk에서 제거합니다.
    # 위 작업을 마친 후 만들어진 stk를 return 하는 solution 함수를 완성해 주세요.
    
    i = 0
    stk = []
    
    while i < len(arr) :
        
        if not stk :
            stk.append(arr[i])
            i += 1
        
        elif stk[-1] < arr[i] :
            stk.append(arr[i])
            i += 1
        
        elif stk[-1] >= arr[i] :
            del stk[-1]
            
    return stk

# 두 수의 합
def solution(a, b):
    answer = str(int(a)+int(b))
    return answer

# 왼쪽 오른쪽
def solution(str_list):
    
    # 솔루션 정의
    # 문자열 리스트 str_list에는 "u", "d", "l", "r" 네 개의 문자열이 여러 개 저장되어 있습니다.
    # str_list에서 "l"과 "r" 중 먼저 나오는 문자열이 "l"이라면 해당 문자열을 기준으로 왼쪽에 있는 문자열들을 순서대로 담은 리스트를
    # 먼저 나오는 문자열이 "r"이라면 해당 문자열을 기준으로 오른쪽에 있는 문자열들을 순서대로 담은 리스트를 return하도록 solution 함수를 완성해주세요.
    # "l"이나 "r"이 없다면 빈 리스트를 return합니다.
    
    answer = []
    
    if not str_list :
        pass
    
    else :
        
        for i in range(len(str_list)) :
            
            if str_list[i] == 'l' :
                return str_list[:i]
            
            elif  str_list[i] == 'r' :
                return str_list[i+1:]
            
    return answer

# 배열 만들기 6
def solution(arr):
    
    # 솔루션 정의
    # 0과 1로만 이루어진 정수 배열 arr가 주어집니다. arr를 이용해 새로운 배열 stk을 만드려고 합니다.

    # i의 초기값을 0으로 설정하고 i가 arr의 길이보다 작으면 다음을 반복합니다.

    # 만약 stk이 빈 배열이라면 arr[i]를 stk에 추가하고 i에 1을 더합니다.
    # stk에 원소가 있고, stk의 마지막 원소가 arr[i]와 같으면 stk의 마지막 원소를 stk에서 제거하고 i에 1을 더합니다.
    # stk에 원소가 있는데 stk의 마지막 원소가 arr[i]와 다르면 stk의 맨 마지막에 arr[i]를 추가하고 i에 1을 더합니다.
    # 위 작업을 마친 후 만들어진 stk을 return 하는 solution 함수를 완성해 주세요.

    # 단, 만약 빈 배열을 return 해야한다면 [-1]을 return 합니다.

    answer = []
    i = 0
    
    while i < len(arr) :
        
        if not answer :
            answer.append(arr[i])
            i += 1
            
        elif answer[-1] == arr[i] :
            del answer[-1]
            i += 1
            
        elif answer[-1] != arr[i] :
            answer.append(arr[i])
            i += 1
    
    if not answer :
        return [-1]
    
    return answer

# 수열과 구간 쿼리 2
def solution(arr, queries):
    
    # 솔루션 정의
    # 정수 배열 arr와 2차원 정수 배열 queries이 주어집니다.
    # queries의 원소는 각각 하나의 query를 나타내며, [s, e, k] 꼴입니다.
    # 각 query마다 순서대로 s ≤ i ≤ e인 모든 i에 대해 k보다 크면서 가장 작은 arr[i]를 찾습니다.
    # 각 쿼리의 순서에 맞게 답을 저장한 배열을 반환하는 solution 함수를 완성해 주세요.
    # 단, 특정 쿼리의 답이 존재하지 않으면 -1을 저장합니다.
    
    answer = []
    point = []
    n = len(queries)
    
    for s, e, k in queries :
        
        for i in range(len(arr)) :
            
            if s <= i <= e and arr[i] > k :
                point.append(arr[i])
                
            else :
                pass        
        
        if not point :
            answer.append(-1)
        
        else :
            answer.append(min(point))
            point = []
        
    return answer

# 문자열 여러 번 뒤집기
def solution(my_string, queries):
    
    # 문자열 my_string과 이차원 정수 배열 queries가 매개변수로 주어집니다.
    # queries의 원소는 [s, e] 형태로, my_string의 인덱스 s부터 인덱스 e까지를 뒤집으라는 의미입니다.
    # my_string에 queries의 명령을 순서대로 처리한 후의 문자열을 return 하는 solution 함수를 작성해 주세요.

    for s, e in queries :
        my_string = my_string[:s] + my_string[s:e+1][::-1] + my_string[e+1:]
        
    return my_string

# 조건 문자열
def solution(ineq, eq, n, m):
    
    # 솔루션 정의
    # 문자열에 따라 다음과 같이 두 수의 크기를 비교하려고 합니다.

    # 두 수가 n과 m이라면
    # ">", "=" : n >= m
    # "<", "=" : n <= m
    # ">", "!" : n > m
    # "<", "!" : n < m
    # 두 문자열 ineq와 eq가 주어집니다.
    # ineq는 "<"와 ">"중 하나고, eq는 "="와 "!"중 하나입니다.
    # 그리고 두 정수 n과 m이 주어질 때, n과 m이 ineq와 eq의 조건에 맞으면 1을 아니면 0을 return
    
    if ineq == ">" and eq == "=":
        if n >= m :
            return 1
        else :
             return 0
    
    elif ineq == "<" and eq == "=":
        if n <= m :
            return 1
        else :
             return 0
    
    elif ineq == ">" and eq == "!":
        if n > m :
            return 1       
        else :
             return 0
    
    elif ineq == "<" and eq == "!":
        if n < m :
            return 1
        else :
            return 0
        
# 무작위로 K개의 수 뽑기
def solution(arr, k):
    
    # 솔루션 정의
    # 랜덤으로 서로 다른 k개의 수를 저장한 배열을 만드려고 합니다.
    # 적절한 방법이 떠오르지 않기 때문에 일정한 범위 내에서 무작위로 수를 뽑은 후
    # 지금까지 나온적이 없는 수이면 배열 맨 뒤에 추가하는 방식으로 만들기로 합니다.

    # 이미 어떤 수가 무작위로 주어질지 알고 있다고 가정하고, 실제 만들어질 길이 k의 배열을 예상해봅시다.
    # 정수 배열 arr가 주어집니다. 문제에서의 무작위의 수는 arr에 저장된 순서대로 주어질 예정이라고 했을 때
    # 완성될 배열을 return 하는 solution 함수를 완성해 주세요.
    # 단, 완성될 배열의 길이가 k보다 작으면 나머지 값을 전부 -1로 채워서 return 합니다.
    
    n = len(arr)
    answer = []
    
    for i in range(n) :
        
        if arr[i] not in answer and len(answer) < k :
            answer.append(arr[i])
            
    if k > len(answer) :
        answer.extend([-1] * (k-len(answer)))
    
    return answer

# 그림 확대
def solution(picture, k):
    
    # 솔루션 정의
    # 직사각형 형태의 그림 파일이 있고, 이 그림 파일은 1 × 1 크기의 정사각형 크기의 픽셀로 이루어져 있습니다.
    # 이 그림 파일을 나타낸 문자열 배열 picture과 정수 k가 매개변수로 주어질 때
    # 이 그림 파일을 가로 세로로 k배 늘린 그림 파일을 나타내도록 문자열 배열을 return
    
    answer = []
    
    for i in range(len(picture)) :
        
        Reset = ''
        
        for m in range(len(picture[i])) :
            Reset += picture[i][m] * k
            
        for _ in range(k) :
            answer.append(Reset)
    
    return answer

# a와 b 출력하기
a, b = map(int, input().strip().split(' '))
print(f'a = {a}\nb = {b}')

# 문자열 겹쳐쓰기
def solution(my_string, overwrite_string, s):
    
    # 문자열 my_string, overwrite_string과 정수 s가 주어집니다.
    # 문자열 my_string의 인덱스 s부터 overwrite_string의 길이만큼을 문자열 overwrite_string으로 바꾼 문자열을 return
    n = len(overwrite_string)
    answer = my_string[:s] + overwrite_string + my_string[s+n:]

    return answer

# 대소문자 바꿔서 출력하기
import string
str = input()

upper = list(string.ascii_uppercase)
lower = list(string.ascii_lowercase)
result = ''

for char in str :
    
    if char in upper :
        result += char.lower()
        
    if char in lower :
        result += char.upper()

print(result)

# 전국 대회 선발 고사
def solution(rank, attendance):
    
    # 솔루션 정의
    # 0번부터 n - 1번까지 n명의 학생 중 3명을 선발하는 전국 대회 선발 고사를 보았습니다.
    # 등수가 높은 3명을 선발해야 하지만, 개인 사정으로 전국 대회에 참여하지 못하는 학생들이 있어 참여가 가능한 학생 중 등수가 높은 3명을 선발하기로 했습니다.

    # 각 학생들의 선발 고사 등수를 담은 정수 배열 rank와 전국 대회 참여 가능 여부가 담긴 boolean 배열 attendance가 매개변수로 주어집니다.
    # 전국 대회에 선발된 학생 번호들을 등수가 높은 순서대로 각각 a, b, c번이라고 할 때 10000 × a + 100 × b + c를 return 하는 solution 함수를 작성해 주세요.
    
    answer = []
    n = len(rank)
    
    for i in range(n) :
        
        if attendance[i] :
            answer.append((rank[i], i))
    
    answer = sorted(answer)
    a, b, c = answer[0][1], answer[1][1], answer[2][1]
    
    return 10000 * a + 100 * b + c

# 배열 만들기 2
def solution(l, r):
    
    # 솔루션 정의
    # 정수 l과 r이 주어졌을 때, l 이상 r이하의 정수 중에서 숫자 "0"과 "5"로만 이루어진 모든 정수를 오름차순으로 저장한 배열을 return
    # 만약 그러한 정수가 없다면, -1이 담긴 배열을 return 합니다.
    
    # 먼저 l, r 범위를 만들자
    
    answer = []
    Range_List = list(range(l, r+1))
    
    for i in Range_List :
        
        if all(ch in ['0', '5'] for ch in str(i)) :
            answer.append(i)
    
    if not answer :
        return [-1]
    
    return answer