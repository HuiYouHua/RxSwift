//
//  Hero.swift
//  04-RxSwift的UITableView使用
//
//  Created by apple on 16/12/25.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit

class Hero: NSObject {
    var icon : String = ""
    var intro : String = ""
    var name : String = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
}
