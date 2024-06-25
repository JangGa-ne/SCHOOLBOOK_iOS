//
//  DATA_API.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/07/21.
//  Copyright © 2020 장제현. All rights reserved.
//

import Foundation

// URL
class DATA_URL {
    
    let KEY: String = "passwordpasswordpasswordpassword"
    let IV: [UInt8] = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    var BASE_URL: [UInt8] = [88, 68, 55, 103, 28, 127, 168, 226, 107, 161, 191, 176, 175, 1, 154, 25, 132, 93, 71, 140, 70, 15, 116, 253, 193, 250, 24, 78, 30, 55, 96, 27, 54, 228, 61, 90, 64, 67, 16, 157, 67, 88, 169, 156, 87, 204, 103, 153]
    var SMS_URL: [UInt8] = [88, 68, 55, 103, 28, 127, 168, 226, 107, 161, 191, 176, 175, 1, 154, 25, 132, 93, 71, 140, 70, 15, 116, 253, 193, 250, 24, 78, 30, 55, 96, 27, 60, 157, 255, 236, 219, 169, 70, 118, 84, 47, 221, 117, 37, 158, 227, 211, 221, 2, 92, 35, 107, 160, 88, 26, 208, 113, 6, 47, 243, 229, 150, 191]
    var SCHOOL_LOGO_URL: [UInt8] = [144, 67, 140, 22, 61, 235, 147, 190, 107, 173, 39, 182, 97, 116, 166, 99, 27, 27, 172, 21, 61, 200, 250, 52, 24, 146, 64, 232, 62, 168, 8, 254, 159, 111, 236, 193, 211, 12, 42, 32, 141, 249, 43, 119, 105, 180, 38, 168]
    var PROFILE_IMAGE_URL: [UInt8] = [144, 67, 140, 22, 61, 235, 147, 190, 107, 173, 39, 182, 97, 116, 166, 99, 6, 67, 46, 7, 236, 189, 72, 113, 226, 31, 224, 30, 18, 94, 235, 247, 62, 4, 146, 238, 210, 43, 58, 214, 16, 8, 167, 68, 70, 43, 90, 51]
}

// 주소록
public class CONTACT_DATA {
    
    // MAIN
    var BOOK_CODE: String = ""
    var CAN_WRITE: String = ""
    var DEPTH: String = ""
    var IDX: String = ""
    var ORDER_LIST: String = ""
    var S_IDX: String = ""
    var SC_CODE: String = ""
    var SC_GRADE: String = ""
    var SC_GROUP: String = ""
    var SC_LOCATION: String = ""
    var SC_NAME: String = ""
    var UPPER_CODE: String = ""
    
    func SET_BOOK_CODE(BOOK_CODE: Any) { self.BOOK_CODE = BOOK_CODE as? String ?? "" }
    func SET_CAN_WRITE(CAN_WRITE: Any) { self.CAN_WRITE = CAN_WRITE as? String ?? "" }
    func SET_DEPTH(DEPTH: Any) { self.DEPTH = DEPTH as? String ?? "" }
    func SET_IDX(IDX: Any) { self.IDX = IDX as? String ?? "" }
    func SET_ORDER_LIST(ORDER_LIST: Any) { self.ORDER_LIST = ORDER_LIST as? String ?? "" }
    func SET_S_IDX(S_IDX: Any) { self.S_IDX = S_IDX as? String ?? "" }
    func SET_SC_CODE(SC_CODE: Any) { self.SC_CODE = SC_CODE as? String ?? "" }
    func SET_SC_GRADE(SC_GRADE: Any) { self.SC_GRADE = SC_GRADE as? String ?? "" }
    func SET_SC_GROUP(SC_GROUP: Any) { self.SC_GROUP = SC_GROUP as? String ?? "" }
    func SET_SC_LOCATION(SC_LOCATION: Any) { self.SC_LOCATION = SC_LOCATION as? String ?? "" }
    func SET_SC_NAME(SC_NAME: Any) { self.SC_NAME = SC_NAME as? String ?? "" }
    func SET_UPPER_CODE(UPPER_CODE: Any) { self.UPPER_CODE = UPPER_CODE as? String ?? "" }
    
    
    // LIST
    var AP_SMS: String = ""
    var BG_NAME: String = ""
    var BG_NO: String = ""
    var BK_GRADE: String = ""
    var BK_GRADE_CODE: String = ""
    var BK_HP: String = ""
    var BK_NAME: String = ""
    var BK_NO: String = ""
//    var BOOK_CODE: String = ""
    var BOOK_CODE2: String = ""
    var BOOK_TYPE: String = ""
    var EDUBOOK_DISPLAY: String = ""
    var EDUBOOK_GRADE: String = ""
    var EDUBOOK_GRADE2: String = ""
    var EDUBOOK_GROUP: String = ""
    var EDUBOOK_GROUP2: String = ""
    var FCM_KEY: String = ""
    var INFO_PROV: String = ""
    var LIST_TYPE: String = ""
    var MB_CLASS: String = ""
    var MB_FILE: String = ""
    var MB_GRADE: String = ""
    var MB_ID: String = ""
    var MB_LEVEL: String = ""
    var MB_LOGIN_IP: String = ""
    var MB_PASSWORD: String = ""
    var MB_PHONE: String = ""
    var MB_ROLE: String = ""
    var MB_ROLE2: String = ""
    var MB_TODAY_LOGIN: String = ""
    var MB_TYPE: String = ""
    var NEIS_CODE: String = ""
//    var ORDER_LIST: String = ""
    var REG_DATE: String = ""
//    var S_IDX: String = ""
    var SAFE_NUMBER: String = ""
//    var SC_CODE: String = ""
//    var SC_GRADE: String = ""
    var SC_GRADE_NAME: String = ""
//    var SC_GROUP: String = ""
    var SC_GROUP_NAME: String = ""
//    var SC_LOCATION: String = ""
//    var SC_NAME: String = ""
//    var UPPER_CODE: String = ""
    
