# 가까운 1 찾기
def solution(arr, idx):
    
    # 솔루션 정의
    # 정수 배열 arr가 주어집니다.
    # 이때 arr의 원소는 1 또는 0입니다. 정수 idx가 주어졌을 때
    # idx보다 크면서 배열의 값이 1인 가장 작은 인덱스를 찾아서 반환
    # 단, 만약 그러한 인덱스가 없다면 -1을 반환합니다.
    
    # 반복문 최대 진행 횟수
    n = len(arr)
    
    for i in range(n) :
        
        # 원소가 1이고, 해당 원소까지의 길이가 idx 보다 크거나 같을 때
        if arr[i] == 1 and len(arr[:i]) >= idx :
            
            # 배열의 길이 값 반환
            return len(arr[:i])
    
    # 해당없을 시 -1 반환
    answer = -1
    return answer

# 간단한 식 계산하기
def solution(binomial):
    
    # 솔루션 정의
    # 문자열 binomial이 매개변수로 주어집니다.
    # binomial은 "a op b" 형태의 이항식이고 a와 b는 음이 아닌 정수, op는 '+', '-', '*' 중 하나입니다.
    # 주어진 식을 계산한 정수를 return
    
    answer = eval(binomial)
    return answer

# A 강조하기
def solution(myString):
    
    # 솔루션 정의
    # 문자열 myString이 주어집니다.
    # myString에서 알파벳 "a"가 등장하면 전부 "A"로 변환하고
    # "A"가 아닌 모든 대문자 알파벳은 소문자 알파벳으로 변환하여 return
    
    n = len(myString)
    answer = ''
    
    for i in range(n) :
        
        if myString[i] == 'a' or myString[i] == 'A' :
            answer += myString[i].upper()
        else :
            answer += myString[i].lower()
    
    return answer

# 특별한 이차원 배열 1
def solution(n):
    
    # 솔루션 정의
    # 정수 n이 매개변수로 주어질 때, 다음과 같은 n × n 크기의 이차원 배열 arr를 return
    # arr[i][j] (0 ≤ i, j < n)의 값은 i = j라면 1, 아니라면 0입니다.
    
    # n x n 크기의 이차원 배열 생성 및 초기화
    arr = [[0] * n for _ in range(n)]
    
    # 대각선에 배치된 원소들을 1로 변환
    for i in range(n) :
        arr[i][i] = 1
        
    return arr

# ad 제거하기
def solution(strArr):
    
    # 솔루션 정의
    # 문자열 배열 strArr가 주어집니다.
    # 배열 내의 문자열 중 "ad"라는 부분 문자열을 포함하고 있는
    # 모든 문자열을 제거하고 남은 문자열을 순서를 유지하여 배열로 return
    
    answer = [x for x in strArr if "ad" not in x]
    return answer

# 문자열 잘라서 정렬하기
def solution(myString):
    
    # 솔루션
    # 문자열 myString이 주어집니다.
    # "x"를 기준으로 해당 문자열을 잘라내 배열을 만든 후 사전순으로 정렬한 배열을 return
    # 단, 빈 문자열은 반환할 배열에 넣지 않습니다.
    
    # 로직 구상
    # 1. myString을 split 메서드로 분할한다.
    # 2. 각 알파벳을 오름차순으로 정렬한다.
    # 3. 각 알파벳과 동일한 알파벳 기준으로 리스트안에 그룹화한다.
    
    split_str = myString.split('x')
    answer = sorted([Alphabets for Alphabets in split_str if Alphabets])
    return answer

# 덧셈식 출력하기
a, b = map(int, input().strip().split(' '))
c = a + b
print(f'{a} + {b} = {c}')

# 접미사 배열
def solution(my_string):
    
    # 솔루션 정의
    # 어떤 문자열에 대해서 접미사는 특정 인덱스부터 시작하는 문자열을 의미합니다.
    # 예를 들어, "banana"의 모든 접미사는 "banana", "anana", "nana", "ana", "na", "a"입니다.
    # 문자열 my_string이 매개변수로 주어질 때, my_string의 모든 접미사를 사전순으로 정렬한 문자열 배열을 return
    
    answer = []
    n = len(my_string)
    
    for i in range(n) :
        answer.append(my_string[i:])
        
    answer = sorted(answer)
    return answer

