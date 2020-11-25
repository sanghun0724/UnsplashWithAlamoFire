//
//  PhotoCollectionVC.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/20.
//

import UIKit

class PhotoCollectionVC: BaseVC,UICollectionViewDelegate,UICollectionViewDataSource {
    //이미지 캐싱 스크롤 할때 메모리에 저장 (프리징 x)
    
    @IBOutlet var collectionView:UICollectionView!
    var photoArr:[Photo] = [Photo]() {
        didSet {
            self.photoArr.forEach{print("Your data IS!!!\($0.thumnail)")}
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRecieveFriendsNotification(_:)), name: NSNotification.Name(rawValue: "DidRecieve"), object: nil)
        
        print("@@\(self.photoArr)")
        fetchData()
        debugPrint(photoArr)
        collectionView.delegate = self
        collectionView.dataSource = self
        UIDesine()
        collectionView.reloadData()
    }
    func fetchData() {
        MyAlamoFiremanager
            .shared
            .getPhotos(searchTerm: self.vcTitle, completion: {
            [self]result in
              switch result {
                case .success(let fetchedPhotos) :
                    print("HomeVC -getPhotos.success -fetchedPhotos.count: \(fetchedPhotos.count)")
                  //self.photoArr = fetchPhotos 할당이 안된다
                    //self.photoArr.append(contentsOf: fetchedPhotos) << 해봐야함
              // 인디케이터 뷰
                    fetchedPhotos.map{
                        $0.createdAt
                    }
                
                        
                case .failure(let error):
                    print("HOmeVC - getPhotos.failure - error: \(error.rawValue)")
                }
        })
    }
    
    @objc func didRecieveFriendsNotification(_ noti: Notification) {
        guard let Test:[Photo] = noti.userInfo?["Test"] as? [Photo] else {
            return
        }
        self.photoArr = Test
        print("\(photoArr)")
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func UIDesine() {
        let collectionLayout:UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 260 , height: 200 )
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets.zero
            layout.scrollDirection = .vertical
            return layout
        }()
        collectionView.collectionViewLayout = collectionLayout
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell:PhotoCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCollectionCell else {
            return UICollectionViewCell()
        }
        let photoTest:Photo = self.photoArr[indexPath.item]
        cell.Image?.image = nil
        cell.testLabel.text = photoTest.username
        
        DispatchQueue.global().async {
            
            guard let imageURL:URL = URL(string:photoTest.thumnail) else {
                return
            }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else {
                return
            }
            DispatchQueue.main.async {
                if let index:IndexPath = collectionView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.Image?.image = UIImage(data: imageData)
                        cell.setNeedsLayout()
                        cell.layoutIfNeeded()
                    }
                }
            
            }
        }
        return cell
        
    }
    
}
