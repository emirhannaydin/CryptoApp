//
//  MainViewController.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 7.08.2024.
//

import UIKit
import FirebaseAuth

protocol MarketViewControllerInterface: AnyObject{
    func style()
    func layout()
    func getSearchText() -> String
    func reloadCollection()
    func reloadTable()
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func userStatus()
    func searchTextChanged(_ textField: UITextField)
    func textFieldDidBeginEditing(_ textField: UITextField)
    func setupTapGesture()
    func removeTapGesture()
    func handleTapOutside(_ sender: UITapGestureRecognizer)
    func showNetworkError(_ errorMessage: ErrorMessage)
    func showNoDataError()
    
}

final class MarketViewController: UIViewController {
    
    lazy var viewModel = MarketViewModel()
    
    let dividerView = UIView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CryptoCollectionViewCell.self, forCellWithReuseIdentifier: CryptoCollectionViewCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = .fast
        
        return collectionView
    }()
    
    private lazy var searchContainerView: UIView = {
        let containerView = CustomSearchInputView(image: UIImage(systemName: "magnifyingglass")!, textField: searchTextField)
        
        return containerView
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = CustomTextField(placeHolder: "Search", placeholderColor: UIColor.darkGray)
        textField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        
        return textField
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Top 5 cryptocurrencies from the top 250 coins by market cap"
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let appName: UILabel = {
        let label = UILabel()
        label.text = "Crypto App"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
}

//MARK: - Functions

extension MarketViewController:MarketViewControllerInterface {
    
    func style(){
        view.backgroundColor = .systemBackground
        dividerView.backgroundColor = .darkGray
        
    }
    
    func layout(){
        view.addSubview(appName)
        view.addSubview(collectionView)
        view.addSubview(searchContainerView)
        view.addSubview(tableView)
        view.addSubview(dividerView)
        view.addSubview(topLabel)
        
        appName.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            appName.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            appName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            appName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            appName.heightAnchor.constraint(equalToConstant: 20),
            
            collectionView.topAnchor.constraint(equalTo: appName.bottomAnchor,constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
            
            topLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 6),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 20),
            
            dividerView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 6),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            searchContainerView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 32),
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    func getSearchText() -> String{
        return self.searchTextField.text ?? ""
    }
    func reloadCollection(){
        self.collectionView.reloadData()

    }
    func reloadTable(){
        self.tableView.reloadData()
    }
    
    func userStatus() {
        if viewModel.checkUser() {
            let loginScreenVC = UINavigationController(rootViewController: LoginViewController())
                loginScreenVC.modalPresentationStyle = .fullScreen
                self.present(loginScreenVC, animated: true)
            
        }
    }
    
    func showNetworkError(_ errorMessage: ErrorMessage) {
        DispatchQueue.main.async {
            self.showHud(show: "Error" ,detailShow: errorMessage.rawValue, delay: 1)
        }
    }
    func showNoDataError(){
        DispatchQueue.main.async {
            self.showHud(show: "Error" ,detailShow: "No crypto data found", delay: 1)
        }
    }
    
//MARK: - Delegates
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView == tableView {
                let position = scrollView.contentOffset.y
                let contentHeight = scrollView.contentSize.height - scrollView.frame.size.height

                if position >= contentHeight + 50 && scrollView.isDragging && !viewModel.isLoading && !viewModel.isSearching {
                    viewModel.getCryptoService(page: viewModel.pageNumber)
                }
            }
        }
    @objc func searchTextChanged(_ textField: UITextField) {
        let searchText = textField.text?.lowercased() ?? ""
        viewModel.isSearching = !searchText.isEmpty
        viewModel.filterContent(searchText: searchText)
        
        if viewModel.isSearching {
               setupTapGesture()
           } else {
               removeTapGesture()
           }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == searchTextField {
                setupTapGesture()
            }
        }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func removeTapGesture() {
        if let tapGesture = view.gestureRecognizers?.first(where: { $0 is UITapGestureRecognizer }) {
            view.removeGestureRecognizer(tapGesture)
        }
    }
    @objc func handleTapOutside(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}




