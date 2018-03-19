//
//  YCPopMenu.swift
//  YCPopMenu
//
//  Created by ungacy on 2018/3/16.
//  Copyright © 2018年 ungacy. All rights reserved.
//

import UIKit

let YCPopMenuNoSelectionIndex = -1

open class YCPopMenu: UIView {

    open var preferences = YCPopMenuPreferences()

    private var dataArray: [Any]?

    public var actionBlock: ((Int, Any) -> Void)?

    public var customCellBlock: ((IndexPath, UITableViewCell) -> Void)?

    public let tableView: UITableView = UITableView(frame: CGRect(), style: .plain)

    public var visible: Bool {
        return _visible
    }

    private var _visible = false

    private var point: CGPoint?

    private var cellClass: AnyClass?

    private var arrow = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public convenience init(dataArray: [Any],
                            cellClass: AnyClass,
                            actionBlock: @escaping (Int, Any) -> Void) {
        self.init(frame: CGRect())
        self.dataArray = dataArray
        self.cellClass = cellClass
        self.actionBlock = actionBlock
        setupTableView()
    }

    func setupTableView() {
        guard cellClass != nil else {
            return
        }
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellClass, forCellReuseIdentifier: NSStringFromClass(cellClass!))
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets()
        tableView.layoutMargins = UIEdgeInsets()
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
    }

    public required init?(coder _: NSCoder) {
        super.init(frame: CGRect())
    }

    func objectAt(indexPath: IndexPath) -> Any {
        return dataArray![indexPath.row]
    }
}

// MARK: Animation
extension YCPopMenu {
    private func animation() {
        if !preferences.animation.animated {
            if _visible {
                addArrow()
                layoutIfNeeded()
            } else {
                superview?.removeFromSuperview()
                removeFromSuperview()
            }
            return
        }
        var oldFrame = frame
        if _visible {
            addArrow()
            var currentFrame = oldFrame
            if preferences.basic.direction == .up {
                currentFrame.origin.y += currentFrame.size.height
            }
            currentFrame.size.height = 0
            frame = currentFrame
            currentFrame.origin = CGPoint()
            tableView.frame = currentFrame
            superview?.alpha = 0
            if preferences.basic.direction == .up {
                var arrowFrame = arrow.frame
                arrowFrame.origin.y -= oldFrame.size.height
                arrow.frame = arrowFrame
            }
        } else {
            superview?.alpha = 1
            arrow.removeFromSuperview()
        }
        UIView.animate(withDuration: preferences.animation.revealDuration,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                           if self.visible {
                               self.frame = oldFrame
                               oldFrame.origin = CGPoint()
                               self.tableView.frame = oldFrame
                               self.superview?.alpha = 1
                               if self.preferences.basic.direction == .up {
                                   var arrowFrame = self.arrow.frame
                                   arrowFrame.origin.y += oldFrame.size.height
                                   self.arrow.frame = arrowFrame
                               }
                           } else {
                               var currentFrame = oldFrame
                               if self.preferences.basic.direction == .up {
                                   currentFrame.origin.y += currentFrame.size.height
                               }
                               currentFrame.size.height = 0
                               self.frame = currentFrame
                               currentFrame.origin = CGPoint()
                               self.tableView.frame = currentFrame
                               self.superview?.alpha = 0
                           }
                       }, completion: { _ in
                           if !self.visible {
                               self.superview?.removeFromSuperview()
                               self.removeFromSuperview()
                           }
        })
    }
}

