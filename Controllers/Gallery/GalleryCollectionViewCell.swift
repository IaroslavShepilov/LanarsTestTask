//
//  GalleryCollectionViewCell.swift
//  LanarsTestTask
//
//  Created by Yaroslav Shepilov on 09.03.2022.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainPhotoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainPhotoView.contentMode = .scaleAspectFit
//        mainPhotoView.layer.cornerRadius = 20
                
        mainPhotoView.layer.shadowOffset = CGSize(width: 5, height: 5)
        mainPhotoView.layer.shadowOpacity = 0.7
        mainPhotoView.layer.shadowRadius = 5
        mainPhotoView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        mainPhotoView.layer.borderColor = UIColor.black.cgColor
        mainPhotoView.layer.borderWidth = 2
        mainPhotoView.clipsToBounds = false
        
        
    }
}
