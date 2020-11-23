//
//  PhotoCollectionVC.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/20.
//

import UIKit

class PhotoCollectionVC: BaseVC,UICollectionViewDelegate,UICollectionViewDataSource {
    
    let userInputText = ""
    var resultPhoto:[Any] = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestResult()
    }
    
    func requestResult() {
        MyAlamoFiremanager
            .shared
            .getPhotos(searchTerm: userInputText, completion: {
            [weak self]result in
                switch result {
                case .success(let fetchedPhotos) :
                    print("HomeVC -getPhotos.success -fetchedPhotos.count: \(fetchedPhotos.count)")
                    self?.resultPhoto = fetchedPhotos
                case .failure(let error):
                    print("HOmeVC - getPhotos.failure - error: \(error.rawValue)")
                }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultPhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
}
