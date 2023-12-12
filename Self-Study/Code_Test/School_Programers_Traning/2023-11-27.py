# 1로 만들기
def solution(num_list):
    
    # 정수가 있을 때, 짝수라면 반으로 나누고
    # 홀수라면 1을 뺀 뒤 반으로 나누면, 마지막엔 1이 됩니다.
    # 예를 들어 10이 있다면 다음과 같은 과정으로 1이 됩니다.
    
    # 10 / 2 = 5
    # (5 - 1) / 2 = 4
    # 4 / 2 = 2
    # 2 / 2 = 1
    # 위와 같이 4번의 나누기 연산으로 1이 되었습니다.
    
    # 정수들이 담긴 리스트 num_list가 주어질 때
    # num_list의 모든 원소를 1로 만들기 위해서 필요한 나누기 연산의 횟수를 return
    
    answer = 0
    
    for i in range(len(num_list)) :
         
        while num_list[i] != 1 :
            answer += 1
            
            if (num_list[i] % 2) != 0 :
                
                num_list[i] = (num_list[i] - 1) // 2
                
            else :
                
                num_list[i] = num_list[i] // 2
            
    return answer

# 특정 문자열로 끝나는 가장 긴 부분 문자열 찾기
def solution(myString, pat):
    
    # 솔루션 정의
    # 문자열 myString과 pat가 주어집니다.
    # myString의 부분 문자열중 pat로 끝나는 가장 긴 부분 문자열을 찾아서 return
    
    n = len(myString)
    m = len(pat)
    answer = ''
    
    for i in range(n) :
        
        start = n-m-i
        end = n-i
        
        if myString[start:end] == pat :
            answer = myString[:end]
            return answer
        
    return answer

# 수열과 구간 쿼리 3
def solution(arr, queries):
    
    # 정수 배열 arr와 2차원 정수 배열 queries이 주어집니다.
    # queries의 원소는 각각 하나의 query를 나타내며, [i, j] 꼴입니다.
    # 각 query마다 순서대로 arr[i]의 값과 arr[j]의 값을 서로 바꿉니다.
    # 위 규칙에 따라 queries를 처리한 이후의 arr를 return
    
    # 반복할 행 길이
    n = len(queries)
    
    for m in range(n) :
        
        i, j = queries[m]
        trans_A = arr[i]
        trans_B = arr[j]
        
        arr[i] = trans_B
        arr[j] = trans_A

    answer = arr
    return answer

# 배열 만들기 5
def solution(intStrs, k, s, l):
    
    # 문자열 배열 intStrs와 정수 k, s, l가 주어집니다.
    # intStrs의 원소는 숫자로 이루어져 있습니다.
    # 배열 intStrs의 각 원소마다 s번 인덱스에서 시작하는 길이 l짜리 부분 문자열을 잘라내 정수로 변환합니다.
    # 이때 변환한 정수값이 k보다 큰 값들을 담은 배열을 return 하는 solution 함수를 완성해 주세요.
    
    n = len(intStrs)
    slicing = ''
    answer = []
    
    for i in range(n) :
        slicing = int(intStrs[i][s:s+l])
        
        if slicing > k :
            answer.append(slicing)

    return answer

# 문자열이 몇 번 등장하는지 세기
def solution(myString, pat):
    
    # 문자열 myString과 pat이 주어집니다.
    # myString에서 pat이 등장하는 횟수를 return
    
    answer = 0
    n = len(myString)
    m = len(pat)
    
    for i in range(n-m+1) :
        
        if myString[i:i+m] == pat :
            answer += 1
    
    return answer

