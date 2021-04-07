//
//  HomeViewController.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 07/04/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var logoImagesView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        let searchFieldTap = UITapGestureRecognizer(target: self,
                                             action: #selector(self.handleSearchTextFieldTap(_:)))
        let tableViewTap = UITapGestureRecognizer(target: self,
                                                  action: #selector(self.handleTableViewTap(_:)))
        tableView.addGestureRecognizer(tableViewTap)
        searchTextField.addGestureRecognizer(searchFieldTap)
        searchTextField.isUserInteractionEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @objc func handleSearchTextFieldTap(_ sender: UITapGestureRecognizer) {
        heightConstraint.constant = 100
        searchTextFieldTopConstraint.constant = 80
        logoImagesView.isHidden = true
        self.view.layoutIfNeeded()
        searchTextField.becomeFirstResponder()
    }
}

extension HomeViewController: UITextFieldDelegate {
}

extension HomeViewController {
    @objc func handleTableViewTap(_ sender: UITapGestureRecognizer) {
        heightConstraint.constant = 200
        searchTextFieldTopConstraint.constant = 180
        logoImagesView.isHidden = false
        self.view.layoutIfNeeded()
        searchTextField.resignFirstResponder()
    }
}
