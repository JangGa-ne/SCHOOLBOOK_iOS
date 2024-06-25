//
//  MENU.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/08/14.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit

enum MENU_TYPE: Int {
    case CONTACT
    case SCHOOL_INFO
    case HOME
    case INDIVIDUAL_CONTACT
    case SOSIK_N
    case LOGIN
}

class MENU: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var DID_TAP_MENU_TYPE: ((MENU_TYPE) -> Void)?
    
    @IBAction func BACK(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    // 조직도
    @IBOutlet weak var CONTACT_VC: UIButton!
    @IBAction func CONTACT_VC(_ sender: UIButton) {
        
        guard let MENU_TYPE_ = MENU_TYPE(rawValue: 0) else { return }
        dismiss(animated: true) { [weak self] in self?.DID_TAP_MENU_TYPE?(MENU_TYPE_) }
    }
    // 학교정보
    @IBOutlet weak var SCHOOL_INFO_VC: UIButton!
    @IBAction func SCHOOL_INFO_VC(_ sender: UIButton) {
        
        guard let MENU_TYPE_ = MENU_TYPE(rawValue: 1) else { return }
        dismiss(animated: true) { [weak self] in self?.DID_TAP_MENU_TYPE?(MENU_TYPE_) }
    }
    // 다이얼
    @IBOutlet weak var HOME_VC: UIButton!
    @IBAction func HOME_VC(_ sender: UIButton) {
        
        guard let MENU_TYPE_ = MENU_TYPE(rawValue: 2) else { return }
        dismiss(animated: true) { [weak self] in self?.DID_TAP_MENU_TYPE?(MENU_TYPE_) }
    }
    // 개인주소록
    @IBOutlet weak var INDIVIDUAL_CONTACT_VC: UIButton!
    @IBAction func INDIVIDUAL_CONTACT_VC(_ sender: UIButton) {
        
        guard let MENU_TYPE_ = MENU_TYPE(rawValue: 3) else { return }
        dismiss(animated: true) { [weak self] in self?.DID_TAP_MENU_TYPE?(MENU_TYPE_) }
    }
    // 공지사항
    @IBOutlet weak var SOSIK_N_VC: UIButton!
    @IBAction func SOSIK_N_VC(_ sender: UIButton) {
        
        guard let MENU_TYPE_ = MENU_TYPE(rawValue: 4) else { return }
        dismiss(animated: true) { [weak self] in self?.DID_TAP_MENU_TYPE?(MENU_TYPE_) }
    }
    // 로그인
    @IBOutlet weak var LOGIN_VC: UIButton!
    @IBAction func LOGIN_VC(_ sender: UIButton) {
        
        guard let MENU_TYPE_ = MENU_TYPE(rawValue: 5) else { return }
        dismiss(animated: true) { [weak self] in self?.DID_TAP_MENU_TYPE?(MENU_TYPE_) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" == "" {
            
            LOGIN_VC.setTitle("로그인", for: .normal)
            LOGIN_VC.setTitleColor(.black, for: .normal)
        } else {
            
            LOGIN_VC.setTitle("로그아웃", for: .normal)
            LOGIN_VC.setTitleColor(.red, for: .normal)
        }
    }
}
