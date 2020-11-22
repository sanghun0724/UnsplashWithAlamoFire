//
//  BaseIntercepter.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/22.
//

import Foundation
import Alamofire
   //시간날때 이부분 공식문서 다시 참고
class BaseInterceptor:RequestInterceptor {
    
    //
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) { //AF.request 호출될때 같이 호출됨 //completion 꼭호출해야함! 안그럼 멈춤
        print("BaseInterceptor - adapt called")
        
        var request = urlRequest
        
        // Accept가 밑에"application/json" -> json형태로만 받는거
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        
        //공통 파라메터 추가
        var dictionary = [String:String]()
        
        dictionary.updateValue(API.CLIENT_ID, forKey: "client_id")
        
        do {
            request = try URLEncodedFormParameterEncoder().encode(dictionary, into: request)
            
        } catch {
            print(error)
        }
        
        
        completion(.success(request))
    }
    
    //
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry() called")
        
        
        completion(.doNotRetry) //호출중에 에러같은거 났을때 다시시도할거?
    }
}
