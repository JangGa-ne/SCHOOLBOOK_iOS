//
//  SOSIK_DETAIL_TC.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/05/13.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import AVKit
import YoutubePlayer_in_WKWebView

class SOSIK_DETAIL_TC: UITableViewCell {
    
    var PROTOCOL: UIViewController?
    
    var SCHOOL_API: [SCHOOL_DATA] = []
    var SCHOOL_POSITION: Int = 0
    
    var ATTACHED_DATETIME: [String] = []
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
    
    // 상세보기
    @IBOutlet weak var School_Content_View: UIView!
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var PageView: UIPageControl!
    @IBOutlet weak var School_Subject_Label: UILabel!               // subjectLabel - 공지사항 제목
    @IBOutlet weak var School_Notice_Content_Label: UITextView!     // noticeContenLabel - 공지사항 내용
    
    public weak var VIEWPASSED: SOSIK_DETAIL?       // 상세보기
    
    // 학부모연수
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Content: UITextView!
}

extension SOSIK_DETAIL_TC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        
        let DATA = SCHOOL_API[SCHOOL_POSITION]
        
        if DATA.ATTACHED.count != 0 {
            
            for i in 0 ..< DATA.ATTACHED.count {
                
                if DATA.ATTACHED[i].MEDIA_TYPE != "f" {
                    
                    ATTACHED_DATETIME.append(DATA.ATTACHED[i].DATETIME)
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
            
            let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "SOSIK_DETAIL_CC_Y", for: indexPath) as! SOSIK_DETAIL_CC
            CELL.School_Content_Youtube.layer.cornerRadius = 10.0
            CELL.School_Content_Youtube.clipsToBounds = true
            CELL.School_Content_Youtube.load(withVideoId: ATTACHED_FILE_NAME[indexPath.item])
            CELL.School_Content_Youtube.backgroundColor = .black
            return CELL
        case "v":   // 동영상
            
            let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "SOSIK_DETAIL_CC", for: indexPath) as! SOSIK_DETAIL_CC
            
            CELL.School_Content_Image.layer.cornerRadius = 10.0
            CELL.School_Content_Image.clipsToBounds = true
            
            if ATTACHED_MEDIA_FILES[indexPath.item].contains("_media1.mp4") {
                let MEDIA_FILES = ATTACHED_MEDIA_FILES[indexPath.item].replacingOccurrences(of: "%2520", with: "%20").replacingOccurrences(of: "_media1.mp4", with: "_mplayer1_1.png")
                NUKE_IMAGE(IMAGE_URL: MEDIA_FILES, PLACEHOLDER: .gifImageWithName("loading_")!, PROFILE: CELL.School_Content_Image, FRAME_SIZE: CGSize(width: CollectionView.frame.size.width, height: 260.0))
            } else  {
                CELL.School_Content_Image.image = THUMBNAIL_VIDEO(ATTACHED_MEDIA_FILES[indexPath.item].replacingOccurrences(of: "%2520", with: "%20"))
            }
            CELL.Play_Image.isHidden = false
            
            return CELL
        case "p":   // 이미지
            
            let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "SOSIK_DETAIL_CC", for: indexPath) as! SOSIK_DETAIL_CC
            
            CELL.School_Content_Image.layer.cornerRadius = 10.0
            CELL.School_Content_Image.clipsToBounds = true
            
            let KOREAN_URL = ATTACHED_MEDIA_FILES[indexPath.item].replacingOccurrences(of: "%2520", with: "%20").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            NUKE_IMAGE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: .gifImageWithName("loading_")!, PROFILE: CELL.School_Content_Image, FRAME_SIZE: CGSize(width: CollectionView.frame.size.width, height: 260.0))
            CELL.Play_Image.isHidden = true
            
            return CELL
        default:
            
            let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "SOSIK_DETAIL_CC", for: indexPath) as! SOSIK_DETAIL_CC
            CELL.School_Content_Image.layer.cornerRadius = 10.0
            CELL.School_Content_Image.clipsToBounds = true
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
        
        if ATTACHED_MEDIA_TYPE[indexPath.item] == "f" || ATTACHED_MEDIA_TYPE[indexPath.item] == "p" {
            
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
}

extension SOSIK_DETAIL_TC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let PAGE = scrollView.contentOffset.x / scrollView.frame.size.width
        self.PageView.currentPage = Int(PAGE)
        VIEWPASSED?.SCHOOL_API[SCHOOL_POSITION].PAGE = Int(PAGE)
    }
}

class SOSIK_DETAIL_CC: UICollectionViewCell {
    
    @IBOutlet weak var Play_Image: UIImageView!
    @IBOutlet weak var School_Content_Image: UIImageView!           // contentImage - 이미지
    @IBOutlet weak var School_Content_Youtube: WKYTPlayerView!      // contentYoutube - 유튜브
}
