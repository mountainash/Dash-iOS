//
//  UIViewController+Swizzle.swift
//  Dash iOS
//
//  Created by chenhaoyu.1999 on 2021/3/30.
//  Copyright © 2021 Kapeli. All rights reserved.
//

import Foundation


extension UIViewController {
    
    @objc func observeUserInterfaceChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(userInterfaceStyleHasChanged(noti:)), name: DHUserInterfaceStyleHasChanged, object: nil)
        overrideUserInterfaceStyle = DHAppPreference.shared.customInterfaceStyle
    }
    
    @objc func userInterfaceStyleHasChanged(noti: Notification) {
        if let style = noti.userInfo?[DHThemeKey] as? UIUserInterfaceStyle {
            overrideUserInterfaceStyle = style
        }
    }
    
}
