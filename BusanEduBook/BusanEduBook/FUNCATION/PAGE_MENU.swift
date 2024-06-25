//
//  PAGE_MENU.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/07/30.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit

@IBDesignable

/*
 Documentation
 
 1 - if selector contains texts set:
 
 segmentedControl.setSelectorWith(titles: [String])
 ITEMS_WIDTH_TEXT = true
 FILL_EQUALLY = true/false depending on the lenght of text, suggest set to true to give mnore space to text
 
 2 - if selector contains images set:
 
 segmentedControl.setSelectorWith(images: [image])
 ITEMS_WIDTH_TEXT = false
 FILL_EQUALLY = true/false depending on design
 BTN_COLOR_FOR_NORMAL and BTN_COLOR_FOR_SELECTED
 
 and set the
 
 3 - if selector contains images that are different and dont want to change its tintColor on selection set:
 
 segmentedControl.setSelectorWith(images: [image])
 ITEMS_WIDTH_TEXT = false
 BTNS_WITH_DYNAMIC_IMAGES = true
 Note - do not set ITEMS_WITH_DYNAMIC_COLOR to true here that will make BTNS not show on app
 
 //this will change the image based on the index
 
 4 - if selector needs to change color set
 
 segmentedControl.setSelectorWith(colors: [UIColor])
 ITEMS_WIDTH_TEXT = false
 FILL_EQUALLY = true/false depending on design
 ITEMS_WITH_DYNAMIC_COLOR = true
 IMAGE_FOR_ITEM_WITH_DYNAMIC_COLORS = image that wil change color
 
 */

class PAGE_MENU: UIControl {
    
    //static properties
    //Set to 10 by default, if setted to 0 the image will be same size at button
    static let IMAGE_INSETS: UIEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    static let BTN_LINE_THUMB_VIEW_HEIGHT: CGFloat = 5.0
    
    //Private UI properties
    fileprivate var BTNS = [UIButton]()
    fileprivate var THUMB_VIEW: UIView = {
        return UIView()
    }()
        
