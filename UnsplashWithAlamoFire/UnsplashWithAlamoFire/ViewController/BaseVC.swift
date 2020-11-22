//
//  BaseVC.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/21.
//

import UIKit
import Toast_Swift

class BaseVC:UIViewController { //상속 사용해서 공통되는 코드 사용 줄이기 
    
    var vcTitle : String = "" {
        didSet {
            print("UserLsitVC - vcTitle didSte() callsed / vcTitle :  \(vcTitle)")
            self.title = vcTitle 
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //인증실패 노티피케이션 등록
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopup(notication:)), name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //노티피케이션 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    //MARK: - objc methods
    
    @objc func showErrorPopup(notication:NSNotification) {
        print("BaseVc - showErrorPopup called")
        
        if let data = notication.userInfo?["statusCode"] {
            print("showEroorPopup() data \(data)")
            
            DispatchQueue.main.async {
                self.view.makeToast("\(data) 에러입니다", duration: 1.5, position: .top)
            }
            
        }
    }
    
}
