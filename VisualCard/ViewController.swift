//
//  ViewController.swift
//  VisualCard
//
//  Created by Nobel on 2017/10/21.
//  Copyright © 2017年 Nobel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }

    @IBAction func showExample(_ sender: Any) {
        let vc = VisualCard()
        vc.modalPresentationStyle = .overCurrentContext
        let first = UINib(nibName: "First", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        vc.views = [first]
        present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

