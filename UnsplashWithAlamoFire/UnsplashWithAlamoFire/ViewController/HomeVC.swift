//
//  ViewController.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/19.
//

import UIKit
import Toast_Swift
import Alamofire

class HomeVC: BaseVC,UISearchBarDelegate,UIGestureRecognizerDelegate {

    @IBOutlet var control:UISegmentedControl!
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var searchBar:UISearchBar!
    @IBOutlet var button:UIButton!
    
    var filterData:[String] = []
    var data:[String] = []
    var keyboardDismissTabGesture : UIGestureRecognizer =
        UITapGestureRecognizer(target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.becomeFirstResponder() //포커싱주기
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            let nextVC = segue.destination as! UserListVC
            
            guard let userInputValue = self.searchBar.text else {
                return
            }
            nextVC.vcTitle = userInputValue
        case SEGUE_ID.PHOTO_COLLECTION_VC:
            let nextVC = segue.destination as! PhotoCollectionVC
            
            guard let userInputValue = self.searchBar.text else {
                return
            }
            nextVC.vcTitle = userInputValue
            
        default:
            print("default")
        }
    }
    
    //MARK:- fileprivate methods
    
    fileprivate func config() {
        searchBar.delegate = self
        self.button.layer.cornerRadius = 10
        self.searchBar.searchBarStyle = .minimal
        self.keyboardDismissTabGesture.delegate = self
        //제스처 추가
        self.view.addGestureRecognizer(keyboardDismissTabGesture) // 그작은뷰 터치하면 감지! 노랭이
        
      
    }
    
    //MARK: -IBAction methods
    @IBAction func onSearchButtonClicked(_sender:UIButton) {
//        let url = API.BASE_URL + "search/photos"
        
        guard let userInput = self.searchBar.text else {
            return
        }
        
        // 키 밸류 형식의 딕셔너리
//        let queryParam = ["quert": userInput,"client_id" : API.CLIENT_ID]
        
//        AF.request(url, method: .get,parameters: queryParam).responseJSON(completionHandler: {
//            response in
//            debugPrint(response)
//        })
        var UrlToCall: URLRequestConvertible?
        
        switch control.selectedSegmentIndex {
        case 0:
            UrlToCall = MySearchRouter.searchPhotos(term: userInput)
        case 1:
            UrlToCall = MySearchRouter.searchUsers(term: userInput)
        default:
            print("default")
              }
        
//        if let urlConvertible = UrlToCall {
//
//            MyAlamoFiremanager
//                .shared
//                .session
//                .request(MySearchRouter.searchPhotos(term: userInput))
//                .validate(statusCode: 200..<401) //200에서 400까지만 받겠다
//                .responseJSON(completionHandler: {
//                    response in
//                    debugPrint(response)
//                })
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            //키보드 올라가는 이벤트를 받는 처리
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 키보드 내려가는 이벤트를 받는 처리
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillAppear(noti: NSNotification) {
        //키보드 사이즈 가져요기 //키보드 사이즈 계산 // 버튼과 키보드 거리 계산해서 얼마나 올라갈지 넣어 주면됨!
        if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("keyboardSize.height:\(keyboardSize.height)")
            print("searchButton.height:\(button.frame.origin.y)")
            
            if keyboardSize.height < button.frame.origin.y { //키패드가 버튼을 덮는다면
                let distance = keyboardSize.height - button.frame.origin.y
                print("이만큼 덮었다:\(distance)")
                self.view.frame.origin.y = distance + button.frame.height
            }
        }
       
    }
    
    @objc func keyboardWillDisappear(noti:NSNotification) {
      
    }
    
    //MARK: - fileprivate methods
    fileprivate func  pushVC() {
        var segueId:String = ""
        
        switch control.selectedSegmentIndex {
        case 0:
            print("사진화면으로이동")
            segueId = "goToPhotoCollctionVC"
        case 1:
            print("유저화면으로이동")
            segueId = "goToUserListVC"
        default:
            print("defalue")
            segueId = "goToPhotoCollectionVC"
        }
        self.performSegue(withIdentifier: segueId, sender: self)
    }
    
    //MARK: - UISearchBar Delegate methods
    
    func  searchBarSearchButtonClicked(_ searchBar:UISearchBar) {
        
        guard let userInputString = searchBar.text else {
            return
        }
        if userInputString.isEmpty {
            self.view.makeToast("키워드를 입력하세요", duration: 3.0, position: .top)
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
    }
    
    @IBAction func didSelectSegment(_ sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.searchBar.placeholder = "사진 키워드 검색"
        }
        if sender.selectedSegmentIndex == 1 {
            self.searchBar.placeholder = "사용자 이름 검색"
        }
        
        self.searchBar.becomeFirstResponder() //포커싱 주기
        
        //self.searchBar.resignFirstResponder() //포커싱 해제
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = []
        
        //입력값이 없을때
        if searchText.isEmpty { //초기값
            //filterData = data
            self.button.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline:  .now() + 0.01, execute:{ searchBar.resignFirstResponder()
            })
        }
        else {
            self.button.isHidden = false 
            for fruit in data {
                if fruit.lowercased().contains(searchText.lowercased()) {
                    filterData.append(fruit)
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        
        if (inputTextCount >= 12) {
            self.view.makeToast("12자 까지만 입력하세요", duration: 3.0, position: .top)
        }
       
        if inputTextCount <= 12 {
            return true
        } else {
            return false
        }
    }
    
    //MARK: -UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("HOmeVC= ges suouldReceive touch called ")
        //터치로 들어온 뷰가 요놈이면 예외처리!
        if touch.view?.isDescendant(of: control) == true {
            return false
        }
        else if touch.view?.isDescendant(of: searchBar) == true {
            return false
        }
        
        view.endEditing(true)
        return true
    }
}

