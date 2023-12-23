# CentOS 7 기준 학습
CentOS는 상용시장에서 가장 인정받는 리눅스 중 하나인 Redhat Enterprise 리눅스의 클론 버전으로 Redhat Enterprise 리눅스의 소스를 그대로 가져다가 재컴파일한 것이다.

그러므로 Redhat Enterprise를 운영하는 것과 100% 같은 효과를 갖는다.

# 실습 환경
물리적인 1대의 컴퓨터를 VMware라는 가상머신 소프트웨어를 사용해 여러 서버를 구축하여 다양한 실습에 활용한다.
![위 학습 과정에서 구축할 네트워크 환경]('./image/01. Network Environment.png')

# Reference
![참고 카페](http://cafe.naver.com/thisislinux)
![참고 유튜브 재생목록 이것이 리눅스다.](http://www.youtube.com/HanbitMedia93)

- - -

# Chapter 01.
- 1부 성공적인 학습을 위한 준비 작업 및 CentOS 설치

기존 PC에 설치되어 있는 Windows를 호스트 운영체제(Host Operating System)라 부르며, 그 외 가상머신에 설치한 운영체제를 게스트 운영체제(Guest Operating System)라고 부른다.

## 가상머신 소프트웨어의 종류와 VMware Player 설치
- VMware(http://www.vmware.com)

> VMware Workstation과 VMware Player 비교
| 구분\제품 | VMware Workstation 9.0.x | VMware Player 5.0.x |
|:---------|:-----------:|:-----------:|
| 호스트 운영체제      | 모든 32비트, 64비트 Windows        | 모든 32비트, 64비트 Windows        |
| 게스트 운영체제      | 모든 16비트, 32비트, 64비트 Windows 대부분의 리눅스 운영체제        | 모든 16비트, 32비트, 64비트 Windows 대부분의 리눅스 운영체제        |
| 라이센스(가격)      | 유료        | 무료        |
| 라이센스 키      | 유료료 구매        | 필요 없음        |
| 가상머신 생성 기능      | O        | O        |
| 스냅숏 기능      | O        | X        |
| 가상 네트워크<br>사용자 설정 기능      | O        | O        |
| 비고      | 여러 가지 부가 기능이 있음        | 부가기능이 별로 없음        |

## VMware Workstation Player Install
![VMware 다운로드 사이트](https://www.vmware.com/kr/products/workstation-player.html)

