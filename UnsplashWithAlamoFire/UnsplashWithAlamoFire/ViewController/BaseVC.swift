//
//  BaseVC.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/21.
//

import UIKit

class BaseVC:UIViewController { //상속 사용해서 공통되는 코드 사용 줄이기 
    
    var vcTitle : String = "" {
        didSet {
            print("UserLsitVC - vcTitle didSte() callsed / vcTitle :  \(vcTitle)")
            self.title = vcTitle 
        }
    }
    
}
