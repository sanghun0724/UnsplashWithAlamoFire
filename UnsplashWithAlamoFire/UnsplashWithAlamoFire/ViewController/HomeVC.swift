//
//  ViewController.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/19.
//

import UIKit
import Toast_Swift

class HomeVC: UIViewController,UISearchBarDelegate,UIGestureRecognizerDelegate {

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
        
        self.searchBar.becomeFirstResponder() //포커싱주기
    }
    
    
    @IBAction func onSearchButtonClicked(_sender:UIButton) {
        pushVC()
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
