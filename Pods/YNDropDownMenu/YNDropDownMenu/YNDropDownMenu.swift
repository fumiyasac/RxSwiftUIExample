//
//  YNDropDownMenu.swift
//  YNDropDownMenu
//
//  Created by YiSeungyoun on 2017. 2. 18..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

/// Button status
public enum YNStatus {
    /// Normal YNStatus
    case normal
    
    /// Selected YNStatus
    case selected
    
    /// Disabled YNStatus
    case disabled
}

/// Main Class for YNDropDownMenu
open class YNDropDownMenu: UIView, YNDropDownDelegate {
    internal var opened: Bool = false
    internal var openedIndex: Int = 0
    
    internal var dropDownButtons: [YNDropDownButton]?
    internal var menuHeight: CGFloat = 0.0
    internal var numberOfMenu: Int = 0
    
    internal var buttonImages: YNImages?
    internal var buttonImagesArray: [YNImages?]?
    internal var buttonlabelFontColors: YNFontColor?
    internal var buttonlabelFonts: YNFont?
    
    internal var _dropDownViews: [UIView]?
    internal var dropDownViews: [UIView]? {
        get {
            return self._dropDownViews
        }
        set {
            guard let _dropDownViews = newValue else { return }
            _dropDownViews.compactMap({ $0 as? YNDropDownView }).forEach { $0.delegate = self }
            self._dropDownViews = newValue
        }
    }
    
    internal var alwaysOnIndex: [Int]?
    internal var dropDownViewTitles: [String]?
    
    /// Blur effect view will changed if you change this popperty. Backgorund view don't have to be blur view (e.g. UIColor.black)
    open var blurEffectView: UIView? {
        didSet {
            self.changeBlurEffectView()
        }
    }
    /// Alpha Value if animation ended in *hideMenu()* function
    open var blurEffectViewAlpha:CGFloat = 1.0
    
    /// Blur effect style in background view
    open var blurEffectStyle:UIBlurEffect.Style = .dark
    
    /// Make background blur view enabled
    open var backgroundBlurEnabled = true
    
    /// Show menu second default value: *0.5*
    open var showMenuDuration = 0.5
    
    /// Hide menu second default value: *0.3*
    open var hideMenuDuration = 0.3
    
    /// Show menu spring velocity default value: *0.5*
    open var showMenuSpringVelocity:CGFloat = 0.5
    
    /// Show menu spring damping default value: *0.8*
    open var showMenuSpringWithDamping:CGFloat = 0.8
    
    /// Hide menu spring velocity Default value: *0.9*
    open var hideMenuSpringVelocity:CGFloat = 0.9
    
    /// Hide menu spring damping Default value: *0.8*
    open var hideMenuSpringWithDamping:CGFloat = 0.8
    
    /// Bottom 0.5px line
    open var bottomLine: UIView!
    /**
     Init YNDropDownMenu with frame, views, strings. Views count and titles count should be same
     
     - Parameter frame: CGRect Frame
     - Parameter dropDownViews: Use [UIView] or [YNDropDownView]
     - Parameter dropDownViewTitles: [String]
     */
    public init(frame: CGRect, dropDownViews: [UIView], dropDownViewTitles: [String]) {
        guard dropDownViews.count == dropDownViewTitles.count else {
            fatalError("Please make dropDownViews count same with dropDownViewsTitles count")
        }
        
        super.init(frame: frame)
        
        numberOfMenu = dropDownViews.count
        self.dropDownViews = dropDownViews
        self.dropDownViewTitles = dropDownViewTitles
        self.menuHeight = self.frame.height
        
        self.initViews()
    }
    
    /// deprecated use init(frame: CGRect, dropDownViews: [UIView], dropDownViewTitles: [String]) instead
    @available(*, deprecated, message: "use init(frame: CGRect, dropDownViews: [UIView], dropDownViewTitles: [String]) instead")
    public init(frame: CGRect, YNDropDownViews: [YNDropDownView], dropDownViewTitles: [String]) {
        super.init(frame: frame)
        
        if YNDropDownViews.count != dropDownViewTitles.count {
            fatalError("Please make dropDownViews count same with dropDownViewsTitles count")
        } else {
            numberOfMenu = YNDropDownViews.count
        }
        
        self.dropDownViews = YNDropDownViews
        self.dropDownViewTitles = dropDownViewTitles
        self.menuHeight = self.frame.height
        
        self.initViews()
    }
    
    /// Init coder
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    deinit {
        if let _blurEffectView = blurEffectView {
            _blurEffectView.removeFromSuperview()
        }
    }
    
