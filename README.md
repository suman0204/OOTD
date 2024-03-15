<p align="left">
  <img width="100" alt="image" src="https://github.com/suman0204/MyPick/assets/18048754/983016dd-cabb-400f-aab6-266f7953aae1">
</p>

# OOTD

---

**코디 정보를 공유하는 커뮤니티 앱**

<p align="center">
<img src="https://github.com/suman0204/OOTD/assets/18048754/4d2bceec-4efb-421b-9d61-a6d50c888799" width="19%" height="20%">
<img src="https://github.com/suman0204/OOTD/assets/18048754/4e8e0aaa-0da1-41b2-bd46-42f11172f37f" width="19%" height="20%">
<img src="https://github.com/suman0204/OOTD/assets/18048754/ce7877cf-6efe-42d0-bf8a-7922b46a2bf0" width="19%" height="20%">
<img src="https://github.com/suman0204/OOTD/assets/18048754/3f2c0617-caba-4360-8678-8da509da04d3" width="19%" height="20%">
<img src="https://github.com/suman0204/OOTD/assets/18048754/449bd201-5269-47a3-b040-788e553318cb" width="19%" height="20%">
</p>

## 프로젝트 소개

---

> 앱 소개
> 
- 회원가입, 로그인 기능
- 사진과 텍스트 기반 게시글 업로드
- 유저들이 올린 게시물 확인

---

> 주요 기능
> 
- **Regular Experession**을 사용하여 회원가입 유효성 검증 및 **RxSwift** 활용한 **반응형 UI** 구현
- **JWT Token** 기반 로그인 구현 및 **KeyChain**을 통한 Token 관리
- **RequestInterceptor**를 통한 **AccessToken** 갱신 및 **RefreshToken** 만료 시 대응
- **RxSwift**의 **Single Trait**를 활용한 네트워크 요청 로직 구현
- **Moya**를 활용한 **Router Pattern** 구성
- **Custom Result**와 **Custom Error** 구성을 통한 **에러 핸들링**
- **Cursor Based Pagination**을 통한 데이터 갱신
- **multipart/form-data** 를 통한 이미지 및 텍스트 데이터 업로드

---

> 개발 환경
> 
- 최소 버전 : iOS 16.0
- 개발 인원: 1인
- 개발 기간: 2023.11.22 ~ 2023.12.17

---

> 기술 스택
> 
- UIKit, PhotosUI, KeyChain
- RxSwift, Moya, Alamofire, Snapkit, Kingfisher
- MVVM, Input/Output, Singleton, DTO

---

## 트러블 슈팅

---

### 1. 네트워크 에러 핸들링 해결법

**문제점**

서버에서 오는주는 에러에 유연하게 대응하기 위해 **프로토콜**을 정의하고 이를 채택하는 **enum을 활용**하여 에러 **케이스들을 정의**하였으나 이를 **Result타입**과 함께 사용하지 못하는 문제

```swift
protocol LoggableError: Error {
    var rawValue: Int { get }
    var errorDescription: String { get }
}
```

```swift
enum CommonError: Int, LoggableError {
    case requiredValue = 400
    case noUserWrongPassword = 401
    case forbiden = 403
    ...

    var errorDescription: String {
        switch self {
        case .serverKey:
            return "This service sesac_memolease only"
        case .overCall:
            return "과호출입니다."
        ...
        
        default:
            return ""
        }
    }
}
...
```

**해결법**

**Generic**을 활용한 **Custom Type**을 정의하여 각기 다른 API 호출의 응답에 따른 반환 값에 대응할 수 있게 만듦

모든 API에서 **공통적으로 오는 에러**에 대해서 **1차적으로 필터링**을 하고 만약 공통 에러에서 **걸러지지 않는 에러**인 경우 **에러 자체를 던져**주어 활용할 수 있도록 설계함

```swift
enum CustomResult<T, E> {
    case success(T)
    case failure(E)
}
```

```swift
func loginRequest(api: API) -> Single<CustomResult<LogInResponse, LoggableError>>{
    return Single.create { single in
        self.provider.request(api) { result in
            switch result {
            case.success(let value):
                print("Success", value.statusCode, value.data)
                
                guard let data = try? JSONDecoder().decode(LogInResponse.self, from: value.data) else {
                    return
                }
                single(.success(.success(data)))
                
            case .failure(let error):
                print("Failure", error)
                
                guard let statusCode = error.response?.statusCode, let commonError = CommonError(rawValue: statusCode) else {
                    single(.success(.failure(CommonError.unknownError)))
                    return
                }
                
                single(.success(.failure(commonError)))
               
            }
        }
        return Disposables.create()
    }
}
```

---

### 2. RxSwift Single의 failure로 에러 방출 시 스트림 종료 문제

**문제점**

네트워크 요청 과정에서 성공과 실패에 대해서만 관리할 수 있는 **RxSwift**의 **Single**을 활용하였으나 **single(.failure(error)**를 return 하는 경우 flatMap으로 연결된  **Stream이 dispose**되어 다시 요청할 수 없는 문제가 발생

```swift
func signUpRequest(api: API) -> Single<CustomResult<JoinResponse, LoggableError>> {
    return Single.create { single in
        self.provider.request(api) { result in
            switch result {
            case.success(let value):
		            ...
                single(.success(.success(data)))
                
            case.failure(let error):
                ...
                single(.failure(.failure(commonError)))
                
            }
        }
        return Disposables.create()
    }
}
```

**해결법**

네트워크 요청 시 성공, 실패 여부와 상관 없이 **Single의 success 이벤트를 발행**하여 구독을 유지

```swift
func signUpRequest(api: API) -> Single<CustomResult<JoinResponse, LoggableError>> {
    return Single.create { single in
        self.provider.request(api) { result in
            switch result {
            case.success(let value):
		            ...
                single(.success(.success(data)))
                
            case.failure(let error):
                ...
                single(.success(.failure(commonError)))
****                
            }
        }
        return Disposables.create()
    }
}
```
