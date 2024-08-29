//
//  ApiManager.swift
//  Sample App
//
//  Created by Mudassir Asghar on 07/05/2024.
//

import Alamofire
import Foundation

class APIManager {
    // MARK: - Vars & Lets
    private let sessionManager: Session
    static let networkEnviroment: NetworkEnvironment = .development
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager(sessionManager: Session())
        return apiManager
    }()

    // MARK: - Accessors
    class func shared() -> APIManager {
        return sharedApiManager
    }

    // MARK: - Initialization
    private init(sessionManager: Session) {           
        self.sessionManager = sessionManager
        self.sessionManager.sessionConfiguration.timeoutIntervalForRequest = 90
        self.sessionManager.sessionConfiguration.timeoutIntervalForResource = 90
    }

    // MARK: - Public methods
    func call<T>(type: EndPointType, params: Parameters? = nil,
                 handler: @escaping (Swift.Result<T, AlertMessage>) -> Void) where T: Codable {
        self.sessionManager.request(type.url,
                                    method: type.httpMethod,
                                    parameters: params,
                                    encoding: type.encoding,
                                    headers: type.headers) {$0.timeoutInterval = 90}.validate().responseDecodable(of: T.self) { (data) in
            do {
                print("URL: \(type.url)")
                print("PARAMS: \(String(describing: params))")
                print("Response =  \(data.debugDescription)")
                if data.response?.statusCode ?? 404 == Constants.ServerResponseCodes.success {
                    guard let jsonData = data.data else {
                        let errorMsg = AlertMessage(title: "Error".localized, body: "Something_went_wrong".localized)
                        return handler(.failure(errorMsg))
                    }
                    let result = try JSONDecoder().decode(T.self, from: jsonData)
                    handler(.success(result))
                } else {
                    if data.response?.statusCode ?? 404 == Constants.ServerResponseCodes.unAuth {
                        NotificationCenter.default.post(name: Constants.NotificationNames.k_sessionExpired, object: nil, userInfo: nil)
                        return
                    } else if data.response?.statusCode == Constants.ServerResponseCodes.underMaintenance {
                        NotificationCenter.default.post(name: Constants.NotificationNames.k_maintenance, object: nil)
                        return
                    } else {
                        if let error = data.error?.localizedDescription {
                            if error.contains("Internet") || error.contains("The request timed out") ||
                                error.contains("connection") {
                                let errorMsg = AlertMessage(title: "Error".localized, body: "No_internet_connection_Tap_to_retry".localized)
                                return handler(.failure(errorMsg))
                            } else {
                                let errorMsg = AlertMessage(title: "Error".localized, body: "Something_went_wrong".localized)
                                return handler(.failure(errorMsg))
                            }
                        } else {
                            let errorMsg = AlertMessage(title: "Error".localized, body: "Something went wrong. Tap to retry...")
                            return handler(.failure(errorMsg))
                        }
                    }
                }
            } catch {
                if let errorMsg = error as? AlertMessage {
                    return handler(.failure(errorMsg))
                }
                handler(.failure(AlertMessage(title: "Error".localized, body: "Something_went_wrong".localized)))
            }
        }
    }

    func parseApiError(data: Data?) -> AlertMessage {
        let decoder = JSONDecoder()
        if let jsonData = data, let errorMsg = try? decoder.decode(GeneralMessage.self, from: jsonData) {
            return AlertMessage(title: "Error".localized, body: errorMsg.error_message ?? errorMsg.success_message ?? "Something_went_wrong".localized)
        }
        return AlertMessage(title: "Error".localized, body: "Something_went_wrong".localized)
    }
}

// Multipart request
extension APIManager {

    // Function to get MIME type from file extension
    func mimeTypeForPathExtension(_ pathExtension: String) -> String {
        switch pathExtension.lowercased() {
        case "jpg", "jpeg": return "image/jpeg"
        case "png": return "image/png"
        case "pdf": return "application/pdf"
        case "doc": return "application/msword"
        case "docx": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        // Add other cases as needed
        default: return "application/octet-stream"
        }
    }

