//
//  ViewController.swift
//  Asaf VideoIMG
//
//  Created by Mobile on 17/08/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .white
        let vc = PreViewVc()
        self.navigationController?.pushViewController(vc, animated: true)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false

    }
}

