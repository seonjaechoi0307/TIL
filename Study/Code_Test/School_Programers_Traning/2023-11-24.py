# n보다 커질 때까지 더하기
def solution(numbers, n):
    
    # 솔루션 정의
    # 정수 배열 numbers와 정수 n이 매개변수로 주어집니다.
    # numbers의 원소를 앞에서부터 하나씩 더하다가 그 합이 n보다 커지는 순간 이때까지 더했던 원소들의 합을 return
    
    length = len(numbers) + 1
    
    # 시작부터 i까지 더한 값을 sum_number에 더하는 for문
    for i in range(length) :
        sum_number = sum(numbers[:i])
        
        # sum_number가 n 보다 높아질 시 sum_number 반환
        if sum_number > n :
            return sum_number
        
# 뒤에서 5등 위로
def solution(num_list):
    
    # 솔루션 정의
    # 정수로 이루어진 리스트 num_list가 주어집니다.
    # num_list에서 가장 작은 5개의 수를 제외한 수들을 오름차순으로 담은 리스트를 return
    
    # 로직 구상
    # 1. 리스트의 값의 크기 순으로 정렬시킨다.
    # 2. 6번째 값부터 슬라이싱해서 리스트 반환한다.
    
    answer = sorted(num_list)
    return answer[5:]

# n 번째 원소까지
def solution(num_list, n):
    
    # 솔루션 정의
    # 정수 리스트 num_list와 정수 n이 주어질 때
    # num_list의 첫 번째 원소부터 n 번째 원소까지의 모든 원소를 담은 리스트를 return
    
    # 로직 구상
    # num_list의 시작부터 n번까지 슬라이싱한 값을 반환
    
    answer = num_list[:n]
    return answer

# 배열 만들기 1
def solution(n, k):
    
    # 솔루션 정의
    # 정수 n과 k가 주어졌을 때
    # 1 이상 n이하의 정수 중에서 k의 배수를 오름차순으로 저장한 배열을 return
    
    # 로직 구상
    # 1부터 n까지의 오름차순으로 리스트를 만들고
    # k값 부터 k의 배수를 슬라이싱한 값을 반환
    
    answer = list(range(1, n+1))
    return answer[k-1::k]

# 문자열로 변환
def solution(n):
    
    # 솔루션 정의
    # 정수 n이 주어질 때, n을 문자열로 변환하여 return
    
    # 로직 구상
    # n을 문자 타입으로 변환하여 반환
    answer = str(n)
    return answer

# 홀짝 구분하기
a = int(input())

# 문제 정의
# 자연수 n이 입력으로 주어졌을 때 만약 n이 짝수이면 "n is even"을, 홀수이면 "n is odd"를 출력하는 코드를 작성해 보세요.

# a가 홀수면
if (a % 2) != 0 :
    print(f"{a} is odd")
# 그 외(짝수)면
else :
    print(f"{a} is even")

# 길이에 따른 연산
def solution(num_list):
    
    # 솔루션 정의
    # 정수가 담긴 리스트 num_list가 주어질 때
    # 리스트의 길이가 11 이상이면 리스트에 있는 모든 원소의 합을 10 이하이면 모든 원소의 곱을 return
    
    # 로직 구상
    # 솔루션 조건으로 if 문을 작성
    # 조건의 계산식을 통해 값 반환
    answer = 1
    n = len(num_list)
    
    if n >= 11 :
        answer = sum(num_list)
        
    else :
        for i in num_list :
            answer *= i
    
    return answer

# 접두사인지 확인하기
def solution(my_string, is_prefix):
    
    # 솔루션 정의
    # 어떤 문자열에 대해서 접두사는 특정 인덱스까지의 문자열을 의미합니다.
    # 예를 들어, "banana"의 모든 접두사는 "b", "ba", "ban", "bana", "banan", "banana"입니다.
    # 문자열 my_string과 is_prefix가 주어질 때, is_prefix가 my_string의 접두사라면
    # 1을, 아니면 0을 return 하는 solution 함수를 작성해 주세요.
    
    # 로직 구상
    # 1. my_string, is_prefix의 문자열 길이를 구하고
    # 2. 문자열의 길이를 비교하여 같거나 작을 시 로직 시작
    # 3. my_string를 슬라이싱한 값과 is_prefix이 일치하는지 확인
    # 4. 일치 시 1을 아니면 0을 반환
    
    n = len(my_string)
    m = len(is_prefix)
    
    if n >= m :
        for i in range(n+1) :
            if is_prefix == my_string[:i] :
                return 1
    return 0

