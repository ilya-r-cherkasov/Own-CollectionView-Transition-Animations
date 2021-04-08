//
//  SecondViewController.swift
//  Search Bar and Custom Transition
//
//  Created by Ilya Cherkasov on 07.04.2021.
//

import UIKit

class SecondViewController: UIViewController {

    var textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textField)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 30)
        ])
        textField.text = "Хочу креветочек"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}