# l로 만들기
def solution(myString):
    
    # 솔루션 정의
    # 알파벳 소문자로 이루어진 문자열 myString이 주어집니다.
    # 알파벳 순서에서 "l"보다 앞서는 모든 문자를 "l"로 바꾼 문자열을 return
    
    # 로직 구상
    # 알파벳은 ASCII 코드에 따라 숫자가 정해져있어 비교가 가능하다.
    # EX) a = 97, b = 98 ... z = 122
    answer = ''
    
    for char in myString :
        if char < 'l' :
            answer += 'l'
        else :
            answer += char
    
    return answer

# 수 조작하기 2
def solution(numLog):
    
    # 솔루션 정의
    # 정수 배열 numLog가 주어집니다.
    # 처음에 numLog[0]에서 부터 시작해 "w", "a", "s", "d"로 이루어진 문자열을 입력으로 받아 순서대로 다음과 같은 조작을 했다고 합시다.
    
    # "w" : 수에 1을 더한다.
    # "s" : 수에 1을 뺀다.
    # "d" : 수에 10을 더한다.
    # "a" : 수에 10을 뺀다.
    
    # 그리고 매번 조작을 할 때마다 결괏값을 기록한 정수 배열이 numLog입니다.
    # 즉, numLog[i]는 numLog[0]로부터 총 i번의 조작을 가한 결과가 저장되어 있습니다.
    # 주어진 정수 배열 numLog에 대해 조작을 위해 입력받은 문자열을 return
    
    # 로직 구상
    # 기존 numLog[0] = 0 이며
    # 다음 numLog[1]로 넘어갔을 때의 차이를 두고 해당하는 텍스트를 붙혀주면 된다.
    
    n = len(numLog)
    answer = ''
    
    for i in range(n-1) :
        Log = numLog[i] - numLog[i+1]
        
        if Log == -1 :
            answer += 'w'
            
        elif Log == +1 :
            answer += 's'
            
        elif Log == -10 :
            answer += 'd'
            
        elif Log == +10 :
            answer += 'a'
        
        else :
            None
            
    return answer

# 배열 만들기 3
def solution(arr, intervals):
    
    # 솔루션 정의
    # 정수 배열 arr와 2개의 구간이 담긴 배열 intervals가 주어집니다.
    # intervals는 항상 [[a1, b1], [a2, b2]]의 꼴로 주어지며 각 구간은 닫힌 구간입니다.
    # 닫힌 구간은 양 끝값과 그 사이의 값을 모두 포함하는 구간을 의미합니다.
    # 이때 배열 arr의 첫 번째 구간에 해당하는 배열과 두 번째 구간에 해당하는 배열을 앞뒤로 붙여 새로운 배열을 만들어 return
    answer = []
    
    for i in range(len(intervals)) :
        a, b = intervals[i]
        answer.extend(arr[a:b+1])
    
    return answer

# 문자 리스트를 문자열로 변환하기
def solution(arr):
    
    # 솔루션 설명
    # 문자들이 담겨있는 배열 arr가 주어집니다.
    # arr의 원소들을 순서대로 이어 붙인 문자열을 return
    
    answer = ''
    
    for i in arr :
        answer += i
    
    return answer

# 빈 배열에 추가, 삭제하기
def solution(arr, flag):
    
    # 아무 원소도 들어있지 않은 빈 배열 X가 있습니다.
    # 길이가 같은 정수 배열 arr과 boolean 배열 flag가 매개변수로 주어질 때
    # flag를 차례대로 순회하며 flag[i]가 true라면 X의 뒤에 arr[i]를 arr[i] × 2 번 추가하고
    # flag[i]가 false라면 X에서 마지막 arr[i]개의 원소를 제거한 뒤 X를 return

    X = []
    
    for i in range(len(flag)) :
        
        if flag[i] == True :
            X.extend([arr[i]] * (arr[i] * 2))
            
        else :
            X = X[:-arr[i]]
    
    return X

# 문자열 뒤집기
def solution(my_string, s, e):
    
    # 문자열 my_string과 정수 s, e가 매개변수로 주어질 때
    # my_string에서 인덱스 s부터 인덱스 e까지를 뒤집은 문자열을 return 하는 solution 함수를 작성해 주세요.
    
    answer = my_string[:s] + my_string[s:e+1][::-1] + my_string[e+1:]
    
    return answer
