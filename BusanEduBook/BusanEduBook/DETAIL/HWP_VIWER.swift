//
//  HWP_VIWER.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/06/19.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class HWP_VIWER: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    var FILE_NAME: String = ""
    var FILE_URL: String = ""
    var IDX: String = ""
    var MSG_GROUP: String = ""
    var DT_FROM: String = ""
    
    @IBOutlet weak var Navi_Title: UILabel!
    @IBOutlet weak var WKWebView: WKWebView!
    
    // 로딩인디케이터
    let VIEW = UIView()
    override func loadView() {
        super.loadView()
        
        EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "busan_edu.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WKWebView.navigationDelegate = self
        WKWebView.scrollView.showsHorizontalScrollIndicator = false
        WKWebView.scrollView.showsVerticalScrollIndicator = false
        WKWebView.scrollView.minimumZoomScale = 1.0
        WKWebView.scrollView.maximumZoomScale = 2.0
        
        if FILE_NAME != "" { Navi_Title.text = FILE_NAME}
        
        // 문서전환
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("네트워크 상태를 확인해 주세요")
        } else {
            HTTP_VIWER()
        }
        
        FILE_DOWNLOAD.layer.cornerRadius = 5.0
        FILE_DOWNLOAD.clipsToBounds = true
    }
    
    func HTTP_VIWER() {
        
        let VIEWER_URL = "https://dapp.uic.me/viewer/index.php"
        
        let PARAMETERS: Parameters = [
            "idx": IDX,
            "msg_group": MSG_GROUP,
            "dt_from": DT_FROM
        ]
        
        print("PARAMETER -", PARAMETERS)
        
        Alamofire.request(VIEWER_URL, method: .post, parameters: PARAMETERS).responseString { response in
            
//            print("[문서뷰어]", response)
            
            guard let HTML_STRING = response.result.value else { return }
            self.WKWebView.loadHTMLString(HTML_STRING, baseURL: nil)
        }
    }
    
    // 첨부파일
    @IBOutlet weak var FILE_DOWNLOAD: UIButton!
    @IBAction func FILE_DOWNLOAD(_ sender: UIButton) {
        
        if FILE_URL != "" { DOWNLOAD_BUTTON(FILE_URL: FILE_URL, FILE_NAME: FILE_NAME) }
    }
}

extension HWP_VIWER: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.VIEW.alpha = 0.0
        }, completion: {(isCompleted) in
            self.VIEW.removeFromSuperview()
        })
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.VIEW.alpha = 0.0
        }, completion: {(isCompleted) in
            self.VIEW.removeFromSuperview()
        })
    }
}