# 주사위 게임 1
def solution(a, b):
    
    # 솔루션 정의
    # 1부터 6까지 숫자가 적힌 주사위가 두 개 있습니다.
    # 두 주사위를 굴렸을 때 나온 숫자를 각각 a, b라고 했을 때 얻는 점수는 다음과 같습니다.
    # a와 b가 모두 홀수라면 a2 + b2 점을 얻습니다.
    # a와 b 중 하나만 홀수라면 2 × (a + b) 점을 얻습니다.
    # a와 b 모두 홀수가 아니라면 |a - b| 점을 얻습니다.
    # 두 정수 a와 b가 매개변수로 주어질 때, 얻는 점수를 return
    
    # 로직 구상
    # 조건에 맞는 계산식을 통해 계산된 값 반환
    if (a % 2) != 0 and (b % 2) != 0 :
        answer = (a ** 2) + (b ** 2)
        
    elif (a % 2) != 0 or (b % 2) != 0 :
        answer = 2 * (a + b)
        
    else :
        answer = abs(a-b)
    
    return answer

# 문자열 정수의 합
def solution(num_str):
    
    # 솔루션 정의
    # 한 자리 정수로 이루어진 문자열 num_str이 주어질 때, 각 자리수의 합을 return
    
    # 로직 구상
    # 문자열 길이 만큼 for문을 통해 각 값을 answer에 더하기
    n = len(num_str)
    answer = 0
    
    for i in range(n) :
        answer += int(num_str[i])
    
    return answer

# 0 떼기
def solution(n_str):
    
    # 솔루션 정의
    # 정수로 이루어진 문자열 n_str이 주어질 때
    # n_str의 가장 왼쪽에 처음으로 등장하는 0들을 뗀 문자열을 return
    
    # 로직 구상
    # 1. 매개 변수의 문자 길이를 구하고
    # 2. for문을 통해 0이 없는 지점까지 계산하여 슬라이싱한 값을 반환
    n = len(n_str)
    
    for i in range(n) :
        if n_str[i] != '0' :
            return n_str[i:]
        
# 배열의 원소만큼 추가하기
def solution(arr):
    
    # 솔루션 정의
    # 아무 원소도 들어있지 않은 빈 배열 X가 있습니다.
    # 양의 정수 배열 arr가 매개변수로 주어질 때
    # arr의 앞에서부터 차례대로 원소를 보면서 원소가 a라면
    # X의 맨 뒤에 a를 a번 추가하는 일을 반복한 뒤의 배열 X를 return
    answer = []
    
    n = len(arr)
    
    # 로직 구상
    # 배열의 길이 만큼 FOR문을 활용하여 배열의 원소 값만큼 리스트에 추가하기    

    for i in range(n) :
        
        for k in range(arr[i]) :
            answer.append(arr[i])
            
    return answer

