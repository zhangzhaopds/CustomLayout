//
//  TransferView.swift
//  CustomLayout
//
//  Created by 张昭 on 16/7/14.
//  Copyright © 2016年 张昭. All rights reserved.
//

import UIKit

// 基础配置
public let kNotification = "currentIndexNoti"
private let kBaseTag: Int = 10000
private let kScreenWidth: CGFloat = UIScreen.mainScreen().bounds.width
private let kItemSpacing: CGFloat = 40.0
private let kItemWidth: CGFloat = kScreenWidth - 120
private let kItemHeight: CGFloat = 270
private let kItemSelectedWidth: CGFloat = kScreenWidth - 80
private let kItemSelectedHeight: CGFloat = 300
private let kScrollViewContentOffset: CGFloat = kScreenWidth / 2.0 - (kItemWidth / 2.0 +  kItemSpacing)


class TransferView: UIView, UIScrollViewDelegate {

    var currentIndex: NSInteger?
    var lastIndex: NSInteger?
    private var scrollViewContentOffset: CGPoint?
    private var scrollView: UIScrollView?
    private var itemsNumber: Int = 0
    private var contents = [[String]]()
    private var items = [BEMSimpleLineGraphView]()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(frame: CGRect, contents: [[String]]) {
        self.init(frame: frame)
        itemsNumber = contents.count
        self.contents = contents
        setupScrollView()
        setupCurrentIndex(itemsNumber - 1)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCurrentIndex(index: Int) {
        if index >= 0 && index < itemsNumber {
            self.currentIndex = index
            let point: CGPoint = CGPointMake((kItemSpacing + kItemWidth) * CGFloat(index) - kScrollViewContentOffset, 0)
            scrollView?.setContentOffset(point, animated: true)
        }
    }
    
    func setupScrollView() {
        scrollView = UIScrollView.init(frame: self.bounds)
        self.addSubview(scrollView!)
        
        
        for i in 0..<itemsNumber {
            let sub = BEMSimpleLineGraphView.init(frame: CGRectMake((kItemSpacing + kItemWidth) * CGFloat(i) + kItemSpacing, self.frame.size.height - kItemHeight, kItemWidth, kItemHeight))
            sub.dataArray = contents[i]
            sub.colorTop = UIColor.redColor()
            sub.colorBottom = UIColor.yellowColor()
            sub.colorLine = UIColor.greenColor()
            sub.userInteractionEnabled = true
            sub.widthLine = 1
        
            sub.layer.cornerRadius = 8
            sub.layer.masksToBounds = true
            scrollView?.addSubview(sub)
            
            items.append(sub)
            sub.tag = i + kBaseTag
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(TransferView.tapDetected(_:)))
            // FIXME:
            sub.backgroundColor = UIColor.init(red: CGFloat(i) * 20 / 225.0, green: 100 / 255.0, blue: 200 / 255.0, alpha: 1)
            sub.addGestureRecognizer(tapGesture)
        }
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView?.alwaysBounceHorizontal = true
        scrollView?.delegate = self
        scrollView?.contentInset = UIEdgeInsetsMake(0, kScrollViewContentOffset, 0, kScrollViewContentOffset)
        scrollView?.contentSize = CGSizeMake((kItemWidth + kItemSpacing) * CGFloat(itemsNumber) + kItemSpacing, self.frame.size.height)
        
        
    }
    
