
import Foundation
import UIKit

public class HotThisWeekCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    public static let cellID = "HotThisWeekCellID"
    
    internal lazy var hotThisWeekCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 6.0
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.allowsSelection = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.brandBackground
        self.configureView()
    }
    
    private func configureView() {
        addSubview(hotThisWeekCollectionView)
        hotThisWeekCollectionView.register(HotWeekCell.self, forCellWithReuseIdentifier: HotWeekCell.cellID)
        
        hotThisWeekCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        hotThisWeekCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        hotThisWeekCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        hotThisWeekCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HotThisWeekCell {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hotCell: HotWeekCell = collectionView.dequeueReusableCell(withReuseIdentifier: HotWeekCell.cellID, for: indexPath) as! HotWeekCell
        hotCell.eventImageView.image = UIImage(named: "hot")
        return hotCell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40.0, height: 280)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
