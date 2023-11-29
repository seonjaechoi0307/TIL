def solution(my_string, n):
    
    # 솔루션 정의
    # 문자열 my_string과 정수 n이 매개변수로 주어질 때
    # my_string의 뒤에서부터 n글자로 이루어진 문자열을 return
    
    length = len(my_string)
    answer = my_string[(length-n):]
    return answer

def solution(n, control):
    
    # 솔루션 정의
    # 정수 n과 문자열 control이 주어집니다.
    # control은 "w", "a", "s", "d"의 4개의 문자로 이루어져 있으며
    # control의 앞에서부터 순서대로 문자에 따라 n의 값을 바꿉니다.
    
    # 원소 계산 딕셔너리 정의
    convert_dict = {
        "w": 1,
        "s": -1,
        "d": 10,
        "a": -10
    }
    
    # 계산
    for i in control :
        if i in convert_dict :
            n += convert_dict[i]
    
    return n

def solution(myString, pat):
    
    # 솔루션 정의
    # 문자 "A"와 "B"로 이루어진 문자열 myString과 pat가 주어집니다.
    # myString의 "A"를 "B"로, "B"를 "A"로 바꾼 문자열의 연속하는 부분 문자열 중
    # pat이 있으면 1을 아니면 0을 return 하는 solution 함수를 완성하세요.
    
    # 변수 설정
    n = len(myString)
    String = ''
    
    # A와 B를 변환하는 For문
    for char in myString :
        if char == 'A' :
            String += 'B'
        else :
            String += 'A'
    
    # myString과 pat을 비교하는 For문 일치 시 1, 불일치 시 0을 반환
    # 최대 반복횟수 = myString 문자길이 - pat 문자길이
    for i in range(n - len(pat) + 1) :
        
        # pat 문자길이 단위로 슬라이싱한 값이 pat과 일치 했을 때 1 반환
        if String[i:i+len(pat)] == pat :
            return 1
        
    return 0

def solution(my_string, n):
    
    # 솔루션 정의
    # 문자열 my_string과 정수 n이 매개변수로 주어질 때
    # my_string의 앞의 n글자로 이루어진 문자열을 return
    
    answer = my_string[:n]
    return answer

def solution(num_list):
    
    # 솔루션 정의
    # 정수가 담긴 리스트 num_list가 주어집니다.
    # num_list의 홀수만 순서대로 이어 붙인 수와 짝수만 순서대로 이어 붙인 수의 합을 return
    
    odd_num = ''
    even_num = ''
    
    for i in num_list :
        
        # i가 홀수일 때
        if (i % 2) != 0 :
            odd_num += str(i)
            
        # i가 짝수일 때
        else :
            even_num += str(i)
        

    answer = int(odd_num) + int(even_num)
    return answer

def solution(names):
    
    # 솔루션 정의
    # 최대 5명씩 탑승가능한 놀이기구를 타기 위해 줄을 서있는 사람들의 이름이 담긴 문자열 리스트 names가 주어질 때
    # 앞에서 부터 5명씩 묶은 그룹의 가장 앞에 서있는 사람들의 이름을 담은 리스트를 return
    # 마지막 그룹이 5명이 되지 않더라도 가장 앞에 있는 사람의 이름을 포함합니다.
    
    # 변수 설정
    n = len(names)
    answer = []
    
    # .append 메서드로 names i ~ i+5 중 첫 번째 해당하는 값 리스트 담기
    for i in range(0, n, 5) :
        
        # 5명씩 묶은 그룹
        group = names[i:i+5]
        
        # 첫 번째 값 리스트에 담기
        answer.append(group[0])
    
    return answer

def solution(start, end_num):
    
    # 솔루션 정의
    # 정수 start_num와 end_num가 주어질 때
    # start_num에서 end_num까지 1씩 감소하는 수들을 차례로 담은 리스트를 return
     
    answer = list(range(start, end_num-1, -1))
    return answer

def solution(my_string, index_list):
    
    # 솔루션 정의
    # 문자열 my_string과 정수 배열 index_list가 매개변수로 주어집니다.
    # my_string의 index_list의 원소들에 해당하는 인덱스의 글자들을 순서대로 이어 붙인 문자열을 return
    
    # 변수 설정
    answer = ''
    
    # my_string의 index_list번째 값을 받아서 answer 값에 붙히기
    for i in index_list :
        answer += my_string[i]
    
    return answer

def solution(num_list):
    
    # 솔루션 정의
    # 정수 리스트 num_list가 주어질 때
    # 마지막 원소가 그전 원소보다 크면 마지막 원소에서 그전 원소를 뺀 값을
    # 마지막 원소가 그전 원소보다 크지 않다면 마지막 원소를 두 배한 값을 추가하여 return
    
    n = len(num_list) - 1
    
    if num_list[n] > num_list[n-1] :
        add = num_list[n] - num_list[n-1]
        num_list.append(add)
    
    else :
        add = num_list[n] * 2
        num_list.append(add)
    
    return num_list

def solution(arr, n):
    
    # 솔루션 정의
    # 정수 배열 arr과 정수 n이 매개변수로 주어집니다.
    # arr의 길이가 홀수라면 arr의 모든 짝수 인덱스 위치에 n을 더한 배열을
    # arr의 길이가 짝수라면 arr의 모든 홀수 인덱스 위치에 n을 더한 배열을 return
    
    # 변수 설정
    k = len(arr)
    
    # 홀수 길이의 배열이면 짝수 인덱스에 n을 더함
    if (k % 2) != 0 :
        for i in range(0, k, 2) :
            arr[i] += n
            
    # 짝수 길이의 배열이면 홀수 인덱스에 n을 더함
    else :
        for i in range(1, k, 2) :
            arr[i] += n
    
    return arr

