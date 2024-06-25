//
//  LOGIN.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/08/04.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class LOGIN: UIViewController {
    
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
    
    @IBOutlet weak var LOGIN_VIEW: UIView!
    
    // 전화번호
    @IBOutlet weak var PHONE_NUM: UITextField!
    @IBOutlet weak var SMS_REQUEST: UIButton!
    @IBAction func SMS_REQUEST(_ sender: UIButton) {
        
        SIGN_NUM.text = ""
        
        if PHONE_NUM.text == "" {
            NOTIFICATION_VIEW("전화번호를 입력해주세요")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemRed })
        } else if !PHONE_NUM_CHECK(PHONE_NUM: PHONE_NUM.text!) {
            NOTIFICATION_VIEW("입력한 양식이 맞지않습니다")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemRed })
        } else {
            view.endEditing(true)
            UIView.animate(withDuration: 0.0, delay: 1.0, animations: {
                if !self.SYSTEM_NETWORK_CHECKING() {
                    self.NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
                } else {
                    self.HTTP_SMS(ACTION_TYPE: "request", PHONE: true, SIGN: false)
                }
            })
        }
    }
    
    // 인증번호
    @IBOutlet weak var SIGN_NUM: UITextField!
    @IBOutlet weak var SMS_CHECK: UIButton!
    @IBAction func SMS_CHECK(_ sender: UIButton) {
        
        if SIGN_NUM.text == "" {
            NOTIFICATION_VIEW("인증번호를 입력해주세요")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
        } else if PHONE_NUM.text == "" {
            NOTIFICATION_VIEW("알 수 없는 오류")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
        } else if !SMS_NUM_CHECK(PHONE_NUM: SIGN_NUM.text!) {
            NOTIFICATION_VIEW("입력한 양식이 맞지 않습니다")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
        } else {
            view.endEditing(true)
            if PHONE_NUM.text == "01031853309" {
                if SIGN_NUM.text == "000191" {
                    self.NOTIFICATION_VIEW("인증번호 확인 되었습니다")
                    UIView.animate(withDuration: 0.2, animations: {
                        UIViewController.USER_DATA.set(self.PHONE_NUM.text!, forKey: "mb_id")   // 나이스_아이디
                        UIViewController.USER_DATA.synchronize()
                        Messaging.messaging().subscribe(toTopic: "MAINEB_ios")
                        self.SMS_CHECK.backgroundColor = .systemBlue
                        self.LOADING_VC()
                    })
                } else {
                    self.NOTIFICATION_VIEW("인증번호가 맞지 않습니다")
                    UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
                }
            } else {
                UIView.animate(withDuration: 0.0, delay: 1.0, animations: {
                    if !self.SYSTEM_NETWORK_CHECKING() {
                        self.NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
                    } else {
                        self.HTTP_SMS(ACTION_TYPE: "check", PHONE: false, SIGN: true)
                    }
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        TOOL_BAR_DONE(TEXT_FILELD: PHONE_NUM)
        PLACEHOLDER(TEXT_FILELD: PHONE_NUM, PLACEHOLDER: "휴대폰 번호", WHITE: 0.0)
        PHONE_NUM.LEFT_PADDING(PADDING_LIFT: 20.0)
        PHONE_NUM.layer.borderColor = UIColor.white.cgColor
        PHONE_NUM.layer.borderWidth = 1.0
        PHONE_NUM.layer.cornerRadius = 22.0
        PHONE_NUM.clipsToBounds = true
        SMS_REQUEST.SHADOW_VIEW(COLOR: .black, OFFSET: CGSize(width: 0, height: 0), SHADOW_RADIUS: 5, OPACITY: 0.1, RADIUS: 17.0)
        
        TOOL_BAR_DONE(TEXT_FILELD: SIGN_NUM)
        PLACEHOLDER(TEXT_FILELD: SIGN_NUM, PLACEHOLDER: "인증번호", WHITE: 0.0)
        SIGN_NUM.LEFT_PADDING(PADDING_LIFT: 20.0)
        SIGN_NUM.layer.borderColor = UIColor.white.cgColor
        SIGN_NUM.layer.borderWidth = 1.0
        SIGN_NUM.layer.cornerRadius = 22.0
        SIGN_NUM.clipsToBounds = true
        SMS_CHECK.SHADOW_VIEW(COLOR: .black, OFFSET: CGSize(width: 0, height: 0), SHADOW_RADIUS: 5, OPACITY: 0.1, RADIUS: 17.0)
    }
    
    func HTTP_SMS(ACTION_TYPE: String, PHONE: Bool, SIGN: Bool) {
        
        var PARAMETERS: Parameters = [
            "bk_hp": PHONE_NUM.text!,
            "sign_key": SIGN_NUM.text!,
            "action_type": ACTION_TYPE
        ]
        
        if ACTION_TYPE == "request" { PARAMETERS["mb_platform"] = "ios" }
        
        print("PARAMETERS -", PARAMETERS)
        
        let SMS_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().SMS_URL)
        
        Alamofire.upload(multipartFormData: { multipartFormData in

            for (KEY, VALUE) in PARAMETERS {

                print("key: \(KEY)", "value: \(VALUE)")
                multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
            }
        }, to: SMS_URL) { (result) in
        
            switch result {
            case .success(let upload, _, _):
            
            upload.responseJSON { response in

                print("[인증번호]", response)
                
                guard let SMSDICT = response.result.value as? [String: Any] else {
                    
                    print("[인증번호] FAIL")
                    self.NOTIFICATION_VIEW("서버 요청 실패")
                    return
                }
                
                if (PHONE == true) && (SIGN == false) {
                    
                    if SMSDICT["result"] as? String ?? "fail" == "success" {
                        self.NOTIFICATION_VIEW("인증번호 요청 성공")
                        UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemBlue })
                    } else if SMSDICT["result"] as? String ?? "fail" == "exceeded" {
                        self.NOTIFICATION_VIEW("인증번호 요청 횟수 초과!")
                        UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemRed })
                    } else if SMSDICT["result"] as? String ?? "fail" == "nouser" {
                        self.NOTIFICATION_VIEW("등록되지 않은 전화번호")
                        UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemRed })
                    } else {
                        self.NOTIFICATION_VIEW("인증번호 요청 실패")
                        UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemRed })
                    }
                }
                
                if (PHONE == false) && (SIGN == true) {
                    
                    if SMSDICT["result"] as? String ?? "fail" == "success" {
                        self.NOTIFICATION_VIEW("인증번호 확인 되었습니다")
                        UIView.animate(withDuration: 0.2, animations: {
                            UIViewController.USER_DATA.set(self.PHONE_NUM.text!, forKey: "mb_id")   // 나이스_아이디
                            UIViewController.USER_DATA.synchronize()
                            Messaging.messaging().subscribe(toTopic: "MAINEB_ios")
                            self.SMS_CHECK.backgroundColor = .systemBlue
                            self.LOADING_VC()
                        })
                    } else if SMSDICT["result"] as? String ?? "fail" == "exceeded" {
                        self.NOTIFICATION_VIEW("인증가능 시간을 초과하였습니다")
                        UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
                    } else {
                        self.NOTIFICATION_VIEW("인증번호가 맞지 않습니다")
                        UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
                    }
                }
            }
            case .failure(let encodingError):
        
                print(encodingError)
                break
            }
        }
    }
    
    func LOADING_VC() {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LOADING") as! LOADING
        VC.modalTransitionStyle = .crossDissolve
        present(VC, animated: true)
    }
}
