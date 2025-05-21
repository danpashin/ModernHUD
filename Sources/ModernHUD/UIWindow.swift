//
//  UIWindow.swift
//  ModernHUD
//
//  Created by Daniil on 10.01.2024.
//

import UIKit

extension UIWindow {
    @objc(mh_focusedScene)
    public static var focusedScene: UIWindowScene? {
        UIApplication.shared.connectedScenes.first { scene in
            let state = scene.activationState
            return (state == .foregroundActive || state == .foregroundInactive) && scene is UIWindowScene
        } as? UIWindowScene
    }
}
