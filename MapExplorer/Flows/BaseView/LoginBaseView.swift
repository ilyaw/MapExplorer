//
//  LoginBaseView.swift
//  MapExplorer
//
//  Created by Ilya on 21.06.2022.
//

import Foundation
import UIKit
import RxSwift

extension LoginBaseView {
    struct Appearance {
        let stackViewInset: CGFloat = 10
        let stackViewSpacing: CGFloat = 15
    }
}

/// Базовая вью для экрана авторизации и регистрацими
class LoginBaseView: UIView {
    /// Стили
    let appearance = Appearance()
    
    /// Поле для ввода логина
    private(set) var loginField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = Strings.Login.inputLogin
        field.autocorrectionType = .no
        return field
    }()
    
    /// Поле для ввода пароля
    private(set) var passwordField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = Strings.Login.inputPassword
        field.isSecureTextEntry = true
        field.autocorrectionType = .no
        return field
    }()
    
    /// Для вывода информации об авторизации/регистрации
    private(set) var informationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
        
    /// Стек для всех view-элементов
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = appearance.stackViewSpacing
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubviews([informationLabel,
                                       loginField,
                                       passwordField])
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(appearance.stackViewInset)
        }
    }
    
    func setInformation(text: String, color: UIColor = .red) {
        informationLabel.isHidden = false
        informationLabel.textColor = color
        informationLabel.text = text
    }
    
    func configureLoginBindings() -> Observable<Bool> {
        return Observable
            .combineLatest(loginField.rx.text, passwordField.rx.text)
            .map { (login, password) -> Bool in
                guard let login = login, let password = password else { return false }
                return !(login.isEmpty || password.isEmpty)
            }
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubviews()
    }
}
