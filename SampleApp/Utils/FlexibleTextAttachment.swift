//
//  FlexibleTextAttachment.swift
//  Sample App
//
//  Created by Mudassir Asghar on 28/05/2024.
//

import UIKit

final class FlexibleTextAttachment: NSTextAttachment {

    // MARK: - Параметры

    enum Resize: Int {
        case none
        case toLowercase
        case toUppercase
        case toLineHeight
    }

    enum Align: Int {
        case none
        case toBaseline
        case centerByLowercase
        case centerByUppercase
    }

    // MARK: - Инициализация

    required init(image: UIImage, font: UIFont, resize: Resize, align: Align, left: CGFloat = 0, right: CGFloat = 0) {
        // инициализируемся
        super.init(data: nil, ofType: nil)

        // соберём картинку
        let height: CGFloat = {
            switch resize {
            case .none:         return image.size.height
            case .toLowercase:  return font.xHeight
            case .toUppercase:  return font.capHeight
            case .toLineHeight: return font.lineHeight + font.descender
            }
        }()

        let y: CGFloat = {
            switch align {
            case .none:              return 0
            case .toBaseline:        return font.descender
            case .centerByLowercase: return (font.xHeight - height) / 2
            case .centerByUppercase: return (font.capHeight - height) / 2
            }
        }()

        let ratio: CGFloat = image.size.height / height
        let size = CGSize(
            width:  image.size.width * ratio,
            height: height
        )
        let bounds = CGRect(
            x:      0,
            y:      y,
            width:  size.width + left + right,
            height: size.height
        )

        self.image = UIGraphicsImageRenderer(size: bounds.size).image { context in
            image.draw(in: CGRect(x: left, y: 0, width: size.width, height: size.height))
        }

        self.bounds = bounds
    }

    @available(*, unavailable)
    override init(data contentData: Data?, ofType uti: String?) {
        super.init(data: contentData, ofType: uti)
    }

    // MARK: - NSCoding

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.bounds = coder.decodeCGRect(forKey: "bounds")
    }

    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(self.bounds, forKey: "bounds")
    }
}
