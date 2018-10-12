//
//  TableViewController.swift
//  HDEmptyViewDemo
//
//  Created by liuyi on 2018/5/24.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

class TableViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBAction func deleteAction(_ sender: Any) {
        if items.count > 0 {
            items.removeLast()
            tableView.reloadData()
        }
    }
    
    @IBAction func addRowAction(_ sender: Any) {
        items.append("添加一行数据")
        tableView.reloadData()
    }
    
    var items = [String]()
    var sections = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let leftBarBtn = UIButton.init(type: UIButton.ButtonType.custom)
        leftBarBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        leftBarBtn.setImage(UIImage.init(named: "service_highlight"), for: UIControl.State.normal)
        leftBarBtn.addTarget(self, action: #selector(changeAction(_:)), for: UIControl.Event.touchUpInside)
        //
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: leftBarBtn)
        self.navigationItem.setRightBarButton(leftBarButtonItem, animated: false)
        
        //
        setupMyEmptyView()
    }
    
    //自定义空数据界面显示
    func setupMyEmptyView() {
        let emptyView: MyEmptyView = Bundle.main.loadNibNamed("MyEmptyView", owner: self, options: nil)?.last as! MyEmptyView
        emptyView.reloadBtn.addTarget(self, action: #selector(reloadBtnAction(_:)), for: UIControl.Event.touchUpInside)
        emptyView.frame = view.bounds
        //空数据界面显示
        let emptyV:HDEmptyView = HDEmptyView.emptyViewWithCustomView(customView: emptyView) as! HDEmptyView
        tableView.ly_emptyView = emptyV
        tableView.ly_emptyView?.tapContentViewBlock = {
            print("点击界面空白区域")
        }
        tableView.ly_showEmptyView()
    }
    
    @objc func reloadBtnAction(_ sender: UIButton) {
        print("点击刷新按钮")
    }
    
    @objc func changeAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            setupMyEmptyView()
        }else {
            sender.isSelected = true
            //空数据界面显示
            let emptyV:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "no_data_tip", titleStr: "暂无数据", detailStr: "", btnTitleStr: "") {
                print("点击刷新按钮")
            }
            emptyV.contentViewOffset = -100
            emptyV.titleLabFont = UIFont.systemFont(ofSize: 18)
            emptyV.titleLabTextColor = UIColor.purple
            tableView.ly_emptyView = emptyV
            
            tableView.ly_emptyView?.tapContentViewBlock = {
                print("点击界面空白区域")
            }
            tableView.ly_endLoading()
        }
    }
    
    
    //MARK: ----- tableView -----
     func numberOfSections(in tableView: UITableView) -> Int {
        return sections
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.removeLast()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("items.count:\(items.count)")
        return items.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = items[indexPath.item]
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        switch item {
        case "点击重新加载":
            items.removeAll()
            tableView.reloadData()
        case "点击添加行":
            tableView.beginUpdates()
            items.append("new row")
            tableView.insertRows(at: [IndexPath(row: tableView.numberOfRows(inSection: indexPath.section), section: indexPath.section)], with: .automatic)
            tableView.endUpdates()
        case "点击删除行":
            tableView.beginUpdates()
            items.removeLast()
            let index = IndexPath(row: tableView.numberOfRows(inSection: indexPath.section) - 1, section: indexPath.section)
            tableView.deleteRows(at: [index], with: .automatic)
            tableView.endUpdates()
        default: break
        }
    }

}
