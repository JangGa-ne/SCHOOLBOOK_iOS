//
//  IMAGE_DETAIL.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/05/21.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import AVKit
import SwiftyGif
import YoutubePlayer_in_WKWebView

class IMAGE_DETAIL_CC: UICollectionViewCell {
    
    @IBOutlet weak var Play_Image: UIImageView!
    @IBOutlet weak var School_Content_Image: UIImageView!           // contentImage - 이미지
    @IBOutlet weak var School_Content_Youtube: WKYTPlayerView!      // contentYoutube - 유튜브
}

class IMAGE_DETAIL: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    var SCHOOL_API: [SCHOOL_DATA] = []
    var SCHOOL_POSITION = 0
    
    var SELECT: Bool = true
    
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
    
    @IBOutlet weak var NAVI_BG: UIView!
    @IBOutlet weak var NAVI_VIEW: UIView!
    @IBOutlet weak var BOTTOM_BG: UIView!
    @IBOutlet weak var BOTTOM_VIEW: UIView!
    
    @IBOutlet weak var DATE: UILabel!
    @IBOutlet weak var TIME: UILabel!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    @IBOutlet weak var Image_Count: UILabel!                        // PageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CollectionView.delegate = self
        CollectionView.dataSource = self
        CollectionView.reloadData()
        
        let LAYER = UICollectionViewFlowLayout()
        LAYER.scrollDirection = .horizontal
        LAYER.minimumLineSpacing = 0.0
        CollectionView.setCollectionViewLayout(LAYER, animated: false)
        
        ATTACHED_DATETIME.removeAll()
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
                
                    ATTACHED_DATETIME.append(DATA.ATTACHED_DATETIME.components(separatedBy: "|")[i])
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
        
        let DATETIME = DateFormatter()
        DATETIME.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let DATETIME_ = DATETIME.date(from: DATA.DATETIME) ?? Date()
        
        DATETIME.dateFormat = "MM월 dd일"
        DATE.text = DATETIME.string(from: DATETIME_)
        
        DATETIME.locale = Locale(identifier: "ko_kr")
        DATETIME.dateFormat = "E요일"
//        DATETIME.dateFormat = "a H:mm"
//        DATETIME.amSymbol = "오전"
//        DATETIME.pmSymbol = "오후"
        TIME.text = DATETIME.string(from: DATETIME_)
        
        Image_Count.layer.cornerRadius = 12.5
        Image_Count.clipsToBounds = true
        Image_Count.text = "1 / \(ATTACHED_MEDIA_TYPE.count)"
    }
    
    public weak var VIEWPASSED: IMAGE_DETAIL?       // 이미지상세보기

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let PAGE = scrollView.contentOffset.x / scrollView.frame.size.width
        
        Image_Count.text = "\(Int(PAGE)+1) / \(ATTACHED_MEDIA_TYPE.count)"
        VIEWPASSED?.SCHOOL_API[SCHOOL_POSITION].PAGE = Int(PAGE)
    }
}

