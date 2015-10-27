//
//  PullAndInfiniteTableView.swift
//  PullAndInfiniteTableView
//
//  Created by Kaoru Tsutsumishita on 2015/10/27.
//  Copyright © 2015年 roana0229. All rights reserved.
//

import UIKit

public class PullAndInfiniteTableView: UITableView {
    
    private let TOP_ATTRIBUTE = "TopAttribute"
    private var refreshControl: UIRefreshControl!
    private var footerHeight: CGFloat = 0
    private var footerIndicator: UIActivityIndicatorView!
    private var pullToRefreshHandler: (() -> ())?
    private var infiniteScrollHandler: (() -> ())?
    private var nowLoading: Bool = false
    
    public var showPullToRefresh: Bool = false {
        didSet {
            if oldValue != showPullToRefresh {
                if showPullToRefresh {
                    showPullToRefreshView()
                } else {
                    hidePullToRefreshView()
                }
            }
        }
    }
    public var showInfiniteScroll: Bool = false {
        didSet {
            if oldValue != showInfiniteScroll {
                if showInfiniteScroll {
                    showInfiniteScrollRefreshView()
                } else {
                    hideInfiniteScrollRefreshView()
                }
            }
        }
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: footerHeight))
        footerView.hidden = true
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return showInfiniteScroll ? footerHeight : 0
    }
    
    private func showPullToRefreshView() {
        if refreshControl == nil {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: "pullToRefresh", forControlEvents: .ValueChanged)
        }
        addSubview(refreshControl)
    }
    
    private func hidePullToRefreshView() {
        refreshControl.removeFromSuperview()
    }
    
    private func showInfiniteScrollRefreshView() {
        if footerIndicator == nil {
            footerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            footerHeight = footerIndicator.bounds.height * 3
        }
        footerIndicator.startAnimating()
        addSubview(footerIndicator)
        
        footerIndicator.translatesAutoresizingMaskIntoConstraints = false
        let topAttribute = NSLayoutConstraint(item: footerIndicator, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0)
        topAttribute.identifier = TOP_ATTRIBUTE
        addConstraints([
            topAttribute,
            NSLayoutConstraint(item: footerIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: footerIndicator, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 56),
            NSLayoutConstraint(item: footerIndicator, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 56)
            ])
    }
    
    private func hideInfiniteScrollRefreshView() {
        footerIndicator.removeFromSuperview()
    }
    
    public func addPullToRefreshHandler(handler: () -> ()) {
        pullToRefreshHandler = handler
    }
    
    public func addInfiniteScrollHandler(handler: () -> ()) {
        infiniteScrollHandler = handler
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if contentSize.height <= footerHeight || !showInfiniteScroll || nowLoading {
            return
        }
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        let o = maximumOffset - currentOffset
        if o <= footerHeight {
            if !scrollView.dragging {
                executeHandler(.INFINITE_SCROLL_REFRESH)
            }
        }
    }
    
    func pullToRefresh() {
        if nowLoading {
            return
        }
        executeHandler(.PULL_TO_REFRESH)
    }
    
    private func executeHandler(state: RefreshState) {
        nowLoading = true
        switch state {
        case .PULL_TO_REFRESH:
            pullToRefreshHandler?()
            break
        case .INFINITE_SCROLL_REFRESH:
            infiniteScrollHandler?()
            break
        case .INIT_REFRESH:
            break
        }
    }
    
    public func refresh(state: RefreshState) {
        switch state {
        case .PULL_TO_REFRESH:
            refreshControl.endRefreshing()
            reloadData()
            break
        case .INFINITE_SCROLL_REFRESH:
            UIView.animateWithDuration(0.3, animations: {
                self.reloadData()
            })
            break
        case .INIT_REFRESH:
            reloadData()
            break
        }
        layoutFooterIndicatorTopConstraint()
        nowLoading = false
    }
    
    private func layoutFooterIndicatorTopConstraint() {
        if !showInfiniteScroll {
            return
        }
        
        for constraint in constraints {
            if let id = constraint.identifier where id == TOP_ATTRIBUTE {
                constraint.constant = contentSize.height - footerHeight
                footerIndicator.layoutIfNeeded()
            }
        }
    }
    
}