    func SET_AP_SMS(AP_SMS: Any) { self.AP_SMS = AP_SMS as? String ?? "" }
    func SET_BG_NAME(BG_NAME: Any) { self.BG_NAME = BG_NAME as? String ?? "" }
    func SET_BG_NO(BG_NO: Any) { self.BG_NO = BG_NO as? String ?? "" }
    func SET_BK_GRADE(BK_GRADE: Any) { self.BK_GRADE = BK_GRADE as? String ?? "" }
    func SET_BK_GRADE_CODE(BK_GRADE_CODE: Any) { self.BK_GRADE_CODE = BK_GRADE_CODE as? String ?? "" }
    func SET_BK_HP(BK_HP: Any) { self.BK_HP = BK_HP as? String ?? "" }
    func SET_BK_NAME(BK_NAME: Any) { self.BK_NAME = BK_NAME as? String ?? "" }
    func SET_BK_NO(BK_NO: Any) { self.BK_NO = BK_NO as? String ?? "" }
//    func SET_BOOK_CODE(BOOK_CODE: Any) { self.BOOK_CODE = BOOK_CODE as? String ?? "" }
    func SET_BOOK_CODE2(BOOK_CODE2: Any) { self.BOOK_CODE2 = BOOK_CODE2 as? String ?? "" }
    func SET_BOOK_TYPE(BOOK_TYPE: Any) { self.BOOK_TYPE = BOOK_TYPE as? String ?? "" }
    func SET_EDUBOOK_DISPLAY(EDUBOOK_DISPLAY: Any) { self.EDUBOOK_DISPLAY = EDUBOOK_DISPLAY as? String ?? "" }
    func SET_EDUBOOK_GRADE(EDUBOOK_GRADE: Any) { self.EDUBOOK_GRADE = EDUBOOK_GRADE as? String ?? "" }
    func SET_EDUBOOK_GRADE2(EDUBOOK_GRADE2: Any) { self.EDUBOOK_GRADE2 = EDUBOOK_GRADE2 as? String ?? "" }
    func SET_EDUBOOK_GROUP(EDUBOOK_GROUP: Any) { self.EDUBOOK_GROUP = EDUBOOK_GROUP as? String ?? "" }
    func SET_EDUBOOK_GROUP2(EDUBOOK_GROUP2: Any) { self.EDUBOOK_GROUP2 = EDUBOOK_GROUP2 as? String ?? "" }
    func SET_FCM_KEY(FCM_KEY: Any) { self.FCM_KEY = FCM_KEY as? String ?? "" }
    func SET_INFO_PROV(INFO_PROV: Any) { self.INFO_PROV = INFO_PROV as? String ?? "" }
    func SET_LIST_TYPE(LIST_TYPE: Any) { self.LIST_TYPE = LIST_TYPE as? String ?? "" }
    func SET_MB_CLASS(MB_CLASS: Any) { self.MB_CLASS = MB_CLASS as? String ?? "" }
    func SET_MB_FILE(MB_FILE: Any) { self.MB_FILE = MB_FILE as? String ?? "" }
    func SET_MB_GRADE(MB_GRADE: Any) { self.MB_GRADE = MB_GRADE as? String ?? "" }
    func SET_MB_ID(MB_ID: Any) { self.MB_ID = MB_ID as? String ?? "" }
    func SET_MB_LEVEL(MB_LEVEL: Any) { self.MB_LEVEL = MB_LEVEL as? String ?? "" }
    func SET_MB_LOGIN_IP(MB_LOGIN_IP: Any) { self.MB_LOGIN_IP = MB_LOGIN_IP as? String ?? "" }
    func SET_MB_PASSWORD(MB_PASSWORD: Any) { self.MB_PASSWORD = MB_PASSWORD as? String ?? "" }
    func SET_MB_PHONE(MB_PHONE: Any) { self.MB_PHONE = MB_PHONE as? String ?? "" }
    func SET_MB_ROLE(MB_ROLE: Any) { self.MB_ROLE = MB_ROLE as? String ?? "" }
    func SET_MB_ROLE2(MB_ROLE2: Any) { self.MB_ROLE2 = MB_ROLE2 as? String ?? "" }
    func SET_MB_TODAY_LOGIN(MB_TODAY_LOGIN: Any) { self.MB_TODAY_LOGIN = MB_TODAY_LOGIN as? String ?? "" }
    func SET_MB_TYPE(MB_TYPE: Any) { self.MB_TYPE = MB_TYPE as? String ?? "" }
    func SET_NEIS_CODE(NEIS_CODE: Any) { self.NEIS_CODE = NEIS_CODE as? String ?? "" }
//    func SET_ORDER_LIST(ORDER_LIST: Any) { self.ORDER_LIST = ORDER_LIST as? String ?? "" }
    func SET_REG_DATE(REG_DATE: Any) { self.REG_DATE = REG_DATE as? String ?? "" }
//    func SET_S_IDX(S_IDX: Any) { self.S_IDX = S_IDX as? String ?? "" }
    func SET_SAFE_NUMBER(SAFE_NUMBER: Any) { self.SAFE_NUMBER = SAFE_NUMBER as? String ?? "" }
//    func SET_SC_CODE(SC_CODE: Any) { self.SC_CODE = SC_CODE as? String ?? "" }
//    func SET_SC_GRADE(SC_GRADE: Any) { self.SC_GRADE = SC_GRADE as? String ?? "" }
    func SET_SC_GRADE_NAME(SC_GRADE_NAME: Any) { self.SC_GRADE_NAME = SC_GRADE_NAME as? String ?? "" }
//    func SET_SC_GROUP(SC_GROUP: Any) { self.SC_GROUP = SC_GROUP as? String ?? "" }
    func SET_SC_GROUP_NAME(SC_GROUP_NAME: Any) { self.SC_GROUP_NAME = SC_GROUP_NAME as? String ?? "" }
//    func SET_SC_LOCATION(SC_LOCATION: Any) { self.SC_LOCATION = SC_LOCATION as? String ?? "" }
//    func SET_SC_NAME(SC_NAME: Any) { self.SC_NAME = SC_NAME as? String ?? "" }
//    func SET_UPPER_CODE(UPPER_CODE: Any) { self.UPPER_CODE = UPPER_CODE as? String ?? "" }
}

// 검색
public class SEARCH_DATA {
    
    var AP_SMS: String = ""
    var BG_NAME: String = ""
    var BG_NO: String = ""
    var BK_GRADE: String = ""
    var BK_GRADE_CODE: String = ""
    var BK_HP: String = ""
    var BK_NAME: String = ""
    var BK_NO: String = ""
    var BOOK_CODE: String = ""
    var BOOK_CODE2: String = ""
    var BOOK_TYPE: String = ""
    var EDUBOOK_DISPLAY: String = ""
    var EDUBOOK_GRADE: String = ""
    var EDUBOOK_GRADE2: String = ""
    var EDUBOOK_GROUP: String = ""
    var EDUBOOK_GROUP2: String = ""
    var FCM_KEY: String = ""
    var INFO_PROV: String = ""
    var LIST_TYPE: String = ""
    var MB_CLASS: String = ""
    var MB_FILE: String = ""
    var MB_GRADE: String = ""
    var MB_ID: String = ""
    var MB_LEVEL: String = ""
    var MB_LOGIN_IP: String = ""
    var MB_PASSWORD: String = ""
    var MB_PHONE: String = ""
    var MB_ROLE: String = ""
    var MB_ROLE2: String = ""
    var MB_TODAY_LOGIN: String = ""
    var MB_TYPE: String = ""
    var NEIS_CODE: String = ""
    var ORDER_LIST: String = ""
    var REG_DATE: String = ""
    var S_IDX: String = ""
    var SAFE_NUMBER: String = ""
    var SC_CODE: String = ""
    var SC_GRADE: String = ""
    var SC_GRADE_NAME: String = ""
    var SC_GROUP: String = ""
    var SC_GROUP_NAME: String = ""
    var SC_LOCATION: String = ""
    var SC_NAME: String = ""
    var UPPER_CODE: String = ""
    
