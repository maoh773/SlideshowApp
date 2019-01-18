//
//  DetailViewController.swift
//  SlideshowApp
//
//  Created by AiTH2 on 2018/12/15.
//  Copyright © 2018 hirohisa.kimura. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidLayoutSubviews() {
        
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = image
        
        let backButton = UIButton()
        backButton.frame.size = CGSize(width: 40, height: 40)
        backButton.backgroundColor = UIColor.black
        backButton.alpha = 0.5
        backButton.setTitle("<", for: .normal)
        backButton.titleLabel?.textAlignment = .center
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        backButton.titleLabel?.textColor = UIColor.white
        backButton.layer.cornerRadius = 20.0
        backButton.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        let safeAreaInsets: UIEdgeInsets
        if #available(iOS 11, *) {
            safeAreaInsets = view.safeAreaInsets
        } else {
            safeAreaInsets = .zero
        }
        backButton.frame.origin = CGPoint(x: 10, y: safeAreaInsets.top)
        
        self.view.addSubview(imageView)
        self.view.addSubview(backButton)
        
    }
    
    @objc func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
//
//    let nextvc = NextViewController()
//    nextvc.view.backgroundColor = UIColor.blue
//    self.present(nextvc, animated: true, completion: nil)
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
