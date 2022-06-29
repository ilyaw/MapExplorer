//
//  RegistrationView.swift
//  MapExplorer
//
//  Created by Ilya on 21.06.2022.
//

import UIKit

class RegistrationView: LoginBaseView {
    
    /// Зарегистрироваться
    private(set) var registrationButton = Button(title: Strings.Registration.buttonTitle)
    
    override func addSubviews() {
        super.addSubviews()
        stackView.addArrangedSubview(registrationButton)
        super.setConstraints()
    }
}
