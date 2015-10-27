# PullToRefresh and InfiniteScrolling TableView

![DemoGif](demo.gif)

## Installation

Use Carthage  
`github "roana0229/PullAndInfiniteTableView" >= 1.0`  


## Usage

1. Inheritance class change from UITableView to PullAndInfiniteTableView.

2. Change property, Add handler
```
tableView.showPullToRefresh = true
tableView.addPullToRefreshHandler({ [weak self] in ~ })
tableView.showInfiniteScroll = true
tableView.addInfiniteScrollHandler({ [weak self] in ~ })
```

3. When loading is complete, refresh tableview
```
tableView.refresh(state: RefreshState)
```


## SampleCode

```SimpleTableView.swift
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

```

```ViewController.swift
import UIKit
import PullAndInfiniteTableView

class ViewController: UIViewController {

    @IBOutlet weak var tableView: SimpleTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // enable PullToRefresh
        tableView.showPullToRefresh = true
        tableView.addPullToRefreshHandler({ [weak self] in
            self?.fetchData(.PULL_TO_REFRESH)
        })
        // enable InfiniteScrolling
        tableView.showInfiniteScroll = true
        tableView.addInfiniteScrollHandler({ [weak self] in
            self?.fetchData(.INFINITE_SCROLL_REFRESH)
        })
        fetchData(.INIT_REFRESH)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // fetch like api
    func fetchData(state: RefreshState) {
        let delay: Double = 1.0
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))

        dispatch_after(delayTime, dispatch_get_main_queue()) {
            switch state {
            case .PULL_TO_REFRESH:
                self.tableView.rowCount = 20
                // refresh count, reshow InfiniteScrolling
                self.tableView.showInfiniteScroll = true
                break

            case .INFINITE_SCROLL_REFRESH:
                if self.tableView.rowCount >= 40 {
                    // last InfiniteScrolling loading
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

```

## License

PullAndInfiniteTableView is released under the [MIT License](LICENSE.txt).
