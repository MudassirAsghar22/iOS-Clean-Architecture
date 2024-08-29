//
//  ApiManagerRetrier.swift
//  Sample App
//
//  Created by Mudassir Asghar on 07/05/2024.
//

import Foundation
import Alamofire

class APIManagerRetrier: RequestRetrier {

    // MARK: - Vars & Lets

    var numberOfRetries = 0

    // MARK: - Request Retrier methods

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if (error.localizedDescription == "The operation couldn’t be completed. Software caused connection abort") {
            completion(.retryWithDelay(1.0)) // retry after 1 second
            self.numberOfRetries += 1
        } else if let response = request.task?.response as? HTTPURLResponse, response.statusCode >= 500, self.numberOfRetries < 3 {
            completion(.retryWithDelay(1.0)) // retry after 1 second
            self.numberOfRetries += 1
        } else {
            completion(.doNotRetry) // don't retry
            self.numberOfRetries = 0
        }
    }
}

