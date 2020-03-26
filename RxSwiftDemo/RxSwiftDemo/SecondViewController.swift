//
//  SecondViewController.swift
//  RxSwiftDemo
//
//  Created by 华惠友 on 2020/3/17.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan



    }

    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

}
