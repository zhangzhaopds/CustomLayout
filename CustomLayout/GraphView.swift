//
//  GraphView.swift
//  CustomLayout
//
//  Created by 张昭 on 16/7/15.
//  Copyright © 2016年 张昭. All rights reserved.
//

import UIKit

class GraphView: UIView, BEMSimpleLineGraphDelegate {

    var arrayOfValues: [String] = ["1", "9", "1", "1", "1", "1", "1"]
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubView()
        
    }
    
    convenience init(frame: CGRect, dataArray: [String]) {
        self.init(frame: frame)
//        arrayOfValues = dataArray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setupSubView()
//    }
    
    func setupSubView() {
        let myGraph: BEMSimpleLineGraphView = BEMSimpleLineGraphView.init(frame: CGRectMake(15, 15, self.bounds.size.width, self.bounds.size.height))
        
        addSubview(myGraph)
        myGraph.colorTop = UIColor.redColor()
        myGraph.colorBottom = UIColor.yellowColor()
        myGraph.colorLine = UIColor.greenColor()
        myGraph.userInteractionEnabled = true
        myGraph.widthLine = 1
        myGraph.delegate = self
    }
    
    func numberOfPointsInGraph() -> Int32 {
        return Int32(arrayOfValues.count)
    }
    
    func valueForIndex(index: Int) -> Float {
        return Float(arrayOfValues[index])!
    }
    
    func numberOfGapsBetweenLabels() -> Int32 {
        return 0
    }
    
    func labelOnXAxisForIndex(index: Int) -> String! {
        return arrayOfValues[index]
    }
    
}