# 조건에 맞게 수열 변환하기 1
def solution(arr):
    
    # 솔루션 정의
    # 정수 배열 arr가 주어집니다.
    # arr의 각 원소에 대해 값이 50보다 크거나 같은 짝수라면 2로 나누고, 50보다 작은 홀수라면 2를 곱합니다.
    # 그 결과인 정수 배열을 return
    
    # 로직 구상
    # 1. IF문 정의
    # 2. 조건의 계산식 값 반환
    n = len(arr)
    answer = []
    
    for i in range(n) :
        
        if arr[i] >= 50 and (arr[i] % 2) == 0 :
            answer.append(arr[i] // 2)
            
        elif arr[i] < 50 and (arr[i] % 2) != 0 :
            answer.append(arr[i] * 2)
            
        else :
            answer.append(arr[i])
            
    return answer

# 부분 문자열인지 확인하기
def solution(my_string, target):
    
    # 솔루션 정의
    # 부분 문자열이란 문자열에서 연속된 일부분에 해당하는 문자열을 의미합니다.
    # 예를 들어, 문자열 "ana", "ban", "anana", "banana", "n"는 모두 문자열 "banana"의 부분 문자열이지만
    # "aaa", "bnana", "wxyz"는 모두 "banana"의 부분 문자열이 아닙니다.

    # 문자열 my_string과 target이 매개변수로 주어질 때
    # target이 문자열 my_string의 부분 문자열이라면 1을, 아니라면 0을 return
    
    # 로직 구상
    # 두 매개변수의 문자 길이를 구하고
    # 문자 길이를 기준으로 매개변수 A와 B를 비교하여 부분 문자열인지 확인한다.
    # n보다 m길이가 작다는 전제하에 검토 개수 = n - m + 1
    # check 변수와 target 일치 비교
    
    n = len(my_string)
    m = len(target)
    r = n % m
    
    if n >= m :
        for i in range(n - m + 1) :

            # 부분 문자열 추출
            check = my_string[i:i + m]
            
            # 부분 문자열과 target 비교
            if check == target :
                return 1
            
    # 그 외의 상황 0 리턴
    return 0

# 부분 문자열 이어 붙여 문자열 만들기
def solution(my_strings, parts):
    
    # 솔루션 정의
    # 길이가 같은 문자열 배열 my_strings와 이차원 정수 배열 parts가 매개변수로 주어집니다.
    # parts[i]는 [s, e] 형태로, my_string[i]의 인덱스 s부터 인덱스 e까지의 부분 문자열을 의미합니다.
    # 각 my_strings의 원소의 parts에 해당하는 부분 문자열을 순서대로 이어 붙인 문자열을 return
    
    # 반복할 횟수
    length = len(my_strings)
    
    # 변수 초기화
    answer = ''
    
    for n in range(length) :
        
        # 슬라이싱할 범위
        s, e = parts[n]
        
        answer += my_strings[n][s:e+1]
    
    return answer

# 배열의 원소 삭제하기
def solution(arr, delete_list):
    
    # 솔루션 정의
    # 정수 배열 arr과 delete_list가 있습니다.
    # arr의 원소 중 delete_list의 원소를 모두 삭제하고 남은 원소들은 기존의 arr에 있던 순서를 유지한 배열을 return
    
    answer = [x for x in arr if x not in delete_list]
    return answer

# 순서 바꾸기
def solution(num_list, n):
    
    # 솔루션 정의
    # 정수 리스트 num_list와 정수 n이 주어질 때
    # num_list를 n 번째 원소 이후의 원소들과 n 번째까지의 원소들로 나눠
    # n 번째 원소 이후의 원소들을 n 번째까지의 원소들 앞에 붙인 리스트를 return
    
    # 로직 구상
    # 1. 시작 부터 n번 전까지 + n 번 부터 끝 번호 슬라이싱한 값을 answer로 붙히기
    
    answer = num_list[n:] + num_list[:n]
    
    return answer

# 특별한 이차원 배열 2
def solution(arr):
    
    # 솔루션 정의
    # n × n 크기의 이차원 배열 arr이 매개변수로 주어질 때, arr이 다음을 만족하면 1을 아니라면 0을 return
    # 0 ≤ i, j < n인 정수 i, j에 대하여 arr[i][j] = arr[j][i]
    
    # 로직 구상
    # 문자열의 길이를 구하고 그 길이에 맞게 for문 실행
    
    n = len(arr)
    for i in range(n) :
        
        for j in range(n) :
            if arr[i][j] != arr[j][i] :
                return 0
            
    answer = 1
    return answer

# 꼬리 문자열
def solution(str_list, ex):
    
    # 솔루션 정의
    # 문자열들이 담긴 리스트가 주어졌을 때, 모든 문자열들을 순서대로 합친 문자열을 꼬리 문자열이라고 합니다.
    # 꼬리 문자열을 만들 때 특정 문자열을 포함한 문자열은 제외시키려고 합니다.
    # 예를 들어 문자열 리스트 ["abc", "def", "ghi"]가 있고 문자열 "ef"를 포함한 문자열은 제외하고 꼬리 문자열을 만들면 "abcghi"가 됩니다.

    # 문자열 리스트 str_list와 제외하려는 문자열 ex가 주어질 때
    # str_list에서 ex를 포함한 문자열을 제외하고 만든 꼬리 문자열을 return하도록 solution 함수를 완성해주세요.
    
    # 로직 구상
    # 1. 문자열 리스트에서 ex값 제외한다.
    # 2. 남은 값 붙히기
    Group = [x for x in str_list if ex not in x]
    answer = "".join(Group)
    
    return answer

# rny_string
def solution(rny_string):
    
    # 솔루션 정의
    # 'm'과 "rn"이 모양이 비슷하게 생긴 점을 활용해 문자열에 장난을 하려고 합니다.
    # 문자열 rny_string이 주어질 때, rny_string의 모든 'm'을 "rn"으로 바꾼 문자열을 return
    
    answer = rny_string.replace("m", "rn")
    return answer

# 정사각형으로 만들기
def solution(arr):
    
    # 솔루션 정의
    # 이차원 정수 배열 arr이 매개변수로 주어집니다.
    # arr의 행의 수가 더 많다면 열의 수가 행의 수와 같아지도록 각 행의 끝에 0을 추가하고
    # 열의 수가 더 많다면 행의 수가 열의 수와 같아지도록 각 열의 끝에 0을 추가한 이차원 배열을 return
    
    rows, cols = len(arr), len(arr[0])
    diff = abs(rows - cols)
    
    # 가로축이 긴 경우
    if rows < cols :
        for _ in range(diff):
            arr.append([0] * cols)
    
    # 세로축이 긴 경우
    elif rows > cols :
        for row in arr :
            row.extend([0] * diff)
    
    answer = arr
    return answer

# 공백으로 구분하기 2
def solution(my_string):
    
    # 솔루션 정의
    # 단어가 공백 한 개 이상으로 구분되어 있는 문자열 my_string이 매개변수로 주어질 때
    # my_string에 나온 단어를 앞에서부터 순서대로 담은 문자열 배열을 return
    
    answer = my_string.split()
    return answer

# 뒤에서 5등까지
def solution(num_list):
    
    # 솔루션 정의
    # 정수로 이루어진 리스트 num_list가 주어집니다.
    # num_list에서 가장 작은 5개의 수를 오름차순으로 담은 리스트를 return
    
    group = sorted(num_list)
    answer = group[:5]
    return answer

# 원하는 문자열 찾기
def solution(myString, pat):
    
    # 솔루션 정의
    # 알파벳으로 이루어진 문자열 myString과 pat이 주어집니다.
    # myString의 연속된 부분 문자열 중 pat이 존재하면 1을 그렇지 않으면 0을 return
    # 단, 알파벳 대문자와 소문자는 구분하지 않습니다.
    
    # 로직 구성
    # 조건: myString 보다 pat의 문자열 길이가 같거나 작아야 함
    # 1. 조건문으로 두 문자열 길이 비교
    # 2. count 메서드를 통해 myString에 pat 문자열이 존재하는지 확인
    
    n = len(myString)
    m = len(pat)
    answer = 0
    
    if n >= m :
        myString = myString.lower()
        pat = pat.lower()
        
        count = myString.count(pat)
        
        if count >= 1 :
            answer = 1
        else :
            answer = 0
            
    return answer

# 홀수 vs 짝수
def solution(num_list):
    
    # 솔루션 정의
    # 정수 리스트 num_list가 주어집니다.
    # 가장 첫 번째 원소를 1번 원소라고 할 때
    # 홀수 번째 원소들의 합과 짝수 번째 원소들의 합 중 큰 값을 return
    # 두 값이 같을 경우 그 값을 return
    
    odd_sum = sum(num_list[1::2])
    even_sum = sum(num_list[0::2])
    
    if odd_sum >= even_sum :
        answer = odd_sum
    else :
        answer = even_sum
    
    return answer

# 할 일 목록
def solution(todo_list, finished):
    
    # 솔루션 정의
    # 오늘 해야 할 일이 담긴 문자열 배열 todo_list와 각각의 일을 지금 마쳤는지를 나타내는 boolean 배열 finished가 매개변수로 주어질 때
    # todo_list에서 아직 마치지 못한 일들을 순서대로 담은 문자열 배열을 return
    answer = []
    
    for i in range(len(todo_list)) :
        
        if finished[i] == False:
            
            answer.append(todo_list[i])
        
    return answer

# 공백으로 구분하기 1
def solution(my_string):
    
    # 솔루션 정의
    # 단어가 공백 한 개로 구분되어 있는 문자열 my_string이 매개변수로 주어질 때
    # my_string에 나온 단어를 앞에서부터 순서대로 담은 문자열 배열을 return
    
    answer = list(my_string.split(' '))
    return answer

# x 사이의 개수
def solution(myString):
    
    # 솔루션 정의
    # 문자열 myString이 주어집니다.
    # myString을 문자 "x"를 기준으로 나눴을 때 나눠진 문자열 각각의 길이를 순서대로 저장한 배열을 return
    
    answer = []
    group = list(myString.split('x'))
    
    for i in group:
        answer.append(len(i))
    
    return answer

# 부분 문자열
def solution(str1, str2):
    
    # 솔루션 정의
    # 어떤 문자열 A가 다른 문자열 B안에 속하면 A를 B의 부분 문자열이라고 합니다.
    # 예를 들어 문자열 "abc"는 문자열 "aabcc"의 부분 문자열입니다.
    # 문자열 str1과 str2가 주어질 때, str1이 str2의 부분 문자열이라면 1을 부분 문자열이 아니라면 0을 return
    
    # 로직 구상
    # count 메서드를 활용하여 str2에 str1이 포함 되어있는지 체크
    # count가 1이상 이면 return 1, 아니면 return 0
    
    count = str2.count(str1)
    
    if count >= 1 :
        answer = 1
    else :
        answer = 0
        
    return answer

# 두 수의 연산값 비교하기
def solution(a, b):
    
    # 연산 ⊕는 두 정수에 대한 연산으로 두 정수를 붙여서 쓴 값을 반환합니다. 예를 들면 다음과 같습니다.
    # 12 ⊕ 3 = 123
    # 3 ⊕ 12 = 312
    # 양의 정수 a와 b가 주어졌을 때, a ⊕ b와 2 * a * b 중 더 큰 값을 return하는 solution 함수를 완성해 주세요.
    # 단, a ⊕ b와 2 * a * b가 같으면 a ⊕ b를 return 합니다.
    
    A = int(str(a) + str(b))
    B = (2 * a * b) 
    
    if A >= B :
        answer = A
    else :
        answer = B
    
    return answer

# 콜라츠 수열 만들기

def solution(n):
    
    # 모든 자연수 x에 대해서 현재 값이 x이면 x가 짝수일 때는 2로 나누고
    # x가 홀수일 때는 3 * x + 1로 바꾸는 계산을 계속해서 반복하면 언젠가는 반드시 x가 1이 되는지 묻는 문제를 콜라츠 문제라고 부릅니다.
    
    # 그리고 위 과정에서 거쳐간 모든 수를 기록한 수열을 콜라츠 수열이라고 부릅니다.
    
    # 계산 결과 1,000 보다 작거나 같은 수에 대해서는 전부 언젠가 1에 도달한다는 것이 알려져 있습니다.
    # 임의의 1,000 보다 작거나 같은 양의 정수 n이 주어질 때 초기값이 n인 콜라츠 수열을 return 하는 solution 함수를 완성해 주세요.
    
    # 로직 목표: 콜라츠 수열을 반환하는 것
    # 로직 구상
    # 1. n이 1이 되도록 반복적으로 콜라츠 수열을 반복한다.
    # 2. 반복적으로 콜라츠 수열된 각각의 n 값을 리스트에 추가한다.
    # 3. 리스트(answer)를 반환한다.
    
    answer = [n]
    
    while n != 1 :
        if (n % 2) == 0 :
            n //= 2
            
        else:
            n = 3 * n + 1
        
        answer.append(n)
            
    return answer