    func SET_AP_SMS(AP_SMS: Any) { self.AP_SMS = AP_SMS as? String ?? "" }
    func SET_BG_NAME(BG_NAME: Any) { self.BG_NAME = BG_NAME as? String ?? "" }
    func SET_BG_NO(BG_NO: Any) { self.BG_NO = BG_NO as? String ?? "" }
    func SET_BK_GRADE(BK_GRADE: Any) { self.BK_GRADE = BK_GRADE as? String ?? "" }
    func SET_BK_GRADE_CODE(BK_GRADE_CODE: Any) { self.BK_GRADE_CODE = BK_GRADE_CODE as? String ?? "" }
    func SET_BK_HP(BK_HP: Any) { self.BK_HP = BK_HP as? String ?? "" }
    func SET_BK_NAME(BK_NAME: Any) { self.BK_NAME = BK_NAME as? String ?? "" }
    func SET_BK_NO(BK_NO: Any) { self.BK_NO = BK_NO as? String ?? "" }
    func SET_BOOK_CODE(BOOK_CODE: Any) { self.BOOK_CODE = BOOK_CODE as? String ?? "" }
    func SET_BOOK_CODE2(BOOK_CODE2: Any) { self.BOOK_CODE2 = BOOK_CODE2 as? String ?? "" }
    func SET_BOOK_TYPE(BOOK_TYPE: Any) { self.BOOK_TYPE = BOOK_TYPE as? String ?? "" }
    func SET_EDUBOOK_DISPLAY(EDUBOOK_DISPLAY: Any) { self.EDUBOOK_DISPLAY = EDUBOOK_DISPLAY as? String ?? "" }
    func SET_EDUBOOK_GRADE(EDUBOOK_GRADE: Any) { self.EDUBOOK_GRADE = EDUBOOK_GRADE as? String ?? "" }
    func SET_EDUBOOK_GRADE2(EDUBOOK_GRADE2: Any) { self.EDUBOOK_GRADE2 = EDUBOOK_GRADE2 as? String ?? "" }
    func SET_EDUBOOK_GROUP(EDUBOOK_GROUP: Any) { self.EDUBOOK_GROUP = EDUBOOK_GROUP as? String ?? "" }
    func SET_EDUBOOK_GROUP2(EDUBOOK_GROUP2: Any) { self.EDUBOOK_GROUP2 = EDUBOOK_GROUP2 as? String ?? "" }
    func SET_FCM_KEY(FCM_KEY: Any) { self.FCM_KEY = FCM_KEY as? String ?? "" }
    func SET_INFO_PROV(INFO_PROV: Any) { self.INFO_PROV = INFO_PROV as? String ?? "" }
    func SET_LIST_TYPE(LIST_TYPE: Any) { self.LIST_TYPE = LIST_TYPE as? String ?? "" }
    func SET_MB_CLASS(MB_CLASS: Any) { self.MB_CLASS = MB_CLASS as? String ?? "" }
    func SET_MB_FILE(MB_FILE: Any) { self.MB_FILE = MB_FILE as? String ?? "" }
    func SET_MB_GRADE(MB_GRADE: Any) { self.MB_GRADE = MB_GRADE as? String ?? "" }
    func SET_MB_ID(MB_ID: Any) { self.MB_ID = MB_ID as? String ?? "" }
    func SET_MB_LEVEL(MB_LEVEL: Any) { self.MB_LEVEL = MB_LEVEL as? String ?? "" }
    func SET_MB_LOGIN_IP(MB_LOGIN_IP: Any) { self.MB_LOGIN_IP = MB_LOGIN_IP as? String ?? "" }
    func SET_MB_PASSWORD(MB_PASSWORD: Any) { self.MB_PASSWORD = MB_PASSWORD as? String ?? "" }
    func SET_MB_PHONE(MB_PHONE: Any) { self.MB_PHONE = MB_PHONE as? String ?? "" }
    func SET_MB_ROLE(MB_ROLE: Any) { self.MB_ROLE = MB_ROLE as? String ?? "" }
    func SET_MB_ROLE2(MB_ROLE2: Any) { self.MB_ROLE2 = MB_ROLE2 as? String ?? "" }
    func SET_MB_TODAY_LOGIN(MB_TODAY_LOGIN: Any) { self.MB_TODAY_LOGIN = MB_TODAY_LOGIN as? String ?? "" }
    func SET_MB_TYPE(MB_TYPE: Any) { self.MB_TYPE = MB_TYPE as? String ?? "" }
    func SET_NEIS_CODE(NEIS_CODE: Any) { self.NEIS_CODE = NEIS_CODE as? String ?? "" }
    func SET_ORDER_LIST(ORDER_LIST: Any) { self.ORDER_LIST = ORDER_LIST as? String ?? "" }
    func SET_REG_DATE(REG_DATE: Any) { self.REG_DATE = REG_DATE as? String ?? "" }
    func SET_S_IDX(S_IDX: Any) { self.S_IDX = S_IDX as? String ?? "" }
    func SET_SAFE_NUMBER(SAFE_NUMBER: Any) { self.SAFE_NUMBER = SAFE_NUMBER as? String ?? "" }
    func SET_SC_CODE(SC_CODE: Any) { self.SC_CODE = SC_CODE as? String ?? "" }
    func SET_SC_GRADE(SC_GRADE: Any) { self.SC_GRADE = SC_GRADE as? String ?? "" }
    func SET_SC_GRADE_NAME(SC_GRADE_NAME: Any) { self.SC_GRADE_NAME = SC_GRADE_NAME as? String ?? "" }
    func SET_SC_GROUP(SC_GROUP: Any) { self.SC_GROUP = SC_GROUP as? String ?? "" }
    func SET_SC_GROUP_NAME(SC_GROUP_NAME: Any) { self.SC_GROUP_NAME = SC_GROUP_NAME as? String ?? "" }
    func SET_SC_LOCATION(SC_LOCATION: Any) { self.SC_LOCATION = SC_LOCATION as? String ?? "" }
    func SET_SC_NAME(SC_NAME: Any) { self.SC_NAME = SC_NAME as? String ?? "" }
    func SET_UPPER_CODE(UPPER_CODE: Any) { self.UPPER_CODE = UPPER_CODE as? String ?? "" }
}

// 연락처 자세히보기
public class DETAIL_DATA {
    
