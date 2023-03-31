# 찾아봐🔎

<img width="1066" alt="스크린샷 2023-01-27 오후 3 53 04" src="https://user-images.githubusercontent.com/81469717/215980641-8ead2076-029b-47c5-af82-aff350d73239.png">


개발, 기획, 디자인: [@yeaghdev](https://github.com/yeahg-dev)

<br>

### 기획 의도  

- 아이폰에서 다른 국가의 앱스토어를 구경하기 위해서는 [8단계](https://support.apple.com/ko-kr/HT201389)를 거쳐야합니다.

- ''전 세계 앱스토어의 앱을 좀 더 간편하게 검색하고, 모아볼 수 있는 앱이 있다면 번거로움을 덜어줄 수 있겠다!''에서 시작했습니다.
- 국가, OS(iPhone, iPad,) 선택 -> 검색, 2단계만 거치면 바로 내가 보고싶은 국가의 앱을 검색할 수 있습니다.

<br>

### 찾아봐의 기능

| 기능 |   시뮬레이션   |
| ------------------------------------------------------------ | ---- |
| 국가, OS를 설정한 후,  설정한 나라의 OS별 앱 스토어에서 검색을 할 수 있어요<br />이름과 ID 모두 가능해요 | ![search](https://user-images.githubusercontent.com/81469717/215981811-e805274e-6caf-4897-9ba5-418223b9bcc0.gif) |
| 검색한 앱의 더 자세한 정보를 볼 수 있어요  |  ![appDetail](https://user-images.githubusercontent.com/81469717/215981104-629e512b-559c-41ee-b0a7-df28c2017c73.gif)  |
| 최근 검색 키워드를 저장할 수 있어요 <br />물론, 검색 키워드를 삭제할 수 있고, 저장 여부는 선택할 수 있어요 |  ![searchkeyword](https://user-images.githubusercontent.com/81469717/215981189-e6c0f1cb-d1cd-4c2a-9ad5-2a62a7ccbde1.gif) |
| 폴더를 만들어 전세계 국가의 앱을 저장할 수 있어요<br />검색한 앱의 국가와 지원 기기에 대한 정보도 확인할 수 있어요 |  ![appFolderCreate](https://user-images.githubusercontent.com/81469717/215981246-f33ed983-79f7-43c9-85d7-43f8dc92a262.gif)  |
| 폴더를 수정하고 삭제할 수 있어요  |   ![appFolderEdit](https://user-images.githubusercontent.com/81469717/215981309-2f37fdfd-7232-459d-b8de-d8ed0b104f7b.gif)|

  

### 사용 API

- [iTunesAPI ](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html)

<br>

###  Tech Stack

- Swift

- UI : UIKit(code base UI), AutoLayout
- Network : URLSession, RESTAPI
- Database : RealmSwfit
- Reacive Programming: Combine
- 의존성 관리 툴 : SPM

<br>

### code style 

- [Swift Style Guide](https://github.com/StyleShare/swift-style-guide), [API Design GuideLine](https://www.swift.org/documentation/api-design-guidelines/)를 따릅니다. 

<br>

## 아키텍처 소개

### Clean-MVVM

**도입 이유**

- Mssive ViewController의 역할을 분리하기 위해 MVVM 사용
- 애플리케이션 역할을 비즈니스 로직, 데이터 Repository, Database, API로 작게 분리하고, 의존성을 분리하기 위해 클린아키텍처를 역할 분리 모델로 선택
- 레이어의 단방향 의존은 테스트 작성에 용이
- 가장 많이 변경되는 View는 레이어의 최외곽에 위치하므로 UI 변경 요구사항에 대응하기 쉬움

**역할 정의**

![CleanMVVM](https://user-images.githubusercontent.com/81469717/215982031-9bd63f88-577a-4800-bedf-17d3f39fc2a2.png)


- View : UI, 레이아웃을 구성, ViewModel으로 받은 데이터를 표시, 사용자 액션을 ViewModel에 전달
- ViewModel : Usecase로부터 받은 데이터를 UI에 표시하는 형태로 변환, 사용자 액션에 따른 비즈니스 로직을 Usecase를 사용해 실행
- Usecase : 앱의 핵심 비즈니스 로직을 구현, Repositry Layer로부터 얻은 데이터를 모델로 변환해서 사용
- Repository : APIService 또는 Realm을 사용해 데이터를 페치, 수정, 삭제, 저장하는 역할을 구현

**결과**

- **장점**
  - 역할을 작게 유지함으로서 기능의 확장, 유지보수에 용이
  - 각 레이어별 테스트 수행하기 용이
  - 코드의 응집성은 높게, 결합도는 낮게 설계되어있으므로 변경사항이 있을 때  적은 양의 코드만 수정하면 됨

- **단점**
  - 개발 비용(시간, 파일 개수)의 증가
  - 비즈니스 로직에 작은 기능을 추가하는데 모든 레이어에 API를 설계해야하므로 개발 비용이 커짐
  - 내부 데이터베이스 구현 프레임워크를 변경하지 않는다면 RepositoryLayer와 Repository구현체 분리는 오버헤드라는 생각이 들었음

<br>

### Coordinator Pattern

**도입 이유**

- 뷰 컨트롤러 안에 뷰 생성 및 화면 전환 로직이 분산되어 있어 관리하기 어려움
- 뷰 컨트롤러간에 결합이 생김

**결과**

- **장점**
  - 화면 전환 로직을 한 곳에서 관리할 수 있음
  - 여러 화면전환을 한꺼번에 관리 가능

- **단점**

  - 뷰컨 간의 델리게이트를 처리하기 복잡해짐
  - 간단한 전환을 위해서도 생성하는 파일들이 많음

<br>

## 프로젝트에서 도전한 과제와 배운점

### ✅ Realm 백그라운드 스레드에서 비동기로 실행시키기

**도전 과제**

- Realm의 CRUD 작업을 백그라운드 스레드에서 비동기로 실행하고 싶었습니다. 
- 일반적으로 mainQueue에서 작업을 하도록 지정하지만, mainQueue는 UI작업을 하도록 공간을 남겨주고 싶었기 때문입니다.

**구현 방법**

- serialQueue를 생성하여, 큐에서 비동기로 작업을 처리하도록 구현했습니다. 
- 비동기로 작업이 완료된 다음 후속 작업을 할 수 있도록 탈출클로저를 인자로 받았으나, 이는 코드의 가독성을 헤치고 흐름을 파악하기 어렵다는 문제가 있었습니다.
- `withCheckedThrowingContinuation` 을 사용해 비동기 코드를 감싸고, 데이터를 사용하는 코드에서는 `async/await` 을 사용해 동기처럼 코드를 작성했습니다. 
- RealmObject는 생성 스레드에서만 유효하므로, Repository에서 내보낼 때는 도메인 모델(구조체)로 변환시켜 사용했습니다.

<img src="https://user-images.githubusercontent.com/81469717/215983116-7e49fd9d-a87d-46aa-9740-7c425aea80bc.png" width="500">

**결과**

- DB의 트랜잭션을 처리하는 스레드를 분리시킬 수 있었습니다. 
- 구조체로 타입을 변경함으로써 Concurrency 환경에서 안전하게 데이터를 주고 받을 수 있었습니다.
- 가독성이 향상되었습니다. 
- UI업데이트를 위해 `Task`를 사용하는 곳에서는 코드 인덴트가 깊어졌지만, 탈출 클로저 사용으로 인한 가독성 저해보다는 낫다고 생각했습니다. 

<br>

### ✅ Repository Layer Test

**도전 과제**

- Usecase에서 사용하기 전, DB작업이 정상적으로 처리되는지 테스트하고 싶었습니다.

**구현 방법**

- `Realm`과  `serialQueue` 를 프로퍼티로 가지는 `RealmStore`를 주입받아 `RealmAppFolderRepository` 를 생성하도록 구현했습니다.
- Test에서는 InMemory Realm으로 설정한 `RealmStore`를 사용해 각 테스트 케이스를 독립적으로 테스트해 볼 수 있었습니다.

<br>

### ✅ CALayer로 평점 별 모듈 구현

**도전 과제**

- 앱 사용자 평점을 나타낼 별5개의 뷰가 필요했습니다.
- 평점에 따라 별을 채울 수 있도록 뷰를 구현해야했습니다. 

<img width="500" alt="스크린샷 2023-01-27 오전 10 51 49" src="https://user-images.githubusercontent.com/81469717/215982254-7842bcb0-6916-440d-a45b-bfed9eb618a2.png">

**구현 방법**

- 별 5개를  각각 `UIView`로 구현하는 방법도 생각했습니다.
- 하지만 `UIView`는 Mainthread에서 CPU를 사용하고, `CALayer` 는 GPU를 사용하기 때문에 `CALayer`가 CPU활용, 응답성 측면에서 유리할 것이라 생각했습니다.
- 기존에 있는 Cosmos 라이브러리를 참고하여, `StarRatingView` 컴포넌트를 구현했습니다.
- 별의 크기, 색상, 별사이 간격을 Configuration으로 설정할 수 있고, 전달 받은 값에 해당하는 별점을 그려냅니다. 

**결과**

- 별의 크기, 색상, 별 사이 간격을 Configuration으로 설정할 수 있고, 전달 받은 값에 해당하는 별들을 그리도록 구현했습니다. 별의 디자인적 요소는 캡슐화하고, 드로잉 로직은 분리하여 유지 보수의 용이성을 느낄 수 있었습니다. 

<br>

### ✅ 기기 사이즈에 adaptable한 화살표 애니메이션 구현

**도전 과제**

- 다양한 사이즈의 스크린에서 원의 둘레를 따라 움직이는 화살표를 구현하고 싶었습니다. 

**구현 방법**

- `UIBezierPath ` 로 경로를 정의하고, `CAKeyframeAnimation` 을 사용해 호를 따라 움직이는 애니메이션을 구현했습니다.
- `CAShapeLayer`를 상속한 `AnimatableArrowLayer`  를 구현해, 다양한 사이즈의 원에서도 동일한 애니메이션을 동작하도록 타입화했습니다.

**결과**

- 애니메이션 요소를 타입화함으로써 가독성이 높아졌습니다.
- 역할을 작게 분리하여 응집성이 높아졌습니다

[과정을 정리한 블로그](https://velog.io/@yeahg_dev/CoreAnimation%EC%9C%BC%EB%A1%9C-%EC%9B%90%EC%9D%84-%EB%94%B0%EB%9D%BC-%EC%9B%80%EC%A7%81%EC%9D%B4%EB%8A%94-%ED%99%94%EC%82%B4%ED%91%9C-%EB%A7%8C%EB%93%A4%EA%B8%B0)

<br>

### ✅ 다양한 섹션 스타일의 컬렉션뷰 구현

**도전 과제**

- 버전 업데이트 노트, 앱 스크린 샷, 앱 설명, 앱 정보등 다양한 정보와 그를 보여주는 다양한 스타일의 Cell을 하나의 뷰에 구성해야했습니다. 

<img width="214" alt="스크린샷 2023-01-27 오전 10 51 00" src="https://user-images.githubusercontent.com/81469717/215983695-7ff501b9-3b39-49a2-b09d-a1a001ed8f7f.png">


**구현 방법**

- CompositionalLayout을 학습해 섹션별로 CustomCell, layout을 적용할 수 있도록 구현했습니다. 
- 각 CustomCell내부에서 재사용되는 뷰는 CustomView로 타입을 분리해 코드의 복잡성을 덜었습니다. 
- Custom Section Header를 구현하기 위해 UICollectionReusableView를 상속했습니다. 

<br>

### ✅ 사용자 반응형 UI Combine으로 구현하기

**도전 과제**

- 텍스트 필드의 input 사이즈에 따라 버튼의 `isEnabled` 상태를 업데이트해야했습니다. 

**구현 방법**

- 반응형 UI를 구현하기 위해 Combine을 사용해 UserEvent -> Input -> ViewModel -> Output -> UI업데이트 단방향 플로우를 만들었습니다. 

**결과**

- UI를 언제 어떻게 바꿀지에 대한 로직은 뷰모델이 처리, 뷰는 수동적으로 데이터를 표시하는 역할만 수행하도록 분리할 수 있었습니다. 

<br>

### ✅ Realm + iTunes API 데이터 파이프 라인 구축하기

**도전 과제**

- AppFolder에 저장된 SavedApp의 데이터로 iTunes SearchAPI를 호출하고, 받은 Response와 SavedApp 데이터를 병합하여 각 셀에 표시해야 했습니다. 미리 모든 SavedApp에 대한 API 호출을 하고 모든 데이터가 도착한 뒤 reloadData를 하는 것은 비효율적이고, 긴 로딩 시간을 초래하기에 좋지 않은 사용성을 줄 것이라 생각했습니다. 

**구현 방법**

- Combine의 operator를 활용해 “ SavedApp으로 iTunesAPI 호출 ➡️ SavedApp과 Response를 병합해 CellModel로 변환 ➡️  Cell에서 구독” 하는 스트림을 만들었습니다.
- cellForRowAt에서 스트림을 생성한 후 cell에서 구독하여 비동기적으로 받은 데이터를 셀 내부에서 업데이트 할 수 있도록 구현했습니다.

<img width="970" alt="스크린샷 2023-01-30 오후 5 14 13" src="https://user-images.githubusercontent.com/81469717/215983998-e0ff7d7b-75ca-4a33-8f2d-6146eb6535a9.png">

**결과**

- 셀이 디큐되어 표시될 때 스트림이 시작되므로 셀의 데이터가 늦게 표시되는 지연이 발생했습니다. 

- `UITableViewDataSourcePrefetching`으로 셀이 디큐되기전 미리 스트림을 실행시켜 데이터를 다운로드 받은 후, 해당 데이터로 바인딩할 수 있도록 개선했습니다. (https://github.com/yeahg-dev/app-show-room/issues/24)

<br>

## 구현 및 보완 예정 기능

- 다국어 지원(한국어/영어)
- 공유 기능 추가 (앱 스토어 링크 내보내기)
- 네트워크 체커 
- 효율적인 리소스 관리 방법으로 변경
