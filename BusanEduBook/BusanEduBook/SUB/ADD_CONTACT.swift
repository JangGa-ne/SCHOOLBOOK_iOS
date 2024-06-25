//
//  ADD_CONTACT.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/08/06.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

// 연락처 등록 및 수정 (처리완료)
class ADD_CONTACT: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var NEW: Bool = true
    
    var BG_NO: String = ""          // 
    var BK_NAME: String = ""        // 성명
    var BG_NAME: String = ""        // 그룹명
    var BK_HP: String = ""          // 전화번호
    var BK_NO: String = ""          //
    var BK_PHONE: String = ""       // 사무실_전화번호
    var MEMO: String = ""           // 메모
        
    var INDIVIDUAL_CONTACT_DETAIL_API: [INDIVIDUAL_CONTACT_DETAIL_DATA] = []
    var POSITION: Int = 0
    
    @IBOutlet weak var TITLE_LABEL: UILabel!
    @IBOutlet weak var TITLE_INFO: UILabel!
    @IBOutlet weak var TITLE_CONTENTS: UILabel!
    
    @IBOutlet weak var SCROLL_VIEW: UIScrollView!
    @IBOutlet weak var BK_NAME_EDIT: UITextField!       // 이름
    @IBOutlet weak var BK_HP_VIEW: UIView!
    @IBOutlet weak var BK_HP_EDIT: UITextField!         // 전화번호
    @IBOutlet weak var PLUS_BTN: UIButton!
    @IBAction func PLUS_BTN(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.PLUS_BTN.alpha = 0.0
            self.BK_PHONE_VIEW.isHidden = false
        })
    }
    @IBOutlet weak var BK_PHONE_VIEW: UIView!
    @IBOutlet weak var BK_PHONE_EDIT: UITextField!      // 사무실_전화번호
    @IBOutlet weak var MINUS_BTN: UIButton!
    @IBAction func MINUS_BTN(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.PLUS_BTN.alpha = 1.0
            self.BK_PHONE_VIEW.isHidden = true
            self.BK_PHONE_EDIT.text = ""
        })
    }
    @IBOutlet weak var GROUP_NAME_EDIT: UITextField!    // 그룹명
    @IBOutlet weak var MEMO_EDIT: UITextView!           // 메모
    
    var PICKER_VIEW = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        BK_HP_EDIT.delegate = self
        BK_PHONE_EDIT.delegate = self
        
        PLACEHOLDER(TEXT_FILELD: BK_NAME_EDIT, PLACEHOLDER: "이름", WHITE: 0.0)
        TOOL_BAR_DONE(TEXT_FILELD: BK_NAME_EDIT)
        PLACEHOLDER(TEXT_FILELD: BK_HP_EDIT, PLACEHOLDER: "전화번호", WHITE: 0.0)
        TOOL_BAR_DONE(TEXT_FILELD: BK_HP_EDIT)
        PLACEHOLDER(TEXT_FILELD: BK_PHONE_EDIT, PLACEHOLDER: "전화번호", WHITE: 0.0)
        TOOL_BAR_DONE(TEXT_FILELD: BK_PHONE_EDIT)
        PLACEHOLDER(TEXT_FILELD: GROUP_NAME_EDIT, PLACEHOLDER: "그룹명", WHITE: 0.0)
        TOOL_BAR_DONE(TEXT_FILELD: GROUP_NAME_EDIT)
        TOOL_BAR_DONE(TEXT_VIEW: MEMO_EDIT)
        
        if BK_PHONE == "" {
            PLUS_BTN.alpha = 1.0
            BK_PHONE_VIEW.isHidden = true
        } else {
            PLUS_BTN.alpha = 0.0
            BK_PHONE_VIEW.isHidden = false
        }
        
        BK_NAME_EDIT.text = BK_NAME
        if BK_HP.count <= 8 {
            BK_HP_EDIT.text = FORMAT(MASK: "XXXX-XXXX", PHONE: BK_HP)
        } else if BK_HP.count <= 10 {
            BK_HP_EDIT.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: BK_HP)
        } else if BK_HP.count <= 12 {
            BK_HP_EDIT.text = FORMAT(MASK: "XXX-XXXX-XXXXX", PHONE: BK_HP)
        } else {
            BK_HP_EDIT.text = BK_HP
        }
        if BK_PHONE.count <= 8 {
            BK_PHONE_EDIT.text = FORMAT(MASK: "XXXX-XXXX", PHONE: BK_PHONE)
        } else if BK_PHONE.count <= 10 {
            BK_PHONE_EDIT.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: BK_PHONE)
        } else if BK_PHONE.count <= 12 {
            BK_PHONE_EDIT.text = FORMAT(MASK: "XXX-XXXX-XXXXX", PHONE: BK_PHONE)
        } else {
            BK_PHONE_EDIT.text = BK_PHONE
        }
        GROUP_NAME_EDIT.text = BG_NAME
        MEMO_EDIT.text = MEMO
        
        if NEW == true {
            // 등록
            TITLE_LABEL.text = "새로운 연락처"
            TITLE_INFO.text = "연락처 추가"
            TITLE_CONTENTS.text = "연락처를 등록할 수 있습니다."
            SAVE.setTitle("등록", for: .normal)
        } else {
            // 수정
            TITLE_LABEL.text = "연락처 수정"
            TITLE_INFO.text = "연락처 수정"
            TITLE_CONTENTS.text = "연락처를 수정할 수 있습니다."
            SAVE.setTitle("수정", for: .normal)
        }
        // 피커_뷰
        PICKER_VIEW.delegate = self
        PICKER_VIEW.dataSource = self
        GROUP_NAME_EDIT.inputView = PICKER_VIEW
    }
    
    @IBOutlet weak var SAVE: UIButton!
    @IBAction func SAVE(_ sender: UIButton) {
        
        if BK_NAME_EDIT.text == "" || BK_HP_EDIT.text == "" || GROUP_NAME_EDIT.text == "" {
            
            NOTIFICATION_VIEW("미입력된 항목이 있습니다")
        } else {
            
            if NEW == true {
                // 등록
                if !SYSTEM_NETWORK_CHECKING() {
                    NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
                } else {
                    HTTP_CONTACT(ACTION_TYPE: "per_add")
                }
            } else {
                // 수정
                if !SYSTEM_NETWORK_CHECKING() {
                    NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
                } else {
                    HTTP_CONTACT(ACTION_TYPE: "per_update")
                }
            }
        }
    }
    
    func HTTP_CONTACT(ACTION_TYPE: String) {

        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
            "bg_no": BG_NO,
            "bk_name": BK_NAME_EDIT.text!,
            "bg_name": BG_NAME,
            "bk_hp": BK_HP_EDIT.text!.replacingOccurrences(of: "-", with: ""),
            "bk_no": BK_NO,
            "bk_phone": BK_PHONE_EDIT.text!.replacingOccurrences(of: "-", with: ""),
            "memo": MEMO_EDIT.text!,
            "mb_id": UIViewController.USER_DATA.string(forKey: "mb_id") ?? ""
        ]
        
        let BASE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().BASE_URL)

        Alamofire.upload(multipartFormData: { multipartFormData in

            for (KEY, VALUE) in PARAMETERS {

                print("KEY: \(KEY)", "VALUE: \(VALUE)")
                multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
            }
        }, to: BASE_URL) { (result) in

            switch result {
            case .success(let upload, _, _):

            upload.responseString { response in

                print("[연락처등록및수정]", response)
                
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "TAB_VC") as? UITabBarController
                VC!.modalTransitionStyle = .crossDissolve
                VC!.selectedIndex = 3
                self.present(VC!, animated: true)
            }
            case .failure(let encodingError):

                print(encodingError)
                break
            }
        }
    }
}

