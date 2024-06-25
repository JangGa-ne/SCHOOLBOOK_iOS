//
//  SOSIK_N.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/05/07.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

// 공지사항
class SOSIK_N: UIViewController, UITabBarControllerDelegate {
    
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
    
    var SCHOOL_API: [SCHOOL_DATA] = []
    
    var FETCHING_MORE = false
    var PAGE_NUMBER: Int = 0
    var ITEM_COUNT: Int = 20
    
    var DATETIME: String = ""
    var DATETIME2: String = ""
    
    var DECODED_TITLE: String = ""
    var DECODED_CONTENT: String = ""
    
    @IBOutlet weak var LOGIN_CHECK: UILabel!                // 로그인_확인
    
    @IBOutlet weak var Navi_Title: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var TITLE_VIEW_BG: UIView!
    @IBOutlet weak var TITLE_VIEW: UIView!
    
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
        
        if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
            EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DEVICE_RATIO() == "Ratio 16:9" {
            Navi_Title.alpha = 1.0
            TITLE_VIEW_BG.isHidden = true
            TITLE_VIEW.frame.size.height = 0.0
            TITLE_VIEW.clipsToBounds = true
        } else {
            Navi_Title.alpha = 0.0
            TITLE_VIEW_BG.isHidden = false
            TITLE_VIEW.frame.size.height = 52.0
            TITLE_VIEW.clipsToBounds = false
        }
        SCHOOL_API.removeAll()
        
        // 통신
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
                LOGIN_CHECK.text = "로그인 후 사용 가능합니다"
                HTTP_SCHOOL(BOARD_TYPE: "EB")
            }
        }
        
        TableView.separatorStyle = .none
        TableView.delegate = self
        TableView.dataSource = self
        TableView.backgroundColor = .GRAY_COLOR
        
//        let REFRESH = UIRefreshControl()
//        REFRESH.addTarget(self, action: #selector(UPDATE(REFRESH:)), for: .valueChanged)
//        TableView.refreshControl = REFRESH
    }
    
    func HTTP_SCHOOL(BOARD_TYPE: String) {
        
//        let SCHOOL_BOARD = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().BASE_URL)
        
        let SCHOOL_BOARD = "https://dapp.uic.me/conn/message/school_board.php"
        
        let PARAMETERS: Parameters = [
            "mb_id": UIViewController.USER_DATA.string(forKey: "mb_id") ?? "",
            "limit_start": PAGE_NUMBER * ITEM_COUNT,
            "board_type": BOARD_TYPE,
            "sc_code[0]": "EDUBOOK"
        ]
        
        print("PARAMETERS -", PARAMETERS)
        
        Alamofire.request(SCHOOL_BOARD, method: .post, parameters: PARAMETERS).responseJSON { response in
            
            print("[공지사항 - \(BOARD_TYPE)]", response)
            
            guard let SOSIK_ARRAY = response.result.value as? Array<Any> else {
                
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                    self.VIEW.alpha = 0.0
                }, completion: {(isCompleted) in
                    self.VIEW.removeFromSuperview()
                })
                print("[공지사항] FAIL")
                self.TableView.reloadData()
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
                
                self.SCHOOL_API.append(POST_SCHOOL_DATA)
            }
            
            self.TableView.reloadData()
            
//            self.ROAD_LIKE_SQL()
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.VIEW.alpha = 0.0
            }, completion: {(isCompleted) in
                self.VIEW.removeFromSuperview()
            })
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
    
    var IDX: [String] = []
    var LIKE: [String] = []
    
