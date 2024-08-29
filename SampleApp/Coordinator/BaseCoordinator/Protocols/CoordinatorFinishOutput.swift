//
//  CoordinatorFinishOutput.swift
//  Sample App
//
//  Created by Mudassir Asghar on 06/05/2024.
//

import Foundation

protocol CoordinatorFinishOutput {
    var finishFlow: (() -> Void)? { get set }
}