extension ADD_CONTACT: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API.count == 0 { return 0 } else { return UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API.count }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let DATA = UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API[row]
        
        GROUP_NAME_EDIT.text = DATA.BG_NAME
        BG_NAME = DATA.BG_NAME
        BG_NO = DATA.BG_NO
        
        return DATA.BG_NAME
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let DATA = UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API[row]
        
        POSITION = row
        GROUP_NAME_EDIT.text = DATA.BG_NAME
        BG_NAME = DATA.BG_NAME
        BG_NO = DATA.BG_NO
    }
}

extension ADD_CONTACT {
    
    // 텍스트 필드 글자 제한 및 하이픈
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == BK_HP_EDIT {
            
            if range.location <= 8 {
                BK_HP_EDIT.text = FORMAT(MASK: "XXXX-XXXX", PHONE: textField.text!)
            } else if range.location <= 11 {
                BK_HP_EDIT.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: textField.text!)
            } else if range.location <= 12 {
                BK_HP_EDIT.text = FORMAT(MASK: "XXX-XXXX-XXXX", PHONE: textField.text!)
            } else if range.location <= 13 {
                BK_HP_EDIT.text = FORMAT(MASK: "XXXX-XXXX-XXXX", PHONE: textField.text!)
            } else {
                BK_HP_EDIT.text = textField.text!
            }
        } else {
            
            if range.location <= 8 {
                BK_PHONE_EDIT.text = FORMAT(MASK: "XXXX-XXXX", PHONE: textField.text!)
            } else if range.location <= 11 {
                BK_PHONE_EDIT.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: textField.text!)
            } else if range.location <= 12 {
                BK_PHONE_EDIT.text = FORMAT(MASK: "XXX-XXXX-XXXX", PHONE: textField.text!)
            } else if range.location <= 13 {
                BK_PHONE_EDIT.text = FORMAT(MASK: "XXXX-XXXX-XXXX", PHONE: textField.text!)
            } else {
                BK_PHONE_EDIT.text = textField.text!
            }
        }
        return true
    }
}