//    func ROAD_LIKE_SQL() {
//
//        UIViewController.APPDELEGATE.OPEN_DB_MAIN()
//
//        let SQL_EDIT: String = "SELECT * FROM SCHOOL_DB ORDER BY DATETIME DESC"
//
//        let SQL_SCHOOL = UIViewController.APPDELEGATE.SQL_SCHOOL
//
//        // QUERY 준비
//        if sqlite3_prepare(SQL_SCHOOL.DB, SQL_EDIT, -1, &SQL_SCHOOL.STMT, nil) != SQLITE_OK {
//            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(SQL_SCHOOL.DB)!)
//            print("ERROR PREPARING INSERT : \(ERROR_MESSAGE)")
//            return
//        }
//
//        while sqlite3_step(SQL_SCHOOL.STMT) == SQLITE_ROW {
//
//            IDX.append(String(cString: sqlite3_column_text(SQL_SCHOOL.STMT, 18)))
//            LIKE.append(String(cString: sqlite3_column_text(SQL_SCHOOL.STMT, 44)))
//        }
//
//        TableView.reloadData()
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        let CONTENT_HEIGHT = scrollView.contentSize.height
        
        if OFFSET_Y > CONTENT_HEIGHT - scrollView.frame.height && OFFSET_Y > 0 { if !FETCHING_MORE { BEGINBATCHFETCH() } }
        
        if DEVICE_RATIO() == "Ratio 18:9" { SCROLL_EDIT_T(TABLE_VIEW: TableView, NAVI_TITLE: Navi_Title) }
    }
    
    @objc func UPDATE(REFRESH: UIRefreshControl) {
        
        print("bbbbbbbb")
        FETCHING_MORE = false
        PAGE_NUMBER = 0
        SCHOOL_API.removeAll()
        REFRESH.endRefreshing()
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
            HTTP_SCHOOL(BOARD_TYPE: "EB")
        }
    }
    
    func BEGINBATCHFETCH() {
        
        FETCHING_MORE = true
        
        TableView.reloadSections(IndexSet(integer: 1), with: .none)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            
            self.PAGE_NUMBER = self.PAGE_NUMBER + 1
            if !self.SYSTEM_NETWORK_CHECKING() {
                self.NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
            } else {
                self.HTTP_SCHOOL(BOARD_TYPE: "EB")
            }
            self.FETCHING_MORE = false
        })
    }
}

