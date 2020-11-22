//
//  MyAlamoFireManager.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/22.
//

import Foundation
import Alamofire

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
}
