//
//  LOADING.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/07/24.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class LOADING: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var PUSH_YN: Bool = false
    var BOARD_KEY: String = ""
    var BOARD_TYPE: String = ""
    
    var PUSH_API: [SCHOOL_DATA] = []
    
    @IBOutlet weak var APP_NAME: UILabel!
    
    override func loadView() {
        super.loadView()
        
        APP_NAME.font = UIFont(name: "YiSunShinDotumB", size: 40.0)
        
        // 버전 체크
        let STORE_VERSION = UIViewController.APPDELEGATE.NEW_VERSION
        let NOW_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String // 현재 버전

        print("최신 버전: \(STORE_VERSION)")
        print("현재 버전: \(NOW_VERSION)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NETWORK_CHECK()
    }
    
    func NETWORK_CHECK() {
        
        if !SYSTEM_NETWORK_CHECKING() {
            
            DispatchQueue.main.async {
                
                let ALERT = UIAlertController(title: "네트워크 연결 없음", message: "네트워크가 정상적으로 연결되어 있는지 확인하여주세요.", preferredStyle: .alert)
                ALERT.addAction(UIAlertAction(title: "재시도", style: .default, handler: { (_) in self.NETWORK_CHECK() }))
                self.present(ALERT, animated: true, completion: nil)
            }
        } else {
        
            HTTP_VERSION_CHECK()
            
            if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" { HTTP_INDIVIDUAL_CONTACT() }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: {
            
                if self.PUSH_YN == false {
                    self.TAB_VC(IDENTIFIER: "TAB_VC", INDEX: 0)
                } else {
                    if self.BOARD_KEY == "" {
                        self.TAB_VC(IDENTIFIER: "TAB_VC", INDEX: 4)
                    } else {
                        self.LOAD_PUSH_DATA(BOARD_KEY: self.BOARD_KEY, BOARD_TYPE: self.BOARD_TYPE)
                    }
                }
            })
        }
    }
    
    func HTTP_INDIVIDUAL_CONTACT() {
        
        let PARAMETERS: Parameters = [
            "action_type": "per_group",
            "mb_id": UIViewController.USER_DATA.string(forKey: "mb_id") ?? ""
        ]
        
        print("개인 주소록 파라미터: \(PARAMETERS)")
        
        let BASE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().BASE_URL)
        
        Alamofire.request(BASE_URL, method: .post, parameters: PARAMETERS).responseJSON { response in
            
            print("[개인 주소록]", response)
            UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API.removeAll()
            
            guard let DATA_ARRAY = response.result.value as? Array<Any> else {
                print("[개인 주소록] FAIL")
                UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API.removeAll()
                if UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API.count == 0 {
                    self.HTTP_GROUP(ACTION_TYPE: "per_group_add", BG_NAME: "그룹1", BG_NO: "")
                }
                return
            }
            
            for (_, DATA) in DATA_ARRAY.enumerated() {
                
                let DATADICT = DATA as? [String: Any]
                
                let PUT_DATA = INDIVIDUAL_CONTACT_DATA()
                
                PUT_DATA.SET_BG_NO(BG_NO: DATADICT?["bg_no"] as Any)
                PUT_DATA.SET_BG_NAME(BG_NAME: DATADICT?["bg_name"] as Any)
                PUT_DATA.SET_BG_COUNT(BG_COUNT: DATADICT?["bg_count"] as Any)
                PUT_DATA.SET_MB_ID(MB_ID: DATADICT?["mb_id"] as Any)
                PUT_DATA.SET_LIST_TYPE(LIST_TYPE: DATADICT?["list_type"] as Any)
                
                UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API.append(PUT_DATA)
            }
        }
    }
    
    func HTTP_GROUP(ACTION_TYPE: String, BG_NAME: String, BG_NO: String) {
            
        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
            "bg_no": BG_NO,
            "bg_name": BG_NAME,
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

                print("[그룹추가]", response)
                self.HTTP_INDIVIDUAL_CONTACT()
            }
            case .failure(let encodingError):
        
                print(encodingError)
                break
            }
        }
    }
    
    // 버전 체크
    func HTTP_VERSION_CHECK() {
        
        let VERSION_CHECK = "https://dapp.uic.me/conn/member/version_check.php"
        
        let PARAMETERS: Parameters = [ "os": "ios" ]
        
        print("PARAMETERS -" , PARAMETERS)

        Alamofire.request(VERSION_CHECK, method: .post, parameters: PARAMETERS).responseJSON { response in

            print("[버전체크]", response)
            
            guard let VERSIONDICT = response.result.value as? [String: Any] else {
                print("[버전체크] FAIL")
                return
            }
            
            UIViewController.APPDELEGATE.NEW_VERSION.append(VERSIONDICT["version_name"] as? String ?? "1.0.0")
        }
    }
    
    func LOAD_PUSH_DATA(BOARD_KEY: String, BOARD_TYPE: String) {
        
        let SCHOOL_BOARD = "https://dapp.uic.me/conn/message/school_board_detail.php"
        
        let PARAMETERS: Parameters = [
            "mb_id": UIViewController.USER_DATA.string(forKey: "mb_id") ?? "",
            "board_key": BOARD_KEY,
            "board_type": BOARD_TYPE
        ]
        
        print("PARAMETERS -", PARAMETERS)
        
        Alamofire.request(SCHOOL_BOARD, method: .post, parameters: PARAMETERS).responseJSON { response in
            
            print("[PUSH데이터]", response)
            
            self.PUSH_API.removeAll()
            
            guard let SOSIK_ARRAY = response.result.value as? Array<Any> else {
                
                print("[PUSH데이터] FAIL")
                self.TAB_VC(IDENTIFIER: "TAB_VC", INDEX: 4)
                return
            }
            
            for (_, DATA) in SOSIK_ARRAY.enumerated() {

                let DATADICT = DATA as? [String: Any]

                let POST_SCHOOL_DATA = SCHOOL_DATA()

                POST_SCHOOL_DATA.SET_ATTACHED(ATTACHED: self.SET_ATTACHED_DATA(ATTACHED_ARRAY: DATADICT?["attached"] as? [Any] ?? []))
                POST_SCHOOL_DATA.SET_BOARD_CODE(BOARD_CODE: DATADICT?["board_code"] as Any)
                POST_SCHOOL_DATA.SET_BOARD_ID(BOARD_ID: DATADICT?["board_id"] as Any)
                POST_SCHOOL_DATA.SET_BOARD_KEY(BOARD_KEY: DATADICT?["board_key"] as Any)
                POST_SCHOOL_DATA.SET_BOARD_NAME(BOARD_NAME: DATADICT?["board_name"] as Any)
                POST_SCHOOL_DATA.SET_BOARD_SOURCE(BOARD_SOURCE: DATADICT?["board_source"] as Any)
                POST_SCHOOL_DATA.SET_BOARD_TYPE(BOARD_TYPE: DATADICT?["board_type"] as Any)
                POST_SCHOOL_DATA.SET_CALL_BACK(CALL_BACK: DATADICT?["callback"] as Any)
                POST_SCHOOL_DATA.SET_CLASS_INFO(CLASS_INFO: DATADICT?["class_info"] as Any)
                POST_SCHOOL_DATA.SET_CONTENT(CONTENT: DATADICT?["content"] as Any)
                POST_SCHOOL_DATA.SET_CONTENT_TEXT(CONTENT_TEXT: DATADICT?["content_text"] as Any)
                POST_SCHOOL_DATA.SET_CONTENT_TYPE(CONTENT_TYPE: DATADICT?["content_type"] as Any)
                POST_SCHOOL_DATA.SET_DATETIME(DATETIME: DATADICT?["request_time"] as Any)
                POST_SCHOOL_DATA.SET_DST(DST: DATADICT?["dst"] as Any)
                POST_SCHOOL_DATA.SET_DST_NAME(DST_NAME: DATADICT?["dst_name"] as Any)
                POST_SCHOOL_DATA.SET_DST_TYPE(DST_TYPE: DATADICT?["dst_type"] as Any)
                POST_SCHOOL_DATA.SET_FCM_KEY(FCM_KEY: DATADICT?["fcm_key"] as Any)
                POST_SCHOOL_DATA.SET_FILE_COUNT(FILE_COUNT: DATADICT?["file_cnt"] as Any)
                POST_SCHOOL_DATA.SET_FROM_FILE(FROM_FILE: DATADICT?["from_file"] as Any)
                POST_SCHOOL_DATA.SET_IDX(IDX: DATADICT?["board_key"] as Any) // BOARD_KEY 내부DB
                POST_SCHOOL_DATA.SET_INPUT_DATE(INPUT_DATE: DATADICT?["input_date"] as Any)
                POST_SCHOOL_DATA.SET_IS_MODIFY(IS_MODIFY: DATADICT?["is_modify"] as Any)
                POST_SCHOOL_DATA.SET_IS_PUSH(IS_PUSH: DATADICT?["is_push"] as Any)
                POST_SCHOOL_DATA.SET_LIKE_COUNT(LIKE_COUNT: DATADICT?["like_cnt"] as Any)
                POST_SCHOOL_DATA.SET_LIKE_ID(LIKE_ID: DATADICT?["like_id"] as Any)
                POST_SCHOOL_DATA.SET_ME_LENGTH(ME_LENGTH: DATADICT?["me_length"] as Any)
                POST_SCHOOL_DATA.SET_MEDIA_COUNT(MEDIA_COUNT: DATADICT?["media_cnt"] as Any)
                POST_SCHOOL_DATA.SET_MSG_GROUP(MSG_GROUP: DATADICT?["msg_group"] as Any)
                POST_SCHOOL_DATA.SET_NO(NO: DATADICT?["no"] as Any)
                POST_SCHOOL_DATA.SET_OPEN_COUNT(OPEN_COUNT: DATADICT?["open_cnt"] as Any)
                POST_SCHOOL_DATA.SET_POLL_NUM(POLL_NUM: DATADICT?["poll_num"] as Any)
                POST_SCHOOL_DATA.SET_RESULT(RESULT: DATADICT?["result"] as Any)
                POST_SCHOOL_DATA.SET_SC_CODE(SC_CODE: DATADICT?["sc_code"] as Any)
                POST_SCHOOL_DATA.SET_SC_GRADE(SC_GRADE: DATADICT?["sc_grade"] as Any)
                POST_SCHOOL_DATA.SET_SC_GROUP(SC_GROUP: DATADICT?["sc_group"] as Any)
                POST_SCHOOL_DATA.SET_SC_LOCATION(SC_LOCATION: DATADICT?["sc_location"] as Any)
                POST_SCHOOL_DATA.SET_SC_LOGO(SC_LOGO: DATADICT?["sc_logo"] as Any)
                POST_SCHOOL_DATA.SET_SC_NAME(SC_NAME: DATADICT?["sc_name"] as Any)
                POST_SCHOOL_DATA.SET_SEND_TYPE(SEND_TYPE: DATADICT?["send_type"] as Any)
                POST_SCHOOL_DATA.SET_SENDER_IP(SENDER_IP: DATADICT?["sender_ip"] as Any)
                POST_SCHOOL_DATA.SET_SUBJECT(SUBJECT: DATADICT?["subject"] as Any)
                POST_SCHOOL_DATA.SET_TARGET_GRADE(TARGET_GRADE: DATADICT?["tagret_grade"] as Any)
                POST_SCHOOL_DATA.SET_TARGET_CLASS(TARGET_CLASS: DATADICT?["target_class"] as Any)
                POST_SCHOOL_DATA.SET_WR_SHARE(WR_SHARE: DATADICT?["wr_share"] as Any)
                POST_SCHOOL_DATA.SET_WRITER(WRITER: DATADICT?["writer"] as Any)

                self.PUSH_API.append(POST_SCHOOL_DATA)
            }

            self.SOSIK_DETAIL_VC()
        }
    }
    
    func SET_ATTACHED_DATA(ATTACHED_ARRAY: [Any]) -> [ATTACHED] {
        
        var ATTACHED_API: [ATTACHED] = []
        
        for (_, DATA) in ATTACHED_ARRAY.enumerated() {
            
            let DATADICT = DATA as? [String: Any]
            
            let POST_ATTACHED = ATTACHED()
            
            POST_ATTACHED.SET_DATETIME(DATETIME: DATADICT?["datetime"] as Any)
            POST_ATTACHED.SET_DT_FROM(DT_FROM: DATADICT?["dt_from"] as Any)
            POST_ATTACHED.SET_FILE_NAME(FILE_NAME: DATADICT?["file_name"] as Any)
            POST_ATTACHED.SET_FILE_NAME_ORG(FILE_NAME_ORG: DATADICT?["file_name_org"] as Any)
            POST_ATTACHED.SET_FILE_SIZE(FILE_SIZE: DATADICT?["sysId"] as Any)
            POST_ATTACHED.SET_IDX(IDX: DATADICT?["idx"] as Any)
            POST_ATTACHED.SET_IN_SEQ(IN_SEQ: DATADICT?["in_seq"] as Any)
            POST_ATTACHED.SET_LAT(LAT: DATADICT?["lat"] as Any)
            POST_ATTACHED.SET_LNG(LNG: DATADICT?["lng"] as Any)
            POST_ATTACHED.SET_MEDIA_FILES(MEDIA_FILES: DATADICT?["media_files"] as Any)
            POST_ATTACHED.SET_MEDIA_TYPE(MEDIA_TYPE: DATADICT?["media_type"] as Any)
            POST_ATTACHED.SET_MSG_GROUP(MSG_GROUP: DATADICT?["msg_group"] as Any)
            
            ATTACHED_API.append(POST_ATTACHED)
        }
        
        return ATTACHED_API
    }
    
    func SOSIK_DETAIL_VC() {
        
        if PUSH_API.count == 0 {
            TAB_VC(IDENTIFIER: "TAB_VC", INDEX: 4)
        } else {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SOSIK_DETAIL") as! SOSIK_DETAIL
            VC.modalTransitionStyle = .crossDissolve
            VC.SCHOOL_API = PUSH_API
            VC.SCHOOL_POSITION = 0
            VC.BOARD_TYPE = PUSH_API[0].BOARD_TYPE
            VC.PUSH_CHECK = true
            present(VC, animated: true)
        }
    }
}
