//
//  LoginViewController.swift
//  MessengerApp
//
//  Created by Ilya on 11.10.2023.
//

import UIKit
import SnapKit

//вынести в файл helpers
enum TextFieldType {
    case firstName
    case lastName
    case email
    case password
}


class LoginViewController: UIViewController {
    
    // MARK: - Properties
    // это можно вынести в общие константы (новый файл)
    private lazy var textFieldHeight = self.view.frame.width * 0.1
    
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    
    
    // MARK: - UI Components
    
    private lazy var button: UIButton = {
       let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Enter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 12
        
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var stackRegisterIfNeededLabels: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        
        let notClickableLabel = UILabel()
        notClickableLabel.text = "Don't have an account?"
        notClickableLabel.textColor = .gray
        notClickableLabel.font = .systemFont(ofSize: 14, weight: .light)
        
        let clickableLabel = UILabel()
        clickableLabel.text = "Sign Up"
        clickableLabel.textColor = .gray
        clickableLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        clickableLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(signUpLabelTapped))
        clickableLabel.addGestureRecognizer(gestureRecognizer)
        
        stack.addArrangedSubview(notClickableLabel)
        stack.addArrangedSubview(clickableLabel)
        
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Private UI Methods
    
    private func showFailAlert() {
        let alert = UIAlertController(title: "Login Error", message: "Сheck the data you entered", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    
    private func createTextField(for type: TextFieldType) -> UITextField {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        textField.clearsOnBeginEditing = false
        
        switch type {
        case .email:
            textField.placeholder = "Input email..."
            textField.keyboardType = .emailAddress
        case .password:
            textField.placeholder = "Input password..."
            textField.isSecureTextEntry = true
        case .firstName, .lastName: break
        }
        
        textField.delegate = self
        return textField
    }
    
    private func setupUI() {
        setupNavBarTitle()
        
        self.emailTextField = createTextField(for: .email)
        self.passwordTextField = createTextField(for: .password)
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints() { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(self.textFieldHeight)
        }
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints() { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(self.textFieldHeight)
        }
        view.addSubview(button)
        button.snp.makeConstraints() { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        view.addSubview(stackRegisterIfNeededLabels)
        stackRegisterIfNeededLabels.snp.makeConstraints() { make in
            make.top.equalTo(button.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
    }
    
    private func setupNavBarTitle() {
        title = "Log In"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureNavBarBackItem() {
        let backImage = UIImage(named: "chevron.backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    }
    
    // MARK: - Selector Functions
    
    @objc private func loginButtonTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField?.text, let password = passwordTextField?.text,
                  !email.isEmpty, !password.isEmpty, password.count >= 6 else {
                      showFailAlert()
                      return
              }
    }
    
    @objc private func signUpLabelTapped() {
        let rvc = RegisterViewController()
        rvc.modalPresentationStyle = .fullScreen
        
        configureNavBarBackItem()
        show(rvc, sender: self)
    }
}

// MARK: - Extensions

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            loginButtonTapped()
        }
        return true
    }
}
