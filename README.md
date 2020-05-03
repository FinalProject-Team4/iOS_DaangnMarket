# <img src="assets/daangn.png" width="1%">DaangnMarket Clone 
> 패스트캠퍼스 iOS School에서 진행했던 Backend School과의 협업 프로젝트입니다.

## Description

- Duration : 2020.03.20 ~ 2020.04.29
- Skills
  - Language : Swift
  - Framework : UIKit, CoreLocation
  - Service : FCM, APNs, Firebase Authorization(Phone)
  - Library : Then, Alamofire, SnapKit, KingFisher, SwiftLint
- Members : 4명 (LoC<sup id="sup1">[1](#footnote1)</sup> 90%)
- Part
  - Firebase Authorization 서비스를 활용한 문자 인증 서비스 구현
  - FCM 및 APNs를 사용한 푸시 알림 구현
  - 위치기반 동네 설정 및 게시글이 노출될 주변 동네 설정 기능 구현
  - 채팅 UI 구현(기능은 Backend와 함께 계속 개발중)
  - 재사용되는 custom view를 추상화하여 팀원 모두가 사용할 수 있도록 제공(`DGUpperAlert`, `DGToastAlert`, `DGNavigationBar` 등)
  - 서버에 데이터를 요청하는 작업을 `API` class로 추상화 및 모듈화
  - iOS팀 팀장 역할을 맡아 프로젝트 기획, 일정 관리, Backend와의 커뮤니케이션, 원활한 협업을 위한 팀 내 Git 강의 및 Git 관련 trouble shooting 등을 주도함
  - SwiftLint를 적용하기 위해 팀원 모두와 document를 정독하고 코드 스타일을 

## 설계

- Flow Chart
- WireFrame

## 구현

- 위치기반 동네 설정 및 주변 동네 범위 설정
- 문자 인증
- 푸시 알림
- 채팅 UI

## 협업

- Project Board : Github에서 issue로 등록한 작업을 기준으로 project board에서 진행 상황 및 일정 공유
- Notion : Trouble Shooting, 회의 일정 등 관리
- Slack : Web hook 기능을 통해 commit, issue, pull request 등을 실시간으로 알림받고 대응

## Trouble Shooting

- `UITextView`에 입력된 텍스트가 줄바꿈이 될 때 `UITableViewCell`의 높이가 유동적으로 늘어나지 못하는 문제
- Chatting UI 구현 시 `UITableViewCell`이 text 크기에 맞게 줄어들지 않는 문제

---

<b id="footnote1"><sup>1</sup></b> Level of Contribution. 기여도 [↩︎](#sup1)

