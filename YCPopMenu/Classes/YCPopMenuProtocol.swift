//
//  YCPopMenuProtocol.swift
//  YCPopMenu
//
//  Created by ungacy on 2018/3/16.
//  Copyright © 2018年 ungacy. All rights reserved.
//

import Foundation

public protocol YCPopMenuItemProtocol {
    var menuIdentifier: String { set get }
}

public protocol YCPopMenuHeightProtocol {
    var menuHeight: CGFloat { set get }
}

public protocol YCPopMenuAvailableProtocol {
    var available: Bool { set get }
}

public protocol YCPopMenuCellProtocol {
    func reloadWithData(data: Any)
}
