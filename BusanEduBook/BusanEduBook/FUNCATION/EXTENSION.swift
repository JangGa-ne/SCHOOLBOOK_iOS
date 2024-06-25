//
//  EXTENSION.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/07/20.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Nuke
import AVKit
import AFNetworking
import CryptoSwift
import Alamofire
import Foundation
import Firebase
import SystemConfiguration

extension UIViewController: UITextFieldDelegate, UIScrollViewDelegate, UISearchBarDelegate, UIDocumentInteractionControllerDelegate {
    
    static var USER_DATA = UserDefaults.standard
    static var APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
    // 첨부파일 다운
    static private var DOCUMENT_INTERACTION: UIDocumentInteractionController!
    
    func ENCRYPT(KEY: String, IV: [UInt8], URL: String) {
        do {
            let ENCRYPT_TEXT = try AES(key: KEY.bytes, blockMode: CBC(iv: IV), padding: .pkcs7).encrypt(URL.bytes)
            print(ENCRYPT_TEXT)
        } catch { }
    }
    
    func DECRYPT(KEY: String, IV: [UInt8], URL: [UInt8]) -> String {
        do {
            let DECRYPT_TEXT = try AES(key: KEY.bytes, blockMode: CBC(iv: IV), padding: .pkcs7).decrypt(URL)
//            print(String(bytes: DECRYPT_TEXT, encoding: .utf8)!)
            return String(bytes: DECRYPT_TEXT, encoding: .utf8)!
        } catch {
            return "FAIL"
        }
    }
    
