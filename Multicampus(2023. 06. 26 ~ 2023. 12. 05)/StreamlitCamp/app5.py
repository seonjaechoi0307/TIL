import matplotlib.pyplot as plt
import streamlit as st
import seaborn as sns

def main():
    st.title("확인")
    with st.sidebar:
        st.header("Sidebar")
        day = st.selectbox("요일 선택", ["Thur", "Fri", "Sat", "Sun"])

    tips = sns.load_dataset("tips")
    filtered_tips = tips.loc[tips['day'] == day]
    st.dataframe(filtered_tips)
    top_bill = filtered_tips['total_bill'].max()

    tab1, tab2, tab3 = st.sidebar.tabs(['Total Bill', 'Tip', 'Size'])
    with tab1:
        fig, ax = plt.subplots()
        st.header("Total Bill")
        sns.histplot(filtered_tips['total_bill'], kde=False, ax=ax)
        st.pyplot(fig)
    
    with tab2:
        st.metric("Best of tip", top_bill)

    with tab3:
        st.header("Scatter Plot")
        fig, ax = plt.subplots()
        sns.scatterplot( x = 'total_bill', y = 'tip', data = filtered_tips, ax = ax)
        st.pyplot(fig)

if __name__ == "__main__":
    main()

# 2023-07-28
# 1. Streamlit 구성 요소, 기본 문법 배움
# 2. 프로젝트 시 Streamlit or django 중 어떤 것을 사용할지?
# ---> if django : plotly, dash 배워야 함
# ---> if streamlit : plotly?, matplotlib/seaborn?
# 3. 대시보드 레이아웃
# ---> streamlit 에서 제공 해주는 기본 포맷 괜찮을 시
# ---> streamlit 에서 제공 해주는 기본 포맷 마음에 안들 시
#       ---> 레이아웃 찾기 !! HTML, CSS, Streamlit 에 적용하는 훈련
# 4. pandas 기초문법   
# ---> 머신러닝/딥러닝 :
# ---> pandas 데이터 가공하는 훈련 해야됨
# 5. 주말 과제
# ---> ToDolist 이해가 완벽하게 됨 ---> chapter3 깃허브 페이지 주소만 제출
# ---> ToDolist 이해가 부족하게 됨 ---> ToDolist & 이메일 전송 예제 깃허브 페이지 주소 제출