    var AP_SMS: String = ""
    var BG_NAME: String = ""
    var BG_NO: String = ""
    var BK_GRADE: String = ""
    var BK_GRADE_CODE: String = ""
    var BK_HP: String = ""
    var BK_NAME: String = ""
    var BK_NO: String = ""
    var BOOK_CODE: String = ""
    var BOOK_CODE2: String = ""
    var BOOK_TYPE: String = ""
    var EDUBOOK_DISPLAY: String = ""
    var EDUBOOK_GRADE: String = ""
    var EDUBOOK_GRADE2: String = ""
    var EDUBOOK_GROUP: String = ""
    var EDUBOOK_GROUP2: String = ""
    var FCM_KEY: String = ""
    var INFO_PROV: String = ""
    var LIST_TYPE: String = ""
    var MB_CLASS: String = ""
    var MB_FILE: String = ""
    var MB_GRADE: String = ""
    var MB_ID: String = ""
    var MB_LEVEL: String = ""
    var MB_LOGIN_IP: String = ""
    var MB_PASSWORD: String = ""
    var MB_PHONE: String = ""
    var MB_ROLE: String = ""
    var MB_ROLE2: String = ""
    var MB_TODAY_LOGIN: String = ""
    var MB_TYPE: String = ""
    var NEIS_CODE: String = ""
    var ORDER_LIST: String = ""
    var REG_DATE: String = ""
    var S_IDX: String = ""
    var SAFE_NUMBER: String = ""
    var SC_CODE: String = ""
    var SC_GRADE: String = ""
    var SC_GRADE_NAME: String = ""
    var SC_GROUP: String = ""
    var SC_GROUP_NAME: String = ""
    var SC_LOCATION: String = ""
    var SC_NAME: String = ""
    var UPPER_CODE: String = ""
    
    func SET_AP_SMS(AP_SMS: Any) { self.AP_SMS = AP_SMS as? String ?? "" }
    func SET_BG_NAME(BG_NAME: Any) { self.BG_NAME = BG_NAME as? String ?? "" }
    func SET_BG_NO(BG_NO: Any) { self.BG_NO = BG_NO as? String ?? "" }
    func SET_BK_GRADE(BK_GRADE: Any) { self.BK_GRADE = BK_GRADE as? String ?? "" }
    func SET_BK_GRADE_CODE(BK_GRADE_CODE: Any) { self.BK_GRADE_CODE = BK_GRADE_CODE as? String ?? "" }
    func SET_BK_HP(BK_HP: Any) { self.BK_HP = BK_HP as? String ?? "" }
    func SET_BK_NAME(BK_NAME: Any) { self.BK_NAME = BK_NAME as? String ?? "" }
    func SET_BK_NO(BK_NO: Any) { self.BK_NO = BK_NO as? String ?? "" }
    func SET_BOOK_CODE(BOOK_CODE: Any) { self.BOOK_CODE = BOOK_CODE as? String ?? "" }
    func SET_BOOK_CODE2(BOOK_CODE2: Any) { self.BOOK_CODE2 = BOOK_CODE2 as? String ?? "" }
    func SET_BOOK_TYPE(BOOK_TYPE: Any) { self.BOOK_TYPE = BOOK_TYPE as? String ?? "" }
    func SET_EDUBOOK_DISPLAY(EDUBOOK_DISPLAY: Any) { self.EDUBOOK_DISPLAY = EDUBOOK_DISPLAY as? String ?? "" }
    func SET_EDUBOOK_GRADE(EDUBOOK_GRADE: Any) { self.EDUBOOK_GRADE = EDUBOOK_GRADE as? String ?? "" }
    func SET_EDUBOOK_GRADE2(EDUBOOK_GRADE2: Any) { self.EDUBOOK_GRADE2 = EDUBOOK_GRADE2 as? String ?? "" }
    func SET_EDUBOOK_GROUP(EDUBOOK_GROUP: Any) { self.EDUBOOK_GROUP = EDUBOOK_GROUP as? String ?? "" }
    func SET_EDUBOOK_GROUP2(EDUBOOK_GROUP2: Any) { self.EDUBOOK_GROUP2 = EDUBOOK_GROUP2 as? String ?? "" }
    func SET_FCM_KEY(FCM_KEY: Any) { self.FCM_KEY = FCM_KEY as? String ?? "" }
    func SET_INFO_PROV(INFO_PROV: Any) { self.INFO_PROV = INFO_PROV as? String ?? "" }
    func SET_LIST_TYPE(LIST_TYPE: Any) { self.LIST_TYPE = LIST_TYPE as? String ?? "" }
    func SET_MB_CLASS(MB_CLASS: Any) { self.MB_CLASS = MB_CLASS as? String ?? "" }
    func SET_MB_FILE(MB_FILE: Any) { self.MB_FILE = MB_FILE as? String ?? "" }
    func SET_MB_GRADE(MB_GRADE: Any) { self.MB_GRADE = MB_GRADE as? String ?? "" }
    func SET_MB_ID(MB_ID: Any) { self.MB_ID = MB_ID as? String ?? "" }
    func SET_MB_LEVEL(MB_LEVEL: Any) { self.MB_LEVEL = MB_LEVEL as? String ?? "" }
    func SET_MB_LOGIN_IP(MB_LOGIN_IP: Any) { self.MB_LOGIN_IP = MB_LOGIN_IP as? String ?? "" }
    func SET_MB_PASSWORD(MB_PASSWORD: Any) { self.MB_PASSWORD = MB_PASSWORD as? String ?? "" }
    func SET_MB_PHONE(MB_PHONE: Any) { self.MB_PHONE = MB_PHONE as? String ?? "" }
    func SET_MB_ROLE(MB_ROLE: Any) { self.MB_ROLE = MB_ROLE as? String ?? "" }
    func SET_MB_ROLE2(MB_ROLE2: Any) { self.MB_ROLE2 = MB_ROLE2 as? String ?? "" }
    func SET_MB_TODAY_LOGIN(MB_TODAY_LOGIN: Any) { self.MB_TODAY_LOGIN = MB_TODAY_LOGIN as? String ?? "" }
    func SET_MB_TYPE(MB_TYPE: Any) { self.MB_TYPE = MB_TYPE as? String ?? "" }
    func SET_NEIS_CODE(NEIS_CODE: Any) { self.NEIS_CODE = NEIS_CODE as? String ?? "" }
    func SET_ORDER_LIST(ORDER_LIST: Any) { self.ORDER_LIST = ORDER_LIST as? String ?? "" }
    func SET_REG_DATE(REG_DATE: Any) { self.REG_DATE = REG_DATE as? String ?? "" }
    func SET_S_IDX(S_IDX: Any) { self.S_IDX = S_IDX as? String ?? "" }
    func SET_SAFE_NUMBER(SAFE_NUMBER: Any) { self.SAFE_NUMBER = SAFE_NUMBER as? String ?? "" }
    func SET_SC_CODE(SC_CODE: Any) { self.SC_CODE = SC_CODE as? String ?? "" }
    func SET_SC_GRADE(SC_GRADE: Any) { self.SC_GRADE = SC_GRADE as? String ?? "" }
    func SET_SC_GRADE_NAME(SC_GRADE_NAME: Any) { self.SC_GRADE_NAME = SC_GRADE_NAME as? String ?? "" }
    func SET_SC_GROUP(SC_GROUP: Any) { self.SC_GROUP = SC_GROUP as? String ?? "" }
    func SET_SC_GROUP_NAME(SC_GROUP_NAME: Any) { self.SC_GROUP_NAME = SC_GROUP_NAME as? String ?? "" }
    func SET_SC_LOCATION(SC_LOCATION: Any) { self.SC_LOCATION = SC_LOCATION as? String ?? "" }
    func SET_SC_NAME(SC_NAME: Any) { self.SC_NAME = SC_NAME as? String ?? "" }
    func SET_UPPER_CODE(UPPER_CODE: Any) { self.UPPER_CODE = UPPER_CODE as? String ?? "" }
}

