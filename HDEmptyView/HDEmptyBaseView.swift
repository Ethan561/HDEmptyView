//
//  HDEmptyBaseView.swift
//  HDEmptyViewDemo
//
//  Created by liuyi on 2018/5/18.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit
import Foundation

public typealias  HDTapBlock = () -> ()

public class HDEmptyBaseView: UIView {

    //点击空白区域
    var tapContentViewBlock: HDTapBlock?
    //点击刷新按钮
    var _btnClickBlock: HDTapBlock?
    //
    var contentView: UIView! = UIView()
    
    //图片名字
    var _imageStr: NSString? {
        didSet {
            setupSubviews()
        }
    }
    //标题
    var _titleStr: NSString? {
        didSet {
            setupSubviews()
        }
    }
    //详情
    var _detailStr: NSString?
    {
        didSet {
            setupSubviews()
        }
    }
    //按钮标题
    var _btnTitleStr: NSString?
    {
        didSet {
            setupSubviews()
        }
    }
    
    var _target: AnyObject?
    var _selector: Selector?
    //自定义视图界面
    var _customView: UIView?
    //是否自动显隐EmptyView
    var autoShowEmptyView: Bool = true
    
    
    //MARK: -- 初始化方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = UIColor.white

    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let view = self.superview
        if (view?.isKind(of: UIScrollView.classForCoder()))! {
//            self.width = view!.width
//            self.height = view!.height
            self.frame = CGRect.init(x: 0, y: 0, width: view!.ly_width, height: view!.ly_height)
            
        }
        self.setupSubviews()
    }
    
    func setupSubviews() {
        
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        //不是UIScrollView，不做操作
        if (newSuperview is UIScrollView ) == false {
            return;
        }
        if newSuperview != nil {
            self.ly_width = newSuperview!.ly_width
            self.ly_height = newSuperview!.ly_height
        }
    }
    
    //MARK: ---
    // target/action 响应
    public class func emptyActionViewWithImageStr(imageStr: NSString, titleStr: NSString, detailStr: NSString, btnTitleStr: NSString, target:AnyObject, action: Selector) -> HDEmptyBaseView {
        
        let emptyView:HDEmptyView = HDEmptyView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
        
        emptyView.creatEmptyViewWithImageStr(imageStr: imageStr, titleStr: titleStr, detailStr: detailStr, btnTitleStr: btnTitleStr, target: target, action: action)
        
        return emptyView
    }
    
    //Block 回调方法
    public class func emptyActionViewWithImageStr(imageStr: NSString, titleStr: NSString, detailStr: NSString, btnTitleStr: NSString, btnClickBlock:@escaping HDTapBlock) -> HDEmptyView {
//        let emptyView = HDEmptyView.init(frame: CGRect.zero)
        let emptyView:HDEmptyView = HDEmptyView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))

        emptyView.creatEmptyViewWithImageStr(imageStr: imageStr, titleStr: titleStr, detailStr: detailStr, btnTitleStr: btnTitleStr, btnClickBlock: btnClickBlock)
        
        return emptyView
    }
    
    //没有刷新操作
//    public class func emptyActionViewWithImageStr(imageStr: NSString, titleStr: NSString, detailStr: NSString) -> HDEmptyView {
//        let emptyView = self
//        
//        emptyView.creatEmptyViewWithImageStr(imageStr: imageStr, titleStr: titleStr, detailStr: detailStr)
//        
//        return emptyView
//    }
    
    //自定义显示界面
    public class func emptyViewWithCustomView(customView: UIView) -> AnyObject {
        let emptyView:HDEmptyView = HDEmptyView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))

        emptyView.creatEmptyViewWithCustomView(customView: customView)
        
        return emptyView
    }
    
    func creatEmptyViewWithImageStr(imageStr: NSString, titleStr: NSString, detailStr: NSString, btnTitleStr: NSString, target:AnyObject, action: Selector) {
        _imageStr = imageStr
        _titleStr = titleStr
        _detailStr = detailStr
        _btnTitleStr = btnTitleStr
        
        _target = target
        _selector = action
        
        if contentView != nil {
            contentView = UIView.init(frame: CGRect.zero)
            self.addSubview(contentView!)
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapContentView(_:)))
            contentView?.addGestureRecognizer(tap)
            
        }
    }
    
    func creatEmptyViewWithImageStr(imageStr: NSString, titleStr: NSString, detailStr: NSString, btnTitleStr: NSString?, btnClickBlock:@escaping HDTapBlock) {
        _imageStr = imageStr
        _titleStr = titleStr
        _detailStr = detailStr
        _btnTitleStr = btnTitleStr
        _btnClickBlock = btnClickBlock
        
        if contentView != nil {
            self.addSubview(contentView!)
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapContentView(_:)))
            contentView?.addGestureRecognizer(tap)
        }
    }
    
    func creatEmptyViewWithImageStr(imageStr: NSString, titleStr: NSString, detailStr: NSString) {
        _imageStr = imageStr
        _titleStr = titleStr
        _detailStr = detailStr
        
        if contentView != nil {
            self.addSubview(contentView!)
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapContentView(_:)))
            contentView?.addGestureRecognizer(tap)
            
        }
    }
    
    func creatEmptyViewWithCustomView(customView: UIView) {
        if contentView != nil {
            self.addSubview(contentView!)
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapContentView(_:)))
            contentView?.addGestureRecognizer(tap)
        }
        _customView = customView
    }
    
    @objc func tapContentView(_ sender:UITapGestureRecognizer) {
        if tapContentViewBlock != nil {
            tapContentViewBlock!()
        }
    }
}




