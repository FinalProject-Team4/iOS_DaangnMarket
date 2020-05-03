# DaangnMarket Clone
## Description

- 패스트캠퍼스에서 약 1달간(2020.03.20 ~ 2020.04.29) iOS 및 Backend 수강생들과 협업하여 진행했던 프로젝트
- Cocoapods를 통한 다양한 open source library 사용 경험
- Storyboard 없이 code만 사용하여 AutyLayout으로 UI 구현
- 재사용되는 UI를 팀원 모두가 사용할 수 있도록 하나의 View로 추상화하고 적용한 경험
- 당근마켓의 핵심 기능인 위치기반 동네 인증 기능 구현. 인증 동네로부터 일정 반경의 거리 안에 있는 동네에만 게시글 작성 및 피드 노출 구현
- Firebase 전화번호 인증 기능을 활용하여 문자인증 로그인 기능 구현
- FCM 및 APNs를 활용한 서버 알림 기능 구현
- 서버에 데이터를 요청할 때 query할 데이터의 encoding 및 서버에서 제공하는 JSON format 데이터의 파싱(decoding)을 위해 Codable 객체를 design하고 사용한 경험
- Backend 개발자와 함께 데이터 구조를 고민하고 설계해 본 경험
- 코드 가독성 향상을 위해 SwiftLint 적용 경험
- Git, Github, Git-Flow 등 Git을 사용한 프로젝트 관리
- CLI(iTerm2) 및 GUI(GitKraken) 환경에서 Git을 사용해 본 경험
- Github Project Board, Notion, Slack 등을 활용하여 커뮤니케이션 및 프로젝트 관리

## 사용 기술

- Language : Swift
- Framework : UIKit, CoreLocation
- Service : FCM, APNs, Firebase Authorization(Phone)
- Library : Then, Alamofire, SnapKit, KingFisher, SwiftLint

## 주요 기능

- 위치기반 동네 설정
- 게시글이 노출되는 동네 범위 설정
- 게시글 피드 및 카테고리별 목록 조회
- 중고거래 글쓰기
- 판매 상품 페이지 조회
- 전화번호 로그인/인증 및 회원가입
- 채팅(Backend와 함께 추가 구현 중)

