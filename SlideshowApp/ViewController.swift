//
//  ViewController.swift
//  SlideshowApp
//
//  Created by AiTH2 on 2018/12/10.
//  Copyright © 2018 hirohisa.kimura. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var buttonForward: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonAutoPlay: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    let imageArray = [
        UIImage(named: "image1.jpg"),
        UIImage(named: "image2.jpg"),
        UIImage(named: "image3.jpg"),
        UIImage(named: "image4.jpg")
    ]
    
    var cellItemsWidth: CGFloat = 0.0
    
    let screenCenterX: CGFloat = UIScreen.main.bounds.width / 2
    let screenMaxX: CGFloat = UIScreen.main.bounds.width
    let minScale: CGFloat = 0.7
    let maxScale: CGFloat = 1.0
    
    var timer: Timer!
    var isPlayng: Bool = false
    
    enum scrollDirection {
        case normal, reverse
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        pageControl.numberOfPages = imageArray.count
        
        buttonForward.accessibilityValue = "forward"
        buttonForward.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
        
        buttonBack.accessibilityValue = "back"
        buttonBack.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
        
        buttonAutoPlay.accessibilityValue = "autoPlay"
        buttonAutoPlay.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
        
        collectionView.scrollToItem(at:IndexPath(row: imageArray.count, section: 0) , at: .centeredHorizontally, animated: false)
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
        if isPlayng {
            startTimer()
        }
        
    }

    @objc func buttonAction(_ sender: UIButton) {
        
        switch (sender as UIButton).accessibilityValue {
        case "forward":
            collectionViewScroll(.normal)
            break
            
        case "back":
            collectionViewScroll(.reverse)
            break
            
        case "autoPlay":
            if !isPlayng {
                startTimer()
                UIView.animate(
                    withDuration: 0.5,
                    animations: {
                        self.view.backgroundColor = UIColor.black
                        self.collectionView.backgroundColor = UIColor.black
                    }
                )
                buttonBack.isHidden = true
                buttonForward.isHidden = true
                buttonAutoPlay.setImage(UIImage(named: "icon_pause.png"), for: .normal)
                isPlayng = true
            } else {
                stopTimer()
                UIView.animate(
                    withDuration: 0.5,
                    animations: {
                        self.view.backgroundColor = UIColor.white
                        self.collectionView.backgroundColor = UIColor.white
                    }
                )
                buttonBack.isHidden = false
                buttonForward.isHidden = false
                buttonAutoPlay.setImage(UIImage(named: "icon_play.png"), for: .normal)
                isPlayng = false
            }
            break
            
        default:
            break
        }
    
    }
    
    @objc func startAutoPlay(_ sender: Timer) {
        collectionViewScroll(.normal)
    }
    
    
    func collectionViewScroll(_ direction: scrollDirection = .normal) {
        
        let perfectVisibleCells = collectionView.visibleCells.filter {
            collectionView.bounds.contains($0.frame)
        }
        let isScrolling = perfectVisibleCells.count == 0 ? true : false
        
        if isScrolling {return}
        
        let indexPath = collectionView.indexPath(for: perfectVisibleCells[0])!
        
        if direction == .normal {
            collectionView.scrollToItem(at:IndexPath(row: indexPath.row + 1, section: 0) , at: .centeredHorizontally, animated: true)
        } else {
            collectionView.scrollToItem(at:IndexPath(row: indexPath.row - 1, section: 0) , at: .centeredHorizontally, animated: true)
        }
        
    }
    

    
    func startTimer() {
        if timer == nil {
            self.timer = Timer.scheduledTimer(
                timeInterval: 2.0,
                target: self,
                selector: #selector(startAutoPlay(_:)),
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    func stopTimer() {
        if timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    func scaleTransform(cell: UICollectionViewCell) {
        
        let cellCenter: CGPoint = self.collectionView.convert(cell.center, to: nil)
        let diffX: CGFloat = abs(screenCenterX - cellCenter.x)

        let scale = 1 - (diffX * (maxScale - minScale)) / screenCenterX
        cell.transform = CGAffineTransform(scaleX:scale, y:scale)
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
}


extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        stopTimer()
        let nextvc = DetailViewController()
        nextvc.image = imageArray[indexPath.row % imageArray.count]
        nextvc.modalTransitionStyle = .crossDissolve
        
        self.present(nextvc, animated: true, completion: nil)
        
    }
    
}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        
        imageView.image = imageArray[indexPath.row % imageArray.count]
        
        return cell
        
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if cellItemsWidth == 0.0 {
            cellItemsWidth = scrollView.contentSize.width / 3.0
        }
        
        if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x >= cellItemsWidth * 2.0) {
            scrollView.contentOffset.x = cellItemsWidth
        }
        
        let cells = self.collectionView.visibleCells
        for cell in cells {
            self.scaleTransform(cell: cell)
        }
        
        pageControl.currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.width)) % imageArray.count
    }
    
}