extension SOSIK_N: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if SCHOOL_API.count == 0 {
                TableView.isHidden = true
                if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" { LOGIN_CHECK.text = "데이터가 없습니다" }
                return 0
            } else {
                TableView.isHidden = false
                return SCHOOL_API.count
            }
        } else if section == 1 && FETCHING_MORE {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let DATA = SCHOOL_API[indexPath.item]
            
            if DATA.DATETIME == "0000-00-00 00:00:00" {
                
                self.DATETIME = "00월00일"
                self.DATETIME2 = ""
            } else {
                
                let DATE_FORMATTER = DateFormatter()
                DATE_FORMATTER.locale = Locale(identifier: "ko_kr")
                DATE_FORMATTER.dateFormat = "yyyy-MM-dd HH:mm:ss"
                DATE_FORMATTER.timeZone = TimeZone.init(identifier: "Asia/Seoul")
                let DATE: Date = DATE_FORMATTER.date(from: DATA.DATETIME)!
                
                DATE_FORMATTER.dateFormat = "MM월dd일"
                self.DATETIME = DATE_FORMATTER.string(from: DATE)
                
                DATE_FORMATTER.dateFormat = "E"
                self.DATETIME2 = DATE_FORMATTER.string(from: DATE)
            }
            
            if DATA.SUBJECT == "" {
                self.DECODED_TITLE = ""
            } else {
                let BASE64_ENCODE = Data(base64Encoded: DATA.SUBJECT, options: [])
                if let BASE64_ENCODE = BASE64_ENCODE {
                    let DECODED_TITLE = String(data: BASE64_ENCODE, encoding: .utf8) ?? "UTF8 오류 처리중 . . ."
                    self.DECODED_TITLE = DECODED_TITLE.replacingOccurrences(of: "&apos;", with: "")
                } else {
                    self.DECODED_TITLE = DATA.SUBJECT
                }
            }
            
            if DATA.CONTENT_TEXT == "" {
                self.DECODED_CONTENT = ""
            } else {
                let BASE64_ENCODE = Data(base64Encoded: DATA.CONTENT_TEXT, options: [])
                if let BASE64_ENCODE = BASE64_ENCODE {
                    self.DECODED_CONTENT = String(data: BASE64_ENCODE, encoding: .utf8) ?? "UTF8 오류 처리중 . . ."
                } else {
                    self.DECODED_CONTENT = DATA.CONTENT_TEXT
                }
                let DECODED_CONTENT = self.DECODED_CONTENT.replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "&apos;", with: "").replacingOccurrences(of: "?", with: "")
                self.DECODED_CONTENT = DECODED_CONTENT
            }
            
            var HTML_STRING = DATA.CONTENT_TEXT
            if self.DECODED_CONTENT != "" && (self.DECODED_CONTENT == "") == false { HTML_STRING = self.DECODED_CONTENT }
            
            var ATTRIBUTED_STRING: NSAttributedString? = nil
            do {
                if let DATA_ = HTML_STRING.data(using: .unicode) {
                    ATTRIBUTED_STRING = try NSAttributedString(data: DATA_, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                }
            } catch { }
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SOSIK_TC", for: indexPath) as! SOSIK_TC
            
            CELL.SCHOOL_API = SCHOOL_API
            CELL.SCHOOL_POSITION = indexPath.item
            
            if DATA.SC_LOGO == "" {
                if DATA.SC_CODE != "" {
                    let IMAGE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().SCHOOL_LOGO_URL) + DATA.SC_CODE
                    let KOREAN_URL = IMAGE_URL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                    NUKE_IMAGE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: UIImage(named: "school_")!, PROFILE: CELL.School_Symbol_Image, FRAME_SIZE: CELL.School_Symbol_Image.frame.size)
                }
            } else {
                let IMAGE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().SCHOOL_LOGO_URL) + DATA.SC_LOGO
                let KOREAN_URL = IMAGE_URL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                NUKE_IMAGE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: UIImage(named: "school_")!, PROFILE: CELL.School_Symbol_Image, FRAME_SIZE: CELL.School_Symbol_Image.frame.size)
            }
            
            CELL.School_Symbol_Image.layer.cornerRadius = 20.0
            CELL.School_Symbol_Image.clipsToBounds = true
            CELL.School_Type_Label.text = DATA.BOARD_NAME
            CELL.School_Label.text = DATA.SC_NAME
            CELL.School_Date_Label.text = self.DATETIME
            CELL.School_Day_Label.text = self.DATETIME2
            CELL.School_Subject_Label.text = self.DECODED_TITLE
            CELL.School_Notice_Content_Label.text = ATTRIBUTED_STRING?.string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            CELL.PROTOCOL = self
            
            // 미디어
            var ATTACHED_: [String] = []
            
            if DATA.ATTACHED.count != 0 {
                for i in 0 ..< DATA.ATTACHED.count {
                    if DATA.ATTACHED[i].MEDIA_TYPE != "f" { ATTACHED_.append(DATA.ATTACHED[i].MEDIA_TYPE) }
                }
            }
            
            if ATTACHED_.count == 0 {
                
                CELL.School_Content_View.isHidden = true
                CELL.PageView.isHidden = true
            } else if ATTACHED_.count == 1 {
                
                CELL.School_Content_View.isHidden = false
                CELL.PageView.isHidden = true
                CELL.CC_DELEGATE()
            } else {
                
                CELL.School_Content_View.isHidden = false
                CELL.CC_DELEGATE()
                CELL.CollectionView.contentOffset = CGPoint(x: view.frame.width * CGFloat(DATA.PAGE), y: 0)
                CELL.PageView.numberOfPages = ATTACHED_.count
                CELL.PageView.currentPage = DATA.PAGE
                CELL.PageView.isHidden = false
            }
            
            if DATA.CONTENT_TEXT == "IA==" { CELL.LineView.isHidden = true } else { CELL.LineView.isHidden = false }
            
            // 첨부파일 확인
            if DATA.ATTACHED.count == 0 {
                
                CELL.School_Filename_Image.image = UIImage(named: "ico_shcool_file_n.png")
                CELL.School_Filename_Label.text = "첨부파일 없음"
                CELL.School_Filename_Button.isHidden = true
            } else {
                
                var FILE_NAME: String = ""
                var FILE_URL: String = ""
                
                for i in 0 ..< DATA.ATTACHED.count {
                    
                    let DATA = DATA.ATTACHED[i]
                    if DATA.MEDIA_TYPE == "f" {
                        FILE_NAME.append("\(DATA.FILE_NAME_ORG)|")
                        FILE_URL.append("\(DATA.MEDIA_FILES)|")
                    }
                }
                
                if FILE_NAME == "" && FILE_URL == "" {
                    
                    CELL.School_Filename_Image.image = UIImage(named: "ico_shcool_file_n.png")
                    CELL.School_Filename_Label.text = "첨부파일 없음"
                    CELL.School_Filename_Button.isHidden = true
                } else {
                    
                    CELL.School_Filename_Image.image = UIImage(named: "ico_shcool_file_s.png")
                    CELL.School_Filename_Label.text = "파일 보기"
                    CELL.School_Filename_Button.isHidden = false
                    CELL.School_Filename_Button.tag = indexPath.item
                    CELL.School_Filename_Button.addTarget(self, action: #selector(FILE_DOWNLOAD(_:)), for: .touchUpInside)
                }
            }
            
            // 좋아요
            if IDX.count != 0 {
                
                for i in 0 ..< IDX.count {
                    if DATA.IDX == IDX[i] { DATA.LIKE = Bool(LIKE[i]) ?? false }
                }
                
                if DATA.LIKE == true {
                    CELL.School_Like_Image.image = UIImage(named: "like_red.png")
                } else {
                    CELL.School_Like_Image.image = UIImage(named: "ico_shcool_heart_n.png")
                }
                
                CELL.School_Like_Button.tag = indexPath.item
                CELL.School_Like_Button.addTarget(CELL, action: #selector(CELL.LIKE(_:)), for: .touchUpInside)
            }
            
            // 공유하기
            CELL.School_Share_Button.tag = indexPath.item
            CELL.School_Share_Button.addTarget(self, action: #selector(SHARE(_:)), for: .touchUpInside)
            
            return CELL
        } else {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SOSIK_TC_LOAD", for: indexPath) as! SOSIK_TC
            
            if FETCHING_MORE == true {
                CELL.Result_None.text = "데이터 불러오는 중"
            } else {
                CELL.Result_None.text = "부산교육 다모아"
            }
            
            return CELL
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SOSIK_DETAIL") as! SOSIK_DETAIL
        VC.modalTransitionStyle = .crossDissolve
        VC.SCHOOL_API = SCHOOL_API
        VC.SCHOOL_POSITION = indexPath.item
        VC.BOARD_TYPE = "N"
        present(VC, animated: true)
    }
    
    // 첨부파일
    @objc func FILE_DOWNLOAD(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: "미리보기 및 다운로드하고 싶은 파일을 선택해주세요", message: nil, preferredStyle: .actionSheet)

        var SYSTEM_ID: String = ""
        var FILE_NAME: String = ""
        var FILE_URL: String = ""
        var IDX: String = ""
        var MSG_GROUP: String = ""
        var DT_FROM: String = ""

        for i in 0 ..< SCHOOL_API[sender.tag].ATTACHED.count {

            let DATA = SCHOOL_API[sender.tag].ATTACHED[i]
            if DATA.MEDIA_TYPE == "f" {
                
                if DATA.FILE_SIZE == "" {
                    SYSTEM_ID.append("-|")
                } else {
                    SYSTEM_ID.append("\(DATA.FILE_SIZE)|")
                }
                FILE_NAME.append("\(DATA.FILE_NAME_ORG)|")
                FILE_URL.append("\(DATA.MEDIA_FILES)|")
                IDX.append("\(DATA.IDX)|")
                MSG_GROUP.append("\(DATA.MSG_GROUP)|")
                DT_FROM.append("\(DATA.DT_FROM)|")
            }
        }

        if FILE_NAME.lastIndex(of: "|") == nil {

            let BAR0 = SYSTEM_ID.components(separatedBy: "|")
            let BAR1 = FILE_NAME.components(separatedBy: "|")
            let BAR2 = FILE_URL.components(separatedBy: "|")
            let BAR3 = IDX.components(separatedBy: "|")
            let BAR4 = MSG_GROUP.components(separatedBy: "|")
            let BAR5 = DT_FROM.components(separatedBy: "|")

            for i in 0 ..< BAR1.count {

                if BAR0[i] == "-" {
                    
                    ALERT.addAction(UIAlertAction(title: BAR1[i], style: .default) { (_) in
                        
                        self.DOWNLOAD_BUTTON(FILE_URL: BAR2[i], FILE_NAME: BAR1[i])
                    })
                } else {
                    
                    ALERT.addAction(UIAlertAction(title: BAR1[i], style: .default) { (_) in
                        
                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "HWP_VIWER") as! HWP_VIWER
                        VC.modalTransitionStyle = .crossDissolve
                        VC.FILE_NAME = BAR1[i]
                        VC.FILE_URL = BAR2[i]
                        VC.IDX = BAR3[i]
                        VC.MSG_GROUP = BAR4[i]
                        VC.DT_FROM = BAR5[i]
                        self.present(VC, animated: true)
                    })
                }
            }
        } else {
            
            let SYSTEM_ID = SYSTEM_ID.trimmingCharacters(in: ["|"])
            let FILE_NAME = FILE_NAME.trimmingCharacters(in: ["|"])
            let FILE_URL = FILE_URL.trimmingCharacters(in: ["|"])
            let IDX = IDX.trimmingCharacters(in: ["|"])
            let MSG_GROUP = MSG_GROUP.trimmingCharacters(in: ["|"])
            let DT_FROM = DT_FROM.trimmingCharacters(in: ["|"])
            
            let BAR0 = SYSTEM_ID.components(separatedBy: "|")
            let BAR1 = FILE_NAME.components(separatedBy: "|")
            let BAR2 = FILE_URL.components(separatedBy: "|")
            let BAR3 = IDX.components(separatedBy: "|")
            let BAR4 = MSG_GROUP.components(separatedBy: "|")
            let BAR5 = DT_FROM.components(separatedBy: "|")
            
            for i in 0 ..< BAR1.count {

                if BAR0[i] == "-" {
                    
                    ALERT.addAction(UIAlertAction(title: BAR1[i], style: .default) { (_) in
                        
                        self.DOWNLOAD_BUTTON(FILE_URL: BAR2[i], FILE_NAME: BAR1[i])
                    })
                } else {
                    
                    ALERT.addAction(UIAlertAction(title: BAR1[i], style: .default) { (_) in
                        
                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "HWP_VIWER") as! HWP_VIWER
                        VC.modalTransitionStyle = .crossDissolve
                        VC.FILE_NAME = BAR1[i]
                        VC.FILE_URL = BAR2[i]
                        VC.IDX = BAR3[i]
                        VC.MSG_GROUP = BAR4[i]
                        VC.DT_FROM = BAR5[i]
                        self.present(VC, animated: true)
                    })
                }
            }
        }

        let CANCEL = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
        ALERT.addAction(CANCEL)
        CANCEL.setValue(UIColor.red, forKey: "titleTextColor")

        present(ALERT, animated: true)
    }
    
    // 공유하기
    @objc func SHARE(_ sender: UIButton) {

        let DATA = SCHOOL_API[sender.tag]

        if DATA.SUBJECT == "" {
            self.DECODED_TITLE = ""
        } else {
            let BASE64_ENCODE = Data(base64Encoded: DATA.SUBJECT, options: [])
            if let BASE64_ENCODE = BASE64_ENCODE {
                let DECODED_TITLE = String(data: BASE64_ENCODE, encoding: .utf8) ?? "UTF8 오류 처리중 . . ."
                self.DECODED_TITLE = DECODED_TITLE.replacingOccurrences(of: "&apos;", with: "")

                let text = "[ \(DATA.SC_NAME) ]\n\n\(DECODED_TITLE)\nhttps://damoaapp.pen.go.kr/card/_view.php?idx=\(DATA.IDX)"
                let textShare = [text]
                let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TableView.reloadData()
    }
}
