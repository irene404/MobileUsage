//
//  constant.swift
//  YMobileData
//
//  Created by ye on 2020/4/30.
//  Copyright © 2020 ye. All rights reserved.
//

import Foundation
import UIKit

func kIsIPhoneX() ->Bool {
    let screenHeight = UIScreen.main.nativeBounds.size.height;
    if screenHeight == 2436 || screenHeight == 1792 || screenHeight == 2688 || screenHeight == 1624 {
        return true
    }
    return false
}
