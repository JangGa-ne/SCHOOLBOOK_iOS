//
//  CONTACT_DETAIL.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/07/24.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class CONTACT_DETAIL_TC: UITableViewCell {
    
    @IBOutlet weak var PROFILE_IMAGE: UIImageView!
    @IBOutlet weak var NAME_1: UILabel!
    @IBOutlet weak var NAME_2: UILabel!
}

class CONTACT_DETAIL: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) {
        
        if UPPER_CODE[UPPER_POSITION] == "TOP" {
            dismiss(animated: true, completion: nil)
        } else {
            HTTP_CONTACT_DETAIL(ACTION_TYPE: ACTION_TYPE, SC_CODE: UPPER_CODE[UPPER_POSITION], CAN_WRITE: CAN_WRITE)
            UPPER_POSITION -= 1
            UPPER_CODE.remove(at: UPPER_CODE.count - 1)
            
            TITLE_LABEL.text = UPPER_NAME[UPPER_POSITION]
            TITLE_NAME_BG.text = UPPER_NAME[UPPER_POSITION]
            TITLE_NAME.text = UPPER_NAME[UPPER_POSITION]
            UPPER_NAME.remove(at: UPPER_NAME.count - 1)
        }
    }
    
    var CONTACT_API: [CONTACT_DATA] = []
    
    var ACTION_TYPE: String = ""
    var SC_CODE: String = ""
    var CAN_WRITE: String = ""
    var SC_NAME: String = ""
    var UPPER_CODE: [String] = ["TOP"]
    var UPPER_NAME: [String] = []
    var UPPER_POSITION: Int = 0
    
    @IBOutlet weak var TITLE_LABEL: UILabel!                // 타이틀
    @IBOutlet weak var TITLE_VIEW_BG: UIView!               // 타이틀_배경_18:9
    @IBOutlet weak var TITLE_NAME_BG: UILabel!              // 타이틀_18:9
    
    @IBOutlet weak var TABLE_VIEW: UITableView!             // 테이블_뷰
    @IBOutlet weak var HEADER_VIEW: UIView!                 // 헤더_뷰
    @IBOutlet weak var TITLE_VIEW: UIView!                  // 테이블_타이틀_배경_18:9
    @IBOutlet weak var TITLE_NAME: UILabel!                 // 테이블_타이틀_18:9

    // 검색
    @IBAction func SEARCH_VC(_ sender: UIButton) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SEARCH") as! SEARCH
        VC.modalTransitionStyle = .crossDissolve
        present(VC, animated: true)
    }
    
    // 로딩인디케이터
    let VIEW = UIView()
    override func loadView() {
        super.loadView()
        
        EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 타이틀
        if SC_NAME == "" {
            TITLE_LABEL.text = "조직도"
            TITLE_NAME_BG.text = "조직도"
            TITLE_NAME.text = "조직도"
            UPPER_NAME.append("조직도")
        } else {
            TITLE_LABEL.text = SC_NAME
            TITLE_NAME_BG.text = SC_NAME
            TITLE_NAME.text = SC_NAME
            UPPER_NAME.append(SC_NAME)
        }
        // NAVI
        DEVICE_TITLE(TITLE_LABEL: TITLE_LABEL, TITLE_VIEW_BG: TITLE_VIEW_BG, TITLE_VIEW: HEADER_VIEW, HEIGHT: 52.0)
        // 통신
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            HTTP_CONTACT_DETAIL(ACTION_TYPE: ACTION_TYPE, SC_CODE: SC_CODE, CAN_WRITE: CAN_WRITE)
        }
        // 테이블_뷰
        TABLE_VIEW.delegate = self
        TABLE_VIEW.dataSource = self
        TABLE_VIEW.backgroundColor = .white
    }
    
    // 통신
    func HTTP_CONTACT_DETAIL(ACTION_TYPE: String, SC_CODE: String, CAN_WRITE: String) {
        
        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
            "sc_code": SC_CODE,
            "can_write": CAN_WRITE
        ]
        
        print("주소록 파라미터: \(PARAMETERS)")
        
        let BASE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().BASE_URL)
        
        Alamofire.request(BASE_URL, method: .post, parameters: PARAMETERS).responseJSON { response in
            
//            print("[주소록]", response)
            self.CONTACT_API.removeAll()
            
            guard let DATA_ARRAY = response.result.value as? Array<Any> else {
                print("[주소록] FAIL")
                self.CONTACT_API.removeAll()
                self.TABLE_VIEW.reloadData()
                return
            }
            
            for (_, DATA) in DATA_ARRAY.enumerated() {
                
                let DATADICT = DATA as? [String: Any]
                
                let PUT_DATA = CONTACT_DATA()
                
                if DATADICT?["list_type"] as? String ?? "" == "fa_list" || DATADICT?["edubook_display"] as? String ?? "N" == "Y" {
                    
                    PUT_DATA.SET_BOOK_CODE(BOOK_CODE: DATADICT?["book_code"] as Any)
                    PUT_DATA.SET_CAN_WRITE(CAN_WRITE: DATADICT?["can_write"] as Any)
                    PUT_DATA.SET_DEPTH(DEPTH: DATADICT?["depth"] as Any)
                    PUT_DATA.SET_IDX(IDX: DATADICT?["idx"] as Any)
                    PUT_DATA.SET_ORDER_LIST(ORDER_LIST: DATADICT?["order_list"] as Any)
                    PUT_DATA.SET_S_IDX(S_IDX: DATADICT?["s_idx"] as Any)
                    PUT_DATA.SET_SC_CODE(SC_CODE: DATADICT?["sc_code"] as Any)
                    PUT_DATA.SET_SC_GRADE(SC_GRADE: DATADICT?["sc_grade"] as Any)
                    PUT_DATA.SET_SC_GROUP(SC_GROUP: DATADICT?["sc_group"] as Any)
                    PUT_DATA.SET_SC_LOCATION(SC_LOCATION: DATADICT?["sc_location"] as Any)
                    PUT_DATA.SET_SC_NAME(SC_NAME: DATADICT?["sc_name"] as Any)
                    PUT_DATA.SET_UPPER_CODE(UPPER_CODE: DATADICT?["upper_code"] as Any)
                    
                    PUT_DATA.SET_AP_SMS(AP_SMS: DATADICT?["ap_sms"] as Any)
                    PUT_DATA.SET_BG_NAME(BG_NAME: DATADICT?["bg_name"] as Any)
                    PUT_DATA.SET_BG_NO(BG_NO: DATADICT?["bg_no"] as Any)
                    PUT_DATA.SET_BK_GRADE(BK_GRADE: DATADICT?["bk_grade"] as Any)
                    PUT_DATA.SET_BK_GRADE_CODE(BK_GRADE_CODE: DATADICT?["bk_grade_code"] as Any)
                    PUT_DATA.SET_BK_HP(BK_HP: DATADICT?["bk_hp"] as Any)
                    PUT_DATA.SET_BK_NAME(BK_NAME: DATADICT?["bk_name"] as Any)
                    PUT_DATA.SET_BK_NO(BK_NO: DATADICT?["bk_no"] as Any)
    //                PUT_DATA.SET_BOOK_CODE(BOOK_CODE: DATADICT?["book_code"] as Any)
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
    //                PUT_DATA.SET_ORDER_LIST(ORDER_LIST: DATADICT?["order_list"] as Any)
                    PUT_DATA.SET_REG_DATE(REG_DATE: DATADICT?["reg_date"] as Any)
    //                PUT_DATA.SET_S_IDX(S_IDX: DATADICT?["s_idx"] as Any)
                    PUT_DATA.SET_SAFE_NUMBER(SAFE_NUMBER: DATADICT?["safe_number"] as Any)
    //                PUT_DATA.SET_SC_CODE(SC_CODE: DATADICT?["sc_code"] as Any)
    //                PUT_DATA.SET_SC_GRADE(SC_GRADE: DATADICT?["sc_grade"] as Any)
                    PUT_DATA.SET_SC_GRADE_NAME(SC_GRADE_NAME: DATADICT?["sc_grade_name"] as Any)
    //                PUT_DATA.SET_SC_GROUP(SC_GROUP: DATADICT?["sc_group"] as Any)
                    PUT_DATA.SET_SC_GROUP_NAME(SC_GROUP_NAME: DATADICT?["sc_group_name"] as Any)
    //                PUT_DATA.SET_SC_LOCATION(SC_LOCATION: DATADICT?["sc_location"] as Any)
    //                PUT_DATA.SET_SC_NAME(SC_NAME: DATADICT?["sc_name"] as Any)
    //                PUT_DATA.SET_UPPER_CODE(UPPER_CODE: DATADICT?["upper_code"] as Any)
                    
                    self.CONTACT_API.append(PUT_DATA)
                }
            }
            
            self.TABLE_VIEW.reloadData()
            self.EFFECT_INDICATOR_VIEW_HIDDEN(self.VIEW)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if DEVICE_RATIO() == "Ratio 18:9" { SCROLL_EDIT_T(TABLE_VIEW: TABLE_VIEW, NAVI_TITLE: TITLE_LABEL) }
    }
}