// 힉교 정보
public class SCHOOL_INFO_DATA {
    
    var AP_CHUL: String = ""
    var AP_DORM: String = ""
    var AP_FOOD: String = ""
    var AP_MILE: String = ""
    var BG_COUNT: String = ""
    var BG_NO: String = ""
    var BOOK_UPPER_CODE: String = ""
    var COUNT_EDUBOOK: String = ""
    var COUNT_ST: String = ""
    var COUNT_TEACHER: String = ""
    var DATETIME: String = ""
    var DISPLAY: String = ""
    var KA_BILL: String = ""
    var KA_MESSAGE: String = ""
    var KA_POINT: String = ""
    var KA_POLL: String = ""
    var KA_SMS: String = ""
    var LAT: String = ""
    var LATE_POINT: String = ""
    var LIST_TYPE: String = ""
    var LNG: String = ""
    var LOGO_URL: String = ""
    var MI_CHECK: String = ""
    var REG_FILE: String = ""
    var S_IDX: String = ""
    var SC_ADDRESS: String = ""
    var SC_CODE: String = ""
    var SC_EMAIL: String = ""
    var SC_FAX: String = ""
    var SC_GRADE: String = ""
    var SC_GRADE_NAME: String = ""
    var SC_GROUP: String = ""
    var SC_GROUP_NAME: String = ""
    var SC_HOME_PAGE: String = ""
    var SC_IN: String = ""
    var SC_IN_BTE: String = ""
    var SC_IN_BTS: String = ""
    var SC_LATE: String = ""
    var SC_LOCATION: String = ""
    var SC_LOCATION_NAME: String = ""
    var SC_MAXP: String = ""
    var SC_NAME: String = ""
    var SC_OUT: String = ""
    var SC_OUT_BTE: String = ""
    var SC_OUT_BTS: String = ""
    var SC_TEACHER: String = ""
    var SC_TEACHER_HP: String = ""
    var SC_TEL: String = ""
    var SENDER_KEY: String = ""
    var SMS_DORMOUT: String = ""
    var SMS_IN: String = ""
    var SMS_LATE: String = ""
    var SMS_OUT: String = ""
    var SMS_POINT: String = ""
    var SMS_POINT_TEACHER: String = ""
    var SMS_USE: String = ""
    var UPPER_CODE: String = ""
    