    func multipartRequest<T>(type: EndPointType, names: [String], fileURLs: [URL], parameters: Parameters?,
                             progressHandler: @escaping (Double) -> Void, handler: @escaping (Swift.Result<T, AlertMessage>) -> Void) where T: Codable {
        AF.upload(multipartFormData: { multipartFormData in
            for (index, fileURL) in fileURLs.enumerated() {
                let filename = fileURL.lastPathComponent
                multipartFormData.append(fileURL, withName: "documents[]", fileName: filename, mimeType: "\(self.mimeTypeForPathExtension(fileURL.pathExtension))")
            }

            if let params = parameters {

                for (key, value) in params {
                    if let stringValue = value as? String {
                        multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                    } else if let intValue = value as? Int {
                        multipartFormData.append("\(intValue)".data(using: .utf8)!, withName: key)
                    } else if let doubleValue = value as? Double {
                        multipartFormData.append("\(doubleValue)".data(using: .utf8)!, withName: key)
                    } else if let boolValue = value as? Bool {
                        multipartFormData.append("\(boolValue)".data(using: .utf8)!, withName: key)
                    } else if let arrayValue = value as? [String] {
                        for string in arrayValue {
                            multipartFormData.append(string.data(using: .utf8)!, withName: "\(key)[]")
                        }
                    } else if let dataValue = value as? Data {
                        multipartFormData.append(dataValue, withName: key)
                    }
                }

                print("URL: \(type.url)")
                print("PARAMS: \(String(describing: parameters?.debugDescription))")
                print("Response =  \(multipartFormData)")

            }
        },
                  to: type.url, method: .post, headers: type.headers) { $0.timeoutInterval = 90 }.uploadProgress { progress in
            print("UPLOAD PROGRESS: \(progress.fractionCompleted)")
            // Call the progress handler with the current progress
            progressHandler(progress.fractionCompleted)
        }
                  .responseDecodable(of: T.self) { (data) in
                      do {
                          print("URL: \(type.url)")
                          print("PARAMS: \(String(describing: parameters))")
                          print("Response =  \(data.debugDescription)")

                          if data.response?.statusCode ?? 404 == Constants.ServerResponseCodes.success {
                              guard let jsonData = data.data else {
                                  let errorMsg = AlertMessage(title: "Error".localized, body: "Something_went_wrong".localized)
                                  return handler(.failure(errorMsg))
                              }
                              let result = try JSONDecoder().decode(T.self, from: jsonData)
                              handler(.success(result))
                          } else {
                              if data.response?.statusCode ?? 404 == Constants.ServerResponseCodes.unAuth {
                                  NotificationCenter.default.post(name: Constants.NotificationNames.k_sessionExpired, object: nil, userInfo: nil)
                                  return
                              } else if data.response?.statusCode == Constants.ServerResponseCodes.underMaintenance {

                                  NotificationCenter.default.post(name: Constants.NotificationNames.k_maintenance, object: nil)
                                  return
                              } else {
                                  if let error = data.error?.localizedDescription {
                                      if error.contains("Internet") || error.contains("The request timed out") ||
                                            error.contains("connection") {
                                          let errorMsg = AlertMessage(title: "Error".localized, body: "No_internet_connection_Tap_to_retry".localized)
                                          return handler(.failure(errorMsg))
                                      }
                                  } else {
                                      let errorMsg = AlertMessage(title: "Error".localized, body: "Something_went_wrong".localized)
                                      return handler(.failure(errorMsg))
                                  }
                              }
                          }
                      } catch {
                          if let errorMsg = error as? AlertMessage {
                              return handler(.failure(errorMsg))
                          }
                          handler(.failure(self.parseApiError(data: data.data)))
                      }
                  }
    }

}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