    /**
     Set arrow image or other images. Same image size is the best
     
     - Parameter normal: Normal image
     - Parameter selected: Selected image
     - Parameter disabled: Disabled image
     */
    open func setImageWhen(normal: UIImage?, selected: UIImage?, disabled: UIImage?) {
        self.buttonImages = YNImages.init(normal: normal, selected: selected, disabled: disabled)
        
        for i in 0..<numberOfMenu {
            dropDownButtons?[i].buttonImages = self.buttonImages
        }
    }
    

    
    
    /**
     Set an image for a drop-down button with various colors.
     
     - Parameter normal: Normal image used as a drop-down button.
     - Parameter selectedColor: Tint color masking the image when the button selected.
     - Parameter disabledColor: Tint color masking the image when the button disabled.
     */
    open func setImageWhen(normal: UIImage?, selectedTintColor: UIColor, disabledTintColor: UIColor) {
        
        let selected = imageMaskingwithColor(selectedTintColor, image: normal)
        let disabled = imageMaskingwithColor(disabledTintColor, image: normal)
        
        self.buttonImages = YNImages.init(normal: normal, selected: selected, disabled: disabled)
        
        for i in 0..<numberOfMenu {
            dropDownButtons?[i].buttonImages = self.buttonImages
        }
    }
    
    open func setImageWhens(normal: [UIImage?], selectedTintColor: UIColor, disabledTintColor: UIColor) {
        if self.buttonImagesArray == nil {
            self.buttonImagesArray = []
        }
        
        for i in 0 ..< numberOfMenu{
            let image = normal[i]
            let selected = imageMaskingwithColor(selectedTintColor, image: image)
            let disabled = imageMaskingwithColor(disabledTintColor, image: image)
            
            let ynImages = YNImages.init(normal: image, selected: selected, disabled: disabled)
            self.buttonImagesArray?.append(ynImages)
            dropDownButtons?[i].buttonImages = self.buttonImagesArray?[i]
        }
    }
    
    /**
     Set an image for a drop-down button with various colors.
     
     - Parameter normal: Normal image used as a drop-down button.
     - Parameter selectedColorRGB: a Hex code color masking the image when the button selected.
     - Parameter disabledColorRGB: a Hex code color masking the image when the button disabled.
     */
    open func setImageWhen(normal: UIImage?, selectedTintColorRGB: String, disabledTintColorRGB: String) {
        
        let selected = imageMaskingwithColor(hexStringToUIColor(hex: selectedTintColorRGB), image: normal)
        let disabled = imageMaskingwithColor(hexStringToUIColor(hex: disabledTintColorRGB), image: normal)
        
        self.buttonImages = YNImages.init(normal: normal, selected: selected, disabled: disabled)
        
        for i in 0..<numberOfMenu {
            dropDownButtons?[i].buttonImages = self.buttonImages
        }
    }
    
    open func setImageWhens(normal: [UIImage?], selectedTintColorRGB: String, disabledTintColorRGB: String) {
        
        if self.buttonImagesArray == nil {
            self.buttonImagesArray = []
        }
        
        for i in 0 ..< numberOfMenu{
            let image = normal[i]
            let selected = imageMaskingwithColor(hexStringToUIColor(hex: selectedTintColorRGB), image: image)
            let disabled = imageMaskingwithColor(hexStringToUIColor(hex: disabledTintColorRGB), image: image)
            
            let ynImages = YNImages.init(normal: image, selected: selected, disabled: disabled)
            self.buttonImagesArray?.append(ynImages)
            dropDownButtons?[i].buttonImages = self.buttonImagesArray?[i]
        }
    }
    
    /**
     Set backgroung color.
     
     - Parameter color: background color.
     */
    open func setBackgroundColor(color: UIColor) {
        for i in 0..<numberOfMenu {
            dropDownButtons?[i].backgroundColor = color
        }
    }
    
