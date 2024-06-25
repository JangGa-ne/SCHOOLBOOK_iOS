//
//  SCHOOL_INFO.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/07/31.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class SCHOOL_INFO_TC: UITableViewCell {
    
    @IBOutlet weak var PROFILE_IMAGE: UIImageView!
    @IBOutlet weak var NAME_1: UILabel!
    @IBOutlet weak var NAME_2: UILabel!
}

// 학교정보
class SCHOOL_INFO: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let TRANSITION = SLIDE_IN_TRANSITION()
    @IBAction func MENU_VC(_ sender: UIButton) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "MENU") as! MENU
        VC.DID_TAP_MENU_TYPE = { MENU_TYPE in self.TAB_VC(IDENTIFIER: "TAB_VC", INDEX: MENU_TYPE.rawValue) }
        VC.modalPresentationStyle = .overCurrentContext
        VC.transitioningDelegate = self
        present(VC, animated: true)
    }
    
    var SCHOOL_INFO_API: [SCHOOL_INFO_DATA] = []
    
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
    
    // 메뉴
    @IBOutlet weak var MENU_VIEW: PAGE_MENU!
    @IBAction func MENU_VIEW(_ sender: PAGE_MENU) {
        
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            switch MENU_VIEW.SELECTED_SEGMENT_INDEX {
            case 0:
                EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
                HTTP_SCHOOL_INFO(ACTION_TYPE: "school_main", SC_GROUP: "", SC_GRADE: "", SC_NAME: "유치원")
            case 1:
                EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
                HTTP_SCHOOL_INFO(ACTION_TYPE: "school_main", SC_GROUP: "", SC_GRADE: "", SC_NAME: "초등학교")
            case 2:
                EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
                HTTP_SCHOOL_INFO(ACTION_TYPE: "school_main", SC_GROUP: "", SC_GRADE: "", SC_NAME: "중학교")
            case 3:
                EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
                HTTP_SCHOOL_INFO(ACTION_TYPE: "school_list", SC_GROUP: "busan", SC_GRADE: "4", SC_NAME: "고등학교")
            case 4:
                EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
                HTTP_SCHOOL_INFO(ACTION_TYPE: "school_list", SC_GROUP: "busan", SC_GRADE: "5", SC_NAME: "특수학교")
            default:
                break
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NAVI
        if DEVICE_RATIO() == "Ratio 16:9" {
            TITLE_LABEL.alpha = 1.0
            TITLE_VIEW_BG.isHidden = true
            TITLE_VIEW.isHidden = true
            HEADER_VIEW.frame.size.height = 50.0
        } else {
            TITLE_LABEL.alpha = 0.0
            TITLE_VIEW_BG.isHidden = false
            TITLE_VIEW.isHidden = false
            HEADER_VIEW.frame.size.height = 102.0
        }
        // 메뉴
        MENU_VIEW.ITEMS_WIDTH_TEXT = true
        MENU_VIEW.FILL_EQUALLY = true
        MENU_VIEW.BTN_LINE_THUMB_VIEW = true
        MENU_VIEW.SET_SEGMENTED_WITH(ITEMS: ["유치원", "초등학교", "중학교", "고등학교", "특수학교"])
        MENU_VIEW.PADDING = 0
        MENU_VIEW.TEXT_COLOR = .init(white: 0.0, alpha: 0.7)
        MENU_VIEW.SELECTED_TEXT_COLOR = .systemBlue
        MENU_VIEW.THUMB_VIEW_COLOR = .systemBlue
        MENU_VIEW.TITLES_FONT = .boldSystemFont(ofSize: 14)
        // 통신
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            HTTP_SCHOOL_INFO(ACTION_TYPE: "school_main", SC_GROUP: "", SC_GRADE: "", SC_NAME: "")
        }
        // 테이블_뷰
        TABLE_VIEW.delegate = self
        TABLE_VIEW.dataSource = self
        TABLE_VIEW.backgroundColor = .white
    }
    
    // 통신
    func HTTP_SCHOOL_INFO(ACTION_TYPE: String, SC_GROUP: String, SC_GRADE: String, SC_NAME: String) {
        
        let PARAMETER: Parameters = [
            "action_type": ACTION_TYPE,
            "sc_group": SC_GROUP,
            "sc_grade": SC_GRADE
        ]
        
        let BASE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().BASE_URL)
        
        Alamofire.request(BASE_URL, method: .post, parameters: PARAMETER).responseJSON { response in
            
            print("[학교정보] - \(SC_NAME)", response)
            self.SCHOOL_INFO_API.removeAll()
            
            guard let SCHOOL_ARRAY = response.result.value as? Array<Any> else {
                print("[학교정보] - \(SC_NAME) FAIL")
                self.SCHOOL_INFO_API.removeAll()
                self.TABLE_VIEW.reloadData()
                return
            }
            
            for (_, DATA) in SCHOOL_ARRAY.enumerated() {
                
                let DATADICT = DATA as? [String: Any]
                let DISPLAY = DATADICT?["display"] as? String ?? "N"
                
                if ACTION_TYPE == "school_main" || (ACTION_TYPE == "school_list" && DISPLAY == "Y") {
                    
                    let PUT_DATA = SCHOOL_INFO_DATA()
                    
                    PUT_DATA.SET_AP_CHUL(AP_CHUL: DATADICT?["ap_chul"] as Any)
                    PUT_DATA.SET_AP_DORM(AP_DORM: DATADICT?["ap_dorm"] as Any)
                    PUT_DATA.SET_AP_FOOD(AP_FOOD: DATADICT?["ap_food"] as Any)
                    PUT_DATA.SET_AP_MILE(AP_MILE: DATADICT?["ap_mile"] as Any)
                    PUT_DATA.SET_BG_NO(BG_NO: DATADICT?["bg_no"] as Any)
                    PUT_DATA.SET_BOOK_UPPER_CODE(BOOK_UPPER_CODE: DATADICT?["book_upper_code"] as Any)
                    PUT_DATA.SET_COUNT_EDUBOOK(COUNT_EDUBOOK: DATADICT?["count_edubook"] as Any)
                    PUT_DATA.SET_COUNT_ST(COUNT_ST: DATADICT?["count_st"] as Any)
                    PUT_DATA.SET_COUNT_TEACHER(COUNT_TEACHER: DATADICT?["count_teacher"] as Any)
                    PUT_DATA.SET_DATETIME(DATETIME: DATADICT?["datetime"] as Any)
                    PUT_DATA.SET_DISPLAY(DISPLAY: DATADICT?["display"] as Any)
                    PUT_DATA.SET_KA_BILL(KA_BILL: DATADICT?["ka_bill"] as Any)
                    PUT_DATA.SET_KA_MESSAGE(KA_MESSAGE: DATADICT?["ka_message"] as Any)
                    PUT_DATA.SET_KA_POINT(KA_POINT: DATADICT?["ka_point"] as Any)
                    PUT_DATA.SET_KA_POLL(KA_POLL: DATADICT?["ka_poll"] as Any)
                    PUT_DATA.SET_KA_SMS(KA_SMS: DATADICT?["ka_sms"] as Any)
                    PUT_DATA.SET_LAT(LAT: DATADICT?["lat"] as Any)
                    PUT_DATA.SET_LATE_POINT(LATE_POINT: DATADICT?["late_point"] as Any)
                    PUT_DATA.SET_LIST_TYPE(LIST_TYPE: DATADICT?["list_type"] as Any)
                    PUT_DATA.SET_LNG(LNG: DATADICT?["lng"] as Any)
                    PUT_DATA.SET_LOGO_URL(LOGO_URL: DATADICT?["logourl"] as Any)
                    PUT_DATA.SET_MI_CHECK(MI_CHECK: DATADICT?["mi_check"] as Any)
                    PUT_DATA.SET_REG_FILE(REG_FILE: DATADICT?["reg_file"] as Any)
                    PUT_DATA.SET_S_IDX(S_IDX: DATADICT?["s_idx"] as Any)
                    PUT_DATA.SET_SC_ADDRESS(SC_ADDRESS: DATADICT?["sc_address"] as Any)
                    PUT_DATA.SET_SC_CODE(SC_CODE: DATADICT?["sc_code"] as Any)
                    PUT_DATA.SET_SC_EMAIL(SC_EMAIL: DATADICT?["sc_email"] as Any)
                    PUT_DATA.SET_SC_FAX(SC_FAX: DATADICT?["sc_fax"] as Any)
                    PUT_DATA.SET_SC_GRADE(SC_GRADE: DATADICT?["sc_grade"] as Any)
                    PUT_DATA.SET_SC_GRADE_NAME(SC_GRADE_NAME: DATADICT?["sc_grade_name"] as Any)
                    PUT_DATA.SET_SC_GROUP(SC_GROUP: DATADICT?["sc_group"] as Any)
                    PUT_DATA.SET_SC_GROUP_NAME(SC_GROUP_NAME: DATADICT?["sc_group_name"] as Any)
                    PUT_DATA.SET_SC_HOME_PAGE(SC_HOME_PAGE: DATADICT?["sc_hompage"] as Any)
                    PUT_DATA.SET_SC_IN(SC_IN: DATADICT?["sc_in"] as Any)
                    PUT_DATA.SET_SC_IN_BTE(SC_IN_BTE: DATADICT?["sc_in_bte"] as Any)
                    PUT_DATA.SET_SC_IN_BTS(SC_IN_BTS: DATADICT?["sc_in_bts"] as Any)
                    PUT_DATA.SET_SC_LATE(SC_LATE: DATADICT?["sc_late"] as Any)
                    PUT_DATA.SET_SC_LOCATION(SC_LOCATION: DATADICT?["sc_location"] as Any)
                    PUT_DATA.SET_SC_LOCATION_NAME(SC_LOCATION_NAME: DATADICT?["sc_location_name"] as Any)
                    PUT_DATA.SET_SC_MAXP(SC_MAXP: DATADICT?["sc_maxp"] as Any)
                    PUT_DATA.SET_SC_NAME(SC_NAME: DATADICT?["sc_name"] as Any)
                    PUT_DATA.SET_SC_OUT(SC_OUT: DATADICT?["sc_out"] as Any)
                    PUT_DATA.SET_SC_OUT_BTE(SC_OUT_BTE: DATADICT?["sc_out_bte"] as Any)
                    PUT_DATA.SET_SC_OUT_BTS(SC_OUT_BTS: DATADICT?["sc_out_bts"] as Any)
                    PUT_DATA.SET_SC_TEACHER(SC_TEACHER: DATADICT?["sc_teacher"] as Any)
                    PUT_DATA.SET_SC_TEACHER_HP(SC_TEACHER_HP: DATADICT?["sc_teahp"] as Any)
                    PUT_DATA.SET_SC_TEL(SC_TEL: DATADICT?["sc_tel"] as Any)
                    PUT_DATA.SET_SENDER_KEY(SENDER_KEY: DATADICT?["sender_key"] as Any)
                    PUT_DATA.SET_SMS_IN(SMS_IN: DATADICT?["sms_dormout"] as Any)
                    PUT_DATA.SET_SMS_LATE(SMS_LATE: DATADICT?["sms_in"] as Any)
                    PUT_DATA.SET_SMS_OUT(SMS_OUT: DATADICT?["sms_late"] as Any)
                    PUT_DATA.SET_SMS_POINT(SMS_POINT: DATADICT?["sms_point"] as Any)
                    PUT_DATA.SET_SMS_POINT_TEACHER(SMS_POINT_TEACHER: DATADICT?["sms_point_teacher"] as Any)
                    PUT_DATA.SET_SMS_USE(SMS_USE: DATADICT?["sms_use"] as Any)
                    PUT_DATA.SET_UPPER_CODE(UPPER_CODE: DATADICT?["upper_code"] as Any)
                    
                    self.SCHOOL_INFO_API.append(PUT_DATA)
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

extension SCHOOL_INFO: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SCHOOL_INFO_API.count == 0 {
            return 0
        } else {
            return SCHOOL_INFO_API.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = SCHOOL_INFO_API[indexPath.item]
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "SCHOOL_INFO_TC", for: indexPath) as! SCHOOL_INFO_TC
        
        // 이미지
        CELL.PROFILE_IMAGE.layer.cornerRadius = 25.0
        CELL.PROFILE_IMAGE.clipsToBounds = true
        let IMAGE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().SCHOOL_LOGO_URL) + DATA.SC_CODE
        let KOREAN_URL = IMAGE_URL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        NUKE_IMAGE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: UIImage(named: "busanlogo.png")!, PROFILE: CELL.PROFILE_IMAGE, FRAME_SIZE: CELL.PROFILE_IMAGE.frame.size)
        // 기관 및 이름
        if DATA.LIST_TYPE == "fa_list" {
            CELL.NAME_1.text = DATA.SC_GROUP_NAME
            CELL.NAME_2.isHidden = true
        } else {
            if DATA.SC_NAME != "" { CELL.NAME_1.text = DATA.SC_NAME }
            CELL.NAME_2.isHidden = false
            if DATA.SC_GROUP_NAME == "" { CELL.NAME_2.text = "-" } else { CELL.NAME_2.text = DATA.SC_GROUP_NAME }
        }
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if SCHOOL_INFO_API.count != 0 {
            
            let DATA = SCHOOL_INFO_API[indexPath.item]
            
            if DATA.LIST_TYPE == "fa_list" {
                
                switch MENU_VIEW.SELECTED_SEGMENT_INDEX {
                case 0:
                HTTP_SCHOOL_INFO(ACTION_TYPE: "school_list", SC_GROUP: DATA.SC_GROUP, SC_GRADE: "1", SC_NAME: DATA.SC_GROUP_NAME)
                case 1:
                HTTP_SCHOOL_INFO(ACTION_TYPE: "school_list", SC_GROUP: DATA.SC_GROUP, SC_GRADE: "2", SC_NAME: DATA.SC_GROUP_NAME)
                case 2:
                HTTP_SCHOOL_INFO(ACTION_TYPE: "school_list", SC_GROUP: DATA.SC_GROUP, SC_GRADE: "3", SC_NAME: DATA.SC_GROUP_NAME)
                case 3:
                HTTP_SCHOOL_INFO(ACTION_TYPE: "school_list", SC_GROUP: DATA.SC_GROUP, SC_GRADE: "4", SC_NAME: DATA.SC_GROUP_NAME)
                case 4:
                HTTP_SCHOOL_INFO(ACTION_TYPE: "school_list", SC_GROUP: DATA.SC_GROUP, SC_GRADE: "5", SC_NAME: DATA.SC_GROUP_NAME)
                default:
                    break
                }
            } else if DATA.LIST_TYPE == "sc_list" {

                let VC = self.storyboard?.instantiateViewController(withIdentifier: "DETAIL_INFO") as! DETAIL_INFO
                VC.modalTransitionStyle = .crossDissolve
                VC.SCHOOL_INFO_API = SCHOOL_INFO_API
                VC.SCHOOL_POSITION = indexPath.item
                present(VC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