    // 네트워크 연결 확인
    func SYSTEM_NETWORK_CHECKING() -> Bool {
        
        var ZERO_ADDRESS = sockaddr_in()
        ZERO_ADDRESS.sin_len = UInt8(MemoryLayout.size(ofValue: ZERO_ADDRESS))
        ZERO_ADDRESS.sin_family = sa_family_t(AF_INET)
        
        let DEFAULT_ROUTE_REACHABILITY = withUnsafePointer(to: &ZERO_ADDRESS, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1, { zero_Sock_Address in
                SCNetworkReachabilityCreateWithAddress(nil, zero_Sock_Address)
            })
        })
        
        var FLAGS = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(DEFAULT_ROUTE_REACHABILITY!, &FLAGS) {
            return false
        }
        
        let IS_REACHABLE = FLAGS.contains(.reachable)
        let NEEDS_CONNECTION = FLAGS.contains(.connectionRequired)
        
        return (IS_REACHABLE && !NEEDS_CONNECTION)
    }
    
    // 알림창
    func NOTIFICATION_VIEW(_ MESSAGE: String) {
        
        let NOTIFICATION = UILabel(frame: CGRect(x: view.frame.size.width/2 - 97.5, y: 0.0, width: 195.0, height: 50.0))
            
        NOTIFICATION.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        NOTIFICATION.textColor = .lightGray
        NOTIFICATION.textAlignment = .center
        NOTIFICATION.font = UIFont.boldSystemFont(ofSize: 12)
        NOTIFICATION.text = MESSAGE
        NOTIFICATION.layer.cornerRadius = 25.0
        NOTIFICATION.clipsToBounds = true
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            
            NOTIFICATION.alpha = 1.0
//            NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 44.0)
            if self.DEVICE_RATIO() == "Ratio 18:9" {
                NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 20.0)
            } else {
                NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 44.0)
            }
        })
        
        view.addSubview(NOTIFICATION)
        
        UIView.animate(withDuration: 0.2, delay: 2.0, options: .curveEaseOut, animations: {
            
            NOTIFICATION.alpha = 0.0
            NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 0.0)
        }, completion: {(isCompleted) in
            
            NOTIFICATION.removeFromSuperview()
        })
    }
    
    // 로딩
    func EFFECT_INDICATOR_VIEW(_ VIEW: UIView, _ IMAGE: UIImage,_ TITLE: String, _ MESSAGE: String) {
        
        VIEW.frame = CGRect(x: view.frame.size.width / 2 - 80.0, y: view.frame.size.height / 2 - 80.0, width: 160.0, height: 160.0)
        VIEW.backgroundColor = .GRAY_COLOR
        VIEW.layer.cornerRadius = 10.0
        VIEW.clipsToBounds = true
        
        let EFFECT_VIEW = UIVisualEffectView()
        EFFECT_VIEW.frame = VIEW.bounds
        EFFECT_VIEW.effect = UIBlurEffect(style: .extraLight)
        VIEW.addSubview(EFFECT_VIEW)
        
        let IMAGE_ = UIImageView()
        
        IMAGE_.frame = CGRect(x: VIEW.frame.size.width / 2 - 35.0, y: 20.0, width: 70.0, height: 70.0)
        IMAGE_.image = IMAGE
        IMAGE_.isOpaque = true
        IMAGE_.contentMode = .scaleAspectFit
        IMAGE_.layer.cornerRadius = 35.0
        IMAGE_.clipsToBounds = true
        VIEW.addSubview(IMAGE_)
        
        let TITLE_ = UILabel()
            
        TITLE_.frame = CGRect(x: 0.0, y: 100.0, width: EFFECT_VIEW.frame.size.width, height: 20.0)
        TITLE_.textColor = .darkGray
        TITLE_.textAlignment = .center
        TITLE_.font = UIFont.boldSystemFont(ofSize: 14)
        TITLE_.text = TITLE
        VIEW.addSubview(TITLE_)
        
        let MESSAGE_ = UILabel()
            
        MESSAGE_.frame = CGRect(x: 0.0, y: 120.0, width: EFFECT_VIEW.frame.size.width, height: 20.0)
        MESSAGE_.textColor = .gray
        MESSAGE_.textAlignment = .center
        MESSAGE_.font = UIFont.systemFont(ofSize: 10)
        MESSAGE_.text = MESSAGE
        VIEW.addSubview(MESSAGE_)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            VIEW.alpha = 1.0
        })
        
        view.addSubview(VIEW)
    }
    
    func EFFECT_INDICATOR_VIEW_HIDDEN(_ VIEW: UIView) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            VIEW.alpha = 0.0
        }, completion: {(isCompleted) in
            VIEW.removeFromSuperview()
        })
    }
    
    // 키보드 나타남
    @objc func KEYBOARD_SHOW(_ NOTIFICATION: Notification) {
        
        let KEY = NOTIFICATION.userInfo![UIResponder.keyboardFrameEndUserInfoKey]
        let RECT = (KEY! as AnyObject).cgRectValue
        
        let KEYBOARD_FRAME_END = view!.convert(RECT!, to: nil)
        view.frame = CGRect(x: 0, y: 0, width: KEYBOARD_FRAME_END.size.width, height: KEYBOARD_FRAME_END.origin.y)
        view.layoutIfNeeded()
    }
    // 키보드 사라짐
    @objc func KEYBOARD_HIDE(_ NOTIFICATION: Notification) {
        
        let KEY = NOTIFICATION.userInfo![UIResponder.keyboardFrameBeginUserInfoKey]
        let RECT = (KEY! as AnyObject).cgRectValue
        
        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height + RECT!.height)
        view.layoutIfNeeded()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // PLACEHOLDER 표시
    func PLACEHOLDER(TEXT_FILELD: UITextField, PLACEHOLDER: String, WHITE: CGFloat) {
        
        TEXT_FILELD.attributedPlaceholder = NSAttributedString(string: PLACEHOLDER, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: WHITE, alpha: 0.5)])
    }
    
    // 완료 버튼
    func TOOL_BAR_DONE(TEXT_FILELD: UITextField) {
        
        let TOOL_BAR = UIToolbar()
        TOOL_BAR.sizeToFit()
        
        let SPACE = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let DONE = UIBarButtonItem(title: "완료", style: .done, target: self, action:  #selector(DONE_CLICKED))
        if #available(iOS 13.0, *) { TOOL_BAR.tintColor = .label } else { TOOL_BAR.tintColor = .black }
        TOOL_BAR.setItems([SPACE, DONE], animated: false)
        
        TEXT_FILELD.inputAccessoryView = TOOL_BAR
    }
    
    // 완료 버튼
    func TOOL_BAR_DONE(TEXT_VIEW: UITextView) {
        
        let TOOL_BAR = UIToolbar()
        TOOL_BAR.sizeToFit()
        
        let SPACE = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let DONE = UIBarButtonItem(title: "완료", style: .done, target: self, action:  #selector(DONE_CLICKED))
        if #available(iOS 13.0, *) { TOOL_BAR.tintColor = .label } else { TOOL_BAR.tintColor = .black }
        TOOL_BAR.setItems([SPACE, DONE], animated: false)
        
        TEXT_VIEW.inputAccessoryView = TOOL_BAR
    }
    
    @objc func DONE_CLICKED() { view.endEditing(true) }
    
    // 폰 기종
    func GET_DEVICE_IDENTIFIER() -> String {
        
        var SYSTEM_INFO = utsname()
        uname(&SYSTEM_INFO)
        let MACHINE_MIRROR = Mirror(reflecting: SYSTEM_INFO.machine)
        let IDENTIFIER = MACHINE_MIRROR.children.reduce("") { identifier, element in
            guard let VALUE = element.value as? Int8, VALUE != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(VALUE)))
        }
        
        return IDENTIFIER
    }
    
    func DEVICE_RATIO() -> String {
        
        let MODEL = UIDevice.current.model
        
        switch MODEL {
        case "iPhone":
            return IPHONE()
        default:
            print("\(MODEL) 지원하지 않음")
            return IPHONE()
        }
    }
    
    func IPHONE() -> String {
        
        let IDENTIFIER = GET_DEVICE_IDENTIFIER()
        
        switch IDENTIFIER {
        
        // iPhone
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "Ratio 18:9"         // iPhone 4
        case "iPhone4,1":                               return "Ratio 18:9"         // iPhone 4s
        case "iPhone5,1", "iPhone5,2":                  return "Ratio 18:9"         // iPhone 5
        case "iPhone5,3", "iPhone5,4":                  return "Ratio 18:9"         // iPhone 5c
        case "iPhone6,1", "iPhone6,2":                  return "Ratio 18:9"         // iPhone 5s
        case "iPhone7,2":                               return "Ratio 18:9"         // iPhone 6
        case "iPhone7,1":                               return "Ratio 18:9"         // iPhone 6 Plus
        case "iPhone8,1":                               return "Ratio 18:9"         // iPhone 6s
        case "iPhone8,2":                               return "Ratio 18:9"         // iPhone 6s Plus
        case "iPhone8,4":                               return "Ratio 18:9"         // iPhone SE
        case "iPhone9,1", "iPhone9,3":                  return "Ratio 18:9"         // iPhone 7
        case "iPhone9,2", "iPhone9,4":                  return "Ratio 18:9"         // iPhone 7 Plus
        case "iPhone10,1", "iPhone10,4":                return "Ratio 18:9"         // iPhone 8
        case "iPhone10,2", "iPhone10,5":                return "Ratio 18:9"         // iPhone 8 Plus
        
        case "iPhone10,3", "iPhone10,6":                return "Ratio 18:9"         // iPhone X
        case "iPhone11,2":                              return "Ratio 18:9"         // iPhone XS
        case "iPhone11,4", "iPhone11,6":                return "Ratio 18:9"         // iPhone XS Max
        case "iPhone11,8":                              return "Ratio 18:9"         // iPhone XR
        case "iPhone12,1":                              return "Ratio 18:9"         // iPhone 11
        case "iPhone12,3":                              return "Ratio 18:9"         // iPhone 11 Pro
        case "iPhone12,5":                              return "Ratio 18:9"         // iPhone 11 Pro Max
        
        case "iPhone12,8":                              return "Ratio 18:9"         // iPhone SE (2nd generation)
        
        // iPod
        case "iPod1,1":                                 return "Ratio 18:9"         // iPod 1st
        case "iPod2,1":                                 return "Ratio 18:9"         // iPod 2nd
        case "iPod3,1":                                 return "Ratio 18:9"         // iPod 3rd
        case "iPod4,1":                                 return "Ratio 18:9"         // iPod 4th
        case "iPod5,1":                                 return "Ratio 18:9"         // iPod 5th
        case "iPod7,1":                                 return "Ratio 18:9"         // iPod 6th
        case "iPod9,1":                                 return "Ratio 18:9"         // iPod 7th
            
        default: return "Ratio 18:9" }
    }
    
    func DEVICE_TITLE(TITLE_LABEL: UILabel, TITLE_VIEW_BG: UIView, TITLE_VIEW: UIView, HEIGHT: CGFloat) {
        
        if DEVICE_RATIO() == "Ratio 16:9" {
            TITLE_LABEL.alpha = 1.0
            TITLE_VIEW_BG.isHidden = true
            TITLE_VIEW.frame.size.height = 0.0
            TITLE_VIEW.clipsToBounds = true
        } else {
            TITLE_LABEL.alpha = 0.0
            TITLE_VIEW_BG.isHidden = false
            TITLE_VIEW.frame.size.height = HEIGHT
            TITLE_VIEW.clipsToBounds = false
        }
    }
    
    // 스크롤
    func SCROLL_EDIT_T(TABLE_VIEW: UITableView, NAVI_TITLE: UILabel) {
        
        if TABLE_VIEW.contentOffset.y <= 0.0 {
            NAVI_TITLE.alpha = 0.0
        } else if TABLE_VIEW.contentOffset.y <= 34.0 {
            NAVI_TITLE.alpha = 0.0
        } else if TABLE_VIEW.contentOffset.y <= 38.0 {
            NAVI_TITLE.alpha = 0.2
        } else if TABLE_VIEW.contentOffset.y <= 42.0 {
            NAVI_TITLE.alpha = 0.4
        } else if TABLE_VIEW.contentOffset.y <= 46.0 {
            NAVI_TITLE.alpha = 0.6
        } else if TABLE_VIEW.contentOffset.y <= 50.0 {
            NAVI_TITLE.alpha = 0.8
        } else {
            NAVI_TITLE.alpha = 1.0
        }
    }
    
    func SCROLL_EDIT_C(COLLECTION_VIEW: UICollectionView, NAVI_TITLE: UILabel) {
        
        if COLLECTION_VIEW.contentOffset.y <= 0.0 {
            NAVI_TITLE.alpha = 0.0
        } else if COLLECTION_VIEW.contentOffset.y <= 34.0 {
            NAVI_TITLE.alpha = 0.0
        } else if COLLECTION_VIEW.contentOffset.y <= 38.0 {
            NAVI_TITLE.alpha = 0.2
        } else if COLLECTION_VIEW.contentOffset.y <= 42.0 {
            NAVI_TITLE.alpha = 0.4
        } else if COLLECTION_VIEW.contentOffset.y <= 46.0 {
            NAVI_TITLE.alpha = 0.6
        } else if COLLECTION_VIEW.contentOffset.y <= 50.0 {
            NAVI_TITLE.alpha = 0.8
        } else {
            NAVI_TITLE.alpha = 1.0
        }
    }
    
    // 탭바
    func TAB_VC(IDENTIFIER: String, INDEX: Int) {
        
        if INDEX == 5 {
            
            if UIViewController.USER_DATA.string(forKey: "mb_id") ?? "" == "" {
                
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "LOGIN") as! LOGIN
                VC.modalTransitionStyle = .crossDissolve
                present(VC, animated: true)
            } else {
                
                let ALERT = UIAlertController(title: "로그아웃 하시겠습니까?", message: nil, preferredStyle: .alert)
                
                ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                ALERT.addAction(UIAlertAction(title: "로그아웃", style: .destructive) { (_) in
                    
                    Messaging.messaging().unsubscribe(fromTopic: "MAINEB_ios")
                    UIViewController.USER_DATA.removeObject(forKey: "mb_id")
                    UIViewController.USER_DATA.synchronize()
                    UIViewController.APPDELEGATE.INDIVIDUAL_CONTACT_API.removeAll()
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "LOADING") as! LOADING
                    VC.modalTransitionStyle = .crossDissolve
                    self.present(VC, animated: true)
                })
                
                present(ALERT, animated: true)
            }
        } else {
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: IDENTIFIER) as? UITabBarController
            VC!.modalTransitionStyle = .crossDissolve
            VC!.selectedIndex = INDEX
            present(VC!, animated: true)
        }
    }
    
    // 하이픈
    func FORMAT(MASK: String, PHONE: String) -> String {
        
        let NUMBERS = PHONE.replacingOccurrences(of: "[^0-9*#]", with: "", options: .regularExpression)
        var RESULT: String = ""
        var INDEX = NUMBERS.startIndex
        
        for CH in MASK where INDEX < NUMBERS.endIndex {
            
            if CH == "X" {
                RESULT.append(NUMBERS[INDEX])
                INDEX = NUMBERS.index(after: INDEX)
            } else {
                RESULT.append(CH)
            }
        }
        
        return RESULT
    }
    
    // 전화번호 형식 체크
    func PHONE_NUM_CHECK(PHONE_NUM: String) -> Bool {
        
        let REGEX = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: PHONE_NUM)
    }
    
    // 인증번호 형식 체크
    func SMS_NUM_CHECK(PHONE_NUM: String) -> Bool {
        
        let REGEX = "^([0-9]{6})$"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: PHONE_NUM)
    }
    
    // 첨부파일 미리보기 버튼
    func DOWNLOAD_BUTTON(FILE_URL: String, FILE_NAME: String) {
        
        let NAME = "\(FILE_URL[FILE_URL.index(FILE_URL.endIndex, offsetBy: -3)])\(FILE_URL[FILE_URL.index(FILE_URL.endIndex, offsetBy: -2)])\(FILE_URL[FILE_URL.index(FILE_URL.endIndex, offsetBy: -1)])"
        
        if (NAME == "bmp") || (NAME == "BMP") {
            
            let ALERT = UIAlertController(title: "지원하지 않는 첨부파일입니다.", message: nil, preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(ALERT, animated: true)
        } else {
            
            print(FILE_URL)
            
            let FILE_URL_ = URL(string: FILE_URL)
            var REQUEST: URLRequest? = nil
            if let FILE_URL_ = FILE_URL_ { REQUEST = URLRequest(url: FILE_URL_) }
            let SESSION = AFHTTPSessionManager()

            let SECURITY_POLICY = AFSecurityPolicy(pinningMode: AFSSLPinningMode.none)
            SECURITY_POLICY.allowInvalidCertificates = true
            SECURITY_POLICY.validatesDomainName = false
            
            SESSION.securityPolicy = SECURITY_POLICY
            
            let PROGRESS: Progress? = nil
            
            if REQUEST != nil {
                
                let DOWNLOAD_TAST = SESSION.downloadTask(with: REQUEST!, progress: nil, destination: { targetPath, response in
                    
                    let DOCUMENTS_DIRECTORY_PATH = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "")
                    
                    return DOCUMENTS_DIRECTORY_PATH.appendingPathComponent(response.suggestedFilename!)
                }, completionHandler: { response, filePath, error in
                    
                    PROGRESS?.removeObserver(self, forKeyPath: "fractionCompleted", context: nil)
                    
                    UIViewController.DOCUMENT_INTERACTION = UIDocumentInteractionController()
                    UIViewController.DOCUMENT_INTERACTION = UIDocumentInteractionController(url: filePath!)
                    UIViewController.DOCUMENT_INTERACTION.delegate = self
                    UIViewController.DOCUMENT_INTERACTION.name = FILE_NAME
                    
                    UIViewController.DOCUMENT_INTERACTION.presentOpenInMenu(from: .zero, in: self.view, animated: true)
                })
                
                DOWNLOAD_TAST.resume()
                
                PROGRESS?.addObserver(self, forKeyPath: "fractionCompleted", options: .new, context: nil)
            } else {
                NOTIFICATION_VIEW("첨부파일 오류!")
            }
        }
    }
    
    // 이미지 비동기화
    func NUKE_IMAGE(IMAGE_URL: String, PLACEHOLDER: UIImage, PROFILE: UIImageView, FRAME_SIZE: CGSize) {
        
        let REQUEST = ImageRequest(url: URL(string: IMAGE_URL)!, processors: [ImageProcessors.Resize(size: FRAME_SIZE)])
        let OPTIONS = ImageLoadingOptions(placeholder: PLACEHOLDER, contentModes: .init(success: .scaleAspectFill, failure: .scaleAspectFit, placeholder: .scaleAspectFit))
        Nuke.loadImage(with: REQUEST, options: OPTIONS, into: PROFILE)
    }
    
    func NUKE_DETAIL_IMAGE(IMAGE_URL: String, PLACEHOLDER: UIImage, PROFILE: UIImageView, FRAME_SIZE: CGSize) {
        
        let REQUEST = ImageRequest(url: URL(string: IMAGE_URL)!, processors: [ImageProcessors.Resize(size: FRAME_SIZE)])
        let OPTIONS = ImageLoadingOptions(placeholder: PLACEHOLDER, contentModes: .init(success: .scaleAspectFit, failure: .center, placeholder: .center))
        Nuke.loadImage(with: REQUEST, options: OPTIONS, into: PROFILE)
    }
    
    func THUMBNAIL_VIDEO(_ VIDEO_URL: String) -> UIImage? {

        let ASSET = AVAsset(url: URL(string: VIDEO_URL)!)
        let IMAGE_GENERATOR = AVAssetImageGenerator(asset: ASSET)
        IMAGE_GENERATOR.appliesPreferredTrackTransform = true
        let TIME = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
            
        do {
            let CG_IMAGE = try IMAGE_GENERATOR.copyCGImage(at: TIME, actualTime: nil)
            let THUMBNAIL = UIImage(cgImage: CG_IMAGE)
            
            return THUMBNAIL
        } catch { }
        
        return nil
    }
}