    /// Convert String-type hex color codes into UIColor.
    private func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /// Mask images with UIColor.
    private func imageMaskingwithColor(_ color: UIColor, image: UIImage?) -> UIImage?{
        
        if let image = image {
            
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            let context = UIGraphicsGetCurrentContext()!
            
            color.setFill()
            
            context.translateBy(x: 0, y: image.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            
            let rect = CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
            context.draw(image.cgImage!, in: rect)
            
            context.setBlendMode(CGBlendMode.sourceIn)
            context.addRect(rect)
            context.drawPath(using: CGPathDrawingMode.fill)
            
            let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return coloredImage
            
        } else {
            return nil
        }
    }
    
    /**
     Set label color.
     
     - Parameter normal: Normal color
     - Parameter selected: Selected color
     - Parameter disabled: Disabled color
     */
    open func setLabelColorWhen(normal: UIColor, selected: UIColor, disabled: UIColor) {
        self.buttonlabelFontColors = YNFontColor.init(normal: normal, selected: selected, disabled: disabled)
        
        for i in 0..<numberOfMenu {
            dropDownButtons?[i].labelFontColors = self.buttonlabelFontColors
        }
    }
    
    /**
     Set label color with hex color codes
     
     - Parameter normal: Normal color
     - Parameter selected: Selected color
     - Parameter disabled: Disabled color
     */
    open func setLabelColorWhen(normalRGB: String, selectedRGB: String, disabledRGB: String){
        
        self.buttonlabelFontColors = YNFontColor.init(normal: hexStringToUIColor(hex: normalRGB), selected: hexStringToUIColor(hex: selectedRGB), disabled: hexStringToUIColor(hex: disabledRGB))
        
        for i in 0..<numberOfMenu {
            dropDownButtons?[i].labelFontColors = self.buttonlabelFontColors
        }
    }
    
    
    /**
     Set the same label font for every status.
     
     - Parameter font: Normal/Selected/Disabled font
     */
    open func setLabel(font: UIFont) {
        self.setLabelFontWhen(normal: font, selected: font, disabled: font)
    }
    
    /**
     Set label font.
     
     - Parameter normal: Normal font
     - Parameter selected: Selected font
     - Parameter disabled: Disabled font
     */
    open func setLabelFontWhen(normal: UIFont, selected: UIFont, disabled: UIFont) {
        self.buttonlabelFonts = YNFont.init(normal: normal, selected: selected, disabled: disabled)
        
        for i in 0..<numberOfMenu {
            dropDownButtons?[i].labelFonts = self.buttonlabelFonts
        }
    }
    
    /**
     Make button label always selected. (not button image)
     
     - Parameter index: Index should be smaller than your menu counts
     */
    open func alwaysSelected(at index: Int) {
        self.checkIndex(index: index)
        
        guard let alwaysOnIndex = self.alwaysOnIndex else { return }
        
        if alwaysOnIndex.contains(index) {
            print("YNDropDownMenu: Already index is contained in Array")
        } else {
            self.alwaysOnIndex?.append(index)
        }
        
        dropDownButtons?[index].buttonLabel.textColor = self.buttonlabelFontColors?.selected
        dropDownButtons?[index].buttonLabel.font = self.buttonlabelFonts?.selected
    }
    
    /**
     Make button label normal that selected before. (not button image)
     
     - Parameter index: Index should be smaller than your menu counts
     */
    open func normalSelected(at index: Int) {
        self.checkIndex(index: index)
        
        guard let alwaysOnIndex = self.alwaysOnIndex else { return }
        
        if let value = alwaysOnIndex.index(of: index) {
            self.alwaysOnIndex!.remove(at: value)
        } else {
            print("YNDropDownMenu: Index is not contained in Array")
        }
        
        dropDownButtons?[index].buttonLabel.textColor = self.buttonlabelFontColors?.normal
        dropDownButtons?[index].buttonLabel.font = self.buttonlabelFonts?.normal
    }
    
    /**
     Make button disabled (title and image you set)
     
     - Parameter index: Index should be smaller than your menu counts
     */
    open func disabledMenu(at index: Int) {
        self.checkIndex(index: index)
        dropDownButtons?[index].disabled()
    }
    
    /**
     Makes button enabled (title and image you set)
     
     - Parameter index: Index should be smaller than your menu counts
     */
    open func enabledMenu(at index: Int) {
        self.checkIndex(index: index)
        dropDownButtons?[index].enabled()
    }
    
    /// Hide menu will be called when view is opened already.
    open func hideMenu() {
        guard opened else { return }
        hideMenu(yNDropDownButton: dropDownButtons?[openedIndex], buttonImageView: dropDownButtons?[openedIndex].buttonImageView, dropDownView: dropDownViews?[openedIndex], didComplete: nil)
        opened = !opened
    }
    
    /**
     Change menu title you called. you can call it in YNDropDownMenu or YNDropDownView
     
     - Parameter title: Menu title
     - Parameter index: Index should be smaller than your menu counts
     */
    open func changeMenu(title: String, at index: Int) {
        dropDownButtons?[index].buttonLabel.text = title
    }
    
    /**
     Change menu title you called. you can call it in YNDropDownMenu or YNDropDownView
     
     - Parameter title: Menu title
     - Parameter index: Index should be smaller than your menu counts
     */
    open func changeMenu(title: String, status: YNStatus, at index: Int) {
        changeMenu(title: title, at: index)
        switch status {
        case .normal:
            dropDownButtons?[index].buttonLabel.textColor = self.buttonlabelFontColors?.normal
            dropDownButtons?[index].buttonLabel.font = self.buttonlabelFonts?.normal
            dropDownButtons?[index].isUserInteractionEnabled = true
            
        case .selected:
            dropDownButtons?[index].buttonLabel.textColor = self.buttonlabelFontColors?.selected
            dropDownButtons?[index].buttonLabel.font = self.buttonlabelFonts?.selected
            dropDownButtons?[index].isUserInteractionEnabled = true
            
        case .disabled:
            dropDownButtons?[index].buttonLabel.textColor = self.buttonlabelFontColors?.disabled
            dropDownButtons?[index].buttonLabel.font = self.buttonlabelFonts?.disabled
            dropDownButtons?[index].isUserInteractionEnabled = false
        }
    }
    
    
    /**
     Change view you called. you can call it in YNDropDownMenu or YNDropDownView
     
     - Parameter view: view that you want to change
     - Parameter index: Index should be smaller than your menu counts
     */
    open func changeView(view: UIView, at index: Int) {
        self.checkIndex(index: index)
        
        dropDownViews?[index] = view
        
        view.frame.size = CGSize(width: self.bounds.size.width, height: view.frame.size.height)
        view.frame.origin.y = -view.frame.height + CGFloat(menuHeight)
        view.isHidden = true
    }
    
    /**
     View will be closed and open when already opened. If not, just open drop down view
     
     - Parameter index: Index should be smaller than your menu counts
     */
    open func showAndHideMenu(at index: Int) {
        self.checkIndex(index: index)
        
        if openedIndex != index && opened {
            hideMenu(yNDropDownButton: dropDownButtons?[openedIndex], buttonImageView: dropDownButtons?[openedIndex].buttonImageView, dropDownView: dropDownViews?[openedIndex], didComplete: {
                self.showMenu(yNDropDownButton: self.dropDownButtons?[index], buttonImageView: self.dropDownButtons?[index].buttonImageView, dropDownView: self.dropDownViews?[index], didComplete: nil)
            })
            openedIndex = index
            return
        }
        openedIndex = index
        
        if !opened {
            showMenu(yNDropDownButton: dropDownButtons?[index], buttonImageView: dropDownButtons?[index].buttonImageView, dropDownView: dropDownViews?[index], didComplete: nil)
        } else {
            hideMenu(yNDropDownButton: dropDownButtons?[index], buttonImageView: dropDownButtons?[index].buttonImageView, dropDownView: dropDownViews?[index], didComplete: nil)
        }
        
        opened = !opened
    }
    
    @objc internal func menuClicked(_ sender: YNDropDownButton) {
        self.showAndHideMenu(at: sender.tag)
    }
    
    @objc internal func blurEffectViewClicked(_ sender: UITapGestureRecognizer) {
        self.hideMenu()
    }
    
    internal func checkIndex(index: Int) {
        if index >= numberOfMenu {
            fatalError("index should be smaller than menu count")
        }
    }
    
    internal func showMenu(yNDropDownButton: YNDropDownButton?, buttonImageView: UIImageView?, dropDownView: UIView?, didComplete: (()-> Void)?) {
        guard
            let yNDropDownButton = yNDropDownButton,
            let dropDownView = dropDownView else { return }
        
        dropDownView.isHidden = false
        
        self.addSubview(dropDownView)
        self.sendSubviewToBack(dropDownView)
        
        (dropDownView as? YNDropDownView)?.dropDownViewOpened()
        
        if self.backgroundBlurEnabled, let _blurEffectView = blurEffectView {
            self.superview?.insertSubview(_blurEffectView, belowSubview: self)
        }
        UIView.animate(
            withDuration: self.showMenuDuration,
            delay: 0,
            usingSpringWithDamping: self.showMenuSpringWithDamping,
            initialSpringVelocity: self.showMenuSpringVelocity,
            options: [],
            animations: {
                dropDownView.frame.origin.y = CGFloat(self.menuHeight)
                if self.backgroundBlurEnabled {
                    self.blurEffectView?.alpha = self.blurEffectViewAlpha
                }
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: dropDownView.frame.height + CGFloat(self.menuHeight))
                if let _buttonImageView = buttonImageView {
//                    _buttonImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), 1.0, 0.0, 0.0)
                    _buttonImageView.image = self.buttonImagesArray?[yNDropDownButton.tag]?.selected
//                    _buttonImageView.image = self.buttonImages?.selected
                }
                yNDropDownButton.buttonLabel.textColor = self.buttonlabelFontColors?.selected
                yNDropDownButton.buttonLabel.font = self.buttonlabelFonts?.selected
                
        }, completion: { _ in
            didComplete?()
        })
    }
    
