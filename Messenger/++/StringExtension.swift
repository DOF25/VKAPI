//
//  StringExtension.swift
//  Messenger
//
//  Created by Крылов Данила  on 13.10.2021.
//

import UIKit

extension String {
    func getHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let constrainedRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constrainedRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}


