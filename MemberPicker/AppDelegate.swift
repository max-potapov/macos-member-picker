//
//  AppDelegate.swift
//  MemberPicker
//
//  Created by Maxim Potapov on 13.03.2021.
//  Copyright © 2021 Monsters, Inc. All rights reserved.
//

import AppKit

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.contentViewController = ViewController()
    }
}
