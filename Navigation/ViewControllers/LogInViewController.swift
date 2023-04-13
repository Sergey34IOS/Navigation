//
//  LogInViewController.swift
//  Navigation
//
//  Created by My Air on 27.12.2022.
//

import UIKit

final class LogInViewController: UIViewController {
    
    
    // MARK: - Properties
    
    private let logoImage: UIImageView = {
        let logoImage = UIImageView(image: UIImage(named: "logo"))
        return logoImage
    }()
    
    private let textFieldsView = TextFieldsView()
    
    private lazy var logInButton: UIButton = {
        let logInButton = UIButton()
        logInButton.addTarget(self, action: #selector(logInAction), for: .touchUpInside)
        return logInButton
    }()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        setupElements()
        setupGesture()
        setupButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        setupGesture()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            view.frame.origin.y = -keyboardHeight
        }
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    @objc
    private func dismissKeyboarFrame() {
        view.endEditing(true)
    }
    
    @objc
    private func logInAction() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupGesture() {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
        gesture.addTarget(self, action: #selector(dismissKeyboarFrame))
    }
}

extension LogInViewController {
    
    private func setupElements() {
        view.addSubview(logoImage)
        view.addSubview(textFieldsView)
        view.addSubview(logInButton)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        textFieldsView.translatesAutoresizingMaskIntoConstraints = false
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: Padding.heightAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: Padding.heightAnchor),
            
            textFieldsView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 120),
            textFieldsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Padding.inset),
            textFieldsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Padding.inset),
            
            logInButton.topAnchor.constraint(equalTo: textFieldsView.bottomAnchor, constant: Padding.inset),
            logInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Padding.inset),
            logInButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Padding.inset),
            logInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupButton() {
        logInButton.setTitle("Log in", for: .normal)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.layer.cornerRadius = 10
        logInButton.backgroundColor = UIColor(named: "custom_blue_color")
    }
}

final class TextFieldsView: UIView {
    
    private let separatorView = UIView()
    private let emailPhoneTextField = LogInTextField(placeholderText: "Phone or email")
    private let passwordTextField = LogInTextField(placeholderText: "Password", state: .secure)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupTextFieldsView()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextFieldsView {
    
    private func setupTextFieldsView() {
        addSubview(separatorView)
        addSubview(emailPhoneTextField)
        addSubview(passwordTextField)
        
        [separatorView, emailPhoneTextField, passwordTextField].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        
        separatorView.backgroundColor = .lightGray
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Padding.heightAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.leftAnchor.constraint(equalTo: leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            
            emailPhoneTextField.widthAnchor.constraint(equalTo: widthAnchor),
            emailPhoneTextField.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            
            passwordTextField.widthAnchor.constraint(equalTo: widthAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
}

final class LogInTextField: UITextField {
    
    enum StateSecure {
        case notSecure
        case secure
        
        var isSecure: Bool {
            switch self {
            case .notSecure:
                return false
            case .secure:
                return true
            }
        }
    }
    
    private let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    init(placeholderText: String, state: StateSecure = .notSecure) {
        super.init(frame: .zero)
        setupLogInTextField()
        placeholder = placeholderText
        isSecureTextEntry = state.isSecure
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Padding methods
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension LogInTextField {
    
    private func setupLogInTextField() {
        backgroundColor = .clear
    }
}
