//
//  EndPointType.swift
//  Sample App
//
//  Created by Mudassir Asghar on 07/05/2024.
//
import Alamofire

protocol EndPointType {

    // MARK: - Vars & Lets
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var version: String { get }

}
