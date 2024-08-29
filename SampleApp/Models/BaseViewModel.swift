//
//  BaseViewModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 14/05/2024.
//
import Foundation

protocol BaseViewModelDelegatesProtocol: NSObjectProtocol {
    func showAlertView(title: String, msg: String)
    func showLoader()
    func hideLoader()
    func showBannerWithMessage(bannerInfo: BannerInfoModel)
}