    func SET_AP_CHUL(AP_CHUL: Any) { self.AP_CHUL = AP_CHUL as? String ?? "" }
    func SET_AP_DORM(AP_DORM: Any) { self.AP_DORM = AP_DORM as? String ?? "" }
    func SET_AP_FOOD(AP_FOOD: Any) { self.AP_FOOD = AP_FOOD as? String ?? "" }
    func SET_AP_MILE(AP_MILE: Any) { self.AP_MILE = AP_MILE as? String ?? "" }
    func SET_BG_COUNT(BG_COUNT: Any) { self.BG_COUNT = BG_COUNT as? String ?? "" }
    func SET_BG_NO(BG_NO: Any) { self.BG_NO = BG_NO as? String ?? "" }
    func SET_BOOK_UPPER_CODE(BOOK_UPPER_CODE: Any) { self.BOOK_UPPER_CODE = BOOK_UPPER_CODE as? String ?? "" }
    func SET_COUNT_EDUBOOK(COUNT_EDUBOOK: Any) { self.COUNT_EDUBOOK = COUNT_EDUBOOK as? String ?? "" }
    func SET_COUNT_ST(COUNT_ST: Any) { self.COUNT_ST = COUNT_ST as? String ?? "" }
    func SET_COUNT_TEACHER(COUNT_TEACHER: Any) { self.COUNT_TEACHER = COUNT_TEACHER as? String ?? "" }
    func SET_DATETIME(DATETIME: Any) { self.DATETIME = DATETIME as? String ?? "" }
    func SET_DISPLAY(DISPLAY: Any) { self.DISPLAY = DISPLAY as? String ?? "" }
    func SET_KA_BILL(KA_BILL: Any) { self.KA_BILL = KA_BILL as? String ?? "" }
    func SET_KA_MESSAGE(KA_MESSAGE: Any) { self.KA_MESSAGE = KA_MESSAGE as? String ?? "" }
    func SET_KA_POINT(KA_POINT: Any) { self.KA_POINT = KA_POINT as? String ?? "" }
    func SET_KA_POLL(KA_POLL: Any) { self.KA_POLL = KA_POLL as? String ?? "" }
    func SET_KA_SMS(KA_SMS: Any) { self.KA_SMS = KA_SMS as? String ?? "" }
    func SET_LAT(LAT: Any) { self.LAT = LAT as? String ?? "" }
    func SET_LATE_POINT(LATE_POINT: Any) { self.LATE_POINT = LATE_POINT as? String ?? "" }
    func SET_LIST_TYPE(LIST_TYPE: Any) { self.LIST_TYPE = LIST_TYPE as? String ?? "" }
    func SET_LNG(LNG: Any) { self.LNG = LNG as? String ?? "" }
    func SET_LOGO_URL(LOGO_URL: Any) { self.LOGO_URL = LOGO_URL as? String ?? "" }
    func SET_MI_CHECK(MI_CHECK: Any) { self.MI_CHECK = MI_CHECK as? String ?? "" }
    func SET_REG_FILE(REG_FILE: Any) { self.REG_FILE = REG_FILE as? String ?? "" }
    func SET_S_IDX(S_IDX: Any) { self.S_IDX = S_IDX as? String ?? "" }
    func SET_SC_ADDRESS(SC_ADDRESS: Any) { self.SC_ADDRESS = SC_ADDRESS as? String ?? "" }
    func SET_SC_CODE(SC_CODE: Any) { self.SC_CODE = SC_CODE as? String ?? "" }
    func SET_SC_EMAIL(SC_EMAIL: Any) { self.SC_EMAIL = SC_EMAIL as? String ?? "" }
    func SET_SC_FAX(SC_FAX: Any) { self.SC_FAX = SC_FAX as? String ?? "" }
    func SET_SC_GRADE(SC_GRADE: Any) { self.SC_GRADE = SC_GRADE as? String ?? "" }
    func SET_SC_GRADE_NAME(SC_GRADE_NAME: Any) { self.SC_GRADE_NAME = SC_GRADE_NAME as? String ?? "" }
    func SET_SC_GROUP(SC_GROUP: Any) { self.SC_GROUP = SC_GROUP as? String ?? "" }
    func SET_SC_GROUP_NAME(SC_GROUP_NAME: Any) { self.SC_GROUP_NAME = SC_GROUP_NAME as? String ?? "" }
    func SET_SC_HOME_PAGE(SC_HOME_PAGE: Any) { self.SC_HOME_PAGE = SC_HOME_PAGE as? String ?? "" }
    func SET_SC_IN(SC_IN: Any) { self.SC_IN = SC_IN as? String ?? "" }
    func SET_SC_IN_BTE(SC_IN_BTE: Any) { self.SC_IN_BTE = SC_IN_BTE as? String ?? "" }
    func SET_SC_IN_BTS(SC_IN_BTS: Any) { self.SC_IN_BTS = SC_IN_BTS as? String ?? "" }
    func SET_SC_LATE(SC_LATE: Any) { self.SC_LATE = SC_LATE as? String ?? "" }
    func SET_SC_LOCATION(SC_LOCATION: Any) { self.SC_LOCATION = SC_LOCATION as? String ?? "" }
    func SET_SC_LOCATION_NAME(SC_LOCATION_NAME: Any) { self.SC_LOCATION_NAME = SC_LOCATION_NAME as? String ?? "" }
    func SET_SC_MAXP(SC_MAXP: Any) { self.SC_MAXP = SC_MAXP as? String ?? "" }
    func SET_SC_NAME(SC_NAME: Any) { self.SC_NAME = SC_NAME as? String ?? "" }
    func SET_SC_OUT(SC_OUT: Any) { self.SC_OUT = SC_OUT as? String ?? "" }
    func SET_SC_OUT_BTE(SC_OUT_BTE: Any) { self.SC_OUT_BTE = SC_OUT_BTE as? String ?? "" }
    func SET_SC_OUT_BTS(SC_OUT_BTS: Any) { self.SC_OUT_BTS = SC_OUT_BTS as? String ?? "" }
    func SET_SC_TEACHER(SC_TEACHER: Any) { self.SC_TEACHER = SC_TEACHER as? String ?? "" }
    func SET_SC_TEACHER_HP(SC_TEACHER_HP: Any) { self.SC_TEACHER_HP = SC_TEACHER_HP as? String ?? "" }
    func SET_SC_TEL(SC_TEL: Any) { self.SC_TEL = SC_TEL as? String ?? "" }
    func SET_SENDER_KEY(SENDER_KEY: Any) { self.SENDER_KEY = SENDER_KEY as? String ?? "" }
    func SET_SMS_DORMOUT(SMS_DORMOUT: Any) { self.SMS_DORMOUT = SMS_DORMOUT as? String ?? "" }
    func SET_SMS_IN(SMS_IN: Any) { self.SMS_IN = SMS_IN as? String ?? "" }
    func SET_SMS_LATE(SMS_LATE: Any) { self.AP_CHUL = SMS_LATE as? String ?? "" }
    func SET_SMS_OUT(SMS_OUT: Any) { self.SMS_OUT = SMS_OUT as? String ?? "" }
    func SET_SMS_POINT(SMS_POINT: Any) { self.SMS_POINT = SMS_POINT as? String ?? "" }
    func SET_SMS_POINT_TEACHER(SMS_POINT_TEACHER: Any) { self.SMS_POINT_TEACHER = SMS_POINT_TEACHER as? String ?? "" }
    func SET_SMS_USE(SMS_USE: Any) { self.SMS_USE = SMS_USE as? String ?? "" }
    func SET_UPPER_CODE(UPPER_CODE: Any) { self.UPPER_CODE = UPPER_CODE as? String ?? "" }
}

public class GMS_DATA {
    
    var LAT: Double = 0.0
    var LNG: Double = 0.0
    var NAME: String = ""
    
    func SET_LAT(LAT: Any) { self.LAT = LAT as? Double ?? 0.0 }
    func SET_LNG(LNG: Any) { self.LNG = LNG as? Double ?? 0.0 }
    func SET_NAME(NAME: Any) { self.NAME = NAME as? String ?? "" }
}

public class INDIVIDUAL_CONTACT_DATA {
    
    var BG_COUNT: String = ""
    var BG_NAME: String = ""
    var BG_NO: String = ""
    var LIST_TYPE: String = ""
    var MB_ID: String = ""
    
    func SET_BG_COUNT(BG_COUNT: Any) { self.BG_COUNT = BG_COUNT as? String ?? "" }
    func SET_BG_NAME(BG_NAME: Any) { self.BG_NAME = BG_NAME as? String ?? "" }
    func SET_BG_NO(BG_NO: Any) { self.BG_NO = BG_NO as? String ?? "" }
    func SET_LIST_TYPE(LIST_TYPE: Any) { self.LIST_TYPE = LIST_TYPE as? String ?? "" }
    func SET_MB_ID(MB_ID: Any) { self.MB_ID = MB_ID as? String ?? "" }
}

public class INDIVIDUAL_CONTACT_DETAIL_DATA {
    
    var BG_NAME: String = ""
    var BG_NO: String = ""
    var BK_DATETIME: String = ""
    var BK_HP: String = ""
    var BK_NAME: String = ""
    var BK_NO: String = ""
    var BK_PHONE: String = ""
    var BK_TYPE: String = ""
    var FCM_KEY: String = ""
    var LIST_TYPE: String = ""
    var MB_ID: String = ""
    var MEMO: String = ""
    
    func SET_BG_NAME(BG_NAME: Any) { self.BG_NAME = BG_NAME as? String ?? "" }
    func SET_BG_NO(BG_NO: Any) { self.BG_NO = BG_NO as? String ?? "" }
    func SET_BK_DATETIME(BK_DATETIME: Any) { self.BK_DATETIME = BK_DATETIME as? String ?? "" }
    func SET_BK_HP(BK_HP: Any) { self.BK_HP = BK_HP as? String ?? "" }
    func SET_BK_NAME(BK_NAME: Any) { self.BK_NAME = BK_NAME as? String ?? "" }
    func SET_BK_NO(BK_NO: Any) { self.BK_NO = BK_NO as? String ?? "" }
    func SET_BK_PHONE(BK_PHONE: Any) { self.BK_PHONE = BK_PHONE as? String ?? "" }
    func SET_BK_TYPE(BK_TYPE: Any) { self.BK_TYPE = BK_TYPE as? String ?? "" }
    func SET_FCM_KEY(FCM_KEY: Any) { self.FCM_KEY = FCM_KEY as? String ?? "" }
    func SET_LIST_TYPE(LIST_TYPE: Any) { self.LIST_TYPE = LIST_TYPE as? String ?? "" }
    func SET_MB_ID(MB_ID: Any) { self.MB_ID = MB_ID as? String ?? "" }
    func SET_MEMO(MEMO: Any) { self.MEMO = MEMO as? String ?? "" }
}

