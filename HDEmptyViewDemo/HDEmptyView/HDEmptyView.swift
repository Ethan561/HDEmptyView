//
//  HDEmptyView.swift
//  HDEmptyViewDemo
//
//  Created by liuyi on 2018/5/18.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit
import Foundation

//每个子控件之间的间距
let kSubViewMargin = 20.0
//描述字体
let kTitleLabFont = UIFont.systemFont(ofSize: 16)
//详细描述字体
let kDetailLabFont = UIFont.systemFont(ofSize: 14)
//按钮字体大小
let kActionBtnFont = UIFont.systemFont(ofSize: 14)
//按钮高度
let kActionBtnHeight = 40.0
let kActionBtnWidth  = 100.0

//水平方向内边距
let kActionBtnHorizontalMargin = 30.0
//黑色
let kBlackColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
//灰色
let kGrayColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)

public class HDEmptyView: HDEmptyBaseView {
    //提醒图片
    fileprivate lazy var promptImageView: UIImageView = {
        let promptImageView = UIImageView()
        promptImageView.contentMode = .scaleAspectFit
        return promptImageView
    }()
    //标题
    fileprivate lazy var titleLabel: UILabel = {
        let titleL = UILabel()
        titleL.textAlignment = .center
        return titleL
    }()
    //详情
    fileprivate lazy var detailLabel: UILabel = {
        let detailL = UILabel()
        detailL.textAlignment = .center
        detailL.numberOfLines = 2
        return detailL
    }()
    //
    fileprivate  lazy var actionButton: UIButton = {
        let btn = UIButton()
        btn.layer.masksToBounds = true
        return btn
    }()
    
    fileprivate var contentMaxWidth: CGFloat?  //最大宽度
    fileprivate var contentWidth: CGFloat?    //内容物宽度
    fileprivate var contentHeight: CGFloat?   //内容物高度
    fileprivate var subViweMargin: CGFloat?   //间距
    
    //MARK: ----- 显示参数设置 ---
    
    //控件间的间距 default is 20.f
    public var subViewMargin: CGFloat = 20 {
        didSet {
            setupSubviews()
        }
    }
    //内容物-垂直方向偏移 (此属性与contentViewY 互斥，只有一个会有效)
    public var contentViewOffset: CGFloat = 0 {
        didSet {
            self.contentView.ly_centerY += contentViewOffset
        }
    }
    // 内容物-Y坐标 (此属性与contentViewOffset 互斥，只有一个会有效)
    public var contentViewY: CGFloat = 0 {
        didSet {
            self.contentView.ly_top = self.contentViewY
        }
    }
    //图片可设置固定大小 (default=图片实际大小)
    public var imageSize: CGSize = CGSize.zero {
        didSet {
            setupSubviews()
        }
    }
    
    //标题字体, 大小default is 16.f
    public var titleLabFont: UIFont = kTitleLabFont {
        didSet {
            setupSubviews()
        }
    }
    
    //标题文字颜色
    public var titleLabTextColor: UIColor = kBlackColor {
        didSet {
            titleLabel.textColor = titleLabTextColor
        }
    }
    
    //详细描述字体，大小default is 14.f
    public var detailLabFont: UIFont = kDetailLabFont {
        didSet {
            detailLabel.font = detailLabFont
            setupSubviews()
        }
    }
    
    // 详细描述文字颜色
    public var detailLabTextColor: UIColor = kGrayColor {
        didSet {
            detailLabel.textColor = detailLabTextColor
        }
    }
    // 详细描述最大行数， default is 2
    public var detailLabMaxLines: NSInteger = 2 {
        didSet {
            setupSubviews()
        }
    }
    
    //Button
    
    // 按钮字体, 大小default is 14.f
    public var actionBtnFont: UIFont = kActionBtnFont {
        didSet {
            actionButton.titleLabel?.font = actionBtnFont
            setupSubviews()
        }
    }
    
    // 按钮的高度, default is 40.f
    public var actionBtnHeight: CGFloat = CGFloat(kActionBtnHeight) {
        didSet {
            setupSubviews()
        }
    }
    
    public var actionBtnWidth: CGFloat = CGFloat(kActionBtnWidth) {
        didSet {
            setupSubviews()
        }
    }
    
    //水平方向内边距, default is 30.f
    public var actionBtnHorizontalMargin: CGFloat = CGFloat(kActionBtnHorizontalMargin) {
        didSet {
            setupSubviews()
        }
    }
    
    // 按钮的圆角大小, default is 5.f
    public var actionBtnCornerRadius: CGFloat = 5.0 {
        didSet {
            actionButton.layer.cornerRadius = actionBtnCornerRadius
        }
    }
    
