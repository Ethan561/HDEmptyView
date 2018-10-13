//
//  UIScrollView+Empty.swift
//  HDEmptyViewDemo
//
//  Created by liuyi on 2018/5/18.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit
import Foundation

extension UIScrollView {
    struct RuntimeKey {
        static let kEmptyViewKey = UnsafeRawPointer.init(bitPattern: "kEmptyViewKey".hashValue)
    }
    
    public var ly_emptyView: HDEmptyView? {
        set {
            objc_setAssociatedObject(self, RuntimeKey.kEmptyViewKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            for view in self.subviews {
                if view.isKind(of: HDEmptyView.classForCoder()) {
                    view.removeFromSuperview()
                }
            }
         self.addSubview(ly_emptyView!)
         self.ly_emptyView?.isHidden = true
        }
        get {
            return objc_getAssociatedObject(self, RuntimeKey.kEmptyViewKey!) as? HDEmptyView
        }
    }
    
    //MAKR: --- 根据 DataSource 判断是否自动显示 emptyView
    public func ly_startLoading() {
        self.ly_emptyView?.isHidden = true
    }
    
    public func ly_endLoading() {
        getDataAndSet()
    }
    
    //手动控制显隐方法，不受DataSource的影响，需要把 autoShowEmptyView = false
    public func ly_showEmptyView() {
        self.ly_emptyView?.superview?.layoutSubviews()
        self.ly_emptyView?.isHidden = false
        //始终保持显示在最上层
        if self.ly_emptyView != nil {
            self.bringSubviewToFront(self.ly_emptyView!)
        }
    }
    
    public func ly_hideEmptyView() {
        self.ly_emptyView?.isHidden = true
    }
    
    //MARK: - Private Method
    fileprivate func totalDataCount() -> NSInteger {
        var totalCount: NSInteger = 0
        if self.isKind(of: UITableView.classForCoder()) {
            let tableView = self as? UITableView
            if (tableView?.numberOfSections)! >= 1 {
                for section in 0...(tableView?.numberOfSections)!-1 {
                    totalCount += (tableView?.numberOfRows(inSection: section))!
                }
            }
        }
        else if self.isKind(of: UICollectionView.classForCoder()) {
            let collectionView = self as? UICollectionView
            if (collectionView?.numberOfSections)! >= 1 {
                for section in 0...(collectionView?.numberOfSections)!-1 {
                    totalCount += (collectionView?.numberOfItems(inSection: section))!
                }
            }
        }
        return totalCount
    }
    
    fileprivate func getDataAndSet() {
        if self.totalDataCount() == 0 {
            show()
        } else {
            hide()
        }
    }
    
    fileprivate func show() {
        if self.ly_emptyView?.autoShowEmptyView == false {
            self.ly_emptyView?.isHidden = true
            return
        }
        ly_showEmptyView()
    }

    fileprivate func hide() {
        if self.ly_emptyView?.autoShowEmptyView == false {
            self.ly_emptyView?.isHidden = true
            return
        }
        ly_hideEmptyView()
    }
}

//MARK: ------ UITableView ------

extension UITableView:SelfAware {
    static func awake() {
        UITableView.classInit()
    }
    
    static func classInit() {
        swizzleMethod
    }

    private static let swizzleMethod: Void = {
        //insertSections
        let originalSelector = #selector(insertSections(_:with:))
        let swizzledSelector = #selector(ly_insertSections(_:with:))
        HDRunTime.exchangeMethod(selector: originalSelector, replace: swizzledSelector, class: UITableView.self)
        
        //deleteSections
        let originalSelector1 = #selector(deleteSections(_:with:))
        let swizzledSelector1 = #selector(ly_deleteSections(_:with:))
        HDRunTime.exchangeMethod(selector: originalSelector1, replace: swizzledSelector1, class: UITableView.self)
        
        //insertRows
        let originalSelector2 = #selector(insertRows(at:with:))
        let swizzledSelector2 = #selector(ly_insertRowsAtIndexPaths(at:with:))
        HDRunTime.exchangeMethod(selector: originalSelector2, replace: swizzledSelector2, class: UITableView.self)
        
        //deleteRows
        let originalSelector3 = #selector(deleteRows(at:with:))
        let swizzledSelector3 = #selector(ly_deleteRowsAtIndexPaths(at:with:))
        HDRunTime.exchangeMethod(selector: originalSelector3, replace: swizzledSelector3, class: UITableView.self)
        
        //reload
        let originalSelector4 = #selector(reloadData)
        let swizzledSelector4 = #selector(ly_reloadData)
        HDRunTime.exchangeMethod(selector: originalSelector4, replace: swizzledSelector4, class: UITableView.self)
        
    }()
    

