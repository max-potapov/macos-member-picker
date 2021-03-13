//
//  ViewController.swift
//  MemberPicker
//
//  Created by Maxim Potapov on 13.03.2021.
//  Copyright © 2021 Monsters, Inc. All rights reserved.
//

import AppKit

final class ViewController: NSViewController {
    private lazy var members: [Member] = Member.populated()

    private lazy var tokenField: NSTokenField = {
        let field = NSTokenField(wrappingLabelWithString: "")

        field.isEditable = true
        field.lineBreakMode = .byWordWrapping
        field.placeholderString = "Username or Email"
        field.tokenStyle = .rounded
        field.completionDelay = 0.3

        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self

        return field
    }()

    private lazy var okButton: NSButton = {
        let button: NSButton
        if #available(macOS 11.0, *) {
            let image = NSImage(systemSymbolName: "cart.fill.badge.plus", accessibilityDescription: .none)?
                .withSymbolConfiguration(NSImage.SymbolConfiguration(textStyle: .callout))
            button = NSButton(image: image!, target: self, action: #selector(showAlert(_:)))
        } else {
            button = NSButton(title: "OK", target: self, action: #selector(showAlert(_:)))
        }

        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    override func loadView() {
        self.view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tokenField)
        view.addSubview(okButton)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 600),
            view.heightAnchor.constraint(equalToConstant: 400),

            tokenField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tokenField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tokenField.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            tokenField.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -8),

            okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            okButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            okButton.widthAnchor.constraint(equalToConstant: 64),
            okButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }

    @objc private func removeToken(_ sender: NSMenuItem) {
        guard
            let member = sender.representedObject as? Member,
            let members = tokenField.objectValue as? [Member]
        else {
            return
        }

        tokenField.objectValue = members.filter { $0 != member }
    }

    @objc private func showAlert(_ sender: NSButton) {
        let alert = NSAlert()
        alert.accessoryView = .init(frame: .init(x: 0, y: 0, width: 400, height: 0))
        alert.alertStyle = .informational
        alert.messageText = "All Members"
        alert.informativeText = membersDebugDescription()
        alert.beginSheetModal(for: view.window!)
    }

    private func membersDebugDescription() -> String {
        guard let members = tokenField.objectValue as? [Member] else { return "Members list is empty." }
        return members.map { String(describing: $0) }.joined(separator: "\n")
    }
}

extension ViewController: NSTokenFieldDelegate {
    func tokenField(_ tokenField: NSTokenField, completionsForSubstring substring: String, indexOfToken tokenIndex: Int, indexOfSelectedItem selectedIndex: UnsafeMutablePointer<Int>?) -> [Any]? {
        guard substring.count > 1 else { return nil }

        let suggestions = members
            .reduce(into: []) { $0.append(contentsOf: [$1.name, $1.email]) }
            .compactMap { $0 }
            .filter { $0.range(of: substring, options: [.diacriticInsensitive, .caseInsensitive]) != nil }

        return suggestions
    }

    func tokenField(_ tokenField: NSTokenField, representedObjectForEditing editingString: String) -> Any? {
        if let member = members.first(where: { $0.name == editingString || $0.email == editingString }) {
            return member
        } else if let email = EmailExtractor.extract(editingString) {
            return Member(id: -1, name: nil, email: email)
        } else {
            return Member(id: -1, name: editingString.trimmingCharacters(in: .whitespacesAndNewlines), email: nil)
        }
    }

    func tokenField(_ tokenField: NSTokenField, displayStringForRepresentedObject representedObject: Any) -> String? {
        guard let member = representedObject as? Member else { return nil }
        return member.name ?? member.email
    }

    func tokenField(_ tokenField: NSTokenField, hasMenuForRepresentedObject representedObject: Any) -> Bool {
        return true
    }

    func tokenField(_ tokenField: NSTokenField, menuForRepresentedObject representedObject: Any) -> NSMenu? {
        let removeItem = NSMenuItem(title: "Remove", action: #selector(removeToken(_:)), keyEquivalent: "")
        removeItem.target = self
        removeItem.representedObject = representedObject

        let menu = NSMenu()
        menu.addItem(removeItem)

        return menu
    }

    func tokenField(_ tokenField: NSTokenField, styleForRepresentedObject representedObject: Any) -> NSTokenField.TokenStyle {
        return .squared
    }
}
