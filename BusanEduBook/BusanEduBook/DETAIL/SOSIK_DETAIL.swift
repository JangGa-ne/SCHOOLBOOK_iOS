//
//  SOSIK_DETAIL.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/05/07.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire
import AFNetworking

class SOSIK_DETAIL: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var PUSH_CHECK: Bool = false
    
    @IBAction func BACK_VC(_ sender: Any) {
        
        if PUSH_CHECK == false {
            dismiss(animated: true, completion: nil)
        } else {
            self.TAB_VC(IDENTIFIER: "TAB_VC", INDEX: 4)
        }
    }
    
    var SCHOOL_API: [SCHOOL_DATA] = []
    var SCHOOL_POSITION = 0
    
    var ATTACHED_DATETIME: [String] = []
    var ATTACHED_DT_FROM: [String] = []
    var ATTACHED_FILE_NAME: [String] = []
    var ATTACHED_FILE_NAME_ORG: [String] = []
    var ATTACHED_FILE_SIZE: [String] = []
    var ATTACHED_IDX: [String] = []
    var ATTACHED_IN_SEQ: [String] = []
    var ATTACHED_LAT: [String] = []
    var ATTACHED_LNG: [String] = []
    var ATTACHED_MEDIA_FILES: [String] = []
    var ATTACHED_MEDIA_TYPE: [String] = []
    var ATTACHED_MSG_GROUP: [String] = []
    var ATTACHED_HTTP_STRING: [String] = []
    
    var BOARD_TYPE: String = ""
    
    var DATETIME: String = ""
    var DATETIME2: String = ""
    
    var DECODED_TITLE: String = ""
    var DECODED_CONTENT: String = ""
    
    @IBOutlet weak var School_Symbol_Image: UIImageView!            // schoolLogo - 학교 심볼
    @IBOutlet weak var School_Type_Label: UILabel!                  // typeLabel - 타입 (공지사항, 가정통신문, 급식정보, 학사일정)
    @IBOutlet weak var School_Label: UILabel!                       // schoolLabel - 학교 이름
    @IBOutlet weak var School_Date_Label: UILabel!                  // dateLabel - 날짜
    @IBOutlet weak var School_Day_Label: UILabel!                   // dayLabel - 요일
    
    @IBOutlet weak var Navi_Title: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var TITLE_VIEW_BG: UIView!
    @IBOutlet weak var TITLE_VIEW: UIView!
    
    @IBOutlet weak var School_Filename_Image: UIImageView!          // fileIcon - 첨부파일 아이콘
    @IBOutlet weak var School_Filename_Label: UILabel!              // fileName - 첨부파일 이름
    @IBOutlet weak var School_Filename_Button: UIButton!            // fileName - 첨부파일 버튼
    @IBOutlet weak var School_Like_Image: UIImageView!              // 좋아요 아이콘
    @IBOutlet weak var School_Like_Label: UILabel!                  // 좋아요 이름
    @IBOutlet weak var School_Like_Button: UIButton!                // 좋아요 버튼
    @IBOutlet weak var School_Share_Image: UIImageView!             // 공유하기 아이콘
    @IBOutlet weak var School_Share_Label: UILabel!                 // 공유하기 이름
    @IBOutlet weak var School_Share_Button: UIButton!               // 공유하기 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SCHOOL_DATA()
        HTTP_SOSIK_UPDATE(ACTION_TYPE: "open")
        
        TableView.separatorStyle = .none
        TableView.delegate = self
        TableView.dataSource = self
    }
    
    var SUBJECT: String = ""
    var SCHOOL_NAME: String = ""
    var SC_CODE: String = ""
    var FILE_NAME: String = ""
    var FILE_URL: String = ""
    
    func SCHOOL_DATA() {
        
        let DATA = SCHOOL_API[SCHOOL_POSITION]
        
        School_Type_Label.text = DATA.BOARD_NAME
        
        ATTACHED_DATETIME.removeAll()
        ATTACHED_FILE_NAME.removeAll()
        ATTACHED_FILE_NAME_ORG.removeAll()
        ATTACHED_FILE_SIZE.removeAll()
        ATTACHED_IDX.removeAll()
        ATTACHED_IN_SEQ.removeAll()
        ATTACHED_LAT.removeAll()
        ATTACHED_LNG.removeAll()
        ATTACHED_MEDIA_FILES.removeAll()
        ATTACHED_MEDIA_TYPE.removeAll()
        ATTACHED_MSG_GROUP.removeAll()
        ATTACHED_HTTP_STRING.removeAll()
        
        if DATA.ATTACHED.count != 0 {
            
            for i in 0 ..< DATA.ATTACHED.count {
                
//                if DATA.ATTACHED[i].MEDIA_TYPE != "f" {
                    
                    ATTACHED_DATETIME.append(DATA.ATTACHED[i].DATETIME)
                    ATTACHED_DT_FROM.append(DATA.ATTACHED[i].DT_FROM)
                    ATTACHED_FILE_NAME.append(DATA.ATTACHED[i].FILE_NAME)
                    ATTACHED_FILE_NAME_ORG.append(DATA.ATTACHED[i].FILE_NAME_ORG)
                    ATTACHED_FILE_SIZE.append(DATA.ATTACHED[i].FILE_SIZE)
                    ATTACHED_IDX.append(DATA.ATTACHED[i].IDX)
                    ATTACHED_IN_SEQ.append(DATA.ATTACHED[i].IN_SEQ)
                    ATTACHED_LAT.append(DATA.ATTACHED[i].LAT)
                    ATTACHED_LNG.append(DATA.ATTACHED[i].LNG)
                    ATTACHED_MEDIA_FILES.append(DATA.ATTACHED[i].MEDIA_FILES)
                    ATTACHED_MEDIA_TYPE.append(DATA.ATTACHED[i].MEDIA_TYPE)
                    ATTACHED_MSG_GROUP.append(DATA.ATTACHED[i].MSG_GROUP)
                    ATTACHED_HTTP_STRING.append(DATA.ATTACHED[i].HTTP_STRING)
//                }
            }
        }
        
        print(DATA.ATTACHED_MEDIA_TYPE)
        
        if DATA.ATTACHED_MEDIA_TYPE.contains("|") {
            
            for i in 0 ..< DATA.ATTACHED_MEDIA_TYPE.components(separatedBy: "|").count-1 {
                
//                if DATA.ATTACHED_MEDIA_TYPE.components(separatedBy: "|")[i] != "f" {
                
                    ATTACHED_DATETIME.append(DATA.ATTACHED_DATETIME.components(separatedBy: "|")[i])
                    ATTACHED_DT_FROM.append(DATA.ATTACHED_DT_FROM.components(separatedBy: "|")[i])
                    ATTACHED_FILE_NAME.append(DATA.ATTACHED_FILE_NAME.components(separatedBy: "|")[i])
                    ATTACHED_FILE_NAME_ORG.append(DATA.ATTACHED_FILE_NAME_ORG.components(separatedBy: "|")[i])
                    ATTACHED_FILE_SIZE.append(DATA.ATTACHED_FILE_SIZE.components(separatedBy: "|")[i])
                    ATTACHED_IDX.append(DATA.ATTACHED_IDX.components(separatedBy: "|")[i])
                    ATTACHED_IN_SEQ.append(DATA.ATTACHED_IN_SEQ.components(separatedBy: "|")[i])
                    ATTACHED_LAT.append(DATA.ATTACHED_LAT.components(separatedBy: "|")[i])
                    ATTACHED_LNG.append(DATA.ATTACHED_LNG.components(separatedBy: "|")[i])
                    ATTACHED_MEDIA_FILES.append(DATA.ATTACHED_MEDIA_FILES.components(separatedBy: "|")[i])
                    ATTACHED_MEDIA_TYPE.append(DATA.ATTACHED_MEDIA_TYPE.components(separatedBy: "|")[i])
                    ATTACHED_MSG_GROUP.append(DATA.ATTACHED_MSG_GROUP.components(separatedBy: "|")[i])
                    ATTACHED_HTTP_STRING.append(DATA.ATTACHED_HTTP_STRING.components(separatedBy: "|")[i])
//                }
            }
        }
        
        if DATA.DATETIME == "0000-00-00 00:00:00" || DATA.DATETIME == "" {
            
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
        if DATA.SC_LOGO == "" {
            if DATA.SC_CODE != "" {
                let IMAGE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().SCHOOL_LOGO_URL) + DATA.SC_CODE
                let KOREAN_URL = IMAGE_URL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                NUKE_IMAGE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: UIImage(named: "school_")!, PROFILE: School_Symbol_Image, FRAME_SIZE: School_Symbol_Image.frame.size)
            }
        } else {
            let IMAGE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().SCHOOL_LOGO_URL) + DATA.SC_LOGO
            let KOREAN_URL = IMAGE_URL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            NUKE_IMAGE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: UIImage(named: "school_")!, PROFILE: School_Symbol_Image, FRAME_SIZE: School_Symbol_Image.frame.size)
        }
        School_Symbol_Image.layer.cornerRadius = 20.0
        School_Symbol_Image.clipsToBounds = true
        School_Label.text = DATA.SC_NAME
        School_Date_Label.text = self.DATETIME
        School_Day_Label.text = self.DATETIME2
            
        if DATA.ATTACHED.count == 0 {
            
            // 첨부파일 확인
            if ATTACHED_MEDIA_TYPE.count == 0 {
                
                School_Filename_Image.image = UIImage(named: "ico_shcool_file_n.png")
                School_Filename_Label.text = "첨부파일 없음"
                School_Filename_Button.isHidden = true
            } else {
                
                var FILE_NAME: String = ""
                var FILE_URL: String = ""
                
                for i in 0 ..< ATTACHED_MEDIA_TYPE.count {
                    
                    if ATTACHED_MEDIA_TYPE[i] == "f" {
                        FILE_NAME.append("\(ATTACHED_FILE_NAME[i])|")
                        FILE_URL.append("\(ATTACHED_MEDIA_FILES[i])|")
                    }
                }
                
                if FILE_NAME == "" && FILE_URL == "" {
                    
                    School_Filename_Image.image = UIImage(named: "ico_shcool_file_n.png")
                    School_Filename_Label.text = "첨부파일 없음"
                    School_Filename_Button.isHidden = true
                } else {
                    
                    School_Filename_Image.image = UIImage(named: "ico_shcool_file_s.png")
                    School_Filename_Label.text = "파일 보기"
                    School_Filename_Button.isHidden = false
                    School_Filename_Button.tag = SCHOOL_POSITION
                    School_Filename_Button.addTarget(self, action: #selector(FILE_DOWNLOAD(_:)), for: .touchUpInside)
                }
            }
        } else {
            
            // 첨부파일 확인
            if DATA.ATTACHED.count == 0 {
                
                School_Filename_Image.image = UIImage(named: "ico_shcool_file_n.png")
                School_Filename_Label.text = "첨부파일 없음"
                School_Filename_Button.isHidden = true
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
                    
                    School_Filename_Image.image = UIImage(named: "ico_shcool_file_n.png")
                    School_Filename_Label.text = "첨부파일 없음"
                    School_Filename_Button.isHidden = true
                } else {
                    
                    School_Filename_Image.image = UIImage(named: "ico_shcool_file_s.png")
                    School_Filename_Label.text = "파일 보기"
                    School_Filename_Button.isHidden = false
                    School_Filename_Button.tag = SCHOOL_POSITION
                    School_Filename_Button.addTarget(self, action: #selector(FILE_DOWNLOAD(_:)), for: .touchUpInside)
                }
            }
        }
        
//        // 좋아요
//        School_Like_Button.tag = SCHOOL_POSITION
//        School_Like_Button.addTarget(self, action: #selector(LIKE(_:)), for: .touchUpInside)
        
        if DATA.LIKE == true {
            School_Like_Image.image = UIImage(named: "like_red.png")
        } else {
            School_Like_Image.image = UIImage(named: "ico_shcool_heart_n.png")
        }
        
        // 공유하기
        School_Share_Button.tag = SCHOOL_POSITION
        School_Share_Button.addTarget(self, action: #selector(SHARE(_:)), for: .touchUpInside)
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
        
        if SCHOOL_API[sender.tag].ATTACHED.count == 0 {
            
            for i in 0 ..< ATTACHED_MEDIA_TYPE.count {
                
                if ATTACHED_MEDIA_TYPE[i] == "f" {
                    
                    if ATTACHED_FILE_SIZE[i] == "" {
                        SYSTEM_ID.append("-|")
                    } else {
                        SYSTEM_ID.append("\(ATTACHED_FILE_SIZE[i])|")
                    }
                    FILE_NAME.append("\(ATTACHED_FILE_NAME_ORG[i])|")
                    FILE_URL.append("\(ATTACHED_MEDIA_FILES[i])|")
                    IDX.append("\(ATTACHED_IDX[i])|")
                    MSG_GROUP.append("\(ATTACHED_MSG_GROUP[i])|")
                    DT_FROM.append("\(ATTACHED_DT_FROM[i])|")
                }
            }
        } else {
            
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
    
//    // 좋아요
//    @objc func LIKE(_ sender: UIButton) {
//
//        HTTP_SOSIK_UPDATE(ACTION_TYPE: "like")
//
//        let DATA = SCHOOL_API[SCHOOL_POSITION]
//
//        if DATA.LIKE == false {
//            DATA.LIKE = true
//            School_Like_Image.image = UIImage(named: "like_red.png")
//            EFFECT_ALERT_VIEW(UIImage(named: "like_red.png")!, "좋아요!", "스크랩에 추가되었습니다")
//            SCRAP()
//        } else {
//            DATA.LIKE = false
//            School_Like_Image.image = UIImage(named: "ico_shcool_heart_n.png")
//            UIViewController.APPDELEGATE.DELETE_DB_MAIN(IDX: SCHOOL_API[SCHOOL_POSITION].IDX)
//        }
//    }
    
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

                let TEXT = "[ \(DATA.SC_NAME) ]\n\n\(DECODED_TITLE)\nhttps://damoaapp.pen.go.kr/card/_view.php?idx=\(DATA.IDX)"
                let TEXT_SHARE = [TEXT]
                let AVC = UIActivityViewController(activityItems: TEXT_SHARE, applicationActivities: nil)
                AVC.popoverPresentationController?.sourceView = self.view
                self.present(AVC, animated: true, completion: nil)
            }
        }
    }
    
    func HTTP_SOSIK_UPDATE(ACTION_TYPE: String) {
        
        let DATA = SCHOOL_API[SCHOOL_POSITION]
        
        let PARAMETERS: Parameters = [
            "mb_id": UIViewController.USER_DATA.string(forKey: "mb_id") ?? "",
            "board_key": DATA.BOARD_KEY,
            "board_type": BOARD_TYPE,
            "action_type": ACTION_TYPE
        ]
        
        print("PARAMETERS -", PARAMETERS)
        
        Alamofire.upload(multipartFormData: { multipartFormData in

            for (KEY, VALUE) in PARAMETERS {
                
                print("KEY: \(KEY)", "value: \(VALUE)")
                multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
            }
        }, to: "https://dapp.uic.me/conn/message/school_board_update.php") { (result) in
        
            switch result {
            case .success(let upload, _, _):
            
            upload.responseString { response in
                print("[소식업데이트] ", response)
            }
            case .failure(let encodingError):
                
                print(encodingError)
                break
            }
        }
    }
}

