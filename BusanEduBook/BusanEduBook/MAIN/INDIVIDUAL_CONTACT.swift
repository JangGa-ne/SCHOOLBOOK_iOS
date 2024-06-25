//
//  INDIVIDUAL_CONTACT.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/08/04.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class INDIVIDUAL_CONTACT_CC: UICollectionViewCell {
    
    @IBOutlet weak var SC_NAME: UILabel!
}

// 개인 주소록
class INDIVIDUAL_CONTACT: UIViewController {
    
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
    
    @IBOutlet weak var LOGIN_CHECK: UILabel!                // 로그인_확인
    
    @IBOutlet weak var TITLE_LABEL: UILabel!                // 타이틀
    @IBOutlet weak var TITLE_VIEW_BG: UIView!               // 타이틀_배경_18:9
    @IBOutlet weak var TITLE_NAME_BG: UILabel!              // 타이틀_18:9
    
    @IBOutlet weak var COLLECTION_VIEW: UICollectionView!   // 컬레션_뷰
    @IBOutlet weak var HEADER_VIEW: UIView!                 // 헤더_뷰
    @IBOutlet weak var TITLE_VIEW: UIView!                  // 컬레션_타이틀_배경_18:9
    @IBOutlet weak var TITLE_NAME: UILabel!                 // 테이블_타이틀_18:9
    
    var GROUP_NAME: String = ""
    var GROUP_NO: String = ""
    
