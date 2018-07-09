# HDEmptyView

> 一个Swift语言封装的EmptyView显示库，可作用于WKWebView、UITableView、UICollectionView


## 示例

- WKWebView
![WKWebView](https://github.com/Ethan561/HDEmptyView/blob/master/%E7%A4%BA%E4%BE%8Bgif%E5%9B%BE%E7%89%87/webViewEmptyGIF.gif)
- UITableView
![UITableView](https://github.com/Ethan561/HDEmptyView/blob/master/%E7%A4%BA%E4%BE%8Bgif%E5%9B%BE%E7%89%87/tableViewEmptyGIF.gif)
- UICollectionView
![UICollectionView](https://github.com/Ethan561/HDEmptyView/blob/master/%E7%A4%BA%E4%BE%8Bgif%E5%9B%BE%E7%89%87/collectionViewEmptyGIF.gif)


## 要求

- iOS 9.0+
- Xcode 9.0+
- Swift4 (HDEmptyView 4.x)

## 使用方法


### 1、创建 HDEmptyView 界面显示对象

```
//创建方式一：Block回调
let emptyV:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "net_error_tip", titleStr: "暂无数据，点击重新加载", detailStr: "", btnTitleStr: "点击刷新") {
print("点击刷新")
weakSelf?.reloadDataWithCount(count: 4)
}

//创建方式二：target/action
let emptyV:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "net_error_tip", titleStr: "暂无数据，点击重新加载", detailStr: "", btnTitleStr: "点击刷新", target: self, action: #selector(reloadBtnAction)) as! HDEmptyView

```

### 2、设置显示参数属性

```
emptyV.titleLabTextColor = UIColor.red
emptyV.actionBtnFont = UIFont.systemFont(ofSize: 19)
emptyV.contentViewOffset = -50
emptyV.actionBtnBackGroundColor = .white
emptyV.actionBtnBorderWidth = 0.7
emptyV.actionBtnBorderColor = UIColor.gray
emptyV.actionBtnCornerRadius = 10
```

### 3、赋值给当前显示对象的ly_emptyView

```
webView.scrollView.ly_emptyView = emptyV

tableView.ly_emptyView = emptyV

collectionView.ly_emptyView = emptyV

//设置点击空白区域是否有刷新操作
self.webView.scrollView.ly_emptyView?.tapContentViewBlock = {
//weakSelf!.loadingURL(urltring: "http://news.baidu.com/")
}


```

### 4、自定义空数据界面显示

```
//自定义空数据界面显示
func setupMyEmptyView() {
let emptyView: MyEmptyView = Bundle.main.loadNibNamed("MyEmptyView", owner: self, options: nil)?.last as! MyEmptyView
emptyView.reloadBtn.addTarget(self, action: #selector(reloadBtnAction(_:)), for: UIControlEvents.touchUpInside)
emptyView.frame = view.bounds
//空数据界面显示
let emptyV:HDEmptyView = HDEmptyView.emptyViewWithCustomView(customView: emptyView) as! HDEmptyView
tableView.ly_emptyView = emptyV
tableView.ly_emptyView?.tapContentViewBlock = {
print("点击界面空白区域")
}
tableView.ly_showEmptyView()
}

```

>注意事项:是否自动显隐EmptyView的参数 autoShowEmptyView 默认设置是true，列表视图会根据界面cell的count数量自动显隐空界面。当设置成false时只能手动调用 ly_showEmptyView() 和 ly_hideEmptyView() 方法进行显隐操作

[简书详细介绍地址](https://www.jianshu.com/p/6f2760647b77)
