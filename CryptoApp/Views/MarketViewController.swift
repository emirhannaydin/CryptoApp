//
//  MainViewController.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 7.08.2024.
//

import UIKit
import FirebaseAuth

class MarketViewController: UIViewController {

    var cryptoList: [Crypto] = []
    var filteredCryptoList: [Crypto] = []
    var top5Cryptos: [Crypto] = []
    var pageNumber = 1
    var isLoading = false
    var isSearching = false
    let dividerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        style()
        layout()
        getCrypto(page: pageNumber)
        userStatus()
        

    }
    
    
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
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CryptoCollectionViewCell.self, forCellWithReuseIdentifier: CryptoCollectionViewCell.identifier)
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
}

// MARK: - Functions

extension MarketViewController {
    
    private func style(){
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = .fast

        dividerView.backgroundColor = .darkGray
        
    }
    
    private func layout() {
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
    
    private func getCrypto(page: Int) {
        isLoading = true

        NetworkManager.shared.getCrypto(pageNumber: page) { result, error in
            if let error = error {
                print("Error: \(error.rawValue)")
                self.isLoading = false
                return
            }
            
            guard let result = result else {
                print("No crypto data found")
                self.isLoading = false
                return
            }
            
            
            DispatchQueue.main.async {

                self.cryptoList.append(contentsOf: result)
                if !self.isSearching {
                    self.filteredCryptoList = self.cryptoList
                } else {
                    self.filterContent(for: self.searchTextField.text ?? "")
                }
                
                if self.top5Cryptos.isEmpty{
                    self.top5Cryptos = self.getTop5Cryptos(from: self.cryptoList)
                    self.collectionView.reloadData()
                }
                self.tableView.reloadData()

                self.isLoading = false
                self.pageNumber += 1


            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let position = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height - scrollView.frame.size.height

            if position >= contentHeight + 50 && scrollView.isDragging && !isLoading && !isSearching {
                getCrypto(page: pageNumber)
            }
        }
    }
    
    private func userStatus() {
        if Auth.auth().currentUser?.uid == nil {
            print("Kullanıcı yok")
            let loginScreenVC = UINavigationController(rootViewController: LoginViewController())
            DispatchQueue.main.async {
                loginScreenVC.modalPresentationStyle = .fullScreen
                self.present(loginScreenVC, animated: true)
            }
        } else {
            print("Kullanıcı var")
        }
    }
    
    private func filterContent(for searchText: String) {
        if searchText.isEmpty {
            filteredCryptoList = cryptoList
        } else {
            filteredCryptoList = cryptoList.filter { $0.name.lowercased().contains(searchText) }
        }
        tableView.reloadData()
    }
    
    @objc private func searchTextChanged(_ textField: UITextField) {
        let searchText = textField.text?.lowercased() ?? ""
        isSearching = !searchText.isEmpty
        filterContent(for: searchText)
        
        if isSearching {
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
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
       
    }
    
    private func removeTapGesture() {
        if let tapGesture = view.gestureRecognizers?.first(where: { $0 is UITapGestureRecognizer }) {
            view.removeGestureRecognizer(tapGesture)
        }
    }
    
       
    @objc private func handleTapOutside(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func getTop5Cryptos(from cryptos: [Crypto]) -> [Crypto] {
        let sortedCryptos = cryptos.sorted {
            ($0.priceChangePercentage24H ?? 0.0) > ($1.priceChangePercentage24H ?? 0.0)
        }
        let top5Cryptos = Array(sortedCryptos.prefix(5))
        return top5Cryptos
    }
    
    func sortCryptosByPriceChangePercentage(_ cryptos: [Crypto]) -> [Crypto] {
        return cryptos.sorted {
            ($0.priceChangePercentage24H ?? 0.0) > ($1.priceChangePercentage24H ?? 0.0)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as! CryptoTableViewCell
        
        let model = filteredCryptoList[indexPath.row]
        cell.cryptoSetup(model: model)
        
        
        cell.backgroundColor = UIColor.systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        
        let cryptoDetailVC = CryptoDetailViewController()
        cryptoDetailVC.title = "Crypto Details"
        cryptoDetailVC.crypto = self.filteredCryptoList[indexPath.row]
        self.navigationController?.pushViewController(cryptoDetailVC, animated: true)
        print(indexPath.row)
        }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MarketViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return top5Cryptos.count // Burada en yüksek 5 kriptoyu gösteriyoruz
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CryptoCollectionViewCell.identifier, for: indexPath) as! CryptoCollectionViewCell

        let model = top5Cryptos[indexPath.row] // En yüksek 5 kriptoyu kullanıyoruz
        cell.cryptoSetup(model: model)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.darkGray.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 100)
    }
    
}