// 학교 데이터
public class SCHOOL_DATA {
    
    var PAGE: Int = 0
    
    var ATTACHED: [ATTACHED] = []
    var BOARD_CODE: String = ""
    var BOARD_ID: String = ""
    var BOARD_KEY: String = ""
    var BOARD_NAME: String = ""
    var BOARD_SOURCE: String = ""
    var BOARD_TYPE: String = ""
    var CALL_BACK: String = ""
    var CLASS_INFO: String = ""
    var CONTENT: String = ""
    var CONTENT_TEXT: String = ""
    var CONTENT_TYPE: String = ""
    var DATETIME: String = ""
    var DST: String = ""
    var DST_NAME: String = ""
    var DST_TYPE: String = ""
    var FCM_KEY: String = ""
    var FILE_COUNT: String = ""
    var FROM_FILE: String = ""
    var IDX: String = ""
    var INPUT_DATE: String = ""
    var IS_MODIFY: String = ""
    var IS_PUSH: String = ""
    var LIKE_COUNT: String = ""
    var LIKE_ID: String = ""
    var ME_LENGTH: String = ""
    var MEDIA_COUNT: String = ""
    var MSG_GROUP: String = ""
    var NO: String = ""
    var OPEN_COUNT: String = ""
    var POLL_NUM: String = ""
    var RESULT: String = ""
    var SC_CODE: String = ""
    var SC_GRADE: String = ""
    var SC_GROUP: String = ""
    var SC_LOCATION: String = ""
    var SC_LOGO: String = ""
    var SC_NAME: String = ""
    var SEND_TYPE: String = ""
    var SENDER_IP: String = ""
    var SUBJECT: String = ""
    var TARGET_GRADE: String = ""
    var TARGET_CLASS: String = ""
    var WR_SHARE: String = ""
    var WRITER: String = ""
    var LIKE: Bool = false
    
    var ATTACHED_DATETIME: String = ""
    var ATTACHED_DT_FROM: String = ""
    var ATTACHED_FILE_NAME: String = ""
    var ATTACHED_FILE_NAME_ORG: String = ""
    var ATTACHED_FILE_SIZE: String = ""
    var ATTACHED_IDX: String = ""
    var ATTACHED_IN_SEQ: String = ""
    var ATTACHED_LAT: String = ""
    var ATTACHED_LNG: String = ""
    var ATTACHED_MEDIA_FILES: String = ""
    var ATTACHED_MEDIA_TYPE: String = ""
    var ATTACHED_MSG_GROUP: String = ""
    var ATTACHED_HTTP_STRING: String = ""
    
    func SET_ATTACHED(ATTACHED: [ATTACHED]) { self.ATTACHED = ATTACHED }
    func SET_BOARD_CODE(BOARD_CODE: Any) { self.BOARD_CODE = BOARD_CODE as? String ?? "" }
    func SET_BOARD_ID(BOARD_ID: Any) { self.BOARD_ID = BOARD_ID as? String ?? "" }
    func SET_BOARD_KEY(BOARD_KEY: Any) { self.BOARD_KEY = BOARD_KEY as? String ?? "" }
    func SET_BOARD_NAME(BOARD_NAME: Any) { self.BOARD_NAME = BOARD_NAME as? String ?? "" }
    func SET_BOARD_SOURCE(BOARD_SOURCE: Any) { self.BOARD_SOURCE = BOARD_SOURCE as? String ?? "" }
    func SET_BOARD_TYPE(BOARD_TYPE: Any) { self.BOARD_TYPE = BOARD_TYPE as? String ?? "" }
    func SET_CALL_BACK(CALL_BACK: Any) { self.CALL_BACK = CALL_BACK as? String ?? "" }
    func SET_CLASS_INFO(CLASS_INFO: Any) { self.CLASS_INFO = CLASS_INFO as? String ?? "" }
    func SET_CONTENT(CONTENT: Any) { self.CONTENT = CONTENT as? String ?? "" }
    func SET_CONTENT_TEXT(CONTENT_TEXT: Any) { self.CONTENT_TEXT = CONTENT_TEXT as? String ?? "" }
    func SET_CONTENT_TYPE(CONTENT_TYPE: Any) { self.CONTENT_TYPE = CONTENT_TYPE as? String ?? "" }
    func SET_DATETIME(DATETIME: Any) { self.DATETIME = DATETIME as? String ?? "" }
    func SET_DST(DST: Any) { self.DST = DST as? String ?? "" }
    func SET_DST_NAME(DST_NAME: Any) { self.DST_NAME = DST_NAME as? String ?? "" }
    func SET_DST_TYPE(DST_TYPE: Any) { self.DST_TYPE = DST_TYPE as? String ?? "" }
    func SET_FCM_KEY(FCM_KEY: Any) { self.FCM_KEY = FCM_KEY as? String ?? "" }
    func SET_FILE_COUNT(FILE_COUNT: Any) { self.FILE_COUNT = FILE_COUNT as? String ?? "" }
    func SET_FROM_FILE(FROM_FILE: Any) { self.FROM_FILE = FROM_FILE as? String ?? "" }
    func SET_IDX(IDX: Any) { self.IDX = IDX as? String ?? "" }
    func SET_INPUT_DATE(INPUT_DATE: Any) { self.INPUT_DATE = INPUT_DATE as? String ?? "" }
    func SET_IS_MODIFY(IS_MODIFY: Any) { self.IS_MODIFY = IS_MODIFY as? String ?? "" }
    func SET_IS_PUSH(IS_PUSH: Any) { self.IS_PUSH = IS_PUSH as? String ?? "" }
    func SET_LIKE_COUNT(LIKE_COUNT: Any) { self.LIKE_COUNT = LIKE_COUNT as? String ?? "" }
    func SET_LIKE_ID(LIKE_ID: Any) { self.LIKE_ID = LIKE_ID as? String ?? "" }
    func SET_ME_LENGTH(ME_LENGTH: Any) { self.ME_LENGTH = ME_LENGTH as? String ?? "" }
    func SET_MEDIA_COUNT(MEDIA_COUNT: Any) { self.MEDIA_COUNT = MEDIA_COUNT as? String ?? "" }
    func SET_MSG_GROUP(MSG_GROUP: Any) { self.MSG_GROUP = MSG_GROUP as? String ?? "" }
    func SET_NO(NO: Any) { self.NO = NO as? String ?? "" }
    func SET_OPEN_COUNT(OPEN_COUNT: Any) { self.OPEN_COUNT = OPEN_COUNT as? String ?? "" }
    func SET_POLL_NUM(POLL_NUM: Any) { self.POLL_NUM = POLL_NUM as? String ?? "" }
    func SET_RESULT(RESULT: Any) { self.RESULT = RESULT as? String ?? "" }
    func SET_SC_CODE(SC_CODE: Any) { self.SC_CODE = SC_CODE as? String ?? "" }
    func SET_SC_GRADE(SC_GRADE: Any) { self.SC_GRADE = SC_GRADE as? String ?? "" }
    func SET_SC_GROUP(SC_GROUP: Any) { self.SC_GROUP = SC_GROUP as? String ?? "" }
    func SET_SC_LOCATION(SC_LOCATION: Any) { self.SC_LOCATION = SC_LOCATION as? String ?? "" }
    func SET_SC_LOGO(SC_LOGO: Any) { self.SC_LOGO = SC_LOGO as? String ?? "" }
    func SET_SC_NAME(SC_NAME: Any) { self.SC_NAME = SC_NAME as? String ?? "" }
    func SET_SEND_TYPE(SEND_TYPE: Any) { self.SEND_TYPE = SEND_TYPE as? String ?? "" }
    func SET_SENDER_IP(SENDER_IP: Any) { self.SENDER_IP = SENDER_IP as? String ?? "" }
    func SET_SUBJECT(SUBJECT: Any) { self.SUBJECT = SUBJECT as? String ?? "" }
    func SET_TARGET_GRADE(TARGET_GRADE: Any) { self.TARGET_GRADE = TARGET_GRADE as? String ?? "" }
    func SET_TARGET_CLASS(TARGET_CLASS: Any) { self.TARGET_CLASS = TARGET_CLASS as? String ?? "" }
    func SET_WR_SHARE(WR_SHARE: Any) { self.WR_SHARE = WR_SHARE as? String ?? "" }
    func SET_WRITER(WRITER: Any) { self.WRITER = WRITER as? String ?? "" }
    func SET_LIKE(LIKE: Any) { self.LIKE = LIKE as? Bool ?? false }
    