extension SOSIK_DETAIL: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if SCHOOL_API.count == 0 {
            TableView.isHidden = true
            return 0
        } else {
            TableView.isHidden = false
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = SCHOOL_API[SCHOOL_POSITION]
        
        if DATA.SUBJECT == "" {
            self.DECODED_TITLE = ""
        } else {
            let BASE64_ENCODE = Data(base64Encoded: DATA.SUBJECT, options: [])
            if let BASE64_ENCODE = BASE64_ENCODE {
                let DECODED_TITLE = String(data: BASE64_ENCODE, encoding: .utf8) ?? "UTF8 오류 처리중 . . ."
                self.DECODED_TITLE = DECODED_TITLE.replacingOccurrences(of: "&apos;", with: "").replacingOccurrences(of: "%2520", with: "%20")
            }
        }
        
        if DATA.CONTENT == "" {
            self.DECODED_CONTENT = ""
        } else {
            let BASE64_ENCODE = Data(base64Encoded: DATA.CONTENT, options: [])
            if let BASE64_ENCODE = BASE64_ENCODE {
                self.DECODED_CONTENT = String(data: BASE64_ENCODE, encoding: .utf8) ?? "UTF8 오류 처리중 . . ."
            }
            let DECODED_CONTENT = self.DECODED_CONTENT.replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "&apos;", with: "").replacingOccurrences(of: "%2520", with: "%20")
            
            print(DECODED_CONTENT)
            self.DECODED_CONTENT = DECODED_CONTENT
        }
        
        var HTML_STRING = DATA.CONTENT
        if self.DECODED_CONTENT != "" && (self.DECODED_CONTENT == "") == false { HTML_STRING = self.DECODED_CONTENT }
        
        var ATTRIBUTED_STRING: NSAttributedString? = nil
        do {
            if let DATA_ = HTML_STRING.data(using: .unicode) {
                ATTRIBUTED_STRING = try NSAttributedString(data: DATA_, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            }
        } catch { }
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "SOSIK_DETAIL_TC", for: indexPath) as! SOSIK_DETAIL_TC
        
        CELL.SCHOOL_API = SCHOOL_API
        CELL.SCHOOL_POSITION = SCHOOL_POSITION
        
        CELL.PROTOCOL = self
        
        // 미디어
        if DATA.ATTACHED.count == 0 {
            
            var ATTACHED_: [String] = []
            
            if ATTACHED_MEDIA_TYPE.count != 0 {
                for i in 0 ..< ATTACHED_MEDIA_TYPE.count {
                    if ATTACHED_MEDIA_TYPE[i] != "f" { ATTACHED_.append(ATTACHED_MEDIA_TYPE[i]) }
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
        } else {
            
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
        }
        
        if DECODED_TITLE.count <= 36 {
            CELL.School_Subject_Label.frame.size.height = 20
        } else {
            CELL.School_Subject_Label.frame.size.height = 60
        }
        
        if (DATA.TARGET_GRADE == "") && (DATA.TARGET_CLASS == "") {
            CELL.School_Subject_Label.text = DECODED_TITLE
        } else {
            if DATA.TARGET_GRADE == "" {
                if DATA.TARGET_CLASS == "0" {
                    CELL.School_Subject_Label.text = DECODED_TITLE
                } else {
                    CELL.School_Subject_Label.text = "[ \(DATA.TARGET_CLASS)반 ] \(DECODED_TITLE)"
                }
            } else {
                if (DATA.TARGET_GRADE == "0") || (DATA.TARGET_CLASS == "0") {
                    CELL.School_Subject_Label.text = DECODED_TITLE
                } else {
                    CELL.School_Subject_Label.text = "[ \(DATA.TARGET_GRADE)학년 \(DATA.TARGET_CLASS)반 ] \(DECODED_TITLE)"
                }
            }
        }
        CELL.School_Notice_Content_Label.isEditable = false
//        CELL.School_Notice_Content_Label.text = ATTRIBUTED_STRING?.string.trimmingCharacters(in: .whitespacesAndNewlines)
        CELL.School_Notice_Content_Label.attributedText = ATTRIBUTED_STRING?.TEXTVIEW_IMAGE_WIDTH_SIZE(WIDTH: view.frame.size.width - 40)
        CELL.School_Notice_Content_Label.dataDetectorTypes = .link
        
        if DATA.CONTENT_TEXT == "IA==" { CELL.LineView.isHidden = true } else { CELL.LineView.isHidden = false }
        
        return CELL
    }
}

