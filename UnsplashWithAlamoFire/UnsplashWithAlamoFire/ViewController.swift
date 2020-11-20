//
//  ViewController.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/19.
//

import UIKit
import Toast_Swift

class ViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet var control:UISegmentedControl!
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var searchBar:UISearchBar!
    @IBOutlet var button:UIButton!
    
    var filterData:[String] = []
    var data:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillAppear(noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc func keyboardWillDisappear(noti:NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y += keyboardHeight
        }
        
    }
    
    @IBAction func didSelectSegment(_ sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.searchBar.placeholder = "사진 키워드 검색"
        }
        if sender.selectedSegmentIndex == 1 {
            self.searchBar.placeholder = "사용자 이름 검색"
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = []
        
        if searchText.isEmpty { //초기값
            //filterData = data
            
        }
        else {
            
            for fruit in data {
                if fruit.lowercased().contains(searchText.lowercased()) {
                    filterData.append(fruit)
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count > 12 {
            self.view.makeToast("12자 까지만 입력하세요", duration: 3.0, position: .top)
        }
        else if searchBar.text!.isEmpty {
            self.view.makeToast("입력하세요", duration: 3.0, position: .top)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