    //section
    @objc  func ly_insertSections(_ sections: NSIndexSet, with animation: UITableView.RowAnimation) {
        ly_insertSections(sections, with: animation)
        getDataAndSet()
    }
    
    @objc  func ly_deleteSections(_ sections: NSIndexSet, with animation: UITableView.RowAnimation) {
        ly_deleteSections(sections, with: animation)
        getDataAndSet()
    }
    
    //row
    @objc  func ly_insertRowsAtIndexPaths(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){
        ly_insertRowsAtIndexPaths(at: indexPaths, with: animation)
        getDataAndSet()
    }
    
    @objc func ly_deleteRowsAtIndexPaths(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){
        ly_deleteRowsAtIndexPaths(at: indexPaths, with: animation)
        getDataAndSet()
    }
    
    //reloadData
    @objc func ly_reloadData() {
        self.ly_reloadData()
        self.getDataAndSet()
    }
    
}

//MARK: ------ UICollectionView ------

extension UICollectionView:SelfAware {
    static func awake() {
        UICollectionView.classInit()
    }
    
    static func classInit() {
        swizzleMethod
    }
    
    private static let swizzleMethod: Void = {
        //insertSections
        let originalSelector = #selector(insertSections(_:))
        let swizzledSelector = #selector(ly_insertSections(_:))
        HDRunTime.exchangeMethod(selector: originalSelector, replace: swizzledSelector, class: UICollectionView.self)
        
        //deleteSections
        let originalSelector1 = #selector(deleteSections(_:))
        let swizzledSelector1 = #selector(ly_deleteSections(_:))
        HDRunTime.exchangeMethod(selector: originalSelector1, replace: swizzledSelector1, class: UICollectionView.self)
        
        //insertRows
        let originalSelector2 = #selector(insertItems(at:))
        let swizzledSelector2 = #selector(ly_insertItemsAtIndexPaths(at:))
        HDRunTime.exchangeMethod(selector: originalSelector2, replace: swizzledSelector2, class: UICollectionView.self)
        
        //deleteRows
        let originalSelector3 = #selector(deleteItems(at:))
        let swizzledSelector3 = #selector(ly_deleteItemsAtIndexPaths(at:))
        HDRunTime.exchangeMethod(selector: originalSelector3, replace: swizzledSelector3, class: UICollectionView.self)
        
        //reload
        let originalSelector4 = #selector(reloadData)
        let swizzledSelector4 = #selector(ly_reloadData)
        HDRunTime.exchangeMethod(selector: originalSelector4, replace: swizzledSelector4, class: UICollectionView.self)
        
    }()
    
    //section
    @objc  func ly_insertSections(_ sections: NSIndexSet) {
        ly_insertSections(sections)
        getDataAndSet()
    }
    
    @objc  func ly_deleteSections(_ sections: NSIndexSet) {
        ly_deleteSections(sections)
        getDataAndSet()
    }
    
    //item
    @objc  func ly_insertItemsAtIndexPaths(at indexPaths: [IndexPath]){
        ly_insertItemsAtIndexPaths(at: indexPaths)
        getDataAndSet()
    }
    
    @objc func ly_deleteItemsAtIndexPaths(at indexPaths: [IndexPath]){
        ly_deleteItemsAtIndexPaths(at: indexPaths)
        getDataAndSet()
    }
    
    //reloadData
    @objc func ly_reloadData() {
        self.ly_reloadData()
        self.getDataAndSet()
    }
}

// MARK:- SelfAware 定义协议，使得程序在初始化的时候，将遵循该协议的类做了方法交换
protocol SelfAware: class {
    static func awake()
}

class NothingToSeeHere {
    static func harmlessFunction() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? SelfAware.Type)?.awake()
        }
        //types.deallocate(capacity: typeCount)
        types.deallocate()
    }
}

extension UIApplication {
    private static let runOnce: Void = {
        NothingToSeeHere.harmlessFunction()
    }()
    
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}












