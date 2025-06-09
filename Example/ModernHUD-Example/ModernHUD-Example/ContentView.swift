//
//  ContentView.swift
//  ModernHUD-Example
//
//  Created by Daniil on 09.06.2025.
//

import SwiftUI
import ModernHUD

struct ContentView: View {
    var body: some View {
        List {
            Section {
                Button(action: showTextOnly) {
                    Text("Text only")
                }

                Button(action: showPlainSmallText) {
                    Text("Plain HUD with small text")
                }

                Button(action: showPlainBigText) {
                    Text("Plain HUD with big text")
                }

                Button(action: showWithoutText) {
                    Text("Without text")
                }
            }

            Button(action: showProgress) {
                Text("Show progress")
            }
        }
        .scrollContentBackground(.hidden)
        .background(alignment: .center) {
            Image("Fuji")
        }
    }

    private func showPlainSmallText() {
        let hud = try! ModernHUD.show()
        hud.style = .arcRotate
        hud.text = "Hello,"
        hud.detailedText = "World!"

        hud.hide(delay: 5, animated: true)
    }

    private func showTextOnly() {
        let hud = try! ModernHUD.show()
        hud.style = .textOnly
        hud.text = "Error occured!"
        hud.detailedText = "Here is the detailed error description: ....."

        hud.hide(delay: 5, animated: true)
    }

    private func showPlainBigText() {
        let hud = try! ModernHUD.show()
        hud.style = .arcRotate
        hud.text = "Hello,"
        hud.detailedText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum! Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum! Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum! Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum!"

        hud.hide(delay: 5, animated: true)
    }

    private func showWithoutText() {
        let hud = try! ModernHUD.show()
        hud.hide(delay: 5, animated: true)
    }

    private func showProgress() {
        let hud = try! ModernHUD.show()
        hud.tintColor = .red
        hud.style = .arc
        hud.progress = 0
        hud.text = "Please wait..."

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            hud.setProgress(hud.progress + 0.2, animated: true)

            if hud.progress >= 1.0 {
                timer.invalidate()
                hud.hide()
            }
        }
    }
}