extension UITableViewCell {

    override open func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func DECRYPT(KEY: String, IV: [UInt8], URL: [UInt8]) -> String {
            
        do {
            let DECRYPT_TEXT = try AES(key: KEY.bytes, blockMode: CBC(iv: IV), padding: .pkcs7).decrypt(URL)
            return String(bytes: DECRYPT_TEXT, encoding: .utf8)!
        } catch {
            return "FAIL"
        }
    }
    
    // 이미지 비동기화
    func NUKE_IMAGE(IMAGE_URL: String, PLACEHOLDER: UIImage, PROFILE: UIImageView, FRAME_SIZE: CGSize) {
        
        let REQUEST = ImageRequest(url: URL(string: IMAGE_URL)!, processors: [ImageProcessors.Resize(size: FRAME_SIZE)])
        let OPTIONS = ImageLoadingOptions(placeholder: PLACEHOLDER, contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .scaleAspectFit))
        Nuke.loadImage(with: REQUEST, options: OPTIONS, into: PROFILE)
    }
    
    func THUMBNAIL_VIDEO(_ VIDEO_URL: String) -> UIImage? {

        let ASSET = AVAsset(url: URL(string: VIDEO_URL)!)
        let IMAGE_GENERATOR = AVAssetImageGenerator(asset: ASSET)
        IMAGE_GENERATOR.appliesPreferredTrackTransform = true
        let TIME = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
            
        do {
            let CG_IMAGE = try IMAGE_GENERATOR.copyCGImage(at: TIME, actualTime: nil)
            let THUMBNAIL = UIImage(cgImage: CG_IMAGE)
            
            return THUMBNAIL
        } catch { }
        
        return nil
    }
}

extension UIView {
    
    public func SHADOW_VIEW(COLOR: UIColor, OFFSET: CGSize, SHADOW_RADIUS: CGFloat, OPACITY: Float, RADIUS: CGFloat) {
        
        layer.shadowColor = COLOR.cgColor
        layer.shadowOffset = OFFSET
        layer.shadowOpacity = OPACITY
        layer.shadowRadius = SHADOW_RADIUS
        layer.cornerRadius = RADIUS
    }
    
    public func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}

extension UITextField {
    
    public func LEFT_PADDING(PADDING_LIFT: CGFloat) {
    
        let PADDING_VIEW = UIView(frame: CGRect(x: 0.0, y: 0.0, width: PADDING_LIFT, height: frame.height))
        
        leftView = PADDING_VIEW
        leftViewMode = ViewMode.always
    }
}

extension String {
    
    public var FULL_RANGE: NSRange {
        return NSRange(location: 0, length: self.count)
    }
}

extension UIColor {
    
    static var BLUE_COLOR = UIColor.systemBlue
    static var GRAY_COLOR = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
    static var SKY_BLUE_COLOR = UIColor.systemTeal
}
