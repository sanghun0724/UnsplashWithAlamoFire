//
//  PhotoCollectionVC.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/20.
//

import UIKit

class PhotoCollectionVC: BaseVC,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var collectionView:UICollectionView!
    var Photo:[Photo] = []
      
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchData()
    }
    func fetchData() {
        MyAlamoFiremanager
            .shared
            .getPhotos(searchTerm: self.vcTitle, completion: {
            [weak self]result in
                switch result {
                case .success(let fetchedPhotos) :
                    print("HomeVC -getPhotos.success -fetchedPhotos.count: \(fetchedPhotos.count)")
                    self?.Photo = fetchedPhotos
                case .failure(let error):
                    print("HOmeVC - getPhotos.failure - error: \(error.rawValue)")
                }
        })
    }
    
    func UIDesine() {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell:PhotoCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.Image?.image = nil
        
        DispatchQueue.global().async {
            guard let imageURL:URL = URL(string: Photo.)
        }
        return cell
        
    }
    
}
