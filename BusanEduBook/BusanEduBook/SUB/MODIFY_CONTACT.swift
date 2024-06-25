//
//  MODIFY_CONTACT.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/08/06.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire

// 연락처 수정 (처리완료)
class MODIFY_CONTACT: UIViewController, MFMessageComposeViewControllerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var INDIVIDUAL_CONTACT_DETAIL_API: [INDIVIDUAL_CONTACT_DETAIL_DATA] = []
    var POSITION: Int = 0
    
    var ACTION_TYPE: String = ""
    var BG_NO: String = ""
    var BK_NO: String = ""
    
    @IBOutlet weak var TITLE_LABEL: UILabel!
    
    @IBOutlet weak var SCROLL_VIEW: UIScrollView!
    @IBOutlet weak var PROFILE_IMAGE: UIImageView!      // 이미지
    @IBOutlet weak var PROFILE_NAME: UILabel!           // 이름
    @IBOutlet weak var PROFILE_GRADE: UILabel!          // 그룹명
    
    @IBOutlet weak var FAVORITE_IMAGE: UIImageView!
    @IBOutlet weak var FAVORITE_BTN: UIButton!          // 즐겨찾기
    @IBOutlet weak var CALL: UIButton!                  // 전화
    @IBOutlet weak var MESSAGE_BTN: UIButton!           // 메시지
    
    @IBOutlet weak var BK_HP_VIEW: UIView!              // 휴대전화
    @IBOutlet weak var BK_HP_TITLE: UILabel!            // 휴대전화
    @IBOutlet weak var BK_HP: UILabel!                  // 휴대전화
    @IBOutlet weak var BK_PHONE_VIEW: UIView!           // 사무실
    @IBOutlet weak var BK_PHONE_TITLE: UILabel!         // 사무실
    @IBOutlet weak var BK_PHONE: UILabel!               // 사무실
    @IBOutlet weak var BG_NAME: UILabel!                // 그룹명
    @IBOutlet weak var MEMO: UILabel!                   // 메모

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TITLE_LABEL.alpha = 0.0
        SCROLL_VIEW.delegate = self
        
        PROFILE_IMAGE.layer.cornerRadius = 50.0
        PROFILE_IMAGE.clipsToBounds = true
        
        if INDIVIDUAL_CONTACT_DETAIL_API.count != 0 {
            
            let DATA = INDIVIDUAL_CONTACT_DETAIL_API[POSITION]
            
            // 이름
            if DATA.BK_NAME != "" {
                TITLE_LABEL.text = DATA.BK_NAME
                PROFILE_NAME.text = DATA.BK_NAME
            }
            // 그룹명
            if DATA.BG_NAME != "" {
                PROFILE_GRADE.text = DATA.BG_NAME
                BG_NAME.text = DATA.BG_NAME
            }
            if DATA.BK_TYPE == "c" { BK_HP_TITLE.text = "학생"; BK_PHONE_TITLE.text = "학부모"; }
            // 휴대전화
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
            } else {
                BK_HP_VIEW.isHidden = true
            }
            print("전화",DATA.BK_HP)
            print("사무실",DATA.BK_PHONE)
            // 사무실
            if DATA.BK_PHONE != "" {
                if DATA.BK_PHONE.count <= 8 {
                    BK_PHONE.text = FORMAT(MASK: "XXXX-XXXX", PHONE: DATA.BK_PHONE)
                } else if DATA.BK_PHONE.count <= 10 {
                    BK_PHONE.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: DATA.BK_PHONE)
                } else if DATA.BK_PHONE.count >= 11 && DATA.BK_PHONE.count <= 12 {
                    BK_PHONE.text = FORMAT(MASK: "XXX-XXXX-XXXXX", PHONE: DATA.BK_PHONE)
                } else {
                    BK_PHONE.text = DATA.BK_PHONE
                }
            } else {
                BK_PHONE_VIEW.isHidden = true
            }
            // 메모
            if DATA.MEMO != "" { MEMO.text = DATA.MEMO }
            // 즐겨찾기
            FAVORITE_BTN.addTarget(self, action: #selector(FAVORITE_BTN(_:)), for: .touchUpInside)
            // 전화
            CALL.addTarget(self, action: #selector(CALL_BTN(_:)), for: .touchUpInside)
            // 메시지
            MESSAGE_BTN.addTarget(self, action: #selector(MESSAGE_BTN(_:)), for: .touchUpInside)
        }
    }
    
    // 즐겨찾기
    @objc func FAVORITE_BTN(_ sender: UIButton) {
        
    }
    // 전화
    @objc func CALL_BTN(_ sender: UIButton) {
        
        if INDIVIDUAL_CONTACT_DETAIL_API.count != 0 {
        
            let DATA = INDIVIDUAL_CONTACT_DETAIL_API[POSITION]
            
            if DATA.BK_PHONE != "" && DATA.BK_HP != "" {
                
                let ALERT = UIAlertController(title: "전화", message: nil, preferredStyle: .actionSheet)
                
                if DATA.BK_TYPE == "c" {
                    
                    ALERT.addAction(UIAlertAction(title: "학생", style: .default) { (_) in
                        if DATA.BK_HP != "" { UIApplication.shared.open(URL(string: "tel://" + DATA.BK_HP)!) }
                    })
                    ALERT.addAction(UIAlertAction(title: "학부모", style: .default) { (_) in
                        if DATA.BK_PHONE != "" { UIApplication.shared.open(URL(string: "tel://" + DATA.BK_PHONE)!) }
                    })
                } else {
                    
                    ALERT.addAction(UIAlertAction(title: "휴대전화", style: .default) { (_) in
                        if DATA.BK_HP != "" { UIApplication.shared.open(URL(string: "tel://" + DATA.BK_HP)!) }
                    })
                    ALERT.addAction(UIAlertAction(title: "사무실", style: .default) { (_) in
                        if DATA.BK_PHONE != "" { UIApplication.shared.open(URL(string: "tel://" + DATA.BK_PHONE)!) }
                    })
                }
                let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)

                ALERT.addAction(CANCEL)
                CANCEL.setValue(UIColor.red, forKey: "titleTextColor")
                
                present(ALERT, animated: true)
            } else {
                
                if DATA.BK_HP != "" {
                    UIApplication.shared.open(URL(string: "tel://" + DATA.BK_HP)!)
                } else if DATA.BK_PHONE != "" {
                    UIApplication.shared.open(URL(string: "tel://" + DATA.BK_PHONE)!)
                } else {
                    NOTIFICATION_VIEW("전화를 사용할 수 없습니다")
                }
            }
        }
    }
    // 메시지
    @objc func MESSAGE_BTN(_ sender: UIButton) {
        
        let MC = MFMessageComposeViewController()
        MC.messageComposeDelegate = self
        
        if INDIVIDUAL_CONTACT_DETAIL_API.count != 0 {
        
            let DATA = INDIVIDUAL_CONTACT_DETAIL_API[POSITION]
            
            if DATA.BK_PHONE != "" && DATA.BK_HP != "" {
                
                let ALERT = UIAlertController(title: "전화", message: nil, preferredStyle: .actionSheet)
                
                if DATA.BK_TYPE == "c" {
                    
                    ALERT.addAction(UIAlertAction(title: "학생", style: .default) { (_) in
                        if MFMessageComposeViewController.canSendText() {
                            MC.recipients = [DATA.BK_HP]
                            self.present(MC, animated: true, completion: nil)
                        }
                    })
                    ALERT.addAction(UIAlertAction(title: "학부모", style: .default) { (_) in
                        if MFMessageComposeViewController.canSendText() {
                            MC.recipients = [DATA.BK_PHONE]
                            self.present(MC, animated: true, completion: nil)
                        }
                    })
                } else {
                    
                    ALERT.addAction(UIAlertAction(title: "휴대전화", style: .default) { (_) in
                        if MFMessageComposeViewController.canSendText() {
                            MC.recipients = [DATA.BK_HP]
                            self.present(MC, animated: true, completion: nil)
                        }
                    })
                    ALERT.addAction(UIAlertAction(title: "사무실", style: .default) { (_) in
                        if MFMessageComposeViewController.canSendText() {
                            MC.recipients = [DATA.BK_PHONE]
                            self.present(MC, animated: true, completion: nil)
                        }
                    })
                }
                let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)

                ALERT.addAction(CANCEL)
                CANCEL.setValue(UIColor.red, forKey: "titleTextColor")
                
                present(ALERT, animated: true)
            } else {
                
                if DATA.BK_HP != "" {
                    if MFMessageComposeViewController.canSendText() {
                        MC.recipients = [DATA.BK_HP]
                        self.present(MC, animated: true, completion: nil)
                    }
                } else if DATA.BK_PHONE != "" {
                    if MFMessageComposeViewController.canSendText() {
                        MC.recipients = [DATA.BK_PHONE]
                        self.present(MC, animated: true, completion: nil)
                    }
                } else {
                    NOTIFICATION_VIEW("메시지를 사용할 수 없습니다")
                }
            }
        }
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
    // 연락처_수정
    @IBAction func UPDATE_VC(_ sender: UIButton) {
        
        if INDIVIDUAL_CONTACT_DETAIL_API.count != 0 {
            
            let DATA = INDIVIDUAL_CONTACT_DETAIL_API[POSITION]
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ADD_CONTACT") as! ADD_CONTACT
            VC.modalTransitionStyle = .crossDissolve
            VC.NEW = false
            VC.BK_NAME = DATA.BK_NAME   // 이름
            VC.BK_HP = DATA.BK_HP       // 휴대전화
            VC.BK_PHONE = DATA.BK_PHONE // 사무실
            VC.BG_NAME = DATA.BG_NAME   // 그룹명
            VC.BK_NO = DATA.BK_NO
            VC.BG_NO = DATA.BG_NO
            VC.MEMO = DATA.MEMO         // 메모
            present(VC, animated: true)
        }
    }
    // 연락처_삭제
    @IBAction func DELETE_VC(_ sender: UIButton) {
        
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            HTTP_DELETE_CONTACT()
        }
    }
    // 연락처_삭제
    func HTTP_DELETE_CONTACT() {
        
        let PARAMETERS: Parameters = [
            "action_type": "per_del",
            "bk_no": INDIVIDUAL_CONTACT_DETAIL_API[POSITION].BK_NO,
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

                print("[연락처삭제]", response)
                
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
}
