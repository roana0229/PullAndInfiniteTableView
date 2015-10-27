//
//  SimpleTableView.swift
//  PullAndInfiniteTableViewSample
//
//  Created by 堤下薫 on 2015/10/27.
//  Copyright © 2015年 roana0229. All rights reserved.
//

import UIKit
import PullAndInfiniteTableView

class SimpleTableView: PullAndInfiniteTableView, UITableViewDelegate, UITableViewDataSource {
    
    var rowCount = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        init_()
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        init_()
    }
    
    convenience init(){
        self.init(frame: CGRectMake(0, 0, 0, 0), style: UITableViewStyle.Plain)
    }
    
    private func init_() {
        delegate = self
        dataSource = self
        registerNib(UINib(nibName: "SimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SimpleTableViewCell
        cell.label.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
}