# 문자열 돌리기
str = input()

for i in str :
    print(i)

# 9로 나눈 나머지
def solution(number):
    
    # 솔루션 정의
    # 음이 아닌 정수를 9로 나눈 나머지는 그 정수의 각 자리 숫자의 합을 9로 나눈 나머지와 같은 것이 알려져 있습니다.
    # 이 사실을 이용하여 음이 아닌 정수가 문자열 number로 주어질 때, 이 정수를 9로 나눈 나머지를 return 하는 solution 함수를 작성해주세요.
    
    return int(number) % 9

# 세로 읽기
def solution(my_string, m, c):
    
    # 솔루션 정의
    # 문자열 my_string과 두 정수 m, c가 주어집니다.
    # my_string을 한 줄에 m 글자씩 가로로 적었을 때 왼쪽부터 세로로 c번째 열에 적힌 글자들을 문자열로 return
    
    # 한줄로 되어있는 my_string을 c번부터 m 간격값  슬라이싱
    
    answer = my_string[c-1::m]
    return answer

# 수열과 구간 쿼리 1
def solution(arr, queries):
    
    # 솔루션 정의
    # 정수 배열 arr와 2차원 정수 배열 queries이 주어집니다.
    # queries의 원소는 각각 하나의 query를 나타내며, [s, e] 꼴입니다.
    # 각 query마다 순서대로 s ≤ i ≤ e인 모든 i에 대해 arr[i]에 1을 더합니다.
    # 위 규칙에 따라 queries를 처리한 이후의 arr를 return
    
    # arr[i]의 각 원소값에 조건이 만족할 시 +1한 값을 return
    
    n = len(queries)
    m = len(arr)
    answer = arr.copy()
    
    for querie in queries :
        s, e = querie
        
        for i in range(m) :
            
            if s <= i <= e :
                answer[i] += 1
                
            else :
                pass
            
    return answer

# 날짜 비교하기
def solution(date1, date2):
    
    # 솔루션
    # 정수 배열 date1과 date2가 주어집니다.
    # 두 배열은 각각 날짜를 나타내며 [year, month, day] 꼴로 주어집니다.
    # 각 배열에서 year는 연도를, month는 월을, day는 날짜를 나타냅니다.
    # 만약 date1이 date2보다 이전 날짜라면 1을, 아니면 0을 return
    
    answer = 0
    d1 = ''
    d2 = ''
    
    for i in range(3) :
        d1 += str(date1[i])
        d2 += str(date2[i])
    
    if int(d1) < int(d2) :
        answer = 1
        return answer
    
    return answer

# 등차수열의 특정한 항만 더하기
def solution(a, d, included):
    
    # 솔루션 정의
    # 두 정수 a, d와 길이가 n인 boolean 배열 included가 주어집니다.
    # 첫째항이 a, 공차가 d인 등차수열에서 included[i]가 i + 1항을 의미할 때
    # 이 등차수열의 1항부터 n항까지 included가 true인 항들만 더한 값을 return
    
    answer = 0
    n = len(included)
    
    for i in range(n) :
        
        if included[i] == True :
            answer += a + (i) * d
    
    return answer

# 글자 지우기
def solution(my_string, indices):
    
    # 솔루션 정의
    # 문자열 my_string과 정수 배열 indices가 주어질 때
    # my_string에서 indices의 원소에 해당하는 인덱스의 글자를 지우고 이어 붙인 문자열을 return

    answer = ''
    str_list = list(range(0, len(my_string)))
    
    for i in str_list :
        
        if i not in indices :
            answer += my_string[i]
            
    return answer

# 문자열 섞기
def solution(str1, str2):
    
    # 솔루션 정의
    # 길이가 같은 두 문자열 str1과 str2가 주어집니다.
    # 두 문자열의 각 문자가 앞에서부터 서로 번갈아가면서 한 번씩 등장하는 문자열을 만들어 return 하는 solution 함수를 완성해 주세요.

    n = len(str1)
    answer = ''
    
    for i in range(n) :
        answer += (str1[i] + str2[i])
        
    return answer

