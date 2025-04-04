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
    
    //MARK: - Button Title
    static let trackingStartButtonTitle = "코스 추적 시작"
    static let trackingStopButtonTitle = "코스 추적 종료"
    static let cancelTitle = "취소"
    static let submitTitle = "확인"
    static let saveTitle = "저장"
    
    //MARK: - Content
    static let createTrackingTitle = "실시간 추적 코스 생성"
    static let courseFolderCreateTitle = "코스 폴더 생성"
    static let courseFolderPickerTitle = "코스 폴더 선택"
    static let courseTitle = "코스 이름"
    static let courseContent = "코스 내용"
    static let textFiledPlaceholder = "내용을 입력해주세요."
    static let startPinTitle = "출발지"
    static let destinationPinTitle = "도착지"
    
    //MARK: - Modal
    static let warning = "경고"
    static let trackingQuitMessage = "코스 추적 기록을 종료하시겠습니까?\n해당 추적 내역이 저장되지 않으며,\n되돌릴 수 없습니다."
}
