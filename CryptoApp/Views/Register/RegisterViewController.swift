//
//  RegisterViewController.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 6.08.2024.
//

import UIKit

protocol RegisterViewControllerInterface: AnyObject{
    func style()
    func layout()
    func handleRegisterButton()
    func goLoginPage()
    func showRegisterError(_ errorMessage: String)
    func registerSuccess()
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
}

final class RegisterViewController: UIViewController {
    
    private lazy var viewModel = RegisterViewModel()
    
    private let logoImageView: UIImageView = {
        let imageView = CustomLoginImageView(imageName: "person.circle")
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
    
    private lazy var usernameContainerView: UIView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "person")!, textField: usernameTextField)
        return containerView
    }()
    
    private let usernameTextField: UITextField = {
        let textField = CustomTextField(placeHolder: "Username", placeholderColor: UIColor.white)
        textField.textColor = .white
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = CustomTextField(placeHolder: "Email", placeholderColor: UIColor.white)
        textField.textColor = .white
        return textField
    }()

    private let passwordTextField : UITextField = {
        let textField = CustomTextField(placeHolder: "Password", placeholderColor: UIColor.white)
        textField.textColor = .white
        //textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.layer.cornerRadius = 7
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        button.alpha = 0.8
        return button
    }()
    
    private lazy var loginPageButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "If you are a member, Login", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 14)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(goLoginPage), for: .touchUpInside)
        return button
    }()
    
    private var stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()        
    }
}

extension RegisterViewController: RegisterViewControllerInterface{
    
    func style(){
        backgroundGradientColor()
        self.navigationController?.isNavigationBarHidden = true
        
        stackView = UIStackView(arrangedSubviews: [usernameContainerView, emailContainerView, passwordContainerView, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.distribution = .fillEqually
    }
    func layout(){
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        view.addSubview(loginPageButton)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        loginPageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            loginPageButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            loginPageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loginPageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
    }
    
    @objc func handleRegisterButton(){
        guard let emailText = emailTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        guard let usernameText = usernameTextField.text else { return }
        
        if emailText.isEmpty{
            self.showHud(show: "Error" ,detailShow: "Email field cannot be empty", delay: 1)
            
        }
        else if passwordText.isEmpty{
            self.showHud(show: "Error" ,detailShow: "Password field cannot be empty", delay: 1)
            
        }
        else if usernameText.isEmpty{
            self.showHud(show: "Error" ,detailShow: "Username field cannot be empty", delay: 1)
            
        }
        else{
            if !isValidEmail(emailText.trimmingCharacters(in: .whitespacesAndNewlines)) {
                self.showHud(show: "Error" ,detailShow: "Please enter a valid email address", delay: 1)
            }
            else if !isValidPassword(passwordText){
                if passwordText.count < 8 {
                    self.showHud(show: "Error" ,detailShow: "Password must be at least 8 characters long.", delay: 1) }
                
                else if !passwordText.contains(where: { $0.isLowercase }) {
                    self.showHud(show: "Error" ,detailShow: "Password must contain at least one lowercase letter", delay: 1.5)
                        }
                else if !passwordText.contains(where: { $0.isUppercase }) {
                    self.showHud(show: "Error" ,detailShow: "Password must contain at least one uppercase letter", delay: 1.5)
                }
                
                else if !passwordText.contains(where: { $0.isNumber }) {
                    self.showHud(show: "Error" ,detailShow: "Password must contain at least one digit", delay: 1.5)                        }
                else if !passwordText.contains(where: { "!@$%*?&#_-".contains($0) }) {
                    self.showHud(show: "Error" ,detailShow: "Password must contain at least one special character (e.g., $, @, !, %, *, ?, &, #, _, -).", delay: 1.5)
                }
            }
            else{
                viewModel.register(emailText: emailText, passwordText: passwordText, usernameText: usernameText)
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#_-])[A-Za-z\\dd$@$!%*?&#_-]{8,}$"

        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    @objc func goLoginPage(){
        let controller = LoginViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showRegisterError(_ errorMessage: String) {
        self.showHud(show: "Error" ,detailShow: errorMessage, delay: 1)
    }
    
    func registerSuccess(){
        self.showHud(show: "You are being redirected to the home page",detailShow: "Please Wait", delay: 1.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let viewController = UINavigationController(rootViewController: TabBarController())
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = viewController
                window.makeKeyAndVisible()
            }
            
            }
        }
        
        
    }