    // 按钮边框border的宽度, default is 0
    public var actionBtnBorderWidth: CGFloat = 0.0 {
        didSet {
            actionButton.layer.borderWidth = actionBtnBorderWidth
        }
    }
    
    // 按钮边框颜色
    public var actionBtnBorderColor: UIColor = .clear {
        didSet {
            actionButton.layer.borderColor = actionBtnBorderColor.cgColor
        }
    }
    
    // 按钮文字颜色
    public var actionBtnTitleColor: UIColor = kBlackColor {
        didSet {
            actionButton.setTitleColor(actionBtnTitleColor, for: .normal)
        }
    }
    
    // 按钮背景颜色
    public var actionBtnBackGroundColor: UIColor = .clear {
        didSet {
            actionButton.backgroundColor = actionBtnBackGroundColor
        }
    }
    
    //MARK: ----- 初始化方法 ----
    override func prepare() {
        super.prepare()
        self.ly_centerY = 1000//默认值，用来判断是否设置过content的Y值
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        //最大宽度（ScrollView 的宽 - 30）
        contentMaxWidth = self.ly_width - CGFloat(kActionBtnHorizontalMargin)
        contentWidth = 0
        contentHeight = 0
        subViweMargin = self.subViewMargin
        
        if self._customView == nil {
            
            //占位图
            let imgStr = self._imageStr == nil ? "" :self._imageStr
            let image = UIImage.init(named: imgStr! as String)
            if image != nil {
                self.setupPromptImageView(img: image!)
            }else {
                promptImageView.removeFromSuperview()
                if contentHeight == 0 {
                    contentHeight = self.center.y
                }
            }
            
            //标题
            if self._titleStr != nil && (self._titleStr?.length)! > 0{
                self.setupTitleLabel(titleStr: self._titleStr!)
            }else {
                titleLabel.removeFromSuperview()
                if contentHeight == 0 {
                    contentHeight = self.center.y
                }
            }
            
            //详细描述
            if self._detailStr != nil && (self._detailStr?.length)! > 0 {
                self.setupDetailLabel(detailStr: self._detailStr!)
            }else {
                detailLabel.removeFromSuperview()
                if contentHeight == 0 {
                    contentHeight = self.center.y
                }
            }
            //按钮
            if self._btnTitleStr != nil && (self._btnTitleStr?.length)! > 0{
                if _target != nil {
                    self.setupActionBtn(btnTitle: self._btnTitleStr!, target: self._target, action: self._selector, btnClickBlock: nil)
                    
                }else if (_btnClickBlock != nil) {
                    self.setupActionBtn(btnTitle: self._btnTitleStr!, target: nil, action: nil, btnClickBlock: self._btnClickBlock)
                }else {
                    actionButton.removeFromSuperview()
                }
            }else {
                actionButton.removeFromSuperview()
            }
        }
        
        setSubViewFrame()
    }
    
    func setSubViewFrame() {
        //获取self原始宽高
        let scrollViewWidth = self.ly_width
        let scrollViewHeight = self.ly_height
        //重新设置self的frame（大小为content的大小）
        self.ly_size = CGSize.init(width: contentWidth!, height: contentHeight!)
        self.center = CGPoint.init(x: scrollViewWidth*0.5, y: scrollViewHeight*0.5)
        
        //设置contentView
        self.contentView?.frame = self.bounds
        
        //子控件的centerX设置
        let centerX = self.ly_centerX
        if self._customView != nil {
            self._customView?.frame = self.bounds
            self.contentView!.addSubview(_customView!)
        }else {
            if promptImageView.image != nil {
                self.contentView?.addSubview(promptImageView)
            }
            self.contentView!.addSubview(titleLabel)
            self.contentView!.addSubview(detailLabel)
            self.contentView!.addSubview(actionButton)
            //
            self.promptImageView.ly_centerX = centerX
            self.promptImageView.ly_centerY = self.ly_centerY
            self.titleLabel.ly_centerX = centerX
            detailLabel.ly_centerX = centerX
            actionButton.ly_centerX = centerX
        }
        
        //有无偏移
        if self.contentViewOffset > 0 {
            self.contentView.ly_centerY += self.contentViewOffset
        }
        
        //有无设置Y坐标
        if self.contentViewY < 1000 {
            self.contentView.ly_top = self.contentViewY
        }
    }
}

