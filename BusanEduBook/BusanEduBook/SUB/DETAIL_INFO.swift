//
//  DETAIL_INFO.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/07/24.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire
//import CallKit
import MessageUI
import MapKit

class DETAIL_INFO: UIViewController, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var DETAIL_API: [DETAIL_DATA] = []
    var BK_NO: String = ""
    
    var SCHOOL_INFO_API: [SCHOOL_INFO_DATA] = []
    var SCHOOL_POSITION = 0
    var GMS_API: [GMS_DATA] = []
    
    @IBOutlet weak var TITLE_LABEL: UILabel!
    
    @IBOutlet weak var SCROLL_VIEW: UIScrollView!
    @IBOutlet weak var PROFILE_IMAGE: UIImageView!      // 이미지
    @IBOutlet weak var PROFILE_NAME: UILabel!           // 이름
    @IBOutlet weak var PROFILE_GRADE: UILabel!          // 직급
    
    @IBOutlet weak var FAVORITE_BTN: UIButton!          // 즐겨찾기
    @IBOutlet weak var FAVORITE_IMAGE: UIImageView!
    
    @IBOutlet weak var MESSAGE_BTN: UIButton!           // 메시지
    
    @IBOutlet weak var DETAIL_INFO_STACVIEW: UIStackView!
    
    @IBOutlet weak var BK_HP_VIEW: UIView!
    @IBOutlet weak var BK_HP: UILabel!                  // 휴대전화
    @IBOutlet weak var MB_PHONE: UILabel!               // 사무실
    @IBOutlet weak var CALL_1: UIButton!
//    @IBOutlet weak var CALL_2: UIButton!
    @IBOutlet weak var SC_NAME: UILabel!                // 소속
    @IBOutlet weak var EDUBOOK_GRADE: UILabel!          // 직급
    @IBOutlet weak var MB_ROLE: UILabel!                // 담당업무
    
    @IBOutlet weak var DETAIL_SCHOOL_INFO_STACVIEW: UIStackView!
    
    @IBOutlet weak var SC_TEL: UILabel!                 // 전화번호
    @IBOutlet weak var CALL_3: UIButton!
