//
//  SOSIK_TC.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/05/08.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
import YoutubePlayer_in_WKWebView

class SOSIK_TC: UITableViewCell {
    
    var PROTOCOL: UIViewController?
    var PROTOCOL_N: SOSIK_N?
    
    var SCHOOL_API: [SCHOOL_DATA] = []
    var SCHOOL_POSITION: Int = 0
    
    var ATTACHED_DATETIME: [String] = []
    var ATTACHED_DT_FROM: [String] = []
    var ATTACHED_FILE_NAME: [String] = []
    var ATTACHED_FILE_NAME_ORG: [String] = []
    var ATTACHED_FILE_SIZE: [String] = []
    var ATTACHED_IDX: [String] = []
    var ATTACHED_IN_SEQ: [String] = []
    var ATTACHED_LAT: [String] = []
    var ATTACHED_LNG: [String] = []
    var ATTACHED_MEDIA_FILES: [String] = []
    var ATTACHED_MEDIA_TYPE: [String] = []
    var ATTACHED_MSG_GROUP: [String] = []
    var ATTACHED_HTTP_STRING: [String] = []
    
    @IBOutlet weak var LineView: UIView!
    
    // SECTION_1
    @IBOutlet weak var School_Symbol_Image: UIImageView!            // schoolLogo - 학교 심볼
    @IBOutlet weak var School_Type_Label: UILabel!                  // typeLabel - 타입 (공지사항, 가정통신문, 급식정보, 학사일정)
    @IBOutlet weak var School_Label: UILabel!                       // schoolLabel - 학교 이름
    @IBOutlet weak var Calendar_Image: UIImageView!
    @IBOutlet weak var School_Date_Label: UILabel!                  // dateLabel - 날짜
    @IBOutlet weak var School_Day_Label: UILabel!                   // dayLabel - 요일
    
    @IBOutlet weak var School_Content_View: UIView!                 // contentView
    @IBOutlet weak var School_Content_Image: UIImageView!           // contentImage - 이미지
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var PageView: UIPageControl!
    @IBOutlet weak var School_Subject_Label: UILabel!               // subjectLabel - 공지사항 제목
    @IBOutlet weak var School_Notice_Content_Label: UILabel!        // noticeContenLabel - 공지사항 내용
    
    @IBOutlet weak var School_Filename_Image: UIImageView!          // fileIcon - 첨부파일 아이콘
    @IBOutlet weak var School_Filename_Label: UILabel!              // fileName - 첨부파일 이름
    @IBOutlet weak var School_Filename_Button: UIButton!            // fileName - 첨부파일 버튼
    @IBOutlet weak var School_Like_Image: UIImageView!              // 좋아요 아이콘
    @IBOutlet weak var School_Like_Label: UILabel!                  // 좋아요 이름
    @IBOutlet weak var School_Like_Button: UIButton!                // 좋아요 버튼
    @IBOutlet weak var School_Share_Button: UIButton!               // 공유하기 버튼
    
    @IBOutlet weak var School_Bar_View: UIView!
    
    // SECTION_3
    
    // MORE_DATA
    @IBOutlet weak var Result_None: UILabel!
    
    public var VIEWPASSED_N: SOSIK_N?          // 공지사항
    
    // 좋아요
    @objc func LIKE(_ sender: UIButton) {
        
        let DATA = SCHOOL_API[SCHOOL_POSITION]
        
        if DATA.LIKE == false {
            DATA.LIKE = true
            School_Like_Image.image = UIImage(named: "like_red.png")
//            PROTOCOL!.EFFECT_ALERT_VIEW(UIImage(named: "like_red.png")!, "좋아요!", "스크랩에 추가되었습니다")
            HTTP_SOSIK_UPDATE()
        } else {
            DATA.LIKE = false
            School_Like_Image.image = UIImage(named: "ico_shcool_heart_n.png")
//            UIViewController.APPDELEGATE.DELETE_DB_MAIN(IDX: SCHOOL_API[SCHOOL_POSITION].IDX)
        }
    }
}

extension SOSIK_TC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func CC_DELEGATE() {
        
        DispatchQueue.main.async {
            
            self.CollectionView.delegate = self
            self.CollectionView.dataSource = self
            self.CollectionView.reloadData()
            let LAYER = UICollectionViewFlowLayout()
            LAYER.scrollDirection = .horizontal
            LAYER.minimumLineSpacing = 0.0
            self.CollectionView.setCollectionViewLayout(LAYER, animated: false)
        }
        
        ATTACHED_DATETIME.removeAll()
        ATTACHED_DT_FROM.removeAll()
        ATTACHED_FILE_NAME.removeAll()
        ATTACHED_FILE_NAME_ORG.removeAll()
        ATTACHED_FILE_SIZE.removeAll()
        ATTACHED_IDX.removeAll()
        ATTACHED_IN_SEQ.removeAll()
        ATTACHED_LAT.removeAll()
        ATTACHED_LNG.removeAll()
        ATTACHED_MEDIA_FILES.removeAll()
        ATTACHED_MEDIA_TYPE.removeAll()
        ATTACHED_MSG_GROUP.removeAll()
        ATTACHED_HTTP_STRING.removeAll()
        
