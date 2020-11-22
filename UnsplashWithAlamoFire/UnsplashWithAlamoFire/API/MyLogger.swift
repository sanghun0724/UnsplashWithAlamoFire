//
//  MyLogger.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/22.
//

import Foundation
import Alamofire

final class  MyLogger : EventMonitor {
    
    let queue = DispatchQueue(label: "MyLogger")
    
    func requestDidResume(_ request: Request) {
        print("MyLogger - requestDidResume")
        debugPrint(request)  //그 로그중에 get 써잇는부분
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        //로그중에  위에꺼 밑에 400 뜨는거 스테츄코드 그부분
        print("MyLogger -request.didParseRespnse")
        debugPrint(request)
    }
}
