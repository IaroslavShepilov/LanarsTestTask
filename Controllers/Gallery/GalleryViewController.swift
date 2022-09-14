//
//  GalleryViewController.swift
//  LanarsTestTask
//
//  Created by Yaroslav Shepilov on 01.03.2022.
//

import UIKit

class GalleryViewController: UIViewController {
    
    var images = [UIImage]()

    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    private var currentIndex: Int = 0 {
        didSet {
            checkIndex()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewOutlet.delegate = self
        self.collectionViewOutlet.dataSource = self
        self.title = "Gallery"
        setupImages()
        collectionViewOutlet.register(UINib.init(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionReusableCell")
        checkIndex()
    }
    
    func setupImages() {
        for i in 0...14 {
            guard let image = UIImage(named: "image\(i)") else { return }
            images.append(image)
            
        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        collectionViewOutlet.scrollToNextItem()
        currentIndex = Int(collectionViewOutlet.contentOffset.x / view.bounds.size.width) + 1
    }
    
    @IBAction func previousPressed(_ sender: Any) {
        collectionViewOutlet.scrollToPreviousItem()
        currentIndex = Int(collectionViewOutlet.contentOffset.x / view.bounds.size.width) - 1
    }
    
    func checkIndex() {
        previousButton.isEnabled = currentIndex != 0
        nextButton.isEnabled = currentIndex != images.count - 1
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionViewOutlet.contentOffset, size: collectionViewOutlet.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath = collectionViewOutlet.indexPathForItem(at: visiblePoint) else { return }
        currentIndex = visibleIndexPath.row
    }
    
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionReusableCell", for: indexPath) as! GalleryCollectionViewCell
        let image = images[indexPath.item]
        cell.mainPhotoView.image = image
        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: collectionViewOutlet.frame.height)
    }
}

extension UICollectionView {
    
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}

class SnappingCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
