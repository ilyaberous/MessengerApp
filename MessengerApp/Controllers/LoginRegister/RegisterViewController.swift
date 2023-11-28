//
//  RegisterViewController.swift
//  MessengerApp
//
//  Created by Ilya on 11.10.2023.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    // это можно вынести в общие константы (новый файл)
    private lazy var textFieldHeight = self.view.frame.width * 0.1
    
    private var firstNameTextField: UITextField!
    private var lastNameTextField: UITextField!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    
    
    // MARK: - UI Components
    
    private lazy var avatarImage: UIImageView = {
       let avatar = UIImageView()
        avatar.image = UIImage(named: "addAvatar")
        avatar.contentMode = .scaleAspectFill
        avatar.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 60
        avatar.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatar.addGestureRecognizer(gesture)
        
        return avatar
    }()
    
    private lazy var button: UIButton = {
       let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Create profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 12
        
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
        return button
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
        let alert = UIAlertController(title: "Sign Up Error", message: "Сheck the data you entered", preferredStyle: .alert)
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
        case .firstName:
            textField.placeholder = "Input first name..."
        case .lastName:
            textField.placeholder = "Input last name..."
        case .email:
            textField.placeholder = "Input email..."
            textField.keyboardType = .emailAddress
        case .password:
            textField.placeholder = "Input password..."
            textField.isSecureTextEntry = true
        }
        
        textField.delegate = self
        return textField
    }
    
    private func setupUI() {
        setupNavBarTitle()
        
        view.addSubview(avatarImage)
        avatarImage.snp.makeConstraints() { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        self.firstNameTextField = createTextField(for: .firstName)
        self.lastNameTextField = createTextField(for: .lastName)
        self.emailTextField = createTextField(for: .email)
        self.passwordTextField = createTextField(for: .password)
        
        view.addSubview(firstNameTextField)
        firstNameTextField.snp.makeConstraints() { make in
            make.top.equalTo(avatarImage.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(self.textFieldHeight)
        }
        view.addSubview(lastNameTextField)
        lastNameTextField.snp.makeConstraints() { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(self.textFieldHeight)
        }
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints() { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
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
        
    }
    
    private func setupNavBarTitle() {
        title = "Sign Up"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Selector Functions
    
    @objc private func signupButtonTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        
        guard let firstName = firstNameTextField?.text, let lastName = lastNameTextField?.text,
                  let email = emailTextField?.text, let password = passwordTextField?.text,
                  !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty,
                  password.count >= 6 else {
            
                      showFailAlert()
                      return
              }
    }
    
    @objc private func avatarTapped() {
        showPhotoActionSheet()
    }
    
}

// MARK: - Extensions

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            signupButtonTapped()
        }
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Avatar",
                                            message: "How would you like to select a photo",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Choose photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.showPhotoPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Take photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.showCamera()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func showCamera() {
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.allowsEditing = true
        camera.sourceType = .camera
        present(camera, animated: true)
    }
    
    func showPhotoPicker() {
        let photoPicker = UIImagePickerController()
        photoPicker.sourceType = .photoLibrary
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        present(photoPicker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.avatarImage.image = image
    }
    
}
