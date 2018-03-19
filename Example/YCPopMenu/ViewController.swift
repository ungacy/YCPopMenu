//
//  ViewController.swift
//  YCPopMenu
//
//  Created by ungacy on 03/16/2018.
//  Copyright (c) 2018 ungacy. All rights reserved.
//

import UIKit
import YCPopMenu

@objcMembers
class ViewController: UIViewController {

    let button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(popFromBarItem(sender:)))
        button .frame = CGRect(x: (view.bounds.width - 100) / 2, y: (view.bounds.height - 100) / 2, width: 100, height: 100)
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.setTitle("Pop", for: .normal)
        button.backgroundColor = UIColor.gray
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func buttonAction (sender: UIView) {
        let data = 1...5
        let dataArray = data.map { (title) -> YCPopMenuDemoItem in
            var item = YCPopMenuDemoItem()
            item.menuHeight = 40
            item.title = "\(title)"
            item.id = title
            item.available = title % 3 == 0
            return item
        }
        let pop = YCPopMenu(dataArray: dataArray, cellClass: YCPopMenuDemoCell.self) { _, data in
            print(data)
        }
        pop.preferences.basic.menuSize = CGSize(width: 100, height: 30)
        pop.preferences.basic.arrowSize = CGSize(width: 10, height: 5)
        pop.preferences.basic.coverEdgeInsets = UIEdgeInsetsMake(40, 0, 0, 0)
        pop.showFromView(view: sender)
    }
    
    func popFromBarItem(sender: UIBarButtonItem) {
        guard let theView = sender.value(forKey: "view") as? UIView else {
            return
        }
        let data = 1...5
        let dataArray = data.map { (title) -> YCPopMenuDemoItem in
            var item = YCPopMenuDemoItem()
            item.menuHeight = 40
            item.title = "\(title)"
            item.id = title
            item.available = title % 3 == 0
            return item
        }
        let pop = YCPopMenu(dataArray: dataArray, cellClass: YCPopMenuDemoCell.self) { _, data in
            print(data)
        }
        pop.preferences.basic.menuSize = CGSize(width: 100, height: 30)
        pop.preferences.basic.arrowSize = CGSize(width: 10, height: 5)
        pop.preferences.basic.coverEdgeInsets = UIEdgeInsetsMake(40, 0, 0, 0)
        // pop.preferences.basic.coverColor = UIColor.gray
        pop.preferences.basic.direction = .down
        pop.preferences.basic.offset = UIOffset(horizontal: -100/2 - 12, vertical: 0)
        //初始位置在中间.
        pop.preferences.basic.arrowOffset = UIOffset(horizontal: 100/4, vertical: 0)
        //pop.preferences.basic.dismissWhenSelectedMenu = false
        pop.showFromView(view: theView)
    }
}
