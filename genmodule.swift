#!/usr/bin/env swift

import Foundation

if CommandLine.arguments.count < 4 {
    let usage = "" +
        "Usage: genmodule [arguments]\n\n" +
        "Generates Swift Module (Wireframe, DataManager, Interactor, Presenter, and ViewController) on Desktop\n\n" +
        "Arguments:\n" +
        "1. Module name\t\tExample: Home\n" +
        "2. Appname\t\tExample: Broccoli\n" +
        "3. Company name\t\tExample: Bojan\\ Stefanovic"
    print(usage)
    exit(EXIT_FAILURE)
}

let modulename = CommandLine.arguments[1]
let appname = CommandLine.arguments[2]
let name = CommandLine.arguments[3]

enum CreateModuleError: Error {
    case noDirectory
    case noSuchFile
}

let longDateFormatter = DateFormatter()
longDateFormatter.dateFormat = "YYYY-MM-DD"

let yearOnlyFormatter = DateFormatter()
yearOnlyFormatter.dateFormat = "YYYY"

let now = Date()
let fullDate = longDateFormatter.string(from: now)
let year = yearOnlyFormatter.string(from: now)

var header: String {
    return "" +
        "//\n" +
        "//  \(modulename)Wireframe.swift\n" +
        "//  \(appname)\n" +
        "//\n" +
        "//  Created by \(name) on \(fullDate).\n" +
        "//  Copyright © \(year) \(name). All rights reserved.\n" +
        "//\n\n"
}

var wireframeText: String {
    return header +
        "import UIKit\n\n" +
        "protocol \(modulename)ModuleDelegate: class {}\n\n" +
        "final class \(modulename)Wireframe {\n" +
        "    fileprivate weak var moduleDelegate: \(modulename)ModuleDelegate?\n\n" +
        "    init(moduleDelegate: \(modulename)ModuleDelegate?) {\n" +
        "        self.moduleDelegate = moduleDelegate\n" +
        "    }\n\n" +
        "    var viewController: \(modulename)ViewController {\n" +
        "        let dataManager = ModelDataService.defaultManager\n" +
        "        let interactor = \(modulename)Interactor(dataManager: dataManager, moduleDelegate: moduleDelegate)\n" +
        "        let presenter = \(modulename)Presenter(interactor: interactor)\n" +
        "        return \(modulename)ViewController(presenter: presenter)\n" +
        "    }\n" +
        "}\n"
}

var dataManagerText: String {
    return header +
        "import Foundation\n\n" +
        "protocol \(modulename)DataManager {}\n"
}

var interactorText: String {
    return header +
        "import Foundation\n\n" +
        "protocol \(modulename)Interactable {}\n\n" +
        "final class \(modulename)Interactor {\n" +
        "    fileprivate let dataManager: \(modulename)DataManager\n" +
        "    fileprivate weak var moduleDelegate: \(modulename)ModuleDelegate?\n\n" +
        "    init(dataManager: \(modulename)DataManager, moduleDelegate: \(modulename)ModuleDelegate?) {\n" +
        "        self.dataManager = dataManager\n" +
        "        self.moduleDelegate = moduleDelegate\n" +
        "    }\n" +
        "}\n\n" +
        "extension \(modulename)Interactor: \(modulename)Interactable {}\n"
}

var presenterText: String {
    return header +
        "import Foundation\n\n" +
        "protocol \(modulename)Presentable {}\n\n" +
        "final class \(modulename)Presenter {\n" +
        "    fileprivate let interactor: \(modulename)Interactable\n\n" +
        "    init(interactor: \(modulename)Interactable) {\n" +
        "        self.interactor = interactor\n" +
        "    }\n" +
        "}\n\n" +
        "extension \(modulename)Presenter: \(modulename)Presentable {}\n"
}

var viewControllerText: String {
    return header +
        "import UIKit\n\n" +
        "final class \(modulename)ViewController: UIViewController {\n" +
        "    fileprivate let presenter: \(modulename)Presentable\n\n" +
        "    required init?(coder: NSCoder) { fatalError(\"init(coder:) has not been implemented\") }\n" +
        "    init(presenter: \(modulename)Presentable) {\n" +
        "        self.presenter = presenter\n" +
        "        super.init(nibName: nil, bundle: nil)\n" +
        "    }\n\n" +
        "    override func viewDidLoad() {\n" +
        "        super.viewDidLoad()\n" +
        "    }\n" +
        "}\n\n" +
        "fileprivate extension \(modulename)ViewController {}\n"
}

var xibViewControllerText: String {
    return "" +
        "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n" +
        "<document type=\"com.apple.InterfaceBuilder3.CocoaTouch.XIB\" version=\"3.0\" toolsVersion=\"11134\" systemVersion=\"15F34\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\" colorMatched=\"YES\">\n" +
        "<dependencies>\n" +
        "<plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"11106\"/>\n" +
        "<capability name=\"documents saved in the Xcode 8 format\" minToolsVersion=\"8.0\"/>\n" +
        "</dependencies>\n" +
        "<objects>\n" +
        "<placeholder placeholderIdentifier=\"IBFilesOwner\" id=\"-1\" userLabel=\"File\'s Owner\" customClass=\"\(modulename)ViewController\" customModuleProvider=\"target\">\n" +
        "<connections>\n" +
        "<outlet property=\"view\" destination=\"i5M-Pr-FkT\" id=\"sfx-zR-JGt\"/>\n" +
        "</connections>\n" +
        "</placeholder>\n" +
        "<placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"-2\" customClass=\"UIResponder\"/>\n" +
        "<view clearsContextBeforeDrawing=\"NO\" contentMode=\"scaleToFill\" id=\"i5M-Pr-FkT\">\n" +
        "<rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"375\" height=\"667\"/>\n" +
        "<autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>\n" +
        "<color key=\"backgroundColor\" red=\"1\" green=\"1\" blue=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"sRGB\"/>\n" +
        "</view>\n" +
        "</objects>\n" +
        "</document>\n"
}

func writeCode(_ code: String, to file: String) throws {
    guard let dir = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first else {
        throw CreateModuleError.noDirectory
    }

    let path = dir.appendingPathComponent(file)
    try code.write(to: path, atomically: false, encoding: String.Encoding.utf8)
}

do {
    try writeCode(wireframeText, to: "\(modulename)Wireframe.swift")
    try writeCode(dataManagerText, to: "\(modulename)DataManager.swift")
    try writeCode(interactorText, to: "\(modulename)Interactor.swift")
    try writeCode(presenterText, to: "\(modulename)Presenter.swift")
    try writeCode(viewControllerText, to: "\(modulename)ViewController.swift")
    try writeCode(xibViewControllerText, to: "\(modulename)ViewController.xib")
    print("Success.")
    exit(EXIT_SUCCESS)
} catch {
    dump(error)
    exit(EXIT_FAILURE)
}

