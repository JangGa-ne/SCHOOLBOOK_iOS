//
//  SEARCH.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/07/21.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

// 검색
class SEARCH_TC: UITableViewCell {
    
    @IBOutlet weak var SC_NAME: UILabel!
    
    @IBOutlet weak var PROFILE_IMAGE: UIImageView!
    @IBOutlet weak var NAME_1: UILabel!
    @IBOutlet weak var NAME_2: UILabel!
}

class SEARCH: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    let MENU_1 = ["전체", "성명", "기관명", "휴대전화", "사무실전화", "업무"]
    let MENU_2 = ["전체", "성명", "기관명", "사무실전화", "업무"]
    
    let MENU_TYPE_1 = ["all", "bk_name", "sc_name", "bk_hp", "mb_phone", "mb_role"]
    let MENU_TYPE_2 = ["all", "bk_name", "sc_name", "mb_phone", "mb_role"]
    
    var MENU_POSITION = 0
    
    var SEARCH_API: [SEARCH_DATA] = []
    var PICKER_VIEW = UIPickerView()
    
    @IBOutlet weak var TITLE_LABEL: UILabel!                // 타이틀
    @IBOutlet weak var TITLE_VIEW_BG: UIView!               // 타이틀_배경_18:9
    @IBOutlet weak var TITLE_NAME_BG: UILabel!              // 타이틀_18:9
    
    @IBOutlet weak var TABLE_VIEW: UITableView!             // 테이블_뷰
    @IBOutlet weak var HEADER_VIEW: UIView!                 // 헤더_뷰
    @IBOutlet weak var TITLE_VIEW: UIView!                  // 테이블_타이틀_배경_18:9
    @IBOutlet weak var TITLE_NAME: UILabel!                 // 테이블_타이틀_18:9
    
    @IBOutlet weak var SEARCH_OPTION: UITextField!          // 테이블_검색_선택항목
    @IBOutlet weak var SEARCH: UITextField!                 // 테이블_검색

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NAVI
        if DEVICE_RATIO() == "Ratio 16:9" {
            TITLE_LABEL.alpha = 1.0
            TITLE_VIEW_BG.isHidden = true
            TITLE_VIEW.isHidden = true
            HEADER_VIEW.frame.size.height = 58.0
        } else {
            TITLE_LABEL.alpha = 0.0
            TITLE_VIEW_BG.isHidden = false
            TITLE_VIEW.isHidden = false
            HEADER_VIEW.frame.size.height = 100.0
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // 검색_선택항목
        PICKER_VIEW.delegate = self
        PICKER_VIEW.dataSource = self
        SEARCH_OPTION.inputView = PICKER_VIEW
        SEARCH_OPTION.layer.cornerRadius = 5.0
        SEARCH_OPTION.clipsToBounds = true
        SEARCH_OPTION.backgroundColor = .GRAY_COLOR
        TOOL_BAR_DONE(TEXT_FILELD: SEARCH_OPTION)
        SEARCH_OPTION.LEFT_PADDING(PADDING_LIFT: 5.0)
        SEARCH_TYPE()
        // 검색
        SEARCH.layer.borderColor = UIColor.init(white: 1.0, alpha: 0.1).cgColor
        SEARCH.layer.borderWidth = 1.0
        SEARCH.layer.cornerRadius = 5.0
        SEARCH.clipsToBounds = true
        PLACEHOLDER(TEXT_FILELD: SEARCH, PLACEHOLDER: "검색어를 입력해주세요", WHITE: 1.0)
        TOOL_BAR_DONE(TEXT_FILELD: SEARCH)
        // 테이블_뷰
        TABLE_VIEW.delegate = self
        TABLE_VIEW.dataSource = self
        TABLE_VIEW.backgroundColor = .white
        TABLE_VIEW.separatorStyle = .none
    }
    
    func SEARCH_TYPE() {
        
        let DROP_DOWN_IMAGE = UIImageView(frame: CGRect(x: 75.0, y: 12.0, width: 5.0, height: 10.0))
        DROP_DOWN_IMAGE.image = UIImage(named: "next_button_black.png")
        DROP_DOWN_IMAGE.transform = DROP_DOWN_IMAGE.transform.rotated(by: .pi / 2)
        
        SEARCH_OPTION.addSubview(DROP_DOWN_IMAGE)
    }
    
    @IBAction func SEARCH_BTN(_ sender: UIButton) {
        // 통신
        if SEARCH.text == "" {
            NOTIFICATION_VIEW("검색어를 입력해주세요")
        } else {
            if !SYSTEM_NETWORK_CHECKING() {
                NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
            } else {
                HTTP_SEARCH()
            }
        }
    }
    
    // 통신
    func HTTP_SEARCH() {
        
        var PARAMETERS: Parameters = [
            "action_type": "search",
            "search_word": SEARCH.text!
        ]
        
        if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
            PARAMETERS["search_type"] = MENU_TYPE_1[MENU_POSITION]
        } else {
            PARAMETERS["search_type"] = MENU_TYPE_2[MENU_POSITION]
        }
        
        print("검색 파라미터: \(PARAMETERS)")
        
        let BASE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().BASE_URL)
        
        Alamofire.request(BASE_URL, method: .post, parameters: PARAMETERS).responseJSON { response in
            
            print("[검색]", response)
            self.SEARCH_API.removeAll()
            
            guard let SEARCH_ARRAY = response.result.value as? Array<Any> else {
                print("[검색] FAIL")
                self.SEARCH_API.removeAll()
                self.TABLE_VIEW.reloadData()
                return
            }
            
            for (_, DATA) in SEARCH_ARRAY.enumerated() {
                
                let PUT_DATA = SEARCH_DATA()
                
                let DATADICT = DATA as? [String: Any]
                
                if DATADICT?["edubook_display"] as? String ?? "N" == "Y" {
                    
                    PUT_DATA.SET_AP_SMS(AP_SMS: DATADICT?["ap_sms"] as Any)
                    PUT_DATA.SET_BG_NAME(BG_NAME: DATADICT?["bg_name"] as Any)
                    PUT_DATA.SET_BG_NO(BG_NO: DATADICT?["bg_no"] as Any)
                    PUT_DATA.SET_BK_GRADE(BK_GRADE: DATADICT?["bk_grade"] as Any)
                    PUT_DATA.SET_BK_GRADE_CODE(BK_GRADE_CODE: DATADICT?["bk_grade_code"] as Any)
                    PUT_DATA.SET_BK_HP(BK_HP: DATADICT?["bk_hp"] as Any)
                    PUT_DATA.SET_BK_NAME(BK_NAME: DATADICT?["bk_name"] as Any)
                    PUT_DATA.SET_BK_NO(BK_NO: DATADICT?["bk_no"] as Any)
                    PUT_DATA.SET_BOOK_CODE(BOOK_CODE: DATADICT?["book_code"] as Any)
                    PUT_DATA.SET_BOOK_CODE2(BOOK_CODE2: DATADICT?["book_code2"] as Any)
                    PUT_DATA.SET_BOOK_TYPE(BOOK_TYPE: DATADICT?["book_type"] as Any)
                    PUT_DATA.SET_EDUBOOK_DISPLAY(EDUBOOK_DISPLAY: DATADICT?["edubook_display"] as Any)
                    PUT_DATA.SET_EDUBOOK_GRADE(EDUBOOK_GRADE: DATADICT?["edubook_grade"] as Any)
                    PUT_DATA.SET_EDUBOOK_GRADE2(EDUBOOK_GRADE2: DATADICT?["edubook_group2"] as Any)
                    PUT_DATA.SET_EDUBOOK_GROUP(EDUBOOK_GROUP: DATADICT?["edubook_group"] as Any)
                    PUT_DATA.SET_EDUBOOK_GROUP2(EDUBOOK_GROUP2: DATADICT?["edubook_group2"] as Any)
                    PUT_DATA.SET_FCM_KEY(FCM_KEY: DATADICT?["fcm_key"] as Any)
                    PUT_DATA.SET_INFO_PROV(INFO_PROV: DATADICT?["info_prov"] as Any)
                    PUT_DATA.SET_LIST_TYPE(LIST_TYPE: DATADICT?["list_type"] as Any)
                    PUT_DATA.SET_MB_CLASS(MB_CLASS: DATADICT?["mb_class"] as Any)
                    PUT_DATA.SET_MB_FILE(MB_FILE: DATADICT?["mb_file"] as Any)
                    PUT_DATA.SET_MB_GRADE(MB_GRADE: DATADICT?["mb_grade"] as Any)
                    PUT_DATA.SET_MB_ID(MB_ID: DATADICT?["mb_id"] as Any)
                    PUT_DATA.SET_MB_LEVEL(MB_LEVEL: DATADICT?["mb_level"] as Any)
                    PUT_DATA.SET_MB_LOGIN_IP(MB_LOGIN_IP: DATADICT?["mb_login_ip"] as Any)
                    PUT_DATA.SET_MB_PASSWORD(MB_PASSWORD: DATADICT?["mb_password"] as Any)
                    PUT_DATA.SET_MB_PHONE(MB_PHONE: DATADICT?["mb_phone"] as Any)
                    PUT_DATA.SET_MB_ROLE(MB_ROLE: DATADICT?["mb_role"] as Any)
                    PUT_DATA.SET_MB_ROLE2(MB_ROLE2: DATADICT?["mb_role2"] as Any)
                    PUT_DATA.SET_MB_TODAY_LOGIN(MB_TODAY_LOGIN: DATADICT?["mb_today_login"] as Any)
                    PUT_DATA.SET_MB_TYPE(MB_TYPE: DATADICT?["mb_type"] as Any)
                    PUT_DATA.SET_NEIS_CODE(NEIS_CODE: DATADICT?["neis_code"] as Any)
                    PUT_DATA.SET_ORDER_LIST(ORDER_LIST: DATADICT?["order_list"] as Any)
                    PUT_DATA.SET_REG_DATE(REG_DATE: DATADICT?["reg_date"] as Any)
                    PUT_DATA.SET_S_IDX(S_IDX: DATADICT?["s_idx"] as Any)
                    PUT_DATA.SET_SAFE_NUMBER(SAFE_NUMBER: DATADICT?["safe_number"] as Any)
                    PUT_DATA.SET_SC_CODE(SC_CODE: DATADICT?["sc_code"] as Any)
                    PUT_DATA.SET_SC_GRADE(SC_GRADE: DATADICT?["sc_grade"] as Any)
                    PUT_DATA.SET_SC_GRADE_NAME(SC_GRADE_NAME: DATADICT?["sc_grade_name"] as Any)
                    PUT_DATA.SET_SC_GROUP(SC_GROUP: DATADICT?["sc_group"] as Any)
                    PUT_DATA.SET_SC_GROUP_NAME(SC_GROUP_NAME: DATADICT?["sc_group_name"] as Any)
                    PUT_DATA.SET_SC_LOCATION(SC_LOCATION: DATADICT?["sc_location"] as Any)
                    PUT_DATA.SET_SC_NAME(SC_NAME: DATADICT?["sc_name"] as Any)
                    PUT_DATA.SET_UPPER_CODE(UPPER_CODE: DATADICT?["upper_code"] as Any)
                    
                    self.SEARCH_API.append(PUT_DATA)
                }
            }
            
            self.TABLE_VIEW.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if DEVICE_RATIO() == "Ratio 18:9" { SCROLL_EDIT_T(TABLE_VIEW: TABLE_VIEW, NAVI_TITLE: TITLE_LABEL) }
    }
}