    //Private datasources
    @IBInspectable private var BTN_IMAGES: [UIImage] = [] {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    @IBInspectable private var BTN_TITLES: [String] = [] {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    @IBInspectable private var BTN_COLORS: [UIColor] = [] {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    //Public properties customize segmented control
    //change this public properties for customization
    
    //MARK: APPEREANCE
    var SELECTED_SEGMENT_INDEX = 0

    @IBInspectable var PADDING: CGFloat = 0 {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    @IBInspectable var CUSTOM_BORDER_WIDTH: CGFloat = 0 {
        didSet {
            layer.borderWidth = CUSTOM_BORDER_WIDTH
        }
    }
    
    @IBInspectable var CUSTOM_BORDER_COLOR: UIColor = .clear {
        didSet {
            layer.borderColor = CUSTOM_BORDER_COLOR.cgColor
        }
    }
    
    //animation duration is 0.3 by default
    @IBInspectable var ANIMATION_DURATION: CGFloat = 0.3
    @IBInspectable var THUMB_VIEW_ALPHA: CGFloat = 1.0 {
        didSet {
            THUMB_VIEW.alpha = THUMB_VIEW_ALPHA
        }
    }

    //segmented
    @IBInspectable var SEGMENTED_BACKGROUND_COLOR: UIColor = .clear {
        didSet {
            backgroundColor = SEGMENTED_BACKGROUND_COLOR
        }
    }
    
    //THUMB_VIEW
    @IBInspectable var THUMB_VIEW_COLOR: UIColor = .darkGray {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    //MARK: SEGMENTED CONTROL WITH TEXT
    @IBInspectable var TEXT_COLOR: UIColor = .lightGray {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    @IBInspectable var SELECTED_TEXT_COLOR: UIColor = .white {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    public var TITLES_FONT: UIFont? {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    //MARK: SEGMENTED CONTROL WITH IMAGES
    //if images with change on it's tint color on selection
    @IBInspectable var BTN_COLOR_FOR_NORMAL: UIColor = .lightGray {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    @IBInspectable var BTN_COLOR_FOR_SELECTED: UIColor = .darkGray {
        didSet {
            UPDATE_VIEW()
        }
    }

    //MARK: SEGMENTED CONTROL WITH COLORS

    //this is just a placeholder it can be any type of images passed as parameter it will "hold" the color and present it
    @IBInspectable var IMAGE_FOR_ITEM_WITH_DYNAMIC_COLORS: UIImage? {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    //MARK: MAIN BOOLEANS FOR SET UICONTROL
    //main properties for customize segmented, if ITEMS contains text is recommended to set the FILL_EQUALLY to true
    
    //A) Most important booleans are FILL_EQUALLY - ITEMS_WIDTH_TEXT - REOUNDED_CONTROL - BTN_LINE_THUMB_VIEW - THUMB_VIEW_HIDDEN
    public var FILL_EQUALLY: Bool = false {
        didSet {
            layoutSubviews()
        }
    }
    
    //change the control for images and text
    public var ITEMS_WIDTH_TEXT: Bool = false {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    public var REOUNDED_CONTROL: Bool = false {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    public var BTN_LINE_THUMB_VIEW: Bool = false {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    public var THUMB_VIEW_HIDDEN: Bool = false {
        didSet {
            THUMB_VIEW.isHidden = THUMB_VIEW_HIDDEN
        }
    }
    
    //B) This makes changes on BTNS with images and only if ITEMS_WIDTH_TEXT = false
    //if BTNS have dynamicImages means if we want to show the image without changing its tintcolor
    //Setting this to true will make not BTN_COLOR_FOR_NORMAL and BTN_COLOR_FOR_SELECTED not been called
    @IBInspectable var BTNS_WITH_DYNAMIC_IMAGES: Bool = false {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    //C) This makes changes on BTNS with colors and only if ITEMS_WIDTH_TEXT = false
    @IBInspectable public var ITEMS_WITH_DYNAMIC_COLOR: Bool = false {
        didSet {
            UPDATE_VIEW()
        }
    }
    
    //MARK: SET SEGMENTED CONTROL DATASOURCES
    
    func SET_SEGMENTED_WITH<T>(ITEMS: T) {
        if ITEMS is [String] {
            self.BTN_TITLES = ITEMS as! [String]
        } else if ITEMS is [UIImage] {
            self.BTN_IMAGES = ITEMS as! [UIImage]
        } else if ITEMS is [UIColor] {
            self.BTN_COLORS = ITEMS as! [UIColor]
        }
    }
    
    //MARK: GENERIC METHOD FOR UPDATE DATASOURCES
    func updateSegmentedWith<T>(ITEMS: T) {
        
        self.BTN_TITLES.removeAll()
        self.BTN_IMAGES.removeAll()
        self.BTN_COLORS.removeAll()
        self.THUMB_VIEW.alpha = 0
        
        self.SELECTED_SEGMENT_INDEX = 0
        self.SET_SEGMENTED_WITH(ITEMS: ITEMS)

        UIView.animate(withDuration: 0.4) {
            self.UPDATE_VIEW()
            self.THUMB_VIEW.alpha = 1
        }
        //if we want to update the view based on the new selectedSegmentedIndex
        self.PERFORM_ACTION()
    }
    
    //MARK: METHODS THAT WILL CREATE THE CONTROL BASED ON CUSTOMIZATION OF PROPERTIES
    
    //1 reset all views to clean state
    private func RESET_VIEW() {
        BTNS.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    //2 update the UI based on text/ images or colors
    private func UPDATE_VIEW() {
        
        RESET_VIEW()
        self.clipsToBounds = false
        addSubview(THUMB_VIEW)
        if ITEMS_WITH_DYNAMIC_COLOR {
            SET_BTNS_WITH_DYNAMIC_COLORS()
        } else {
            ITEMS_WIDTH_TEXT ? SET_BUTTON_WIDH_TEXT() : SET_BTNS_WITH_IMAGES()
        }
        if FILL_EQUALLY {
            self.LAYOUT_BTNS_OM_STACK_VIEW()
        } else {
            let _ = self.BTNS.map { addSubview($0) }
        }
    }
    
    //3 all UI layout based on FRAMEs must be called on layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        layer.cornerRadius = REOUNDED_CONTROL ? FRAME.height / 2 : 1.0
        self.backgroundColor = self.SEGMENTED_BACKGROUND_COLOR
        self.layer.borderColor = self.SEGMENTED_BACKGROUND_COLOR.cgColor
        SET_THUMB_VIEW()
        //if FILL_EQUALLY is not true the layout is not in stackview and its set based on FRAMEs
        guard !FILL_EQUALLY else { return }
        for (INDEX, BTN) in self.BTNS.enumerated() {
            BTN.frame = SET_FRAME_FOR_BUTTON_AT(INDEX: INDEX)
        }
    }
    
    //MARK: THUMB_VIEW LAYOUT
    private func SET_THUMB_VIEW() {

        let THUMB_VIEW_HEIGHT = BTN_LINE_THUMB_VIEW ? PAGE_MENU.BTN_LINE_THUMB_VIEW_HEIGHT : bounds.height - PADDING * 2
        let THUMB_VIEW_WIDTH = FILL_EQUALLY ? (bounds.width / CGFloat(BTNS.count)) - PADDING * 2 : bounds.height - PADDING * 2
        let THUMB_VIEW_POSITION_X = PADDING
        let THUMB_VIEW_POSITION_Y = BTN_LINE_THUMB_VIEW ? bounds.height - THUMB_VIEW_HEIGHT - PADDING : (bounds.height - THUMB_VIEW_HEIGHT) / 2
        
        THUMB_VIEW.frame = CGRect(x: THUMB_VIEW_POSITION_X, y: THUMB_VIEW_POSITION_Y, width: THUMB_VIEW_WIDTH, height: THUMB_VIEW_HEIGHT)
//        THUMB_VIEW.layer.cornerRadius = REOUNDED_CONTROL ? THUMB_VIEW_HEIGHT / 2 : 1.0
        THUMB_VIEW.backgroundColor = THUMB_VIEW_COLOR
    }
    
    //4 MARK: BTNS LAYOUTS
    // if fillEqualy = true
    private func LAYOUT_BTNS_OM_STACK_VIEW() {
        
        let SV = UIStackView(arrangedSubviews: BTNS)
        SV.axis = .horizontal
        SV.alignment = .fill
        SV.translatesAutoresizingMaskIntoConstraints = false
        SV.distribution = .fillEqually
        addSubview(SV)
        
        NSLayoutConstraint.activate([
            SV.topAnchor.constraint(equalTo: topAnchor),
            SV.bottomAnchor.constraint(equalTo: bottomAnchor),
            SV.trailingAnchor.constraint(equalTo: trailingAnchor),
            SV.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    //if FILL_EQUALLY = false
    private func SET_FRAME_FOR_BUTTON_AT(INDEX: Int) -> CGRect {
        
        var FRAME = CGRect.zero
        
        //1 identify the height of each button
        let BTN_HEIGHT = (bounds.height - PADDING * 2)
        //2 set it's height for circle/square look and centered position Y
        let BTN_WIDTH = BTN_HEIGHT
        let THUMB_VIEW_POSITION_Y = (bounds.height - BTN_HEIGHT) / 2

        //set first and last elements origin x
        let FIRST_ELEMENT_POSITION_X = self.PADDING
        let LAST_ELEMENT_POSITION_X = bounds.width - THUMB_VIEW.frame.width - PADDING
        //MARK Start here to modify the ITEMS from the second until the one before the last
        //the area where the THUMB_VIEW is contained
        let THUMB_VIEW_AREA_TOTAL_WIDTH = bounds.width / CGFloat(BTNS.count)
        //startingPoint based on x position multiplier
        let STARTING_POINT_AT_INDEX = THUMB_VIEW_AREA_TOTAL_WIDTH *  CGFloat(INDEX)
        //the remaining space of a selectorArea based on selector width
        let ORIGIN_X_FOR_NEXT_ITEM = (THUMB_VIEW_AREA_TOTAL_WIDTH - THUMB_VIEW.bounds.width) / 2
        //dynamically change the origin x of the ITEMS between 0 and lastItem
        let SELECTED_START_POSITION_FOR_NOT_EQUALLY_FILL = STARTING_POINT_AT_INDEX + ORIGIN_X_FOR_NEXT_ITEM
        
        if INDEX == 0 {
            FRAME = CGRect(x: FIRST_ELEMENT_POSITION_X, y: THUMB_VIEW_POSITION_Y, width: BTN_WIDTH, height: BTN_HEIGHT)
        } else if INDEX == BTNS.count - 1 {
            FRAME = CGRect(x: LAST_ELEMENT_POSITION_X, y: THUMB_VIEW_POSITION_Y, width: BTN_WIDTH, height: BTN_HEIGHT)
        } else {
            FRAME = CGRect(x: SELECTED_START_POSITION_FOR_NOT_EQUALLY_FILL, y: THUMB_VIEW_POSITION_Y, width: BTN_WIDTH, height: BTN_HEIGHT)
        }
        return FRAME
    }
    
    //called if boolean for text is true
    private func SET_BUTTON_WIDH_TEXT() {
        
        guard self.BTN_TITLES.count != 0 else { return }
        
        for BTN_TITLE in BTN_TITLES {
            let BTN = UIButton(type: .system)
            BTN.setTitle(BTN_TITLE, for: .normal)
            BTN.titleLabel?.font = TITLES_FONT
            BTN.setTitleColor(TEXT_COLOR, for: .normal)
            BTN.addTarget(self, action: #selector(BUTTON_TAP(BUTTON:)), for: .touchUpInside)
            BTNS.append(BTN)
            //set the one that we want to show as selected by default
        }
        BTNS[SELECTED_SEGMENT_INDEX].setTitleColor(SELECTED_TEXT_COLOR, for: .normal)
    }
    
    //called if boolean for text is false
    private func SET_BTNS_WITH_IMAGES() {
        
        guard self.BTN_IMAGES.count != 0 else { return }

        for BTN_IMAGE in self.BTN_IMAGES {
            
            var BTN: UIButton?
            if !BTNS_WITH_DYNAMIC_IMAGES {
                BTN = UIButton(type: .system)
                BTN?.tintColor = BTN_COLOR_FOR_NORMAL
            } else {
                BTN = UIButton(type: .custom)
            }
            BTN?.setImage(BTN_IMAGE, for: .normal)
            BTN?.imageEdgeInsets = PAGE_MENU.IMAGE_INSETS
            BTN?.addTarget(self, action: #selector(BUTTON_TAP(BUTTON:)), for: .touchUpInside)
            BTNS.append(BTN!)
        }
        if !BTNS_WITH_DYNAMIC_IMAGES {
            BTNS[SELECTED_SEGMENT_INDEX].tintColor = BTN_COLOR_FOR_SELECTED
        }
    }
    
    //called if boolean for dynamic colors in BTNS is true
    private func SET_BTNS_WITH_DYNAMIC_COLORS() {
        
        guard self.BTN_COLORS.count != 0 else { return }
        
        for BTN_COLOR in self.BTN_COLORS {
            let BTN = UIButton(type: .system)
            BTN.tintColor = BTN_COLOR
            if let IMAGE = self.IMAGE_FOR_ITEM_WITH_DYNAMIC_COLORS {
                BTN.setImage(IMAGE, for: .normal)
            }
            BTN.imageEdgeInsets = PAGE_MENU.IMAGE_INSETS
            BTN.addTarget(self, action: #selector(BUTTON_TAP(BUTTON:)), for: .touchUpInside)
            BTNS.append(BTN)
        }
    }
}

//MARK: ACTIONS WHEN ITEM IS SELECTED IT HANDLES: ACTION - APPEREANCE - TRANSLATION
extension PAGE_MENU {
    
    //MARK: MAIN ACTION: .valueChanged
    fileprivate func PERFORM_ACTION() {
        sendActions(for: .valueChanged)
    }
    
    //MARK: CHANGING APPEREANCE OF BUTTON ON TAP
    @objc fileprivate func BUTTON_TAP(BUTTON: UIButton) {
        
        for (INDEX, BTN) in self.BTNS.enumerated() {
            
            BTN.setTitleColor(TEXT_COLOR, for: .normal)
            if !ITEMS_WITH_DYNAMIC_COLOR {
                if !BTNS_WITH_DYNAMIC_IMAGES {
                    BTN.tintColor = BTN_COLOR_FOR_NORMAL
                }
            }
            if BTN == BUTTON {
                SELECTED_SEGMENT_INDEX = INDEX
                FILL_EQUALLY ?  MOVE_THUMB_VIEW(at: INDEX) : MOVE_THUMB_VIEW_FILL_EQUALLY_FALSE(at: INDEX)
                BTN.setTitleColor(SELECTED_TEXT_COLOR, for: .normal)
                if !ITEMS_WITH_DYNAMIC_COLOR {
                    if !BTNS_WITH_DYNAMIC_IMAGES {
                        BTN.tintColor = BTN_COLOR_FOR_SELECTED
                    }
                }
            }
        }
        self.PERFORM_ACTION()
    }
    
    //MARK: TRANSLATION OF THUMB_VIEW WITH ANIMATION ON TAP
    
    //Movement of THUMB_VIEW if FILL_EQUALLY = true
    fileprivate func MOVE_THUMB_VIEW(at INDEX: Int) {
        
        let SELECTED_START_POSITION = INDEX == 0 ? self.PADDING : bounds.width / CGFloat(BTNS.count) *  CGFloat(INDEX) + self.PADDING
        UIView.animate(withDuration: TimeInterval(self.ANIMATION_DURATION), animations: {
            self.THUMB_VIEW.frame.origin.x = SELECTED_START_POSITION
        })
    }
    
    //Movement of THUMB_VIEW if FILL_EQUALLY = false
    fileprivate func MOVE_THUMB_VIEW_FILL_EQUALLY_FALSE(at INDEX: Int) {
        
        let FIRST_ELEMENT_POSITION_X = self.PADDING
        let LAST_ELEMENT_POSITION_X = bounds.width - THUMB_VIEW.frame.width - PADDING
        
        //the area where the selector is contained
        let SELECTOR_AREA_TOTAL_WIDTH = bounds.width / CGFloat(BTNS.count)
        //startingPoint based on x position multiplier
        let STARTING_POINT_AT_INDEX = SELECTOR_AREA_TOTAL_WIDTH *  CGFloat(INDEX)
        //the remaining space of a selectorArea based on selector width
        let ORIGIN_X_FOR_NEXT_ITEM = (SELECTOR_AREA_TOTAL_WIDTH - THUMB_VIEW.bounds.width) / 2
        //dynamically change the origin x of the ITEMS between 0 and lastItem
        let SELECTED_START_POSITION_FOR_NOT_EQUALLY_FILL = STARTING_POINT_AT_INDEX + ORIGIN_X_FOR_NEXT_ITEM
        
        UIView.animate(withDuration: TimeInterval(self.ANIMATION_DURATION), animations: {
            
            if INDEX == 0 {
                self.THUMB_VIEW.frame.origin.x = FIRST_ELEMENT_POSITION_X
            } else if INDEX == self.BTNS.count - 1 {
                self.THUMB_VIEW.frame.origin.x = LAST_ELEMENT_POSITION_X
            } else {
                self.THUMB_VIEW.frame.origin.x = SELECTED_START_POSITION_FOR_NOT_EQUALLY_FILL
            }
        })
    }
}


























