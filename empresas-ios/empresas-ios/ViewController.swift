//
//  ViewController.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 01/04/21.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var network = Networking()
    var user = User()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func logIn(_ sender: UIButton) {

        MBProgressHUD.showAdded(to: self.view, animated: true)
        user.email = emailTextField.text ?? ""
        user.password = passwordTextField.text ?? ""
        let endpoint = Endpoint(withPath: .signIn)
        guard let url = endpoint.url else {
            return
        }
        network.request(url: url,
                        method: .POST,
                        header: ["Content-Type": "application/json"],
                        body: network.encodeToJSON(data: user)) { data, response in

            self.user.accessToken = self.network.getHeaderValue(forKey: "access-token")
            self.user.client = self.network.getHeaderValue(forKey: "client")
            self.user.userId = self.network.getHeaderValue(forKey: "uid")

            MBProgressHUD.hide(for: self.view, animated: true)
            self.performSegue(withIdentifier: "goToHomeViewController", sender: self)
        }
    }

    @IBAction func changePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }
}
