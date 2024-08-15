//
//  AccountViewController.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 7.08.2024.
//

import UIKit
import FirebaseAuth

protocol AccountViewControllerInterface: AnyObject {
    func style()
    func layout()
    func configureText()
    func goLoginPage()
    func signOutAlert()
        
}

class AccountViewController: UIViewController {
    
    lazy var viewModel = AccountViewModel()
    
    private let emailLabel = UILabel()
    private let usernameLabel = UILabel()
    
    private lazy var emailContainerView: UIView = {
        let containerView = AccountView(image: UIImage(systemName: "envelope")!, label: emailLabel)
        return containerView
    }()
    private lazy var usernameContainerView: UIView = {
        let containerView = AccountView(image: UIImage(systemName: "person")!, label: usernameLabel)
        return containerView
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.layer.cornerRadius = 7
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.alpha = 0.8
        button.addTarget(self, action: #selector(signOutAlert), for: .touchUpInside)
        return button
    }()
    
    private var stackView = UIStackView()
    private let logoImageView: UIImageView = {
        let imageView = CustomLoginImageView(imageName: "person")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGradientColor()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    
}
extension AccountViewController: AccountViewControllerInterface{
    func style(){
        stackView = UIStackView(arrangedSubviews: [usernameContainerView, emailContainerView, signOutButton])
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.distribution = .fillEqually
        
        usernameLabel.textColor = .white
        emailLabel.textColor = .white
    }
    func layout(){
        view.addSubview(stackView)
        view.addSubview(logoImageView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
            
        ])
    }
    
    func configureText(){
        guard let user = viewModel.user else { return }
        emailLabel.text = "\(user.email)"
        usernameLabel.text = "\(user.username)"
    }
    func goLoginPage(){
        viewModel.signOut()
        let loginScreenVC = UINavigationController(rootViewController: LoginViewController())
        loginScreenVC.modalPresentationStyle = .fullScreen
        self.present(loginScreenVC, animated: true)
    }
    
    @objc func signOutAlert() {
            let alert = UIAlertController(title: "Sign Out",
                                          message: "Do you want to sign out of the application?",
                                          preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                self.goLoginPage()
            }
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
        }
}

