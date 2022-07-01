//
//  LoginViewController.swift
//  MapExplorer
//
//  Created by Ilya on 21.06.2022.
//

import UIKit
import ReactorKit

protocol LoginDelegate: AnyObject {
    func createAccount()
    func goToMainScreen()
}

/// Экран аторизации
class LoginViewController: UIViewController, View {
    
    weak var delegate: LoginDelegate?
    
    var disposeBag = DisposeBag()
    private let customView = LoginView()
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
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
        title = Strings.Login.title
        reactor = viewModel
    }
    
    /// Биндинг
    func bind(reactor: LoginViewModel) {
        var user: (String, String) { (customView.loginField.text ?? "", customView.passwordField.text ?? "")  }
        
        // Тап по кнопке "войти"
        customView.loginButton.rx.tap
            .map { Reactor.Action.login(user.0, user.1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Тап по кнопке "зарегаться"
        customView.needAnAccountButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.createAccount()
            })
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
                    self.customView.setInformation(text: Strings.Login.userInvalid)
                }
            }
            .disposed(by: disposeBag)
    }
}
