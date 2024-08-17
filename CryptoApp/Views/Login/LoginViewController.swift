//
//  ViewController.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 6.08.2024.
//

import UIKit

protocol LoginViewControllerInterface: AnyObject{
    func style()
    func layout()
    func goRegister()
    func handleLoginButton()
    func showLoginError()
    func LoginSuccess()
    func isValidEmail(_ email: String) -> Bool
}

final class LoginViewController: UIViewController {
    
    private lazy var viewModel = LoginViewModel()

    
    private let logoImageView: UIImageView = {
        let imageView = CustomLoginImageView(imageName: "bitcoinsign.circle")
        return imageView
    }()
    
    private lazy var emailContainerView: UIView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
        return containerView
    }()
    private lazy var passwordContainerView: UIView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "lock")!, textField: passwordTextField)
        return containerView
    }()
    
    private let emailTextField: UITextField = {
        let textField = CustomTextField(placeHolder: "Email", placeholderColor: UIColor.white)
        textField.textColor = .white
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = CustomTextField(placeHolder: "Password", placeholderColor: UIColor.white)
        textField.textColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.layer.cornerRadius = 7
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.alpha = 0.8
        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Click To Become A Member", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 14)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(goRegister), for: .touchUpInside)
        return button
    }()
    
    private var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        
    }
}

extension LoginViewController: LoginViewControllerInterface{
    
    func style(){
        backgroundGradientColor()

        stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.distribution = .fillEqually
        
    }
    func layout(){
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        view.addSubview(registrationButton)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            registrationButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            registrationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            registrationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    @objc func handleLoginButton(){
        guard let emailText = emailTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        if emailText.isEmpty{
            self.showHud(show: "Error", detailShow: "Email field cannot be empty", delay: 1.0)
        }
        else if passwordText.isEmpty{
            self.showHud(show: "Error", detailShow: "Password field cannot be empty", delay: 1.0)

        }
        else{
            if !isValidEmail(emailText){
                self.showHud(show: "Error", detailShow: "Please enter a valid email address", delay: 1)

            }else{
                viewModel.login(emailText: emailText, passwordText: passwordText)

            }
        }
        
    }
    @objc func goRegister(){
        let controller = RegisterViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showLoginError(){
        self.showHud(show: "Error", detailShow: "User not found", delay: 1)
    }
    
    
    
    func LoginSuccess(){
        self.showHud(show: "Login Successful",detailShow: "Please Wait", delay: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let viewController = UINavigationController(rootViewController: TabBarController())
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = viewController
                window.makeKeyAndVisible()
            }
        }
        
    }
}

