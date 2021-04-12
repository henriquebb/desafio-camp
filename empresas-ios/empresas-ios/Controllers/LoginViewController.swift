//
//  LoginViewController.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 01/04/21.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator

class LoginViewController: UIViewController {

// MARK: - IBOutlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVisibilityButton: UIButton!
    @IBOutlet weak var emailErrorButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activitySpinner: UIView!
    @IBOutlet weak var blackTransparentView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var bottomViewToMainStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTopToMainStackView: NSLayoutConstraint!
    // MARK: - Variables

    var network = Networking()
    var user = User()
    var errorState = false
    let indicator = MDCActivityIndicator()
    let innerIndicator = MDCActivityIndicator()
    var bottomConstraint: NSLayoutConstraint?
    var spinner: Spinner?

// MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNavigationBarVisibility()
        setViewsToBool(view: [emailErrorButton, errorLabel], bool: true)
        self.view.bringSubviewToFront(mainStackView)
    }

    override func viewDidDisappear(_ animated: Bool) {
        spinner?.stopAnimating()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObservers()
    }
}

// MARK: - IBActions

extension LoginViewController {

    @IBAction func logIn(_ sender: UIButton) {

        spinner = Spinner(activitySpinner, blackTransparentView, self.view)
        spinner?.startAnimating()
        setUserBody()
        guard let url = createURL() else {
            return
        }
        network.request(url: url,
                        method: .POST,
                        header: ["Content-Type": "application/json"],
                        body: network.encodeToJSON(data: user)) { [self] _, response in

            switchResponseCode(response: response)
        }
    }

    @IBAction func changePasswordVisibility(_ sender: UIButton) {
        if errorState == false {
            sender.isSelected.toggle()
            passwordTextField.isSecureTextEntry.toggle()
        } else {
            passwordTextField.layer.borderWidth = 0
            passwordTextField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
            sender.setImage(UIImage(named: "eye"), for: .normal)
            sender.layoutIfNeeded()
            passwordTextField.text = ""
            passwordTextField.layoutIfNeeded()
            errorLabel.isHidden = true
            errorState = false
        }
    }

    @IBAction func clearEmail(_ sender: UIButton) {
        emailTextField.text = ""
        emailTextField.layer.borderWidth = 0
        emailTextField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        emailErrorButton.imageView?.contentMode = .scaleAspectFit
        emailErrorButton.isHidden = true
        emailTextField.layoutIfNeeded()
    }
}

// MARK: - User functions

extension LoginViewController {

    private func setUserBody() {
        user.email = emailTextField.text ?? ""
        user.password = passwordTextField.text ?? ""
    }

    private func setUserHeaders() {
        self.user.accessToken = self.network.getHeaderValue(forKey: "access-token")
        self.user.client = self.network.getHeaderValue(forKey: "client")
        self.user.userId = self.network.getHeaderValue(forKey: "uid")
    }

    private func setTextLabelBorderStyleOnError(views: [UIView]) {
        views.forEach { view in
            view.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
            view.layer.borderWidth = 2
            view.layoutIfNeeded()
        }
    }
}

// MARK: - VC functions

extension LoginViewController {

    private func navigateToHomeVC() {
        guard let homeVC = self.storyboard?
                .instantiateViewController(identifier: "HomeViewControllerID") as? HomeViewController else {
            return
        }
        homeVC.user = self.user
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}

// MARK: - Networking functions

extension LoginViewController {

    private func createURL() -> URL? {
        return Endpoint(withPath: .signIn).url
    }

    private func switchResponseCode(response: HTTPURLResponse) {
        switch response.statusCode {
        case 200...299:
            setUserHeaders()
            navigateToHomeVC()
        case 300...310:
            print("redirected")
        case 401...499:
            errorState = true
            setTextLabelBorderStyleOnError(views: [emailTextField, passwordTextField])
            setPasswordTextLabelImage()
            setViewsToBool(view: [emailErrorButton, errorLabel], bool: false)
            passwordVisibilityButton.layoutIfNeeded()
            emailErrorButton.layoutIfNeeded()
        case 500...599:
            print("internal server error")
        default:
            print("unknown error")
        }
    }
}

// MARK: - UI functions

extension LoginViewController {

    private func setNavigationBarVisibility() {
        self.navigationController?.navigationBar.isHidden = true
    }

    private func setPasswordTextLabelImage() {
        passwordVisibilityButton.setImage(UIImage(named: "x.error"), for: .normal)
        passwordVisibilityButton.imageView?.contentMode = .scaleAspectFit
        passwordVisibilityButton.imageView?.frame =
            CGRect(x: 0, y: 0, width: 20, height: 20)
    }

    private func setViewsToBool(view: [UIView], bool: Bool) {
        view.forEach { $0.isHidden = bool }
    }
}

// MARK: - Keyboard functions

extension LoginViewController {

    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomViewToMainStackViewConstraint.constant = keyboardSize.height/2
            self.view.layoutIfNeeded()
            welcomeLabel.isHidden = true
        }

    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        bottomViewToMainStackViewConstraint.constant = 0
        welcomeLabel.isHidden = false
    }
}
