//
//  VisualCardController.swift
//  Toast
//
//  Created by Nobel on 2017/10/10.
//  Copyright © 2017年 Nobel. All rights reserved.
//

import UIKit

public protocol VisualCardDataSource : UICollectionViewDataSource {
    func visualCard(_ visualCard: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

public protocol VisualCardDelegate : UICollectionViewDelegate {
    func visualCard(_ visualCard: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool
}
class VisualCardWindow: UIWindow {
    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.windowLevel = 1
    }
}

class VisualCard: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView?
    var views: [UIView]?
    var pageControl: UIPageControl?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(views != nil, "NOTHING TO SHOW!")
        
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: view.frame.size.height - 22, width: view.frame.size.width, height: 22))
        pageControl?.alpha = 0
        pageControl?.numberOfPages = (views?.count)!
        pageControl?.currentPage = 0
        view.addSubview(pageControl!)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = .clear
        view.addSubview(collectionView!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .clear
        var f = UIScreen.main.bounds
        f.origin.y = f.size.height
        collectionView?.frame = f
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 8, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
            f.origin.y = 0
            self.collectionView?.frame = f
            self.view.backgroundColor = UIColor(white: 0, alpha: 0.35)
            self.pageControl?.alpha = 1
        }, completion: nil)
    }
    
    func blurGround(_ contentView:UIView) -> UIVisualEffectView {
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurGround = UIVisualEffectView(effect: blurEffect)
        blurGround.frame = CGRect(x: 8, y: view.frame.size.height - 360 - 8, width: view.frame.size.width - 16, height: 360)
        blurGround.frame = CGRect(x: 8, y: view.frame.size.height - 360 - 8 - 14, width: view.frame.size.width - 16, height: 360)
        blurGround.layer.cornerRadius = 8
        blurGround.layer.masksToBounds = true
        blurGround.contentView.addSubview(contentView)
        return blurGround
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return views!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        cell.contentView.addSubview(blurGround(views![indexPath.row]))
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        pageControl?.currentPage = Int(offsetX / view.frame.size.width)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        var f = UIScreen.main.bounds
        UIView.animate(withDuration: flag ? 0.35 : 0, animations: {
            f.origin.y = f.size.height
            self.collectionView?.frame = f
            self.view.alpha = 0
        }) { (completed) in
            super.dismiss(animated: false, completion: completion)
        }
    }
    
    func scrollToCard(at index: Int, animated: Bool) {
        self.collectionView?.scrollToItem(at: IndexPath(row: index, section: 0), at: .right, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