# 세 개의 구분자
def solution(myStr):
    
    # 임의의 문자열이 주어졌을 때 문자 "a", "b", "c"를 구분자로 사용해 문자열을 나누고자 합니다.

    # 예를 들어 주어진 문자열이 "baconlettucetomato"라면 나눠진 문자열 목록은 ["onlettu", "etom", "to"] 가 됩니다.

    # 문자열 myStr이 주어졌을 때 위 예시와 같이 "a", "b", "c"를 사용해 나눠진 문자열을 순서대로 저장한 배열을 return 하는 solution 함수를 완성해 주세요.

    # 단, 두 구분자 사이에 다른 문자가 없을 경우에는 아무것도 저장하지 않으며, return할 배열이 빈 배열이라면 ["EMPTY"]를 return 합니다.

    answer = ''
    
    for i in range(len(myStr)) :
        
        if myStr[i] in ["a", "b", "c"] :
            answer += "a"
        else :
            answer += myStr[i]

    answer = answer.split("a")
    answer = [i for i in answer if i != ""]
    
    if not answer :
        return ["EMPTY"]
    else :
        return answer
    
    # 배열의 길이를 2의 거듭제곱으로 만들기
def solution(arr):
    
    # 정수 배열 arr이 매개변수로 주어집니다.
    # arr의 길이가 2의 정수 거듭제곱이 되도록 arr 뒤에 정수 0을 추가하려고 합니다.
    # arr에 최소한의 개수로 0을 추가한 배열을 return 하는 solution 함수를 작성해 주세요.
    
    # n == 2의 최소거듭제곱이 될 수 있도록
    # arr 배열에 0을 추가하여 길이를 늘려주자
    
    n = len(arr)
    Add = 1
    
    while Add < n :
        Add *= 2
        
    add_num = Add - n
    
    arr.extend([0] * add_num)
    
    return arr

# 간단한 논리 연산
def solution(x1, x2, x3, x4):
    
    # boolean 변수 x1, x2, x3, x4가 매개변수로 주어질 때, 다음의 식의 true/false를 return
    # (x1 ∨ x2) ∧ (x3 ∨ x4)
    
    answer = (x1 or x2) and (x3 or x4)
    return answer

# 문자열 반복해서 출력하기

# 솔루션 정의
# 문자열 str과 정수 n이 주어집니다.
# str이 n번 반복된 문자열을 만들어 출력하는 코드를 작성해 보세요.

a, b = input().strip().split(' ')
b = int(b)

print(a*b)

# 수열과 구간 쿼리 4
def solution(arr, queries):
    
    # 솔루션 정의
    # 정수 배열 arr와 2차원 정수 배열 queries이 주어집니다.
    # queries의 원소는 각각 하나의 query를 나타내며, [s, e, k] 꼴입니다.
    # 각 query마다 순서대로 s ≤ i ≤ e인 모든 i에 대해 i가 k의 배수이면 arr[i]에 1을 더합니다.
    # 위 규칙에 따라 queries를 처리한 이후의 arr를 return 하는 solution 함수를 완성해 주세요.
    
    n = len(queries)
    
    for m in range(n) :
        
        s, e, k = queries[m]
        
        for i in range(len(arr)) :
            
            if s <= i <= e and i % k == 0:
                arr[i] += 1

    answer = arr
    return answer

# 2의 영역
def solution(arr):
    
    # 솔루션 정의
    # 정수 배열 arr가 주어집니다.
    # 배열 안의 2가 모두 포함된 가장 작은 연속된 부분 배열을 return 하는 solution 함수를 완성해 주세요.
    # 단, arr에 2가 없는 경우 [-1]을 return 합니다.
    
    point = []
    answer = []
    
    for i in range(len(arr)) :
        
        if arr[i] == 2 :
            point.append(i)
    
    if not point :
        return [-1]
    
    else :
        min_value = min(point)
        max_value = max(point) + 1
        answer = arr[min_value:max_value]
        
        return answer
    
# 문자열 묶기
def solution(strArr):
    
    # 문자열 배열 strArr이 주어집니다.
    # strArr의 원소들을 길이가 같은 문자열들끼리 그룹으로 묶었을 때 가장 개수가 많은 그룹의 크기를 return
    
    n = len(strArr)
    answer = []
    
    for i in range(n) :
        
        answer.append(len(strArr[i]))
    
    max_count = answer.count(max(set(answer), key=answer.count))
    
    return max_count

