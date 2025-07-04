//
//  Constant.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import Foundation

typealias C = Constant

enum Constant {
    //MARK: - Widget
    static let widgetKind = "BariBariWidget"
    
    //MARK: - ETC
    static let appUrlScheme = "baribari"
    static let appGroupID = "group.hgoo.baribari"
    static let realmPath = "default.realm"
    static let appNamePlaceholder = "com.example.myapp"
    static let dateFormatWithTime = "yyyy-MM-dd a hh:mm"
    static let dateFormat = "yyyy.MM.dd"
    static let unsplashSearchQuery = "motorcycle panning shot"
    static let presentBottomDetents = 0.15
    static let presentTopDetents = 0.9
    static let naverMapTitle = "네이버 지도"
    static let prepared = "준비중입니다."
    
    //MARK: - About
    static let aboutTitle = "앱 정보"
    static let appStoreURL = "https://apps.apple.com/app/id6744330390"
    static let mailURL = "mailto:rngus3436@icloud.com?subject=[바리바리-BariBari] 피드백"
    static let privacyPolicyURL = "https://suave-friend-bf6.notion.site/BariBari-1ce7f64fbfdb80a28306d2c7f5a04a92"
    static let unsplashURL = "https://unsplash.com/developers"
    
    //MARK: - Setting
    static let settingTitle = "앱 설정"
    
    //MARK: - Button Title
    static let createTemporaryCourseFolderTitle = "임시 폴더 만들기"
    static let trackingStartButtonTitle = "코스 추적 시작"
    static let trackingQuitButtonTitle = "기록 종료"
    static let trackingSaveButtonTitle = "코스 저장"
    static let quitTitle = "종료"
    static let cancelTitle = "취소"
    static let submitTitle = "확인"
    static let saveTitle = "저장"
    static let updateTitle = "수정"
    static let deleteTitle = "삭제"
    static let resetTitle = "초기화"
    
    //MARK: - Content
    //MARK: - Home & Create
    static let mainTitle = "밤공기를 가르며, 추천 코스로 밤바리 어때요?"
    static let mainSubTitle = "라이딩 코스"
    static let createTrackingTitle = "실시간 추적 코스 생성"
    static let courseFolderCreateTitle = "코스 폴더 생성"
    static let courseFolderUpdateTitle = "코스 폴더 수정"
    static let courseFolderPickerTitle = "코스 폴더 선택"
    static let temporaryCourseFolderTitle = "임시폴더"
    static let courseFolderTitle = "코스 폴더 이름"
    static let courseTitle = "코스 이름"
    static let courseContent = "코스 내용"
    static let startPinTitle = "출발지"
    static let waypointPinTitle = "경유지"
    static let destinationPinTitle = "도착지"
    
    //MARK: - Modal
    static let info = "안내"
    static let warning = "경고"
    static let failure = "실패"
    static let minimumPin = "최소 2개 이상의 핀이 필요합니다."
    static let trackingQuitMessage = "코스 추적을 종료하고 저장하시겠습니까?"
    static let createFormQuitMessage = "코스 기록을 종료하시겠습니까?\n해당 경로와 내용이 저장되지 않으며,\n되돌릴 수 없습니다."
    static let updateFormQuitMessage = "코스 수정을 종료하시겠습니까?\n수정한 내용이 저장되지 않으며,\n되돌릴 수 없습니다."
    static let deleteCourseFolderMessage = "코스 폴더를 삭제하시겠습니까?\n해당 폴더의 코스가 전부 삭제되며,\n되돌릴 수 없습니다."
    static let deleteCourseMessage = "코스를 삭제하시겠습니까?\n되돌릴 수 없습니다."
    static let resetMessage = "코스 보관함을 초기화하시겠습니까?\n되돌릴 수 없습니다."
    static let cantLoadImageMessage = "이미지 로드에 실패했습니다."
    static let cantSaveCourseMessage = "코스 저장에 실패했습니다."
    static let saveCourseMessage = "코스를 보관함에 저장하였습니다."
    static let updateCourseMessage = "코스를 수정하였습니다."
    static let deleteCourseConfirmMessage = "코스를 보관함에서 삭제하였습니다."
    static let resetConfirmMessage = "코스 보관함을 초기화하였습니다."
    
    //MARK: - Placeholder
    static let textFiledPlaceholder = "내용을 입력해주세요."
    static let courseFolderTitlePlaceholder = "코스 폴더 이름을 찾을 수 없습니다."
    static let addressPlaceholder = "위치 정보를 찾을 수 없습니다."
    static let distancePlaceholder = "0km"
    static let noneCourseFolder = "보관함이 비어있습니다.\n코스를 생성해보세요."
    static let noneCourse = "폴더가 비어있습니다.\n코스를 생성해보세요."
}
