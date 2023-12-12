## 함수
def findMinIndex(ary) :
    minIdx = 0
    for i in range(1, len(ary)) :
        if (ary[minIdx] > ary[i]) :
            minIdx = i
    return minIdx

## 변수
testAry = [55, 88, 33, 77, 99, 11, 55, 89, 13]

## 메인
minPos = findMinIndex(testAry)
print('최솟값 -->', testAry[minPos])