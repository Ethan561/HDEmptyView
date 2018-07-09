//
//  CollectionVC.swift
//  HDEmptyViewDemo
//
//  Created by liuyi on 2018/5/24.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var rows = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = UIColor.gray
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        //
        setupNoDataTip()
    }
    
    func setupNoDataTip() {
        rows = 3
        collectionView.reloadData()
        weak var weakSelf = self
        
        //创建方式一：Block回调
//        let emptyV:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "net_error_tip", titleStr: "暂无数据，点击重新加载", detailStr: "", btnTitleStr: "点击刷新") {
//            print("点击刷新")
//            weakSelf?.reloadDataWithCount(count: 4)
//        }
        
        //创建方式二：target/action
        let emptyV:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "net_error_tip", titleStr: "暂无数据，点击重新加载", detailStr: "", btnTitleStr: "点击刷新", target: self, action: #selector(reloadBtnAction)) as! HDEmptyView
        
        emptyV.titleLabTextColor = UIColor.red
        emptyV.actionBtnFont = UIFont.systemFont(ofSize: 19)
        emptyV.contentViewOffset = -50
        emptyV.actionBtnBackGroundColor = .white
        emptyV.actionBtnBorderWidth = 0.7
        emptyV.actionBtnBorderColor = UIColor.gray
        emptyV.actionBtnCornerRadius = 10

        collectionView.ly_emptyView = emptyV
        //点击空白区域
        collectionView.ly_emptyView?.tapContentViewBlock = {
            print("dianji ")
//            weakSelf?.reloadDataWithCount(count: 6)
        }
    }
    
    func reloadDataWithCount(count: Int) {
        rows = count
        collectionView.reloadData()
    }
    
    @objc func reloadBtnAction() {
        print("点击刷新")
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if rows > 0 {
            rows -= 1
            collectionView.reloadData()
        }
    }
    
    @IBAction func addRowAction(_ sender: Any) {
        rows += 1
        collectionView.reloadData()
    }
    
    //MARK: ----- UICollectionView ---
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let imgV = UIImageView.init(frame: cell.bounds)
        imgV.image = UIImage.init(named: "qq_login")
        cell.addSubview(imgV)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rows -= 1
        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
    }
}