extension CONTACT_DETAIL: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CONTACT_API.count == 0 {
            TABLE_VIEW.isHidden = true
            return 0
        } else {
            TABLE_VIEW.isHidden = false
            return CONTACT_API.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = CONTACT_API[indexPath.item]
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "CONTACT_DETAIL_TC", for: indexPath) as! CONTACT_DETAIL_TC
        
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
        
        let DATA = CONTACT_API[indexPath.item]
        
        if DATA.LIST_TYPE == "fa_list" || DATA.CAN_WRITE == "Y" {
            
            UPPER_CODE.append(DATA.UPPER_CODE)
            UPPER_NAME.append(DATA.SC_NAME)
            UPPER_POSITION += 1
            
            TITLE_LABEL.text = DATA.SC_NAME
            TITLE_NAME_BG.text = DATA.SC_NAME
            TITLE_NAME.text = DATA.SC_NAME
            
            if !SYSTEM_NETWORK_CHECKING() {
                NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
            } else {
                HTTP_CONTACT_DETAIL(ACTION_TYPE: ACTION_TYPE, SC_CODE: DATA.BOOK_CODE, CAN_WRITE: DATA.CAN_WRITE)
            }
        } else if DATA.LIST_TYPE == "person_list" && DATA.BK_NO != "" {

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
