//
//  MainViewController.swift
//  LanarsTestTask
//
//  Created by Yaroslav Shepilov on 28.02.2022.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listVC = UINavigationController(rootViewController: ListViewController())
        let galleryVC = UINavigationController(rootViewController: GalleryViewController())
        listVC.title = "List"
        galleryVC.title = "Gallery"
        self.setViewControllers([listVC, galleryVC], animated: false)
        self.tabBar.tintColor = .black
    }
}