    // 검색
    @IBAction func SEARCH_VC(_ sender: UIButton) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SEARCH") as! SEARCH
        VC.modalTransitionStyle = .crossDissolve
        present(VC, animated: true)
    }
    
    // 그룹_뷰
    private let BUTTON = UIButton()
    @IBOutlet weak var GROUP_VIEW: UIView!
    @IBOutlet weak var ADD_VIEW: UIView!
    @IBOutlet weak var MODIFY_VIEW: UIView!
    @IBOutlet weak var DELETE_VIEW: UIView!
    @IBOutlet weak var GROUP_BTN: UIButton!
    @IBAction func GROUP_BTN(_ sender: UIButton) {
        
//        BUTTON.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        BUTTON.backgroundColor = UIColor.init(white: 0.0, alpha: 0.3)
//        BUTTON.addTarget(self, action: #selector(CLOSE(_:)), for: .touchUpInside)
//        view.addSubview(BUTTON)
//        view.bringSubviewToFront(GROUP_VIEW)

        if sender.isSelected == false {
            sender.isSelected = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(40)) { self.DELETE_VIEW.isHidden = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(80)) { self.MODIFY_VIEW.isHidden = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(120)) { self.ADD_VIEW.isHidden = false }
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.BUTTON.alpha = 0.3
            })
        } else {
            sender.isSelected = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(40)) { self.DELETE_VIEW.isHidden = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(80)) { self.MODIFY_VIEW.isHidden = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(120)) { self.ADD_VIEW.isHidden = true }

            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.BUTTON.alpha = 0.0
            })
        }
    }
    
    @objc func CLOSE(_ sender: UIButton) { HIDDEN() }
    
    func HIDDEN() {
        
        GROUP_BTN.isSelected = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(40)) { self.DELETE_VIEW.isHidden = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(80)) { self.MODIFY_VIEW.isHidden = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(120)) { self.ADD_VIEW.isHidden = true }

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.BUTTON.alpha = 0.0
        })
    }
    
    // 그룹_추가
    @IBAction func GROUP_ADD_BTN(_ sender: UIButton) {
        
        HIDDEN()
        
        let ALERT = UIAlertController(title: "그룹 추가", message: nil, preferredStyle: .alert)

        ALERT.addTextField() { (textField) in textField.placeholder = "그룹명을 입력하세요" }
        ALERT.addAction(UIAlertAction(title: "추가하기", style: .default) { (_) in

            if ALERT.textFields?[0].text ?? "" == "" {
                self.NOTIFICATION_VIEW("미입력된 항목이 있습니다")
            } else {
                if !self.SYSTEM_NETWORK_CHECKING() {
                    self.NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
                } else {
                    self.EFFECT_INDICATOR_VIEW(self.VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
                    self.HTTP_GROUP(ACTION_TYPE: "per_group_add", BG_NAME: ALERT.textFields?[0].text ?? "", BG_NO: "")
                }
            }
        })
        let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        ALERT.addAction(CANCEL)
        CANCEL.setValue(UIColor.red, forKey: "titleTextColor")

        present(ALERT, animated: true)
    }
    // 그룹_수정
    @IBAction func GROUP_MODIFY_BTN(_ sender: UIButton) {
        
        HIDDEN()
        
        let ALERT = UIAlertController(title: "그룹 수정", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let PICKER_VIEW = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 165))
        PICKER_VIEW.dataSource = self
        PICKER_VIEW.delegate = self
        PICKER_VIEW.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        ALERT.view.addSubview(PICKER_VIEW)
        
        ALERT.addTextField() { (textField) in textField.placeholder = "그룹명을 입력하세요" }
        ALERT.addAction(UIAlertAction(title: "수정하기", style: .default) { (_) in

            if ALERT.textFields?[0].text ?? "" == "" {
                self.NOTIFICATION_VIEW("미입력된 항목이 있습니다")
            } else {
                if !self.SYSTEM_NETWORK_CHECKING() {
                    self.NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
                } else {
                    self.EFFECT_INDICATOR_VIEW(self.VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
                    self.HTTP_GROUP(ACTION_TYPE: "per_group_update", BG_NAME: ALERT.textFields?[0].text ?? "", BG_NO: self.GROUP_NO)
                }
            }
        })
        let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        ALERT.addAction(CANCEL)
        CANCEL.setValue(UIColor.red, forKey: "titleTextColor")

        present(ALERT, animated: true, completion: { PICKER_VIEW.frame.size.width = ALERT.view.frame.size.width })
    }
    // 그룹_삭제
    @IBAction func GROUP_DELETE_BTN(_ sender: UIButton) {
        
        HIDDEN()
        
        let ALERT = UIAlertController(title: "그룹 삭제", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let PICKER_VIEW = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 165))
        PICKER_VIEW.dataSource = self
        PICKER_VIEW.delegate = self
        PICKER_VIEW.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        ALERT.view.addSubview(PICKER_VIEW)
        
        ALERT.addAction(UIAlertAction(title: "삭제하기", style: .default) { (_) in

            if !self.SYSTEM_NETWORK_CHECKING() {
                self.NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
            } else {
                self.EFFECT_INDICATOR_VIEW(self.VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
                self.HTTP_GROUP(ACTION_TYPE: "per_group_delete", BG_NAME: "", BG_NO: self.GROUP_NO)
            }
        })
        let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        ALERT.addAction(CANCEL)
        CANCEL.setValue(UIColor.red, forKey: "titleTextColor")

        present(ALERT, animated: true, completion: { PICKER_VIEW.frame.size.width = ALERT.view.frame.size.width })
    }
    
    // 로딩인디케이터
    let VIEW = UIView()
    override func loadView() {
        super.loadView()
        
        // 로그인_여부
        if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
            EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NAVI
        DEVICE_TITLE(TITLE_LABEL: TITLE_LABEL, TITLE_VIEW_BG: TITLE_VIEW_BG, TITLE_VIEW: UIView(), HEIGHT: 52.0)
        // 통신
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" {
                LOGIN_CHECK.text = "로그인 후 사용 가능합니다"
                HTTP_INDIVIDUAL_CONTACT()
            }
        }
        // 컬렉션_뷰
        let LAYER = UICollectionViewFlowLayout()
        COLLECTION_VIEW.delegate = self
        COLLECTION_VIEW.dataSource = self
        COLLECTION_VIEW.backgroundColor = .white
        LAYER.sectionInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        LAYER.minimumLineSpacing = 10.0
        LAYER.minimumInteritemSpacing = 10.0
        COLLECTION_VIEW.setCollectionViewLayout(LAYER, animated: true)
        // 그룹_뷰
        GROUP_VIEW.SHADOW_VIEW(COLOR: .black, OFFSET: CGSize(width: 0, height: 0), SHADOW_RADIUS: 10, OPACITY: 0.1, RADIUS: 25.0)
        ADD_VIEW.isHidden = true
        MODIFY_VIEW.isHidden = true
        DELETE_VIEW.isHidden = true
    }
    
    // 통신
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
                self.COLLECTION_VIEW.reloadData()
                self.EFFECT_INDICATOR_VIEW_HIDDEN(self.VIEW)
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
            
            self.COLLECTION_VIEW.reloadData()
            self.EFFECT_INDICATOR_VIEW_HIDDEN(self.VIEW)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if DEVICE_RATIO() == "Ratio 18:9" { SCROLL_EDIT_C(COLLECTION_VIEW: COLLECTION_VIEW, NAVI_TITLE: TITLE_LABEL) }
        
        if COLLECTION_VIEW.contentOffset.y >= 20 {
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
                
                self.GROUP_VIEW.alpha = 1.0
                self.GROUP_VIEW.transform = CGAffineTransform(translationX: 0, y: self.COLLECTION_VIEW.frame.size.height - 70)
            })
        } else {
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                
                self.GROUP_VIEW.alpha = 1.0
                self.GROUP_VIEW.transform = CGAffineTransform(translationX: 0, y: 0)
            })
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
}

