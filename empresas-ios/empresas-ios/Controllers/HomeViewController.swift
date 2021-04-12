//
//  HomeViewController.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 07/04/21.
//

import UIKit

class HomeViewController: UIViewController {

// MARK: - IBOutlets

    @IBOutlet weak var logoImagesView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backgroundImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

// MARK: - Variables

    var user: User?
    let network = Networking()
    var enterprisesSchema: Enterprises?
    var constraint: NSLayoutConstraint?
    var spinner: Spinner?

// MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewDelegates()
        addKeyboardObservers()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.tableView.layoutIfNeeded()
    }
}

// MARK: - SearchBar

extension HomeViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        handleSearchBarTap()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else {
            self.enterprisesSchema?.enterprises?.removeAll()
            tableView.reloadData()
            return
        }
        tableView.tableHeaderView = nil
        let url = Endpoint(withPath: .enterprises)
        tableView.isHidden = false
        guard let endpointUrl = url.url else {
            return
        }
        var components = URLComponents(url: endpointUrl, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "name", value: searchText)]
        guard let requestURL = components?.url else {
            return
        }
        let headers = ["content-type": "application/json",
                       "client": user?.client ?? "",
                       "uid": user?.userId ?? "",
                       "access-token": user?.accessToken ?? ""]
        createTableViewSpinnerViewHeader()
        guard let tableHeaderView = tableView.tableHeaderView else {
            return
        }
        spinner = Spinner(tableHeaderView, nil, self.view)
        spinner?.changeSpinnerColor([UIColor(red: 0.984, green: 0.859, blue: 0.907, alpha: 1)])
        spinner?.startAnimating()
        network.request(url: requestURL, method: .GET, header: headers, body: nil) { (data, _) in
            self.enterprisesSchema = self.network.decodeFromJSON(type: Enterprises.self, data: data)
            if self.enterprisesSchema?.enterprises?.count == 0 {
                self.createTableViewLabelHeader()
            }
            self.tableView.tableHeaderView = nil
            self.tableView.reloadData()
            self.spinner?.stopAnimating()
        }
    }
}

// MARK: - TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.enterprisesSchema?.enterprises?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
            let labelView = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width, height: 20))
            labelView.font = UIFont(name: "Rubik", size: 18)
            labelView.text = "\(String(self.enterprisesSchema?.enterprises?.count ?? 0)) Resultados encontrados"
            view.addSubview(labelView)
            return view
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let nib = UINib(nibName: "CompanyTableViewCell", bundle: Bundle(for: CompanyTableViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: "CompanyTableViewCell")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTableViewCell",
                                                   for: indexPath) as? CompanyTableViewCell
        else { return UITableViewCell() }

        let colors = [Color.blue, Color.pink, Color.green]
        cell.companyBackgroundView.backgroundColor = colors.randomElement()
        cell.companyLabel.text = self.enterprisesSchema?.enterprises?[indexPath.section].enterpriseName
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let companyVC = self
                .storyboard?
                .instantiateViewController(identifier: "CompanyDetailViewControllerID") as? CompanyDetailViewController
        else { return }
        companyVC.companyDetailText = self.enterprisesSchema?.enterprises?[indexPath.section].description
        companyVC.companyTitle = self.enterprisesSchema?.enterprises?[indexPath.section].enterpriseName
        navigationController?.pushViewController(companyVC, animated: true)
    }

    private func setTableViewHeader(_ view: UIView) {
        tableView.tableHeaderView = view
        tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView?
            .centerYAnchor
            .constraint(equalTo: self.tableView.centerYAnchor).isActive = true
        tableView.tableHeaderView?
            .centerXAnchor
            .constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        tableView.layoutIfNeeded()
    }

    private func createTableViewLabelHeader() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 17))
        label.text = "Nenhum resultado encontrado"
        label.textAlignment = .center
        setTableViewHeader(label)
    }

    private func createTableViewSpinnerViewHeader() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 70))
        setTableViewHeader(view)
    }
}

// MARK: - Gestures functions

extension HomeViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (tableView.visibleCells.count != 0) ? false : true
    }

    private func addGestureRecognizerToTableView() {
        let tableViewTap = UITapGestureRecognizer(target: self,
                                                  action: #selector(self.handleTableViewTap(_:)))
        tableViewTap.cancelsTouchesInView = false
        tableViewTap.delegate = self
        tableView.addGestureRecognizer(tableViewTap)
    }

    @objc func handleTableViewTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.35) {
            self.backgroundImageHeightConstraint.constant = 200
            self.searchBarTopConstraint.constant = 180
            self.logoImagesView.isHidden = false
            self.view.layoutIfNeeded()
            self.searchBar.resignFirstResponder()
        }
}

    private func handleSearchBarTap() {
        UIView.animate(withDuration: 0.35) {
            self.backgroundImageHeightConstraint.constant = 100
            self.searchBarTopConstraint.constant = 80
            self.logoImagesView.isHidden = true
            self.view.layoutIfNeeded()
            self.searchBar.becomeFirstResponder()
        }
    }
}

// MARK: - Layout

extension HomeViewController {

    private func setSearchBarLayout() {
        searchBar.searchTextField.backgroundColor = searchBar.backgroundColor
        searchBar.layer.cornerRadius = 4.0
        searchBar.clipsToBounds = true
    }

    private func setNavigationItemTitle() {
        navigationItem.title = ""
    }

    private func styleTableView() {
        tableView.separatorStyle = .none
    }

    private func hideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - View Delegates

extension HomeViewController {

    private func setViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
}

// MARK: - Setup

extension HomeViewController {

    private func setup() {
        hideNavigationBar()
        styleTableView()
        addGestureRecognizerToTableView()
        setSearchBarLayout()
        setNavigationItemTitle()
    }
}

// MARK: - Keyboard functions

extension HomeViewController {

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

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            constraint = tableView
                .tableHeaderView?
                .centerYAnchor
                .constraint(equalTo: tableView.centerYAnchor, constant: -keyboardSize.height/2)
            constraint?.isActive = true
        }

    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            constraint?.isActive = false
            tableView
                .tableHeaderView?
                .centerYAnchor
                .constraint(equalTo: tableView.centerYAnchor, constant: keyboardSize.height/2).isActive = true
        }
        tableView.layoutIfNeeded()
    }
}
