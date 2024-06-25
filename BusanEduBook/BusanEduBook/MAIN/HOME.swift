//
//  HOME.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/07/20.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import MessageUI

class HOME_NUMBER {
    
    var NUMBER: String = ""
}

class HOME: UIViewController {
    
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
    
    var NUMBER: String = ""
    
    @IBOutlet weak var MB_NUMBER: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MB_NUMBER.text = "전화번호를 입력하세요"
        
        let LONG_CLICK = UILongPressGestureRecognizer(target: self, action: #selector(LONG_CLICK(GESTURE:)))
        LONG_CLICK.minimumPressDuration = 0.5
        BACK_BTN.addGestureRecognizer(LONG_CLICK)
    }
    
    @IBAction func NUM_1(_ sender: UIButton) { NUMBER.append("1"); PHONE_NUMBER() }
    @IBAction func NUM_2(_ sender: UIButton) { NUMBER.append("2"); PHONE_NUMBER() }
    @IBAction func NUM_3(_ sender: UIButton) { NUMBER.append("3"); PHONE_NUMBER() }
    @IBAction func NUM_4(_ sender: UIButton) { NUMBER.append("4"); PHONE_NUMBER() }
    @IBAction func NUM_5(_ sender: UIButton) { NUMBER.append("5"); PHONE_NUMBER() }
    @IBAction func NUM_6(_ sender: UIButton) { NUMBER.append("6"); PHONE_NUMBER() }
    @IBAction func NUM_7(_ sender: UIButton) { NUMBER.append("7"); PHONE_NUMBER() }
    @IBAction func NUM_8(_ sender: UIButton) { NUMBER.append("8"); PHONE_NUMBER() }
    @IBAction func NUM_9(_ sender: UIButton) { NUMBER.append("9"); PHONE_NUMBER() }
    @IBAction func NUM_S(_ sender: UIButton) { NUMBER.append("*"); PHONE_NUMBER() }
    @IBAction func NUM_0(_ sender: UIButton) { NUMBER.append("0"); PHONE_NUMBER() }
    @IBAction func NUM_SS(_ sender: UIButton) { NUMBER.append("#"); PHONE_NUMBER() }
    
    func PHONE_NUMBER() {
        
        if NUMBER.count <= 8 {
            MB_NUMBER.text = FORMAT(MASK: "XXXX-XXXX", PHONE: NUMBER)
        } else if NUMBER.count <= 10 {
            MB_NUMBER.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: NUMBER)
        } else if NUMBER.count >= 11 && NUMBER.count <= 12 {
            MB_NUMBER.text = FORMAT(MASK: "XXX-XXXX-XXXXX", PHONE: NUMBER)
        } else {
            MB_NUMBER.text = NUMBER
        }
    }
    
    @IBAction func MESSAGE(_ sender: UIButton) {
        
//        if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" == "" {
//            NOTIFICATION_VIEW("로그인 후 사용 가능합니다")
//        } else {
            
            if NUMBER != "" {
                
                let MC = MFMessageComposeViewController()
                MC.messageComposeDelegate = self
                
                if MFMessageComposeViewController.canSendText() {
                    MC.recipients = [NUMBER]
                    present(MC, animated: true, completion: nil)
                }
            }
//        }
    }
    @IBAction func CALL_BTN(_ sender: UIButton) {
//        if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" == "" {
//            NOTIFICATION_VIEW("로그인 후 사용 가능합니다")
//        } else {
            if NUMBER != "" { UIApplication.shared.open(URL(string: "tel://" + NUMBER)!) }
//        }
    }
    @IBOutlet weak var BACK_BTN: UIButton!
    @IBAction func BACK_BTN(_ sender: UIButton) {
        
        if NUMBER != "" {
            NUMBER.remove(at: NUMBER.index(before: NUMBER.endIndex))
            if NUMBER.count <= 8 {
                MB_NUMBER.text = FORMAT(MASK: "XXXX-XXXX", PHONE: NUMBER)
            } else if NUMBER.count <= 10 {
                MB_NUMBER.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: NUMBER)
            } else if NUMBER.count >= 11 && NUMBER.count <= 12 {
                MB_NUMBER.text = FORMAT(MASK: "XXX-XXXX-XXXXX", PHONE: NUMBER)
            } else {
                MB_NUMBER.text = NUMBER
            }
            if NUMBER == "" { MB_NUMBER.text = "전화번호를 입력하세요"}
        }
    }
    
    @objc func LONG_CLICK(GESTURE: UILongPressGestureRecognizer) {
        
        if GESTURE.state == .began {
            if NUMBER != "" {
                NUMBER.removeAll()
                if NUMBER.count <= 8 {
                    MB_NUMBER.text = FORMAT(MASK: "XXXX-XXXX", PHONE: NUMBER)
                } else if NUMBER.count <= 10 {
                    MB_NUMBER.text = FORMAT(MASK: "XXX-XXX-XXXX", PHONE: NUMBER)
                } else if NUMBER.count >= 11 && NUMBER.count <= 12 {
                    MB_NUMBER.text = FORMAT(MASK: "XXX-XXXX-XXXXX", PHONE: NUMBER)
                } else {
                    MB_NUMBER.text = NUMBER
                }
                if NUMBER == "" { MB_NUMBER.text = "전화번호를 입력하세요"}
            }
        }
    }
}

extension HOME: MFMessageComposeViewControllerDelegate {
    
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
}