        let DATA = SCHOOL_API[SCHOOL_POSITION]
        
        if DATA.ATTACHED.count != 0 {
            
            for i in 0 ..< DATA.ATTACHED.count {
                
                if DATA.ATTACHED[i].MEDIA_TYPE != "f" {
                    
                    ATTACHED_DATETIME.append(DATA.ATTACHED[i].DATETIME)
                    ATTACHED_DT_FROM.append(DATA.ATTACHED[i].DT_FROM)
                    ATTACHED_FILE_NAME.append(DATA.ATTACHED[i].FILE_NAME)
                    ATTACHED_FILE_NAME_ORG.append(DATA.ATTACHED[i].FILE_NAME_ORG)
                    ATTACHED_FILE_SIZE.append(DATA.ATTACHED[i].FILE_SIZE)
                    ATTACHED_IDX.append(DATA.ATTACHED[i].IDX)
                    ATTACHED_IN_SEQ.append(DATA.ATTACHED[i].IN_SEQ)
                    ATTACHED_LAT.append(DATA.ATTACHED[i].LAT)
                    ATTACHED_LNG.append(DATA.ATTACHED[i].LNG)
                    ATTACHED_MEDIA_FILES.append(DATA.ATTACHED[i].MEDIA_FILES)
                    ATTACHED_MEDIA_TYPE.append(DATA.ATTACHED[i].MEDIA_TYPE)
                    ATTACHED_MSG_GROUP.append(DATA.ATTACHED[i].MSG_GROUP)
                    ATTACHED_HTTP_STRING.append(DATA.ATTACHED[i].HTTP_STRING)
                }
            }
        }
        
        if DATA.ATTACHED_MEDIA_TYPE.contains("|") {
            
            for i in 0 ..< DATA.ATTACHED_MEDIA_TYPE.components(separatedBy: "|").count-1 {
                
                if DATA.ATTACHED_MEDIA_TYPE.components(separatedBy: "|")[i] != "f" {
                
                    ATTACHED_DATETIME.append(DATA.ATTACHED_MEDIA_TYPE.components(separatedBy: "|")[i])
                    ATTACHED_DT_FROM.append(DATA.ATTACHED_DT_FROM.components(separatedBy: "|")[i])
                    ATTACHED_FILE_NAME.append(DATA.ATTACHED_FILE_NAME.components(separatedBy: "|")[i])
                    ATTACHED_FILE_NAME_ORG.append(DATA.ATTACHED_FILE_NAME_ORG.components(separatedBy: "|")[i])
                    ATTACHED_FILE_SIZE.append(DATA.ATTACHED_FILE_SIZE.components(separatedBy: "|")[i])
                    ATTACHED_IDX.append(DATA.ATTACHED_IDX.components(separatedBy: "|")[i])
                    ATTACHED_IN_SEQ.append(DATA.ATTACHED_IN_SEQ.components(separatedBy: "|")[i])
                    ATTACHED_LAT.append(DATA.ATTACHED_LAT.components(separatedBy: "|")[i])
                    ATTACHED_LNG.append(DATA.ATTACHED_LNG.components(separatedBy: "|")[i])
                    ATTACHED_MEDIA_FILES.append(DATA.ATTACHED_MEDIA_FILES.components(separatedBy: "|")[i])
                    ATTACHED_MEDIA_TYPE.append(DATA.ATTACHED_MEDIA_TYPE.components(separatedBy: "|")[i])
                    ATTACHED_MSG_GROUP.append(DATA.ATTACHED_MSG_GROUP.components(separatedBy: "|")[i])
                    ATTACHED_HTTP_STRING.append(DATA.ATTACHED_HTTP_STRING.components(separatedBy: "|")[i])
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if ATTACHED_MEDIA_TYPE.count == 0 {
            return 0
        } else {
            return ATTACHED_MEDIA_TYPE.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch ATTACHED_MEDIA_TYPE[indexPath.item] {
        case "y":   // 유튜브
            
            let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "SOSIK_CC_Y", for: indexPath) as! SOSIK_CC
            CELL.School_Content_Youtube.load(withVideoId: ATTACHED_FILE_NAME[indexPath.item])
            CELL.School_Content_Youtube.backgroundColor = .black
            return CELL
        case "v":   // 동영상
            
            let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "SOSIK_CC", for: indexPath) as! SOSIK_CC
            
            if ATTACHED_MEDIA_FILES[indexPath.item].contains("_media1.mp4") {
                let MEDIA_FILES = ATTACHED_MEDIA_FILES[indexPath.item].replacingOccurrences(of: "%2520", with: "%20").replacingOccurrences(of: "_media1.mp4", with: "_mplayer1_1.png")
                NUKE_IMAGE(IMAGE_URL: MEDIA_FILES, PLACEHOLDER: .gifImageWithName("loading_")!, PROFILE: CELL.School_Content_Image, FRAME_SIZE: CGSize(width: CollectionView.frame.size.width, height: CollectionView.frame.size.height))
            } else  {
                CELL.School_Content_Image.image = THUMBNAIL_VIDEO(ATTACHED_MEDIA_FILES[indexPath.item].replacingOccurrences(of: "%2520", with: "%20"))
            }
            CELL.Play_Image.isHidden = false
            return CELL
        case "p":   // 이미지
            
            let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "SOSIK_CC", for: indexPath) as! SOSIK_CC
            
            let KOREAN_URL = ATTACHED_MEDIA_FILES[indexPath.item].replacingOccurrences(of: "%2520", with: "%20").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            NUKE_IMAGE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: .gifImageWithName("loading_")!, PROFILE: CELL.School_Content_Image, FRAME_SIZE: CGSize(width: CollectionView.frame.size.width, height: CollectionView.frame.size.height))
            CELL.Play_Image.isHidden = true
            
            return CELL
        default:
            
            let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "SOSIK_CC", for: indexPath) as! SOSIK_CC
            CELL.School_Content_Image.image = .gifImageWithName("loading_")
            CELL.Play_Image.isHidden = true
            return CELL
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if ATTACHED_MEDIA_TYPE[indexPath.item] == "v" {
            
            if ATTACHED_MEDIA_FILES[indexPath.item].contains("_media1.mp4") {
                
                let PLAYER = AVPlayer(url: URL(string: ATTACHED_MEDIA_FILES[indexPath.item].replacingOccurrences(of: "%2520", with: "%20"))!)
                let PLAYER_VC = AVPlayerViewController()
                PLAYER_VC.player = PLAYER
                PLAYER.play()
                PROTOCOL!.present(PLAYER_VC, animated: true)
            } else {
                
                let PLAYER = AVPlayer(url: URL(string: ATTACHED_MEDIA_FILES[indexPath.item].replacingOccurrences(of: "%2520", with: "%20")+"_media1.mp4")!)
                let PLAYER_VC = AVPlayerViewController()
                PLAYER_VC.player = PLAYER
                PLAYER.play()
                PROTOCOL!.present(PLAYER_VC, animated: true)
            }
        }
        
