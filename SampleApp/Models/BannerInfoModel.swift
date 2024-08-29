//
//  BannerInfoModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 14/05/2024.
//

import UIKit

struct BannerInfoModel {
    var message: String?
    var apiType: RequestItemsType?
    var params:  Dictionary<String, Any>?
    var statusCode: Constants.APIErrorType?
    var image: UIImage?
    var imageUrl: URL?
}
