//
//  BaseViewModel.swift
//  ios-movie-pedia
//
//  Created by Goo on 3/29/25.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