    internal func hideMenu(yNDropDownButton: YNDropDownButton?, buttonImageView: UIImageView?, dropDownView: UIView?, didComplete: (()-> Void)?) {
        guard
            let yNDropDownButton = yNDropDownButton,
            let dropDownView = dropDownView else { return }
        
        (dropDownView as? YNDropDownView)?.dropDownViewClosed()
        
        UIView.animate(
            withDuration: self.hideMenuDuration,
            delay: 0,
            usingSpringWithDamping: self.hideMenuSpringWithDamping,
            initialSpringVelocity: self.hideMenuSpringVelocity,
            options: [],
            animations: {
                dropDownView.frame.origin.y = CGFloat(self.menuHeight)
                if self.backgroundBlurEnabled {
                    self.blurEffectView?.alpha = 0
                }
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: CGFloat(self.menuHeight))
                if let _buttonImageView = buttonImageView {
                    _buttonImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), 0.0, 0.0, 0.0);
//                    _buttonImageView.image = self.buttonImages?.normal
                    _buttonImageView.image = self.buttonImagesArray?[yNDropDownButton.tag]?.normal
                }
                
                guard let alwaysOnIndex = self.alwaysOnIndex else { return }
                if !alwaysOnIndex.contains(yNDropDownButton.tag) {
                    yNDropDownButton.buttonLabel.textColor = self.buttonlabelFontColors?.normal
                    yNDropDownButton.buttonLabel.font = self.buttonlabelFonts?.normal
                }
                
        }, completion: { _ in
            if self.backgroundBlurEnabled {
                self.blurEffectView?.removeFromSuperview()
                dropDownView.isHidden = true
            }
            didComplete?()
        })
    }
    
    
    internal func changeBlurEffectView() {
        let originY = self.frame.origin.y + menuHeight + 5

        self.blurEffectView?.frame = CGRect(x: self.frame.origin.x, y: originY, width: self.frame.width, height: UIScreen.main.bounds.size.height - originY)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(blurEffectViewClicked(_:)))
        self.blurEffectView?.addGestureRecognizer(tapGesture)
        self.blurEffectView?.alpha = 0
    }
    
    internal func initViews() {
        self.clipsToBounds = true
        self.alwaysOnIndex = []
        
        self.dropDownButtons = []
        
        for i in 0..<numberOfMenu {
            // Setup button
            let button = YNDropDownButton(frame: CGRect(x: 0, y: 0.0, width: 10, height: CGFloat(menuHeight)), buttonLabelText: dropDownViewTitles?[i])
            button.tag = i
            button.addTarget(self, action: #selector(menuClicked(_:)), for: .touchUpInside)
            dropDownButtons?.append(button)
            
            self.addSubview(button)
            
            // Setup Views
            if let _dropDownView = dropDownViews?[i] {
                _dropDownView.isHidden = true
            }
        }
        
        self.bottomLine = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0.5))
        self.bottomLine.backgroundColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
        self.bottomLine.isHidden = true
        self.addSubview(self.bottomLine)
        
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurEffectView?.alpha = 0
        
        self.blurEffectView?.frame = CGRect(x: self.frame.origin.x, y: 0, width: self.frame.width, height: 0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(blurEffectViewClicked(_:)))
        self.blurEffectView?.addGestureRecognizer(tapGesture)
        
        layoutViews()
    }
    
    internal func layoutViews() {
        let eachWidth = self.bounds.size.width / CGFloat(numberOfMenu)
        for i in 0..<numberOfMenu {
            // Setup button
            if let button = dropDownButtons?[i] {
                button.frame = CGRect(x: eachWidth * CGFloat(i), y: 0.0, width: eachWidth, height: CGFloat(menuHeight))
            }
            // Setup Views
            if let _dropDownView = dropDownViews?[i] {
                _dropDownView.frame.size = CGSize(width: self.bounds.size.width, height: _dropDownView.frame.height)
                _dropDownView.frame.origin.y = CGFloat(menuHeight)
            }
        }
        let originY = self.frame.origin.y + menuHeight + 5
        self.bottomLine.frame = CGRect(x: 0, y: CGFloat(menuHeight) - 0.5, width: self.frame.width, height: 0.5)
        self.blurEffectView?.frame = CGRect(x: self.frame.origin.x, y: originY, width: self.frame.width, height: UIScreen.main.bounds.size.height - originY)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        layoutViews()
    }
}
