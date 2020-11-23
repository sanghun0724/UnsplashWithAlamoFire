//
//  MyAlamoFireManager.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/22.
//

import Foundation
import Alamofire
import SwiftyJSON

final class MyAlamoFiremanager {
    
    //싱글턴 적용
    static let shared = MyAlamoFiremanager()
    
    //인터셉터(API를 호출할때 그 중간에서 예를들어 공통 파라미터를 넣는다던지 엑세스 토큰을 넣는다든지 등(JWT) < 확인등)
    let interceptors = Interceptor(interceptors:
                                    [
                                        BaseInterceptor()
                                    ]) //배열형태라 여러가지 추가가능
    
    //로거 설정 (이벤트 모니터!)
    let monitors = [MyLogger(), MyApiStatusLogger()] as [EventMonitor]
    
    //세션 설정
    var session : Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func getPhotos(searchTerm userInput:String,completion : @escaping (Result<[Photo],MyError>) -> Void) {
        
        print("MyAlamofireManager - getPhotos \(userInput)")
        
        self
            .session
            .request(MySearchRouter.searchPhotos(term: userInput))
            .validate(statusCode: 200..<401) //200에서 400까지만 받겠다
            .responseJSON(completionHandler: {
                response in
                
                guard let responseValue = response.value else {
                    return
                }
                
                
                let responseJson = JSON(responseValue)
                
                let jsonArray = responseJson["results"]
                
                var photos = [Photo]()
                
                print("jsonArray.size \(jsonArray.count)")
                
                for (index,subJson) : (String,JSON) in jsonArray {
                    print("index: \(index) , subJson: \(subJson)")
                    
                    //데이터 파싱
                    // -1
                    //                    let thumnail = subJson["urls"]["thum"].string ?? ""
                    //                    let username = subJson["user"]["username"].string ?? ""
                    //                    let likesCount = subJson["likes"].intValue ?? 0
                    //                    let createdAt = subJson["created_at"].string ?? ""
                    
                    //-2
                    guard let thumnail = subJson["urls"]["thumb"].string,
                          let username = subJson["user"]["username"].string,
                          let createdAt = subJson["created_at"].string else {
                        return
                    }
                    let likesCount = subJson["likes"].intValue
                    
                    let PhotoItem = Photo(thumnail: thumnail, username: username, likesCount: likesCount, createdAt: createdAt)
                    //배열에 넣고
                photos.append(PhotoItem)
                }
                
                if photos.count > 0 {
                    completion(.success(photos))
                } else {
                    completion(.failure(MyError.noContent))
                }
                
            })
    }
    
    
}
