//
//  YCPopMenuDemoCell.swift
//  YCPopMenu_Example
//
//  Created by Ye Tao on 2018/3/16.
//  Copyright © 2018年 ungacy. All rights reserved.
//

import UIKit
import YCPopMenu

struct YCPopMenuDemoItem: YCPopMenuHeightProtocol, YCPopMenuAvailableProtocol {
    var title: String?
    var id: Int?
    var data: Any?
    var menuHeight: CGFloat
    var available = true
    init() {
        available = true
        menuHeight = 0
    }
}

class YCPopMenuDemoCell: UITableViewCell, YCPopMenuCellProtocol {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadWithData(data: Any) {
        if let item = data as? YCPopMenuDemoItem {
            textLabel?.text = item.title
        }
    }
}
