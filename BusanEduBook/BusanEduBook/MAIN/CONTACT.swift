//
//  CONTACT.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/07/20.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class CONTACT_TC: UITableViewCell {
    
    @IBOutlet weak var BG_VIEW: UIView!
    @IBOutlet weak var SC_NAME: UILabel!
    @IBOutlet weak var IMAGE_VIEW: UIImageView!
}

// 조직도
class CONTACT: UIViewController {
    
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
    
    var CONTACT_API: [CONTACT_DATA] = []
    let IMAGE = ["busanlogo.png", "DirectAgency.png", "library.png", "SupportAgency.png", "CityCouncil.png", "HighSchool.png", "DisabledSchool.png", "RelatedAgency.png"]
    
    @IBOutlet weak var TITLE_LABEL: UILabel!                // 타이틀
    @IBOutlet weak var TITLE_VIEW_BG: UIView!               // 타이틀_배경_18:9
    @IBOutlet weak var TITLE_NAME_BG: UILabel!              // 타이틀_18:9
    
    @IBOutlet weak var TABLE_VIEW: UITableView!             // 테이블_뷰
    @IBOutlet weak var HEADER_VIEW: UIView!                 // 헤더_뷰
    @IBOutlet weak var TITLE_VIEW: UIView!                  // 컬렉션_타이틀_배경_18:9
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
        
        // NAVI
        DEVICE_TITLE(TITLE_LABEL: TITLE_LABEL, TITLE_VIEW_BG: TITLE_VIEW_BG, TITLE_VIEW: HEADER_VIEW, HEIGHT: 62.0)
        // 통신
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            HTTP_CONTACT(ACTION_TYPE: "main", SC_CODE: "", CAN_WRITE: "")
        }
        // 테이블_뷰
        TABLE_VIEW.delegate = self
        TABLE_VIEW.dataSource = self
        TABLE_VIEW.backgroundColor = .white
        TABLE_VIEW.separatorStyle = .none
    }
    
    // 통신
    func HTTP_CONTACT(ACTION_TYPE: String, SC_CODE: String, CAN_WRITE: String) {
        
        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
            "sc_code": SC_CODE,
            "can_write": CAN_WRITE
        ]
        
        print("조직도 파라미터: \(PARAMETERS)")
        
        let BASE_URL = DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().BASE_URL)
        
        Alamofire.request(BASE_URL, method: .post, parameters: PARAMETERS).responseJSON { response in
            
            print("[조직도]", response)
            self.CONTACT_API.removeAll()
            
            guard let DATA_ARRAY = response.result.value as? Array<Any> else {
                print("[조직도] FAIL")
                self.CONTACT_API.removeAll()
                self.TABLE_VIEW.reloadData()
                return
            }
            
            for (_, DATA) in DATA_ARRAY.enumerated() {
                
                let DATADICT = DATA as? [String: Any]
                
                let PUT_DATA = CONTACT_DATA()
                
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
                
                self.CONTACT_API.append(PUT_DATA)
            }
            
            self.TABLE_VIEW.reloadData()
            self.EFFECT_INDICATOR_VIEW_HIDDEN(self.VIEW)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if DEVICE_RATIO() == "Ratio 18:9" { SCROLL_EDIT_T(TABLE_VIEW: TABLE_VIEW, NAVI_TITLE: TITLE_LABEL) }
    }
}

extension CONTACT: UITableViewDelegate, UITableViewDataSource {
    
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
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "CONTACT_TC", for: indexPath) as! CONTACT_TC
        
        CELL.BG_VIEW.SHADOW_VIEW(COLOR: .black, OFFSET: CGSize(width: 0, height: 0), SHADOW_RADIUS: 7.5, OPACITY: 0.1, RADIUS: 10.0)
        CELL.IMAGE_VIEW.image = UIImage(named: IMAGE[indexPath.item])
        CELL.SC_NAME.text = DATA.SC_NAME
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let DATA = CONTACT_API[indexPath.item]
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CONTACT_DETAIL") as! CONTACT_DETAIL
        
        VC.modalTransitionStyle = .crossDissolve
        VC.ACTION_TYPE = "list"
        VC.SC_CODE = DATA.BOOK_CODE
        VC.CAN_WRITE = DATA.CAN_WRITE
        VC.SC_NAME = DATA.SC_NAME
        
        present(VC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