//MARK: ------- Setup View ------
extension HDEmptyView {
    // ImageView
    func setupPromptImageView(img: UIImage) {
        self.promptImageView.image = img
        
        var imgViewWidth = img.size.width
        var imgViewHeight = img.size.height
        if self.imageSize.width > 0 && self.imageSize.height > 0{
            if imgViewWidth > imgViewHeight {
                imgViewHeight = (imgViewHeight/imgViewWidth)*self.imageSize.width
                imgViewWidth = self.imageSize.width
            }else {
                imgViewWidth = (imgViewWidth / imgViewHeight) * self.imageSize.height
                imgViewHeight = self.imageSize.height
            }
        }
        
        self.promptImageView.frame = CGRect.init(x: 0, y: 0, width: imgViewWidth, height: imgViewHeight)
        self.promptImageView.center = CGPoint.init(x: self.ly_centerX, y: self.ly_centerY-imgViewHeight*0.5)
        contentWidth = self.promptImageView.ly_width
        contentHeight = self.promptImageView.ly_maxY
        
    }
    //titleLabel
    func setupTitleLabel(titleStr: NSString) {
        let fontSize: CGFloat = self.titleLabFont.pointSize
        let width: CGFloat = self.getTextWidth(text: titleStr, size: CGSize.init(width: contentMaxWidth!, height: fontSize), font: self.titleLabFont).width
        titleLabel.frame = CGRect.init(x: 0, y: contentHeight!+subViweMargin!, width: width, height: fontSize)
        self.titleLabel.center = CGPoint.init(x: self.ly_centerX, y: titleLabel.ly_centerY)
        titleLabel.font = self.titleLabFont
        titleLabel.textColor = titleLabTextColor
        titleLabel.text = self._titleStr! as String
        contentWidth = (Float(width) > Float(contentWidth!)) ? width : contentWidth
        contentHeight = titleLabel.ly_maxY
        
    }
    
    //DetailLabel
    func setupDetailLabel(detailStr: NSString) {
        
        let size: CGSize = self.getTextWidth(text: detailStr, size: CGSize.init(width: contentMaxWidth!, height: 900), font: self.detailLabFont)
        var width = size.width
        if width < contentMaxWidth! {
            width = contentMaxWidth!
        }
        detailLabel.frame = CGRect.init(x: contentMaxWidth!/2.0, y: contentHeight!+subViweMargin!, width: width, height: size.height+5)
        detailLabel.center = CGPoint.init(x: self.ly_centerX, y: detailLabel.ly_centerY)
        
        detailLabel.font = self.titleLabFont
        detailLabel.text = self._detailStr! as String
        detailLabel.textColor = detailLabTextColor
        contentWidth = (Float(width) > Float(contentWidth!)) ? width : contentWidth
        contentHeight = detailLabel.ly_maxY
        
    }
    
    //button
    func setupActionBtn(btnTitle: NSString, target:AnyObject?, action: Selector?, btnClickBlock: HDTapBlock?) {
        
        let fontSize: CGFloat = self.actionBtnFont.pointSize
        var btnWidth: CGFloat = self.getTextWidth(text: btnTitle, size: CGSize.init(width: contentMaxWidth!, height: fontSize), font: self.actionBtnFont).width + self.actionBtnHorizontalMargin*2
        let btnHeight = self.actionBtnHeight
        if btnWidth < self.actionBtnWidth {
            btnWidth = self.actionBtnWidth
        }
        actionButton.frame = CGRect.init(x: 0, y: contentHeight!+subViewMargin, width: btnWidth, height: btnHeight)
        actionButton.center = CGPoint.init(x: self.ly_centerX, y: actionButton.ly_centerY)

        actionButton.setTitle(btnTitle as String, for: .normal)
        actionButton.setTitleColor(self.actionBtnTitleColor, for: .normal)
        actionButton.titleLabel?.font = self.actionBtnFont
        actionButton.backgroundColor = self.actionBtnBackGroundColor
        
        actionButton.layer.borderWidth = self.actionBtnBorderWidth
        actionButton.layer.borderColor = self.actionBtnBorderColor.cgColor
        actionButton.layer.cornerRadius = self.actionBtnCornerRadius
        
        if action != nil {
            actionButton.addTarget(target!, action: action!, for: UIControl.Event.touchUpInside)
            actionButton.addTarget(self, action: #selector(actionBtnClick(_:)), for: UIControl.Event.touchUpInside)

        }else {
            actionButton.addTarget(self, action: #selector(actionBtnClick(_:)), for: UIControl.Event.touchUpInside)

        }
    }
    
    //MARK: ----
    func getTextWidth(text: NSString , size: CGSize, font: UIFont) -> CGSize {
        let textSize: CGSize = (text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedString.Key: font], context: nil)).size
        return textSize
    }
    
    @objc func actionBtnClick(_ sender: UIButton) {
        if self._btnClickBlock != nil {
            self._btnClickBlock!()
        }
    }
    
    
}



















