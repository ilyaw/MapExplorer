//
//  LoginView.swift
//  MapExplorer
//
//  Created by Ilya on 21.06.2022.
//

import UIKit

class LoginView: LoginBaseView {
    
    /// Авторизоваться
    private(set) var loginButton = Button(title: Strings.Login.authorizeButtonTitle)
    
    /// Создать аккаунт
    private(set) var needAnAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.orange, for: .normal)
        button.setTitle(Strings.Login.createAccountButtonTitle, for: .normal)
        return button
    }()
    
    override func addSubviews() {
        super.addSubviews()
        stackView.addArrangedSubviews([loginButton, needAnAccountButton])
        super.setConstraints()
    }
}
