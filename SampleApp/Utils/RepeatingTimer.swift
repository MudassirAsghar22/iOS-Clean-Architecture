//
//  RepeatingTimer.swift
//  Sample App
//
//  Created by Mudassir Asghar on 15/05/2024.
//

import UIKit

class RepeatingTimer {

    let timeInterval: TimeInterval

    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }

    private lazy var timer: DispatchSourceTimer = {
        let timer_soruce = DispatchSource.makeTimerSource()
        timer_soruce.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        timer_soruce.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return timer_soruce
    }()

    var eventHandler: (() -> Void)?

    private enum State {
        case suspended
        case resumed
    }

    private var state: State = .suspended

    deinit {

        timer.setEventHandler {}
        timer.cancel()

        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */

        resume()
        eventHandler = nil
    }

    func resume() {

        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }

    func suspend() {

        if state == .suspended {
            return
        }

        state = .suspended
        timer.suspend()

    }

    @objc fileprivate func didEnterBackgroundNotification() {

    }

    @objc fileprivate func willEnterForegroundNotification() {

    }

}