# 리스트 자르기
def solution(n, slicer, num_list):
    
    # 정수 n과 정수 3개가 담긴 리스트 slicer 그리고 정수 여러 개가 담긴 리스트 num_list가 주어집니다.
    # slicer에 담긴 정수를 차례대로 a, b, c라고 할 때, n에 따라 다음과 같이 num_list를 슬라이싱 하려고 합니다.

    # n = 1 : num_list의 0번 인덱스부터 b번 인덱스까지
    # n = 2 : num_list의 a번 인덱스부터 마지막 인덱스까지
    # n = 3 : num_list의 a번 인덱스부터 b번 인덱스까지
    # n = 4 : num_list의 a번 인덱스부터 b번 인덱스까지 c 간격으로
    
    # 올바르게 슬라이싱한 리스트를 return하도록 solution 함수를 완성해주세요.
    
    answer = []
    a, b, c = slicer
    
    if n == 1 :
        answer.extend(num_list[:b+1])
        
    elif n == 2 :
        answer.extend(num_list[a:])
        
    elif n == 3 :
        answer.extend(num_list[a:b+1])
        
    elif n == 4 :
        answer.extend(num_list[a:b+1:c])
        
    else : pass
    
    return answer

# 조건에 맞게 수열 변환하기 2
def solution(arr):
    
    # 솔루션 정의
    # 정수 배열 arr가 주어집니다.
    # arr의 각 원소에 대해 값이 50보다 크거나 같은 짝수라면 2로 나누고
    # 50보다 작은 홀수라면 2를 곱하고 다시 1을 더합니다.

    # 이러한 작업을 x번 반복한 결과인 배열을 arr(x)라고 표현했을 때, arr(x) = arr(x + 1)인 x가 항상 존재합니다.
    # 이러한 x 중 가장 작은 값을 return 하는 solution 함수를 완성해 주세요.

    # 단, 두 배열에 대한 "="는 두 배열의 크기가 서로 같으며, 같은 인덱스의 원소가 각각 서로 같음을 의미합니다.
    
    n = len(arr)
    answer = arr
    num = 0
    
    while True :
        
        new_arr = []
        
        for i in answer :
        
            # 50보다 작고, 홀수라면 i * 2 + 1
            if (i % 2) != 0 and i < 50 :
                new_arr.append(i*2+1)

            # 그외(50보다 크거나 같은 짝수라면) 
            elif (i % 2) == 0 and i >= 50 :
                new_arr.append(i//2)
            
            else:
                new_arr.append(i)

        if answer == new_arr :
            return num
        
        answer = new_arr
        num += 1

    # qr code
def solution(q, r, code):
    
    # 솔루션 정의
    # 두 정수 q, r과 문자열 code가 주어질 때
    # code의 각 인덱스를 q로 나누었을 때 나머지가 r인 위치의 문자를 앞에서부터 순서대로 이어 붙인 문자열을 return
        
    answer = code[r::q]
    return answer

# 커피 심부름
def solution(order):
    
    # 솔루션 정의
    # 팀의 막내인 철수는 아메리카노와 카페 라테만 판매하는 카페에서 팀원들의 커피를 사려고 합니다.
    # 아메리카노와 카페 라테의 가격은 차가운 것과 뜨거운 것 상관없이 각각 4500, 5000원입니다.
    # 각 팀원에게 마실 메뉴를 적어달라고 하였고
    # 그 중에서 메뉴만 적은 팀원의 것은 차가운 것으로 통일하고 "아무거나"를 적은 팀원의 것은 차가운 아메리카노로 통일하기로 하였습니다.

    # 각 직원이 적은 메뉴가 문자열 배열 order로 주어질 때
    # 카페에서 결제하게 될 금액을 return 하는 solution 함수를 작성해주세요.
    # order의 원소는 아래의 것들만 들어오고, 각각의 의미는 다음과 같습니다.
    answer = 0
    
    for i in order :
        
        if 'americano' in i :
            answer += 4500
            
        elif 'latte' in i :
            answer += 5000
            
        else :
            answer += 4500
    
    return answer