    func SET_ATTACHED_DATETIME(ATTACHED_DATETIME: Any) { self.ATTACHED_DATETIME = ATTACHED_DATETIME as? String ?? "" }
    func SET_ATTACHED_DT_FROM(ATTACHED_DT_FROM: Any) { self.ATTACHED_DT_FROM = ATTACHED_DT_FROM as? String ?? "" }
    func SET_ATTACHED_FILE_NAME(ATTACHED_FILE_NAME: Any) { self.ATTACHED_FILE_NAME = ATTACHED_FILE_NAME as? String ?? "" }
    func SET_ATTACHED_FILE_NAME_ORG(ATTACHED_FILE_NAME_ORG: Any) { self.ATTACHED_FILE_NAME_ORG = ATTACHED_FILE_NAME_ORG as? String ?? "" }
    func SET_ATTACHED_FILE_SIZE(ATTACHED_FILE_SIZE: Any) { self.ATTACHED_FILE_SIZE = ATTACHED_FILE_SIZE as? String ?? "" }
    func SET_ATTACHED_IDX(ATTACHED_IDX: Any) { self.ATTACHED_IDX = ATTACHED_IDX as? String ?? "" }
    func SET_ATTACHED_IN_SEQ(ATTACHED_IN_SEQ: Any) { self.ATTACHED_IN_SEQ = ATTACHED_IN_SEQ as? String ?? "" }
    func SET_ATTACHED_LAT(ATTACHED_LAT: Any) { self.ATTACHED_LAT = ATTACHED_LAT as? String ?? "" }
    func SET_ATTACHED_LNG(ATTACHED_LNG: Any) { self.ATTACHED_LNG = ATTACHED_LNG as? String ?? "" }
    func SET_ATTACHED_MEDIA_FILES(ATTACHED_MEDIA_FILES: Any) { self.ATTACHED_MEDIA_FILES = ATTACHED_MEDIA_FILES as? String ?? "" }
    func SET_ATTACHED_MEDIA_TYPE(ATTACHED_MEDIA_TYPE: Any) { self.ATTACHED_MEDIA_TYPE = ATTACHED_MEDIA_TYPE as? String ?? "" }
    func SET_ATTACHED_MSG_GROUP(ATTACHED_MSG_GROUP: Any) { self.ATTACHED_MSG_GROUP = ATTACHED_MSG_GROUP as? String ?? "" }
    func SET_ATTACHED_HTTP_STRING(ATTACHED_HTTP_STRING: Any) { self.ATTACHED_HTTP_STRING = ATTACHED_HTTP_STRING as? String ?? "" }
}

// 학교 데이터 (미디어)
public class ATTACHED {
    
    var DATETIME: String = ""
    var DT_FROM: String = ""
    var FILE_NAME: String = ""
    var FILE_NAME_ORG: String = ""
    var FILE_SIZE: String = ""
    var IDX: String = ""
    var IN_SEQ: String = ""
    var LAT: String = ""
    var LNG: String = ""
    var MEDIA_FILES: String = ""
    var MEDIA_TYPE: String = ""
    var MSG_GROUP: String = ""
    var HTTP_STRING: String = ""
    
    func SET_DATETIME(DATETIME: Any) { self.DATETIME = DATETIME as? String ?? "" }
    func SET_DT_FROM(DT_FROM: Any) { self.DT_FROM = DT_FROM as? String ?? "" }
    func SET_FILE_NAME(FILE_NAME: Any) { self.FILE_NAME = FILE_NAME as? String ?? "" }
    func SET_FILE_NAME_ORG(FILE_NAME_ORG: Any) { self.FILE_NAME_ORG = FILE_NAME_ORG as? String ?? "" }
    func SET_FILE_SIZE(FILE_SIZE: Any) { self.FILE_SIZE = FILE_SIZE as? String ?? "" }
    func SET_IDX(IDX: Any) { self.IDX = IDX as? String ?? "" }
    func SET_IN_SEQ(IN_SEQ: Any) { self.IN_SEQ = IN_SEQ as? String ?? "" }
    func SET_LAT(LAT: Any) { self.LAT = LAT as? String ?? "" }
    func SET_LNG(LNG: Any) { self.LNG = LNG as? String ?? "" }
    func SET_MEDIA_FILES(MEDIA_FILES: Any) { self.MEDIA_FILES = MEDIA_FILES as? String ?? "" }
    func SET_MEDIA_TYPE(MEDIA_TYPE: Any) { self.MEDIA_TYPE = MEDIA_TYPE as? String ?? "" }
    func SET_MSG_GROUP(MSG_GROUP: Any) { self.MSG_GROUP = MSG_GROUP as? String ?? "" }
    func SET_HTTP_STRING(HTTP_STRING: Any) { self.HTTP_STRING = HTTP_STRING as? String ?? "" }
}