// MARK: Looking
extension YCPopMenu {
    private func addCover() {
        let cover = UIScrollView()
        let windows = UIApplication.shared.keyWindow!
        windows.addSubview(cover)
        let coverContent = UIView()
        cover.addSubview(coverContent)
        if let color = preferences.basic.coverColor {
            coverContent.backgroundColor = color
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        tapGesture.delegate = self
        cover.addGestureRecognizer(tapGesture)
        cover.frame = windows.bounds
        var frame = windows.bounds
        let coverEdgeInsets = preferences.basic.coverEdgeInsets
        frame.origin.x += coverEdgeInsets.left
        frame.origin.y += coverEdgeInsets.top
        frame.size.width -= (coverEdgeInsets.left + coverEdgeInsets.right)
        frame.size.height -= (coverEdgeInsets.top + coverEdgeInsets.bottom)
        coverContent.frame = frame
        cover.addSubview(self)
        setupShadow()
    }

    func addArrow() {
        let size = preferences.basic.arrowSize
        if size.equalTo(CGSize()) {
            return
        }
        var currentFrame = CGRect(origin: CGPoint(), size: size)
        currentFrame.origin.x = frame.width / 2 + preferences.basic.arrowOffset.horizontal
        let arrowLayer = CAShapeLayer()
        arrow.layer.addSublayer(arrowLayer)
        let path = UIBezierPath()
        if preferences.basic.direction == .up {
            currentFrame.origin.y = frame.height
            path.move(to: CGPoint())
            path.addLine(to: CGPoint(x: size.width, y: 0))
            path.addLine(to: CGPoint(x: size.width / 2, y: size.height))
            path.addLine(to: CGPoint())
        } else {
            currentFrame.origin.y -= size.height
            path.move(to: CGPoint(x: 0, y: size.height))
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: size.width / 2, y: 0))
            path.addLine(to: CGPoint(x: 0, y : size.height))
        }
        arrowLayer.fillColor = UIColor.white.cgColor
        arrowLayer.strokeColor = nil
        arrowLayer.path = path.cgPath
        arrow.frame = currentFrame
        arrowLayer.frame = arrow.bounds
        addSubview(arrow)
    }

    func setupShadow() {
        if preferences.basic.shadow {
            layer.shadowColor = UIColor.gray.cgColor
            layer.shadowOffset = CGSize()
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 3
        } else {
            layer.shadowColor = nil
            layer.shadowOffset = CGSize()
            layer.shadowOpacity = 0
            layer.shadowRadius = 0
        }
    }

    @objc func tap() {
        hide()
    }
}

extension YCPopMenu: UIGestureRecognizerDelegate {
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: self)
        return !tableView.frame.contains(point)
    }
}

// MARK: Show
public extension YCPopMenu {

    func setupLayout(point: CGPoint) {
        self.point = point
        var frame = CGRect(origin: point, size: CGSize(width: 0, height: 0))
        let size = preferences.basic.menuSize
        var height: CGFloat = 0.0
        for item in dataArray! {
            if let one = item as? YCPopMenuHeightProtocol {
                height += one.menuHeight
            }
        }
        if height == 0 {
            var count = dataArray!.count
            if count > preferences.basic.maxMenuCount {
                tableView.isScrollEnabled = true
                count = preferences.basic.maxMenuCount
            }
            height = size.height * CGFloat(count)
        }

        if preferences.basic.direction == .up {
            frame.origin.y -= height
        }
        frame.size.height = height
        frame.size.width = size.width
        frame.origin.x += preferences.basic.offset.horizontal
        frame.origin.y += preferences.basic.offset.vertical
        self.frame = frame
        frame.origin = CGPoint()
        tableView.frame = frame
    }

    public func showFromPoint(point: CGPoint) {
        guard UIApplication.shared.keyWindow != nil &&
            cellClass != nil &&
            dataArray != nil &&
            dataArray!.count > 0 else {
            return
        }
        addCover()
        setupLayout(point: point)
        tableView.reloadData()
        _visible = true
        animation()
    }
    
    
    public func showFromView(view: UIView) {
        let windows = UIApplication.shared.keyWindow
        let rect = view.superview?.convert(view.frame, to: windows)
        var point = rect?.origin
        if preferences.basic.direction == .down {
            point = CGPoint(x: rect!.minX, y: rect!.maxY)
        }
        showFromPoint(point: point!)
    }

    public func hide() {
        _visible = false
        animation()
    }
}

extension YCPopMenu: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return dataArray!.count
    }

    public func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = objectAt(indexPath: indexPath)
        if let one = item as? YCPopMenuHeightProtocol {
            return one.menuHeight
        }
        return preferences.basic.menuSize.height
    }

    public func tableView(_ tableView: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(cellClass!))!
    }

    public func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let one = cell as? YCPopMenuCellProtocol {
            one.reloadWithData(data: objectAt(indexPath: indexPath))
        }
        if let one = customCellBlock {
            one(indexPath, cell)
        }
    }

    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = objectAt(indexPath: indexPath)
        if let one = item as? YCPopMenuAvailableProtocol {
            if !one.available {
                return
            }
        }
        if let block = actionBlock {
            block(indexPath.row, item)
        }
        if preferences.basic.dismissWhenSelectedMenu {
            hide()
        }
    }
}
