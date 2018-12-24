
import UIKit
import BigNeonUI

final class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    internal lazy var exploreCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 32.0
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.brandBackground
        collectionView.contentInset = UIEdgeInsets(top: 32.0, left: 0.0, bottom: 32.0, right: 0.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = false
        collectionView.allowsSelection = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.configureCollectionView()
    }
    
    private func configureCollectionView() {
        view.addSubview(exploreCollectionView)
//        hometripsCollectionView.register(HeadingCell.self, forCellWithReuseIdentifier: HeadingCell.cellID)
        
        exploreCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        exploreCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        exploreCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        exploreCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

