//
//  ViewController.swift
//  MessengerApp
//
//  Created by Ilya on 11.10.2023.
//

import UIKit

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        
        if !isLoggedIn {
            let vc = LoginViewController()
            let navc = UINavigationController(rootViewController: vc)
            navc.modalPresentationStyle = .fullScreen
            present(navc, animated: false)
        }
    }
    
}