//    @IBOutlet weak var CALL_4: UIButton!
    @IBOutlet weak var SC_FAX: UILabel!                 // 팩스번호
    @IBOutlet weak var SC_NAME_2: UILabel!              // 학교명
    @IBOutlet weak var SC_HOMEPAGE: UILabel!            // 홈페이지
    @IBOutlet weak var OPEN_HOMEPAGE: UIButton!
    @IBOutlet weak var SC_ADDRESS: UILabel!             // 학교위치
    @IBOutlet weak var MAP_VIEW: MKMapView!             // 맵_뷰
    
    // 로딩인디케이터
    let VIEW = UIView()
    override func loadView() {
        super.loadView()
        
        EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TITLE_LABEL.alpha = 0.0
        SCROLL_VIEW.delegate = self
        
        DETAIL_INFO_STACVIEW.isHidden = false
        DETAIL_SCHOOL_INFO_STACVIEW.isHidden = true
        
        if SCHOOL_INFO_API.count == 0 {
            
            if !SYSTEM_NETWORK_CHECKING() {
                NOTIFICATION_VIEW("검색어를 입력해주세요")
            } else {
                HTTP_DETAIL_INFO()
            }
        } else {
            
            if SCHOOL_INFO_API[SCHOOL_POSITION].SC_ADDRESS == "" {
                CSS()
            } else {
                if !SYSTEM_NETWORK_CHECKING() {
                    NOTIFICATION_VIEW("검색어를 입력해주세요")
                } else {
                    HTTP_MAP(SC_ADDRESS: SCHOOL_INFO_API[SCHOOL_POSITION].SC_ADDRESS)
                }
            }
        }
        
        MAP_VIEW.layer.cornerRadius = 10.0
        MAP_VIEW.clipsToBounds = true
        MAP_VIEW.delegate = self
        // 스케일을 표시한다.
        MAP_VIEW.showsScale = true
        // 회전 가능 여부
        MAP_VIEW.isRotateEnabled = false
        if #available(iOS 13.0, *) { MAP_VIEW.overrideUserInterfaceStyle = .light }
        
        PROFILE_IMAGE.layer.cornerRadius = 50.0
        PROFILE_IMAGE.clipsToBounds = true
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
        case .sent:
            print("전송 완료")
            break
        case .cancelled:
            print("취소")
            break
        case .failed:
            print("전송 실패")
            break
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func HTTP_DETAIL_INFO() {
        
        let PARAMETERS: Parameters = [
            "action_type": "person",
            "bk_no": BK_NO
        ]
        
        let BASE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().BASE_URL)
        
        Alamofire.request(BASE_URL, method: .post, parameters: PARAMETERS).responseJSON { response in
            
            print("[자세히]", response)
            self.DETAIL_API.removeAll()
            
            guard let DETAIL_ARRAY = response.result.value as? Array<Any> else {
                print("[자세히] FAIL")
                self.DETAIL_API.removeAll()
                return
            }
            
            for (_, DATA) in DETAIL_ARRAY.enumerated() {
                
                let PUT_DATA = DETAIL_DATA()
                
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
                    
                    self.DETAIL_API.append(PUT_DATA)
                }
            }
            
            self.CSS()
        }
    }
    
    func HTTP_MAP(SC_ADDRESS: String) {
        
        let SC_LOCATION = SC_ADDRESS.replacingOccurrences(of: "%2520", with: "%20").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        
        let GET_PLACE = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input="+SC_LOCATION!+"&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyB7LDRjki-RZgn8X7Fr9S0GYZnbyHMGnrQ"
        
        Alamofire.request(GET_PLACE, method: .post, parameters: nil).responseJSON { response in
            
            print("[학교정보위치]", response)
            self.GMS_API.removeAll()
            
            guard let CANDIDATES_DICT = response.result.value as? [String: Any] else {
                return
            }
            
            guard let CANDIDATES_ARRAY = CANDIDATES_DICT["candidates"] as? Array<Any> else {
                return
            }
            
            for (_, DATA) in CANDIDATES_ARRAY.enumerated() {

                let PUT_DATA = GMS_DATA()
                
                let DATADICT = DATA as? [String: Any]
                
                let GEOMETRY = DATADICT?["geometry"] as? [String: Any]
                let LOCATION = GEOMETRY?["location"] as? [String: Any]
                PUT_DATA.SET_LAT(LAT: LOCATION?["lat"] as Any)
                PUT_DATA.SET_LNG(LNG: LOCATION?["lng"] as Any)
                
                PUT_DATA.SET_NAME(NAME: DATADICT?["name"] as Any)
                
                self.GMS_API.append(PUT_DATA)
            }
            
            self.CSS()
        }
    }
    
    func CSS() {
        
        EFFECT_INDICATOR_VIEW_HIDDEN(VIEW)
        
        if SCHOOL_INFO_API.count == 0 {
            
            DETAIL_INFO_STACVIEW.isHidden = false
            DETAIL_SCHOOL_INFO_STACVIEW.isHidden = true
            
            if DETAIL_API.count != 0 {
                
                let DATA = DETAIL_API[0]
                
                // 이미지
                if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" && DATA.MB_FILE != "" {
                    let IMAGE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().PROFILE_IMAGE_URL) + DATA.MB_FILE
                    let KOREAN_URL = IMAGE_URL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                    NUKE_IMAGE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: UIImage(named: "busanlogo.png")!, PROFILE: PROFILE_IMAGE, FRAME_SIZE: PROFILE_IMAGE.frame.size)
                    // 프로필 이미지 상세보기
                    let ADD_TARGET = UITapGestureRecognizer(target: self, action: #selector(NEXT_VC(_:)))
                    PROFILE_IMAGE.isUserInteractionEnabled = true
                    PROFILE_IMAGE.addGestureRecognizer(ADD_TARGET)
                }
                // 이름
                if DATA.BK_NAME != "" {
                    TITLE_LABEL.text = DATA.BK_NAME
                    PROFILE_NAME.text = DATA.BK_NAME
                }
                // 그룹명
                if DATA.EDUBOOK_GRADE != "" {
                    PROFILE_GRADE.text = DATA.EDUBOOK_GRADE
                    EDUBOOK_GRADE.text = DATA.EDUBOOK_GRADE
                }
                // 휴대전화
                if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
                    BK_HP_VIEW.isHidden = false
                    if DATA.BK_HP != "" {
                        if DATA.BK_HP.count <= 8 {
                            BK_HP.text = FORMAT(MASK: "XXXX-XXXX", PHONE: DATA.BK_HP)
                        } else if DATA.BK_HP.count <= 10 {
                            BK_HP.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: DATA.BK_HP)
                        } else if DATA.BK_HP.count >= 11 && DATA.BK_HP.count <= 12 {
                            BK_HP.text = FORMAT(MASK: "XXX-XXXX-XXXXX", PHONE: DATA.BK_HP)
                        } else {
                            BK_HP.text = DATA.BK_HP
                        }
                    }
                } else {
                    BK_HP_VIEW.isHidden = true
                }
                // 사무실
                if DATA.MB_PHONE != "" {
                    if DATA.MB_PHONE.count <= 8 {
                        MB_PHONE.text = FORMAT(MASK: "XXXX-XXXX", PHONE: DATA.MB_PHONE)
                    } else if DATA.MB_PHONE.count <= 10 {
                        MB_PHONE.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: DATA.MB_PHONE)
                    } else if DATA.MB_PHONE.count >= 11 && DATA.MB_PHONE.count <= 12 {
                        MB_PHONE.text = FORMAT(MASK: "XXX-XXXX-XXXXX", PHONE: DATA.MB_PHONE)
                    } else {
                        MB_PHONE.text = DATA.MB_PHONE
                    }
                }
                // 소속
                if DATA.SC_NAME != "" { SC_NAME.text = DATA.SC_NAME }
                // 직위(직급)
                if DATA.MB_ROLE != "" {
                    if DATA.MB_ROLE2 == "" {
                        MB_ROLE.text = "· \(DATA.MB_ROLE)"
                    } else {
                        MB_ROLE.text = "· \(DATA.MB_ROLE)\n· \(DATA.MB_ROLE2)"
                    }
                }
                
                // 즐겨찾기
                FAVORITE_BTN.addTarget(self, action: #selector(FAVORITE_BTN(_:)), for: .touchUpInside)
                // 전화
                CALL_1.addTarget(self, action: #selector(CALL_BTN(_:)), for: .touchUpInside)
//                CALL_2.addTarget(self, action: #selector(CALL_BTN(_:)), for: .touchUpInside)
                // 메시지
                MESSAGE_BTN.addTarget(self, action: #selector(MESSAGE_BTN(_:)), for: .touchUpInside)
            }
        } else {
            
            DETAIL_INFO_STACVIEW.isHidden = true
            DETAIL_SCHOOL_INFO_STACVIEW.isHidden = false
            
            let DATA = SCHOOL_INFO_API[SCHOOL_POSITION]
            
            PROFILE_IMAGE.image = UIImage(named: "busanlogo.png")
            
            // 이미지
            if DATA.SC_CODE != "" {
                let IMAGE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().SCHOOL_LOGO_URL) + DATA.SC_CODE
                let KOREAN_URL = IMAGE_URL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                NUKE_IMAGE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: UIImage(named: "busanlogo.png")!, PROFILE: PROFILE_IMAGE, FRAME_SIZE: PROFILE_IMAGE.frame.size)
                // 프로필 이미지 상세보기
                let ADD_TARGET = UITapGestureRecognizer(target: self, action: #selector(NEXT_VC(_:)))
                PROFILE_IMAGE.isUserInteractionEnabled = true
                PROFILE_IMAGE.addGestureRecognizer(ADD_TARGET)
            }
            // 이름
            if DATA.SC_NAME != "" {
                TITLE_LABEL.text = DATA.SC_NAME
                PROFILE_NAME.text = DATA.SC_NAME
                SC_NAME_2.text = DATA.SC_NAME
            }
            // 소속
            if DATA.SC_GROUP_NAME != "" {
                PROFILE_GRADE.text = DATA.SC_GROUP_NAME
                EDUBOOK_GRADE.text = DATA.SC_GROUP_NAME
            }
            // 전화
            if DATA.SC_TEL != "" { SC_TEL.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: DATA.SC_TEL) }
            // 팩스
            if DATA.SC_FAX != "" { SC_FAX.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: DATA.SC_FAX) }
            // 홈페이지
            if DATA.SC_HOME_PAGE != "" {
                if DATA.SC_HOME_PAGE.contains("https://") || DATA.SC_HOME_PAGE.contains("http://") {
                    SC_HOMEPAGE.text = DATA.SC_HOME_PAGE
                } else {
                    SC_HOMEPAGE.text = "http://" + DATA.SC_HOME_PAGE
                }
            }
            // 주소
            if DATA.SC_ADDRESS != "" { SC_ADDRESS.text = DATA.SC_ADDRESS }
            
            if GMS_API.count != 0 {
                
                // 특수 효과 제거
                let ANNOTATIONS = MAP_VIEW.annotations
                MAP_VIEW.removeAnnotations(ANNOTATIONS)
                
                let MAP_DATA = GMS_API[0]
                let ANNOTATION = MKPointAnnotation()
                ANNOTATION.title = DATA.SC_ADDRESS
                ANNOTATION.coordinate = CLLocationCoordinate2D(latitude: MAP_DATA.LAT, longitude: MAP_DATA.LNG)
                MAP_VIEW.addAnnotation(ANNOTATION)
                
                // 특수 효과 확대
                let COORDINATE = CLLocationCoordinate2D(latitude: MAP_DATA.LAT, longitude: MAP_DATA.LNG)
                let SPAN = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                let REGION = MKCoordinateRegion(center: COORDINATE, span: SPAN)
                MAP_VIEW.setRegion(REGION, animated: true)
            }
            
            // 즐겨찾기
            FAVORITE_BTN.addTarget(self, action: #selector(FAVORITE_BTN(_:)), for: .touchUpInside)
            // 전화
            CALL_3.addTarget(self, action: #selector(CALL_BTN(_:)), for: .touchUpInside)
//            CALL_4.addTarget(self, action: #selector(CALL_BTN(_:)), for: .touchUpInside)
            // 메시지
            MESSAGE_BTN.addTarget(self, action: #selector(MESSAGE_BTN(_:)), for: .touchUpInside)
            
            OPEN_HOMEPAGE.addTarget(self, action: #selector(OPEN_HOMEPAGE(_:)), for: .touchUpInside)
        }
    }
    
    // 프로필 이미지 상세보기
    @objc func NEXT_VC(_ sender: UIButton) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "DETAIL_IMAGE") as! DETAIL_IMAGE
        VC.modalTransitionStyle = .crossDissolve
        if SCHOOL_INFO_API.count == 0 {
            VC.IMAGE = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().PROFILE_IMAGE_URL) + DETAIL_API[0].MB_FILE
        } else {
            VC.IMAGE = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().SCHOOL_LOGO_URL) + SCHOOL_INFO_API[SCHOOL_POSITION].SC_CODE
        }
        
        present(VC, animated: true, completion: nil)
    }
    
    @objc func FAVORITE_BTN(_ sender: UIButton) {               // 즐겨찾기
        
        if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
        
            if sender.isSelected == false {
                sender.isSelected = true
                
//                FAVORITE_IMAGE.image = UIImage(named: "favorite_on.png")
//                NOTIFICATION_VIEW("개인주소록에 저장되었습니다")
                
                if DETAIL_API.count != 0 {
                    
                    let DATA = DETAIL_API[0]
                    
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "ADD_CONTACT") as! ADD_CONTACT
                    VC.modalTransitionStyle = .crossDissolve
                    
                    VC.NEW = true
                    VC.BK_NAME = DATA.BK_NAME   // 이름
                    VC.BK_HP = DATA.BK_HP      // 휴대전화
                    VC.BK_PHONE = DATA.MB_PHONE   // 사무실
                    
                    if DATA.SC_NAME != "" { VC.MEMO.append("소속 - \(DATA.SC_NAME)\n") }
                    if DATA.EDUBOOK_GRADE != "" { VC.MEMO.append("직위(직급) - \(DATA.EDUBOOK_GRADE)\n") }
                    if DATA.MB_ROLE != "" {
                        if DATA.MB_ROLE2 == "" {
                            VC.MEMO.append("담당업무 - \(DATA.MB_ROLE)")
                        } else {
                            VC.MEMO.append("담당업무 - \(DATA.MB_ROLE), \(DATA.MB_ROLE2)")
                        }
                    }
                    
                    present(VC, animated: true)
                } else if SCHOOL_INFO_API.count != 0 {
                    
                    let DATA = SCHOOL_INFO_API[SCHOOL_POSITION]
                    
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "ADD_CONTACT") as! ADD_CONTACT
                    VC.modalTransitionStyle = .crossDissolve
                    
                    VC.NEW = true
                    VC.BK_NAME = DATA.SC_NAME   // 이름
                    VC.BK_HP = DATA.SC_TEL      // 휴대전화
                    if DATA.SC_FAX != "" { VC.MEMO.append("팩스번호 - \(FORMAT(MASK: "XXX-XXX-XXXX", PHONE: DATA.SC_FAX))\n") }
                    if DATA.SC_HOME_PAGE != "" {
                        if DATA.SC_HOME_PAGE.contains("https://") || DATA.SC_HOME_PAGE.contains("http://") {
                            VC.MEMO.append("홈페이지 - \(DATA.SC_HOME_PAGE)\n")
                        } else {
                            VC.MEMO.append("홈페이지 - http://\(DATA.SC_HOME_PAGE)\n")
                        }
                    }
                    if DATA.SC_ADDRESS != "" { VC.MEMO.append("학교위치 - \(DATA.SC_ADDRESS)\n") }
                    
                    present(VC, animated: true)
                }
            } else {
                sender.isSelected = false
                
//                FAVORITE_IMAGE.image = UIImage(named: "favorite_off.png")
//                NOTIFICATION_VIEW("개인주소록에 삭제되였습니다")
            }
        } else {
            NOTIFICATION_VIEW("로그인 후 사용 가능합니다")
        }
    }
    
    @objc func CALL_BTN(_ sender: UIButton) {                   // 전화
        
        if DETAIL_API.count != 0 {
            
            let DATA = DETAIL_API[0]
            
            if DATA.MB_PHONE != "" && DATA.BK_HP != "" && UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
                
                let ALERT = UIAlertController(title: "전화", message: nil, preferredStyle: .actionSheet)
                
                ALERT.addAction(UIAlertAction(title: "휴대전화", style: .default) { (_) in
                    if DATA.BK_HP != "" { UIApplication.shared.open(URL(string: "tel://" + DATA.BK_HP)!) }
                })
                ALERT.addAction(UIAlertAction(title: "사무실", style: .default) { (_) in
                    if DATA.MB_PHONE != "" { UIApplication.shared.open(URL(string: "tel://" + DATA.MB_PHONE)!) }
                })
                let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)

                ALERT.addAction(CANCEL)
                CANCEL.setValue(UIColor.red, forKey: "titleTextColor")
                
                present(ALERT, animated: true)
            } else {
                
                if DATA.BK_HP != "" && UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
                    UIApplication.shared.open(URL(string: "tel://" + DATA.BK_HP)!)
                } else if DATA.MB_PHONE != "" {
                    UIApplication.shared.open(URL(string: "tel://" + DATA.MB_PHONE)!)
                } else {
                    NOTIFICATION_VIEW("전화를 사용할 수 없습니다")
                }
            }
        }
        
        if SCHOOL_INFO_API.count != 0 {
            if SCHOOL_INFO_API[SCHOOL_POSITION].SC_TEL != "" {
                UIApplication.shared.open(URL(string: "tel://" + SCHOOL_INFO_API[SCHOOL_POSITION].SC_TEL)!)
            } else {
                NOTIFICATION_VIEW("전화를 사용할 수 없습니다")
            }
        }
    }
    
    @objc func MESSAGE_BTN(_ sender: UIButton) {            // 메시지
        
        let MC = MFMessageComposeViewController()
        MC.messageComposeDelegate = self
        
        if DETAIL_API.count != 0 {
            
            let DATA = DETAIL_API[0]
            
            if DATA.MB_PHONE != "" && DATA.BK_HP != "" && UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
                
                let ALERT = UIAlertController(title: "메시지", message: nil, preferredStyle: .actionSheet)
                
                ALERT.addAction(UIAlertAction(title: "휴대전화", style: .default) { (_) in
                    if MFMessageComposeViewController.canSendText() {
                        MC.recipients = [DATA.BK_HP]
                        self.present(MC, animated: true, completion: nil)
                    }
                })
                ALERT.addAction(UIAlertAction(title: "사무실", style: .default) { (_) in
                    if MFMessageComposeViewController.canSendText() {
                        MC.recipients = [DATA.MB_PHONE]
                        self.present(MC, animated: true, completion: nil)
                    }
                })
                let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)

                ALERT.addAction(CANCEL)
                CANCEL.setValue(UIColor.red, forKey: "titleTextColor")
                
                present(ALERT, animated: true)
            } else {
                
                if DATA.BK_HP != "" && UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
                    if MFMessageComposeViewController.canSendText() {
                        MC.recipients = [DATA.BK_HP]
                        present(MC, animated: true, completion: nil)
                    }
                } else if DATA.MB_PHONE != "" {
                    if MFMessageComposeViewController.canSendText() {
                        MC.recipients = [DATA.MB_PHONE]
                        present(MC, animated: true, completion: nil)
                    }
                } else {
                    NOTIFICATION_VIEW("메시지를 사용할 수 없습니다")
                }
            }
        }
        
        if SCHOOL_INFO_API.count != 0 {
            if SCHOOL_INFO_API[SCHOOL_POSITION].SC_TEL != "" {
                UIApplication.shared.open(URL(string: "tel://" + SCHOOL_INFO_API[SCHOOL_POSITION].SC_TEL)!)
            } else {
                NOTIFICATION_VIEW("메시지를 사용할 수 없습니다")
            }
        }
    }
    
    @objc func OPEN_HOMEPAGE(_ sender: UIButton) {          // 홈페이지
        
        if SCHOOL_INFO_API.count != 0 {
            
            let HOME_PAGE = SCHOOL_INFO_API[SCHOOL_POSITION].SC_HOME_PAGE
            
            if HOME_PAGE != "" {
                
                if HOME_PAGE.contains("https://") || HOME_PAGE.contains("http://") {
                    UIApplication.shared.open(URL(string: HOME_PAGE)!)
                } else {
                    UIApplication.shared.open(URL(string: "http://" + HOME_PAGE)!)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if SCROLL_VIEW.contentOffset.y <= 0.0 {
            TITLE_LABEL.alpha = 0.0
        } else if SCROLL_VIEW.contentOffset.y <= 34.0 {
            TITLE_LABEL.alpha = 0.0
        } else if SCROLL_VIEW.contentOffset.y <= 38.0 {
            TITLE_LABEL.alpha = 0.2
        } else if SCROLL_VIEW.contentOffset.y <= 42.0 {
            TITLE_LABEL.alpha = 0.4
        } else if SCROLL_VIEW.contentOffset.y <= 46.0 {
            TITLE_LABEL.alpha = 0.6
        } else if SCROLL_VIEW.contentOffset.y <= 50.0 {
            TITLE_LABEL.alpha = 0.8
        } else {
            TITLE_LABEL.alpha = 1.0
        }
    }
    
//    func HTTP_FAVORITE(ACTION_TYPE: String) {
//
//        let PARAMETERS: Parameters = [
//            "action_type": ACTION_TYPE,
//            "": ""
//        ]
//    }
}

//extension DETAIL_INFO: CXProviderDelegate {
//
//    func CALL() {
//
//        let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "음성녹음"))
//        provider.setDelegate(self, queue: nil)
//        let update = CXCallUpdate()
//        update.remoteHandle = CXHandle(type: .generic, value: "부산광역시교육청")
//        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
//    }
//
//    func providerDidReset(_ provider: CXProvider) {
//
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
//        action.fulfill()
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
//        action.fulfill()
//    }
//}
