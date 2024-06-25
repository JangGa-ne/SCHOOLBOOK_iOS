//
//  DETAIL_IMAGE.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 부산광역시교육청 on 2020/12/29.
//

import UIKit

//MARK: - 소식 이미지 상세보기
class DETAIL_IMAGE: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var IMAGE: String = ""
    var MEDIA_IMAGE = UIImageView()
    
    // 내비게이션바
    @IBOutlet weak var NAVI_BG: UIView!
    @IBOutlet weak var NAVI_VIEW: UIView!
    @IBOutlet weak var NAVI_TITLE: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let KOREAN_URL = IMAGE.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        NUKE_DETAIL_IMAGE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: UIImage(named: "busanlogo.png")!, PROFILE: MEDIA_IMAGE, FRAME_SIZE: CGSize(width: view.frame.width, height: view.frame.height))
        MEDIA_IMAGE.frame = CGRect(x: 0.0, y: NAVI_BG.frame.height + 22.0, width: view.frame.width, height: view.frame.height - (NAVI_BG.frame.height + 22.0))
        view.addSubview(MEDIA_IMAGE)
    }
}