extension IMAGE_DETAIL: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if ATTACHED_MEDIA_TYPE.count == 0 {
            CollectionView.isHidden = true
            return 0
        } else {
            CollectionView.isHidden = false
            return ATTACHED_MEDIA_TYPE.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch ATTACHED_MEDIA_TYPE[indexPath.item] {
        case "y":   // 유튜브
            
            let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "IMAGE_DETAIL_CC_Y", for: indexPath) as! IMAGE_DETAIL_CC
            CELL.School_Content_Youtube.load(withVideoId: ATTACHED_FILE_NAME[indexPath.item].replacingOccurrences(of: "%2520", with: "%20"))
            CELL.School_Content_Youtube.backgroundColor = .black
            return CELL
        case "v":   // 동영상
            
            let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "IMAGE_DETAIL_CC", for: indexPath) as! IMAGE_DETAIL_CC
            
            if ATTACHED_MEDIA_FILES[indexPath.item].contains("_media1.mp4") {
                let MEDIA_FILES = ATTACHED_MEDIA_FILES[indexPath.item].replacingOccurrences(of: "%2520", with: "%20").replacingOccurrences(of: "_media1.mp4", with: "_mplayer1_1.png")
                NUKE_DETAIL_IMAGE(IMAGE_URL: MEDIA_FILES, PLACEHOLDER: .gifImageWithName("loading_")!, PROFILE: CELL.School_Content_Image, FRAME_SIZE: CGSize(width: CollectionView.frame.size.width, height: 260.0))
            } else  {
                CELL.School_Content_Image.image = THUMBNAIL_VIDEO(ATTACHED_MEDIA_FILES[indexPath.item].replacingOccurrences(of: "%2520", with: "%20"))
            }
            CELL.Play_Image.isHidden = false
            
            return CELL
        case "p":   // 이미지
            
            let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "IMAGE_DETAIL_CC", for: indexPath) as! IMAGE_DETAIL_CC
            
            let KOREAN_URL = ATTACHED_MEDIA_FILES[indexPath.item].addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            NUKE_DETAIL_IMAGE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: .gifImageWithName("loading_")!, PROFILE: CELL.School_Content_Image, FRAME_SIZE: CGSize(width: CollectionView.frame.size.width, height: 260.0))
            CELL.Play_Image.isHidden = true
            
            return CELL
        default:
            
            let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "IMAGE_DETAIL_CC", for: indexPath) as! IMAGE_DETAIL_CC
            CELL.School_Content_Image.image = .gifImageWithName("loading_")
            CELL.Play_Image.isHidden = true
            return CELL
        }
    }
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        if ATTACHED_MEDIA_TYPE[indexPath.item] == "p" {
        
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
                
                let KOREAN_URL = self.ATTACHED_MEDIA_FILES[indexPath.item].addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                
                let IMAGE_TO_CLIP = UIAction(title: "이미지 복사하기", image: UIImage(systemName: "doc.on.clipboard")) { action in

                    let IMAGE_DATA = try! Data(contentsOf: URL(string: KOREAN_URL ?? "")!)
                    let IMAGE_SAVE = UIImage(data: IMAGE_DATA)
                    UIPasteboard.general.image = IMAGE_SAVE
                }
                
                let IMAGE_TO_SAVE = UIAction(title: "카메라 롤에 저장", image: UIImage(systemName: "square.and.arrow.down")) { action in
                    
                    let IMAGE_DATA = try! Data(contentsOf: URL(string: KOREAN_URL ?? "")!)
                    let IMAGE_SAVE = UIImage(data: IMAGE_DATA)
                    UIImageWriteToSavedPhotosAlbum(IMAGE_SAVE!, nil, nil, nil)
                }
                
                return UIMenu(title: "", children: [IMAGE_TO_CLIP, IMAGE_TO_SAVE])
            }
        } else {
            return nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if SELECT == true {
            
            SELECT = false
            UIView.animate(withDuration: 0.2, animations: {
                
                self.NAVI_BG.alpha = 0.0
                self.NAVI_VIEW.alpha = 0.0
                self.BOTTOM_BG.alpha = 0.0
                self.BOTTOM_VIEW.alpha = 0.0
            })
        } else {
            
            SELECT = true
            UIView.animate(withDuration: 0.2, animations: {
                
                self.NAVI_BG.alpha = 1.0
                self.NAVI_VIEW.alpha = 1.0
                self.BOTTOM_BG.alpha = 1.0
                self.BOTTOM_VIEW.alpha = 1.0
            })
        }
        
        if ATTACHED_MEDIA_TYPE[indexPath.item] == "v" {
            
            if ATTACHED_MEDIA_FILES[indexPath.item].contains("_media1.mp4") {
                
                let PLAYER = AVPlayer(url: URL(string: ATTACHED_MEDIA_FILES[indexPath.item].replacingOccurrences(of: "%2520", with: "%20"))!)
                let PLAYER_VC = AVPlayerViewController()
                PLAYER_VC.player = PLAYER
                PLAYER.play()
                present(PLAYER_VC, animated: true)
            } else {
                
                let PLAYER = AVPlayer(url: URL(string: ATTACHED_MEDIA_FILES[indexPath.item].replacingOccurrences(of: "%2520", with: "%20")+"_media1.mp4")!)
                let PLAYER_VC = AVPlayerViewController()
                PLAYER_VC.player = PLAYER
                PLAYER.play()
                present(PLAYER_VC, animated: true)
            }
        }
    }
    
    // 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CollectionView.frame.size.width, height: CollectionView.frame.size.height)
    }
}
