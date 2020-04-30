//
//  YExtension.swift
//  YMobileData
//
//  Created by ye on 2020/4/29.
//  Copyright © 2020 ye. All rights reserved.
//

import Foundation
import UIKit

extension String {
    static func isNullOrEmpty(_ any:Any?) -> String {
        guard  let s = any else {return ""}
        if s is NSNull {  return "";  }
        let val = "\(s)".replacingOccurrences(of: "<br/>", with: "")
        
        return val
    }

}

extension UIDevice {
    public func isIphonex() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
}
