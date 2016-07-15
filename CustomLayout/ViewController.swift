//
//  ViewController.swift
//  CustomLayout
//
//  Created by 张昭 on 16/7/14.
//  Copyright © 2016年 张昭. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
    }
    
    func setupUI() {
        //let transfer = TransferView.init(frame: CGRectMake(0, 200, UIScreen.mainScreen().bounds.width, 300), contents: 8)
        let transfer = TransferView.init(frame: CGRectMake(0, 200, UIScreen.mainScreen().bounds.width, 300), contents: [
            ["23", "20", "27", "88", "27", "88", "27", "88", "99"],
            ["77", "20", "27", "88", "20", "27", "20", "27", "99"],
            ["99", "77", "20", "27", "77", "20", "77", "20", "99"],
            ["22", "99", "77", "20", "77", "20", "77", "20", "99"],
            ["44", "22", "99", "77", "22", "99", "22", "99", "99"],
            ["33", "44", "22", "99", "44", "22", "44", "22", "99"]])
        
        transfer.backgroundColor = UIColor.purpleColor()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(getCurrentIndex(_:)), name: kNotification, object: nil)
        self.view.addSubview(transfer)
    }
    
    func getCurrentIndex(noti: NSNotification) {
        
        print(noti.userInfo!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

