//
//  YCPopMenuPreferences.swift
//  YCPopMenu
//
//  Created by ungacy on 2018/3/16.
//  Copyright © 2018年 ungacy. All rights reserved.
//

import Foundation

public struct YCPopMenuPreferences {

    public enum YCPopMenuDirection {
        case up
        case down
    }

    public struct Animation {

        public var revealDuration: TimeInterval = 0.25

        public var hideDuration: TimeInterval = 0.25

        public var animated = true
    }

    public struct Configuration {

        public var menuSize = CGSize()

        public var maxMenuCount = 6

        public var coverEdgeInsets = UIEdgeInsets()

        public var direction: YCPopMenuDirection = .down

        public var coverColor: UIColor?

        public var shadow = true

        public var arrowSize = CGSize()
        
        public var arrowOffset = UIOffset()

        public var offset = UIOffset()

        public var dismissWhenSelectedMenu = true
    }

    public var basic = Configuration()

    public var animation = Animation()
}