extension SEARCH: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
            return MENU_1.count
        } else {
            return MENU_2.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        MENU_POSITION = row
        
        if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
            if row == 3 || row == 4 { SEARCH.keyboardType = .numberPad } else { SEARCH.keyboardType = .default }
            return MENU_1[row]
        } else {
            if row == 3 { SEARCH.keyboardType = .numberPad } else { SEARCH.keyboardType = .default }
            return MENU_2[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        MENU_POSITION = row
        
        if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
            SEARCH_OPTION.text = MENU_1[row]
        } else {
            SEARCH_OPTION.text = MENU_2[row]
        }
    }
}

extension SEARCH: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SEARCH_API.count == 0 {
            TABLE_VIEW.bounces = false
            TABLE_VIEW.backgroundColor = .clear
            return 0
        } else {
            TABLE_VIEW.bounces = true
            TABLE_VIEW.backgroundColor = .white
            return SEARCH_API.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = SEARCH_API[indexPath.item]
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "SEARCH_TC", for: indexPath) as! SEARCH_TC
        
        // 이미지
        CELL.PROFILE_IMAGE.layer.cornerRadius = 25.0
        CELL.PROFILE_IMAGE.clipsToBounds = true
        if DATA.LIST_TYPE == "fa_list" {
            let IMAGE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().SCHOOL_LOGO_URL) + DATA.SC_CODE
            let KOREAN_URL = IMAGE_URL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            NUKE_IMAGE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: UIImage(named: "busanlogo.png")!, PROFILE: CELL.PROFILE_IMAGE, FRAME_SIZE: CELL.PROFILE_IMAGE.frame.size)
        } else if DATA.LIST_TYPE == "person_list" && DATA.MB_FILE != "" {
            if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
                let IMAGE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().PROFILE_IMAGE_URL) + DATA.MB_FILE
                let KOREAN_URL = IMAGE_URL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                NUKE_IMAGE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: UIImage(named: "busanlogo.png")!, PROFILE: CELL.PROFILE_IMAGE, FRAME_SIZE: CELL.PROFILE_IMAGE.frame.size)
            } else {
                CELL.PROFILE_IMAGE.image = UIImage(named: "busanlogo.png")
            }
        } else {
            CELL.PROFILE_IMAGE.image = UIImage(named: "busanlogo.png")
        }
        // 기관 또는 이름
        if DATA.LIST_TYPE == "fa_list" {
            CELL.NAME_1.text = DATA.SC_NAME
            CELL.NAME_2.isHidden = true
        } else {
            CELL.NAME_1.text = DATA.BK_NAME
            CELL.NAME_2.isHidden = false
            if DATA.SC_NAME == "" {
                CELL.NAME_2.text = DATA.EDUBOOK_GRADE
            } else {
                CELL.NAME_2.text = "\(DATA.SC_NAME) \(DATA.EDUBOOK_GRADE)"
            }
        }
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let DATA = SEARCH_API[indexPath.item]
        
        if DATA.LIST_TYPE == "person_list" && DATA.BK_NO != "" {

            let VC = self.storyboard?.instantiateViewController(withIdentifier: "DETAIL_INFO") as! DETAIL_INFO
            VC.modalTransitionStyle = .crossDissolve
            VC.BK_NO = DATA.BK_NO
            present(VC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
