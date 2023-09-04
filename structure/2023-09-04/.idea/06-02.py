## 함수
def isStackFull() :
    global Size, stack, top
    if (top >= Size-1) :
        return True
    else :
        return False

def push(data):
    global Size, stack, top
    if (isStackFull()) :
        print('스택 꽉참 !!')
        return
    top += 1
    stack[top] = data

def isStackEmpty() :
    global Size, stack, top
    if (top <= -1) :
        return True
    else :
        return False

def pop() :
    global Size, stack, top
    if (isStackEmpty()) :
        print('스택이 비어있음 !!')
        return
    
    # Case 1
    data = stack[top]
    stack[top] = None
    top -= 1
    print('팝-->', data)
    return data
    
def peek() :
    global Size, stack, top
    if (isStackEmpty()) :
        print('스택이 비어있음 !!')
        return
    return stack[top]

## 변수
Size = 5
stack = [None for _ in range(Size)]
top = -1

## 메인
push('커피')
push('녹차')
push('꿀물')
push('콜라')
push('환타')
print('바닥 :', stack)

'''push('게토레이')
print('바닥 :', stack)'''

retData = pop()
print('팝데이터==>', retData)

print('다음 데이터', peek())

retData = pop()
print('팝데이터==>', retData)
retData = pop()
print('팝데이터==>', retData)
print('바닥 :', stack)