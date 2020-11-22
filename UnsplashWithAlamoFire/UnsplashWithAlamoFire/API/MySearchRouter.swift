//
//  MySearchRouter.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/22.
//

import Foundation
import Alamofire

//검색관련 api 호출 은 여기서
enum MySearchRouter: URLRequestConvertible {
    case searchPhotos(term: String)
    case searchUsers(term: String)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL +  "search/")!
    }
    
    var method: HTTPMethod {
        //return .get
    
        
        switch self {
        case .searchUsers, .searchPhotos:
           return .get

        }
        
        
//        switch self {
//        case  .searchPhotos:
//            return .get //포토인경우 HTTP메소드는 get방식으로 하겠다
//        case .searchUsers:
//            return .delete
//        }
    }
    
    var endPoint: String { //끝에 붙는거
        switch self {
        case .searchPhotos:
            return "photos/"
        case .searchUsers:
            return "users/"
        }
    }
    
    var parameters: [String :String] {
        switch self {
        case let.searchUsers(term),let .searchPhotos(term):
            return ["query": term]
    }
    }
        //ex
//        switch self {
//        case let.searchUsers(term):
//            return ["query1": term + ""]
//        case let .searchPhotos(term):
//            return ["query2": term]
//    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
        
        
        print("MysearchRouter - asURLRequest() url:\(url)")
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
                 //위에 throw 있으니
        
        return request
    }

}