        if ATTACHED_MEDIA_TYPE[indexPath.item] == "p" {
            
            let VC = PROTOCOL!.storyboard?.instantiateViewController(withIdentifier: "IMAGE_DETAIL") as! IMAGE_DETAIL
            VC.modalTransitionStyle = .crossDissolve
            VC.SCHOOL_API = SCHOOL_API
            VC.SCHOOL_POSITION = SCHOOL_POSITION
            PROTOCOL!.present(VC, animated: true)
        }
    }
    
    // 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CollectionView.frame.size.width, height: CollectionView.frame.size.height)
    }
    
    func HTTP_SOSIK_UPDATE() {
            
        let DATA = SCHOOL_API[SCHOOL_POSITION]
        
        let PARAMETERS: Parameters = [
            "mb_id": UIViewController.USER_DATA.string(forKey: "mb_id") ?? "",
            "board_key": DATA.BOARD_KEY,
            "board_type": DATA.BOARD_TYPE,
            "action_type": "like"
        ]
        
        print("PARAMETERS -", PARAMETERS)
        
        Alamofire.upload(multipartFormData: { multipartFormData in

            for (KEY, VALUE) in PARAMETERS {
                
                print("KEY: \(KEY)", "value: \(VALUE)")
                multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
            }
        }, to: DECRYPT(KEY: DATA_URL().KEY, IV: DATA_URL().IV, URL: DATA_URL().BASE_URL) + "message/school_board_update.php") { (result) in
        
            switch result {
            case .success(let upload, _, _):
            
            upload.responseJSON { response in

                print("[LIKE] ", response)
            }
            case .failure(let encodingError):
                
                print(encodingError)
                break
            }
        }
    }
}

extension SOSIK_TC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let PAGE = scrollView.contentOffset.x / scrollView.frame.size.width
        
        self.PageView.currentPage = Int(PAGE)
        
        VIEWPASSED_N?.SCHOOL_API[SCHOOL_POSITION].PAGE = Int(PAGE)
    }
}

class SOSIK_CC: UICollectionViewCell {
    
    @IBOutlet weak var Play_Image: UIImageView!
    @IBOutlet weak var School_Content_Image: UIImageView!           // contentImage - 이미지
    @IBOutlet weak var School_Content_Youtube: WKYTPlayerView!      // contentYoutube - 유튜브
}
