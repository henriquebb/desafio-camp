//
//  CompanyDetailViewController.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 08/04/21.
//

import UIKit

class CompanyDetailViewController: UIViewController {

// MARK: - IBOutlets

    @IBOutlet weak var companyDetailTextLabel: UILabel!
    @IBOutlet weak var companyName: UILabel!

// MARK: - Variables

    var companyDetailText: String?
    var companyTitle: String?

// MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        styleNavigationBar()
        setCompanyText()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Style functions

extension CompanyDetailViewController {

    private func setCompanyText() {
        companyDetailTextLabel.text = companyDetailText
        companyName.text = companyTitle ?? ""
    }

    private func styleNavigationBar() {
        guard let navigationBar = self.navigationController?.navigationBar else {
            return
        }
        let image = UIImage(named: "back_arrow")
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)

        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButton
        navigationBar.tintColor = .gray
        navigationBar.barTintColor = .white
        navigationBar.backItem?.title = ""
        navigationBar.isHidden = false
        navigationItem.title = companyTitle ?? ""
    }
}

// MARK: - Navigation functions

extension CompanyDetailViewController {

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
