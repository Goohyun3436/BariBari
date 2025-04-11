//
//  Constant.swift
//  BariBari
//
//  Created by Goo on 3/29/25.
//

import Foundation

typealias C = Constant

enum Constant {
    //MARK: - ETC
    static let appNamePlaceholder = "com.example.myapp"
    static let dateFormat = "yyyy-MM-dd a hh:mm"
    static let unsplashSearchQuery = "motorcycle panning shot"
    static let presentBottomDetents = 0.15
    static let presentTopDetents = 0.9
    static let naverMapTitle = "네이버 지도"
    static let prepared = "준비중입니다."
    
    //MARK: - Button Title
    static let trackingStartButtonTitle = "코스 추적 시작"
    static let trackingQuitButtonTitle = "기록 종료"
    static let trackingSaveButtonTitle = "코스 저장"
    static let quitTitle = "종료"
    static let cancelTitle = "취소"
    static let submitTitle = "확인"
    static let saveTitle = "저장"
    static let updateTitle = "수정"
    static let deleteTitle = "삭제"
    
    //MARK: - Content
    static let mainTitle = "밤공기를 가르며, 추천 코스로 밤바리 어때요?"
    static let mainSubTitle = "라이딩 코스"
    static let createTrackingTitle = "실시간 추적 코스 생성"
    static let courseFolderCreateTitle = "코스 폴더 생성"
    static let courseFolderUpdateTitle = "코스 폴더 수정"
    static let courseFolderPickerTitle = "코스 폴더 선택"
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
    static let cantLoadImageMessage = "이미지 로드에 실패했습니다."
    static let cantSaveCourseMessage = "코스 저장에 실패했습니다."
    static let saveCourseMessage = "코스를 보관함에 저장하였습니다."
    static let updateCourseMessage = "코스를 수정하였습니다."
    static let deleteCourseConfirmMessage = "코스를 보관함에서 삭제하였습니다."
    
    //MARK: - Placeholder
    static let textFiledPlaceholder = "내용을 입력해주세요."
    static let courseFolderTitlePlaceholder = "코스 폴더 이름을 찾을 수 없습니다."
    static let addressPlaceholder = "위치 정보를 찾을 수 없습니다."
    static let distancePlaceholder = "0km"
}