    func tapDetected(tap: UITapGestureRecognizer) {
        var point: CGPoint = (tap.view?.superview?.convertPoint((tap.view?.center)!, toView: scrollView!))!
        point = CGPointMake(point.x - kScrollViewContentOffset - (kItemWidth / 2 + kItemSpacing), 0)
        scrollViewContentOffset = point
        scrollView?.setContentOffset(point, animated: true)
        
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = (scrollView.contentOffset.x + kScrollViewContentOffset + (kItemWidth / 2 + kItemSpacing / 2)) / (kItemWidth + kItemSpacing)
        var vv = Int(index)
        vv = min(itemsNumber - 1, max(0, vv))
        if currentIndex != vv {
            currentIndex = vv
        }
       
        adjustSubViews(scrollView)
        if lastIndex != currentIndex {
            lastIndex = currentIndex
            NSNotificationCenter.defaultCenter().postNotificationName(kNotification
                , object: self, userInfo: ["index": "\(lastIndex!)"])
        }
       
    }
    
    
    func adjustSubViews(scrollView: UIScrollView) {
        
        let index = (scrollView.contentOffset.x + kScrollViewContentOffset) / (kItemWidth + kItemSpacing)
        var vv = Int(index)
        vv = min(itemsNumber - 1, max(0, vv))
        var scale = (scrollView.contentOffset.x + kScrollViewContentOffset - (kItemWidth + kItemSpacing) * CGFloat(vv)) / (kItemWidth + kItemSpacing)
        
        
        if itemsNumber > 0 {
            var height: CGFloat = 0.0
            var width: CGFloat = 0.0
            if scale > 0.0  && scale <= 1.0 {
                if vv + 1 >= itemsNumber {
                    scale = 1 - min(1.0, abs(scale))
                    let sub = items[itemsNumber - 1]
                    sub.layer.borderColor = UIColor.init(white: 1, alpha: scale).CGColor
                    height = kItemHeight + (kItemSelectedHeight - kItemHeight) * scale
                    width = kItemWidth + (kItemSelectedWidth - kItemWidth) * scale
                    sub.frame = CGRectMake((kItemSpacing + kItemWidth) * CGFloat(itemsNumber - 1) + kItemSpacing - (width - kItemWidth) / 2, self.frame.size.height - kItemHeight - (height - kItemHeight), width, height)
                } else {
                    let scaleLeft: CGFloat = 1.0 - min(1.0, abs(scale))
                    let leftView = items[vv]
                    leftView.layer.borderColor = UIColor.init(white: 1, alpha: scaleLeft).CGColor
                    height = kItemHeight + (kItemSelectedHeight - kItemHeight) * scaleLeft
                    width = kItemWidth + (kItemSelectedWidth - kItemWidth) * scaleLeft
                    leftView.frame = CGRectMake((kItemSpacing + kItemWidth) * CGFloat(vv) + kItemSpacing - (width - kItemWidth) / 2, self.frame.size.height - kItemHeight - (height - kItemHeight), width, height)
                    
                    let scalRight: CGFloat = min(1.0, abs(scale))
                    let rightView: UIView = items[vv + 1]
                    rightView.layer.borderColor = UIColor.init(white: 1, alpha: scalRight).CGColor
                    height = kItemHeight + (kItemSelectedHeight - kItemHeight) * scalRight
                    width = kItemWidth + (kItemSelectedWidth - kItemWidth) * scalRight
                    rightView.frame = CGRectMake((kItemSpacing + kItemWidth) * CGFloat(vv + 1) + kItemSpacing - (width - kItemWidth)/2, self.frame.size.height - kItemHeight - (height - kItemHeight), width, height)
                }
            } else if scale <= 0.0 {
                scale = 1.0 - min(1.0, abs(scale))
                let leftView = items[vv]
                leftView.layer.borderColor = UIColor.init(white: 1, alpha: scale).CGColor
                height = kItemHeight + (kItemSelectedHeight - kItemHeight) * scale
                width = kItemWidth + (kItemSelectedWidth - kItemWidth) * scale
                leftView.frame = CGRectMake((kItemSpacing + kItemWidth) * CGFloat(vv) + kItemSpacing - (width - kItemWidth) / 2, self.frame.size.height - kItemHeight - (height - kItemHeight), width, height)
                if vv + 1 < itemsNumber {
                    let rightView = items[vv + 1]
                    rightView.layer.borderColor = UIColor.clearColor().CGColor
                }
            }
        }
        // 避免第一次运行时，从后往前滑动，item0和item1的大小一样
        if vv == 1 {
            items[0].frame.size = CGSizeMake(items[2].frame.width, items[2].frame.height)
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = (targetContentOffset.memory.x + kScrollViewContentOffset + (kItemWidth / 2 + kItemSpacing / 2)) / (kItemWidth + kItemSpacing)
        let ind = Int(index)
        targetContentOffset.memory.x = (kItemSpacing + kItemWidth) * CGFloat(ind) - kScrollViewContentOffset
    }
    
   
}
