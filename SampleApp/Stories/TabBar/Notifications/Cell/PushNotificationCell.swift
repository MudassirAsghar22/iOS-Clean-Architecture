//
//  PushNotificationCell.swift
//  Sample App
//
//  Created by Mudassir Asghar on 05/06/2024.
//

import UIKit

class PushNotificationCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewClipping: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewClipping.shadowAndBorderForClippingView()
        self.viewContainer.shadowAndBorderForViewContainer()

    }

    func setupCell(data: NotificationData) {
        self.lblTitle.text = data.title
        self.lblSubTitle.text = data.message
        
        if let createdAt = data.created_at {
            if let notificationDate = DateHelper.shared.getUnChangedDateFrom(dateString: createdAt, dateFormate: .yyyy_MM_dd_HH_mm_ss) {
                self.lblTime.text = String(format: "Received".localized, notificationDate.getElapsedInterval())
            } else {
                self.lblTime.text = ""
            }
        } else {
            self.lblTime.text = ""
        }

        if data.getIsRead() {
            self.viewClipping.backgroundColor = .white
        } else {
            self.viewClipping.backgroundColor = Colors.cloudyBlue
        }
    }

    func setupDate(date: String) {
        
    }

    func beginSkeltonAnimation() {
        layoutIfNeeded()
        let views: [UIView] = [imgView, lblTitle, lblSubTitle, lblTime]
        self.lblTime.isHidden = true
        self.lblSubTitle.numberOfLines = 1
        views.forEach { $0.startSkelting() }

    }

    func endSkeltonAnimation() {
        layoutIfNeeded()
        let views: [UIView] = [imgView, lblTitle, lblSubTitle, lblTime]
        views.forEach { $0.stopSkelting() }
        self.lblTime.isHidden = false
        self.lblSubTitle.numberOfLines = 0

    }

}

