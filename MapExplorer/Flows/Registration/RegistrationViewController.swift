//
//  RegistrationViewController.swift
//  MapExplorer
//
//  Created by Ilya on 25.06.2022.
//

import UIKit
import RxSwift
import ReactorKit

protocol RegistrationDelegate: AnyObject {
    func goToMainScreen()
}

class RegistrationViewController: UIViewController, View {

    weak var delegate: RegistrationDelegate?
    
    var disposeBag = DisposeBag()
    private let customView = RegistrationView()
    private let viewModel: RegistrationViewModel
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = viewModel
        title = Strings.Registration.title
    }
    
    /// Биндинг
    func bind(reactor: RegistrationViewModel) {
        var user: (String, String) { (customView.loginField.text ?? "", customView.passwordField.text ?? "")  }
        
        customView.configureLoginBindings()
            .bind { [weak self] inputFilled in
                self?.customView.registrationButton.isEnabled = inputFilled
            }
            .disposed(by: disposeBag)
        
        // Тап по кнопке "войти"
        customView.registrationButton.rx.tap
            .map { Reactor.Action.signup(user.0, user.1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isSuccessfully }
            .skip(1)
            .distinctUntilChanged()
            .bind { [weak self] isSuccessfully in
                guard let self = self else { return }
                if isSuccessfully {
                    self.delegate?.goToMainScreen()
                } else {
                    self.customView.setInformation(text: Strings.Registration.registrationError)
                }
            }
            .disposed(by: disposeBag)
    }
}
