//
//  ViewController.swift
//  PullAndInfiniteTableViewSample
//
//  Created by 堤下薫 on 2015/10/27.
//  Copyright © 2015年 roana0229. All rights reserved.
//

import UIKit
import PullAndInfiniteTableView

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: SimpleTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.showPullToRefresh = true
        tableView.showInfiniteScroll = true
        tableView.addPullToRefreshHandler({ [weak self] in
            self?.fetchData(.PULL_TO_REFRESH)
            })
        tableView.addInfiniteScrollHandler({ [weak self] in
            self?.fetchData(.INFINITE_SCROLL_REFRESH)
            })
        fetchData(.INIT_REFRESH)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchData(state: RefreshState) {
        let delay: Double = 0.8
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            switch state {
            case .PULL_TO_REFRESH:
                self.tableView.rowCount = 20
                self.tableView.showInfiniteScroll = true
                break
            case .INFINITE_SCROLL_REFRESH:
                if self.tableView.rowCount >= 40 {
                    self.tableView.showInfiniteScroll = false
                } else {
                    self.tableView.rowCount += 20
                }
                break
            case .INIT_REFRESH:
                self.tableView.rowCount = 20
                break
            }
            self.tableView.refresh(state)
        }
    }

}