// MARK: - 텍스트뷰 HTML_TO_STRING 이미지 사이즈 변환 (WIDTH)
extension NSAttributedString {
    
    func TEXTVIEW_IMAGE_WIDTH_SIZE(WIDTH MAX_WIDTH: CGFloat) -> NSAttributedString {
        
        let TEXT = NSMutableAttributedString(attributedString: self)
        TEXT.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, TEXT.length), options: .init(rawValue: 0), using: { (value, range, stop) in
            if let ATTACHEMENT = value as? NSTextAttachment {
                let IMAGE = ATTACHEMENT.image(forBounds: ATTACHEMENT.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                if IMAGE.size.width > MAX_WIDTH {
                    let NEW_IMAGE = IMAGE.RESIZE_IMAGE(SCALE: MAX_WIDTH/IMAGE.size.width)
                    let NEW_ATTRIBUT = NSTextAttachment()
                    NEW_ATTRIBUT.image = NEW_IMAGE
                    TEXT.addAttribute(NSAttributedString.Key.attachment, value: NEW_ATTRIBUT, range: range)
                }
            }
        })
        return TEXT
    }
}
extension UIImage {
    
    func RESIZE_IMAGE(SCALE: CGFloat) -> UIImage {
        
        let NEW_SIZE = CGSize(width: self.size.width * SCALE, height: self.size.height * SCALE)
        let RECT = CGRect(origin: CGPoint.zero, size: NEW_SIZE)

        UIGraphicsBeginImageContext(NEW_SIZE)
        self.draw(in: RECT)
        let NEW_IMAGE = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return NEW_IMAGE!
    }
}

extension UIImageView {
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                UIImageWriteToSavedPhotosAlbum(UIImage(data: data)!, nil, nil, nil)
            }
        }
    }
}