extension INDIVIDUAL_CONTACT: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 헤더_뷰
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let CELL = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "INDIVIDUAL_CONTACT_CC_T", for: indexPath) as! INDIVIDUAL_CONTACT_CC
        DEVICE_TITLE(TITLE_LABEL: TITLE_LABEL, TITLE_VIEW_BG: TITLE_VIEW_BG, TITLE_VIEW: CELL, HEIGHT: 52.0)
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if DEVICE_RATIO() == "Ratio 16:9" {
            return CGSize(width: COLLECTION_VIEW.frame.width, height: 0.0)
        } else {
            return CGSize(width: COLLECTION_VIEW.frame.width, height: 52.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API.count == 0 {
            COLLECTION_VIEW.isHidden = true
            GROUP_VIEW.isHidden = true
            if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" != "" { LOGIN_CHECK.text = "데이터가 없습니다" }
            return 0
        } else {
            COLLECTION_VIEW.isHidden = false
            GROUP_VIEW.isHidden = false
            return UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        HIDDEN()
        
        let DATA = UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API[indexPath.item]
        
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "INDIVIDUAL_CONTACT_CC", for: indexPath) as! INDIVIDUAL_CONTACT_CC
        
        CELL.layer.cornerRadius = 10.0
        CELL.clipsToBounds = true
        CELL.backgroundColor = .GRAY_COLOR
        
        CELL.SC_NAME.text = DATA.BG_NAME
        
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        HIDDEN()
        
        let DATA = UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API[indexPath.item]

        let VC = self.storyboard?.instantiateViewController(withIdentifier: "INDIVIDUAL_CONTACT_DETAIL") as! INDIVIDUAL_CONTACT_DETAIL

        VC.modalTransitionStyle = .crossDissolve
        VC.ACTION_TYPE = "per_list"
        VC.BG_NO = DATA.BG_NO
        VC.BK_NO = DATA.MB_ID
        VC.SC_NAME = DATA.BG_NAME

        present(VC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: COLLECTION_VIEW.frame.size.width / 3 - 20.0, height: COLLECTION_VIEW.frame.size.width / 3 - 20.0)
    }
}

extension INDIVIDUAL_CONTACT: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API.count == 0 { return 0 } else { return UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API.count }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        GROUP_NAME = UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API[row].BG_NAME
        GROUP_NO = UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API[row].BG_NO
        return UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API[row].BG_NAME
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        GROUP_NAME = UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API[row].BG_NAME
        GROUP_NO = UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API[row].BG_NO
    }
}
