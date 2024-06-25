//
//  INDIVIDUAL_CONTACT_DETAIL.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/08/06.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

// 개인 주소록 디테일 (처리완료)
class INDIVIDUAL_CONTACT_DETAIL_TC: UITableViewCell {
    
    @IBOutlet weak var NAME_1: UILabel!
    @IBOutlet weak var NAME_2: UILabel!
}

class INDIVIDUAL_CONTACT_DETAIL: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var INDIVIDUAL_CONTACT_DETAIL_API: [INDIVIDUAL_CONTACT_DETAIL_DATA] = []
    
    var ACTION_TYPE: String = ""
    var BG_NO: String = ""
    var BK_NO: String = ""
    var SC_NAME: String = ""
    
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
            TITLE_LABEL.text = "개인 주소록"
            TITLE_NAME_BG.text = "개인 주소록"
            TITLE_NAME.text = "개인 주소록"
        } else {
            TITLE_LABEL.text = SC_NAME
            TITLE_NAME_BG.text = SC_NAME
            TITLE_NAME.text = SC_NAME
        }
        // NAVI
        DEVICE_TITLE(TITLE_LABEL: TITLE_LABEL, TITLE_VIEW_BG: TITLE_VIEW_BG, TITLE_VIEW: HEADER_VIEW, HEIGHT: 52.0)
        // 연락처추가
        PER_VIEW.SHADOW_VIEW(COLOR: .black, OFFSET: CGSize(width: 0, height: 0), SHADOW_RADIUS: 10, OPACITY: 0.1, RADIUS: 25.0)
    }
    
    // 통신
    func HTTP_CONTACT_DETAIL() {
        
        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
            "bg_no": BG_NO,
            "bk_no": BK_NO
        ]
        
        print("주소록 파라미터: \(PARAMETERS)")
        
        let BASE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().BASE_URL)
        
        Alamofire.request(BASE_URL, method: .post, parameters: PARAMETERS).responseJSON { response in
            
            print("[주소록]", response)
            self.INDIVIDUAL_CONTACT_DETAIL_API.removeAll()
            
            guard let DATA_ARRAY = response.result.value as? Array<Any> else {
                print("[주소록] FAIL")
                self.INDIVIDUAL_CONTACT_DETAIL_API.removeAll()
                self.TABLE_VIEW.reloadData()
                self.EFFECT_INDICATOR_VIEW_HIDDEN(self.VIEW)
                return
            }
            
            for (_, DATA) in DATA_ARRAY.enumerated() {

                let DATADICT = DATA as? [String: Any]

                let PUT_DATA = INDIVIDUAL_CONTACT_DETAIL_DATA()
                
                PUT_DATA.SET_BG_NAME(BG_NAME: DATADICT?["bg_name"] as Any)
                PUT_DATA.SET_BG_NO(BG_NO: DATADICT?["bg_no"] as Any)
                PUT_DATA.SET_BK_DATETIME(BK_DATETIME: DATADICT?["bk_datetime"] as Any)
                PUT_DATA.SET_BK_HP(BK_HP: DATADICT?["bk_hp"] as Any)
                PUT_DATA.SET_BK_NAME(BK_NAME: DATADICT?["bk_name"] as Any)
                PUT_DATA.SET_BK_NO(BK_NO: DATADICT?["bk_no"] as Any)
                PUT_DATA.SET_BK_PHONE(BK_PHONE: DATADICT?["bk_phone"] as Any)
                PUT_DATA.SET_BK_TYPE(BK_TYPE: DATADICT?["bk_type"] as Any)
                PUT_DATA.SET_FCM_KEY(FCM_KEY: DATADICT?["fcm_key"] as Any)
                PUT_DATA.SET_LIST_TYPE(LIST_TYPE: DATADICT?["list_type"] as Any)
                PUT_DATA.SET_MB_ID(MB_ID: DATADICT?["mb_id"] as Any)
                PUT_DATA.SET_MEMO(MEMO: DATADICT?["memo"] as Any)
                
                self.INDIVIDUAL_CONTACT_DETAIL_API.append(PUT_DATA)
            }
            
            self.TABLE_VIEW.reloadData()
            self.EFFECT_INDICATOR_VIEW_HIDDEN(self.VIEW)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if DEVICE_RATIO() == "Ratio 18:9" { SCROLL_EDIT_T(TABLE_VIEW: TABLE_VIEW, NAVI_TITLE: TITLE_LABEL) }
    }
    
    // 연락처추가
    @IBOutlet weak var PER_VIEW: UIView!
    @IBAction func PER_ADD_BTN(_ sender: UIButton) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ADD_CONTACT") as! ADD_CONTACT
        VC.modalTransitionStyle = .crossDissolve
        VC.NEW = true
        VC.BG_NAME = SC_NAME
        VC.BG_NO = BG_NO
        VC.BK_NO = BK_NO
        present(VC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 통신
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            HTTP_CONTACT_DETAIL()
        }
        // 테이블_뷰
        TABLE_VIEW.delegate = self
        TABLE_VIEW.dataSource = self
        TABLE_VIEW.backgroundColor = .white
    }
}

extension INDIVIDUAL_CONTACT_DETAIL: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if INDIVIDUAL_CONTACT_DETAIL_API.count == 0 {
            TABLE_VIEW.isHidden = true
            return 0
        } else {
            TABLE_VIEW.isHidden = false
            return INDIVIDUAL_CONTACT_DETAIL_API.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = INDIVIDUAL_CONTACT_DETAIL_API[indexPath.item]
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "INDIVIDUAL_CONTACT_DETAIL_TC", for: indexPath) as! INDIVIDUAL_CONTACT_DETAIL_TC
        
        if DATA.LIST_TYPE == "fa_list" {
            CELL.NAME_1.text = DATA.BK_NAME
            CELL.NAME_2.isHidden = true
        } else {
            CELL.NAME_1.text = DATA.BK_NAME
            CELL.NAME_2.isHidden = false
            CELL.NAME_2.text = DATA.BG_NAME
        }
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let VC = self.storyboard?.instantiateViewController(withIdentifier: "MODIFY_CONTACT") as! MODIFY_CONTACT
        VC.modalTransitionStyle = .crossDissolve
        VC.INDIVIDUAL_CONTACT_DETAIL_API = INDIVIDUAL_CONTACT_DETAIL_API
        VC.POSITION = indexPath.item
        VC.ACTION_TYPE = "per_list"
        VC.BG_NO = BG_NO
        VC.BK_NO = BK_NO
        present(VC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if !SYSTEM_NETWORK_CHECKING() {
                
                NOTIFICATION_VIEW("네트워크 연결을 확인하세요")
            } else {
                
                let PARAMETERS: Parameters = [
                    "action_type": "per_del",
                    "bk_no": INDIVIDUAL_CONTACT_DETAIL_API[indexPath.item].BK_NO,
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
                        
                        self.NOTIFICATION_VIEW("삭제 되었습니다")
                        self.INDIVIDUAL_CONTACT_DETAIL_API.remove(at: indexPath.item)
                        self.TABLE_VIEW.deleteRows(at: [indexPath], with: .fade)
                    }
                    case .failure(let encodingError):
                
                        print(encodingError)
                        break
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
