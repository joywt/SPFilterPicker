//
//  FilterTitle.swift
//  SPFilterPicker
//
//  Created by wang tie on 2017/3/10.
//  Copyright © 2017年 360jk. All rights reserved.
//

import UIKit

struct FilterTitle {
    var name:String
    private var noStatusImage:String
    private var statusImages:[String]
    //private var nameColor:UIColor
    init(name:String,noStatusImage:String, statusImages:[String]) {
        self.name = name
        self.noStatusImage = noStatusImage
        self.statusImages = statusImages
    }
    private var status = 0
    var imageName:String {
        switch status {
        case 0:
            return noStatusImage
        default:
            if statusImages.count >= status {
                return statusImages[status - 1]
            }
            return ""
        }
    }
    
    enum Operation {
        case reset,change
    }
    
    public mutating func changeStatus(_ op:Operation){
        switch op {
        case .reset: status = 0
        case .change:
            status += 1
            if status > statusImages.count {
                status = 1
            }
        }
    }
}
