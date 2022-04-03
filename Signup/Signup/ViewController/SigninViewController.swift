//
//  SigninViewController.swift
//  Signup
//
//  Created by juntaek.oh on 2022/03/29.
//

import Foundation
import UIKit

class SigninViewController: UIViewController {
    private var idLabel: UILabel!
    private var pswLabel: UILabel!
    private var recheckPswLabel: UILabel!
    private var nameLabel: UILabel!
    
    private var idTextField: UITextField!
    private var pswTextField: UITextField!
    private var recheckPswTextField: UITextField!
    private var nameTextField: UITextField!
    
    private var validIdLabel: UILabel!
    private var validPswLabel: UILabel!
    private var validRecheckPswLabel: UILabel!
    private var validNameLabel: UILabel!
    
    private var nextButton: UIButton!
    
    private var idCheck = false
    private var pswCheck = false
    private var recheckPswCheck = false
    private var nameCheck = false
    
    let textFieldValueChecker = TextFieldValueChecker()
    let nextVC = InformationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setNavigationBar()
        setAttributes()
        addTextFieldAction()
        setTextFieldDelegate()
        setKeyboardReturnType()
        addButtonAction()
    }
    
    private func setAttributes(){
        setIdLabel()
        setIdTextField()
        setPswLabel()
        setPswTextField()
        setRecheckPswLabel()
        setRecheckPswTextField()
        setNameLabel()
        setNameTextField()
        setValidIdLabel()
        setValidPswLabel()
        setValidRecheckPswLabel()
        setValidNameLabel()
        setNextButton()
    }
    
    private func setTextFieldDelegate(){
        idTextField.delegate = self
        pswTextField.delegate = self
        recheckPswTextField.delegate = self
        nameTextField.delegate = self
    }
    
    private func setKeyboardReturnType(){
        idTextField.returnKeyType = .next
        pswTextField.returnKeyType = .next
        recheckPswTextField.returnKeyType = .next
        nameTextField.returnKeyType = .next
    }
    
    func setNavigationBar(){
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemGreen,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)
        ]
        self.title = "회원가입"
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
}


// MARK: - Use case: TextField validation check action

extension SigninViewController{
    private func addTextFieldAction(){
        idTextField.addTarget(self, action: #selector(checkIdTextFieldValidation), for: .editingChanged)
        pswTextField.addTarget(self, action: #selector(checkPswTextFieldValidation), for: .editingChanged)
        recheckPswTextField.addTarget(self, action: #selector(checkRecheckPswTextFieldValidation), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(checkNameTextFieldValidation), for: .editingChanged)
    }
    
    @objc func checkIdTextFieldValidation(){
        guard let text = idTextField.text else { return }
        
        switch textFieldValueChecker.checkValidationOfID(text: text){
        case CheckValidIDCase.invalid
            : validIdLabel.text = CheckValidIDCase.invalid.showReason()
              validIdLabel.textColor = .systemRed
              self.idCheck = false
        case .shortLength
            : validIdLabel.text = CheckValidIDCase.shortLength.showReason()
              validIdLabel.textColor = .systemRed
              self.idCheck = false
        case .longLength
            : validIdLabel.text = CheckValidIDCase.longLength.showReason()
              validIdLabel.textColor = .systemRed
              self.idCheck = false
        case .valid
            : validIdLabel.text = CheckValidIDCase.valid.showReason()
              validIdLabel.textColor = .systemGreen
              self.idCheck = true
        case .usedId
            : validIdLabel.text = CheckValidIDCase.usedId.showReason()
              validIdLabel.textColor = .systemRed
              self.idCheck = false
        }
        
        changeTextFieldLayer(check: idCheck , textField: idTextField)
        CheckNextButtonEnable()
    }
    
    @objc func checkPswTextFieldValidation(){
        guard let text = pswTextField.text else { return }
        
        switch textFieldValueChecker.checkValidationOfPsw(text: text){
        case .shortLegth:
            validPswLabel.text = CheckValidPswCase.shortLegth.showReason()
            validPswLabel.textColor = .systemRed
            self.pswCheck = false
        case .longLength:
            validPswLabel.text = CheckValidPswCase.longLength.showReason()
            validPswLabel.textColor = .systemRed
            self.pswCheck = false
        case .noUpperCase:
            validPswLabel.text = CheckValidPswCase.noUpperCase.showReason()
            validPswLabel.textColor = .systemRed
            self.pswCheck = false
        case .noNumber:
            validPswLabel.text = CheckValidPswCase.noNumber.showReason()
            validPswLabel.textColor = .systemRed
            self.pswCheck = false
        case .noSpecialChar:
            validPswLabel.text = CheckValidPswCase.noSpecialChar.showReason()
            validPswLabel.textColor = .systemRed
            self.pswCheck = false
        case .invalid:
            validPswLabel.text = CheckValidPswCase.invalid.showReason()
            validPswLabel.textColor = .systemRed
            self.pswCheck = false
        case .valid:
            validPswLabel.text = CheckValidPswCase.valid.showReason()
            validPswLabel.textColor = .systemGreen
            self.pswCheck = true
        }
        
        changeTextFieldLayer(check: pswCheck, textField: pswTextField)
        CheckNextButtonEnable()
    }
    
    @objc func checkRecheckPswTextFieldValidation(){
        guard let originText = pswTextField.text, let newText = recheckPswTextField.text else { return }
        
        switch textFieldValueChecker.checkValidationOfRecheckPsw(originText: originText, newText: newText){
        case .invalid:
            validRecheckPswLabel.text = CheckValidRecheckPswCase.invalid.showReason()
            validRecheckPswLabel.textColor = .systemRed
            self.recheckPswCheck = false
        case .valid:
            validRecheckPswLabel.text = CheckValidRecheckPswCase.valid.showReason()
            validRecheckPswLabel.textColor = .systemGreen
            self.recheckPswCheck = true
        }
        
        changeTextFieldLayer(check: recheckPswCheck, textField: recheckPswTextField)
        CheckNextButtonEnable()
    }
    
    @objc func checkNameTextFieldValidation(){
        guard let text = nameTextField.text else{ return }
        
        switch textFieldValueChecker.checkValidationOfName(text: text){
        case .invalid:
            validNameLabel.text = CheckValidNameCase.invalid.showReason()
            validNameLabel.textColor = .systemRed
            self.nameCheck = false
        case .valid:
            validNameLabel.text = CheckValidNameCase.valid.showReason()
            validNameLabel.textColor = .systemGreen
            self.nameCheck = true
        }
        
        changeTextFieldLayer(check: nameCheck, textField: nameTextField)
        CheckNextButtonEnable()
    }
    
    private func changeTextFieldLayer(check: Bool, textField: UITextField){
        if check{
            textField.layer.borderColor = UIColor.systemGreen.cgColor
        } else{
            textField.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    private func CheckNextButtonEnable(){
        guard idCheck, pswCheck, recheckPswCheck, nameCheck else{
            nextButton.layer.borderColor = UIColor.systemGray.cgColor
            nextButton.setTitleColor(.systemGray, for: .normal)
            nextButton.isEnabled = false
            return
        }
        
        nextButton.layer.borderColor = UIColor.systemGreen.cgColor
        nextButton.setTitleColor(.systemGreen, for: .normal)
        nextButton.isEnabled = true
    }
}

// MARK: - Use case: TextField delegate and dismiss keyboard

extension SigninViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === pswTextField{
            pswTextField.isSecureTextEntry = true
            return true
        } else if textField === recheckPswTextField{
            recheckPswTextField.isSecureTextEntry = true
            return true
        } else{
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField === nameTextField, idCheck, pswCheck, recheckPswCheck, nameCheck else {
            textField.resignFirstResponder()
            nameTextField.returnKeyType = .next
            return true
        }
        
        nameTextField.returnKeyType = .done
        textField.resignFirstResponder()
        self.navigationController?.pushViewController(nextVC, animated: true)
        return true
    }
    
    private func textFieldDismissKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
}

// MARK: - Use case: Next navigation with nextButton action

extension SigninViewController{
    private func addButtonAction(){
        nextButton.addTarget(self, action: #selector(pushNextNavigationVC), for: .touchUpInside)
    }
    
    @objc func pushNextNavigationVC(){
        guard idCheck, pswCheck, recheckPswCheck, nameCheck else{ return }
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - Use case: Configure attributes

extension SigninViewController{
    private func setIdLabel(){
        idLabel = UILabel(frame: CGRect(x: 40, y: (navigationController?.navigationBar.frame.maxY ?? 0) + 60, width: view.frame.width - 80, height: 30))
        idLabel.text = "아이디"
        idLabel.font = UIFont.boldSystemFont(ofSize: 15)
        idLabel.textColor = .black
        
        self.view.addSubview(idLabel)
    }
    
    private func setIdTextField(){
        idTextField = UITextField(frame: CGRect(x: 40, y: idLabel.frame.maxY, width: view.frame.width - 80, height: 30))
        idTextField.attributedPlaceholder = NSAttributedString(string: "영문 소문자, 숫자, 특수기호(_-), 5-20자", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)])
        
        textFieldCommonSetting(textField: idTextField)
        
        self.view.addSubview(idTextField)
    }
    
    private func setValidIdLabel(){
        validIdLabel = UILabel(frame: CGRect(x: 40, y: idTextField.frame.maxY, width: view.frame.width - 80, height: 30))
        validIdLabel.font = UIFont.systemFont(ofSize: 10)
        
        self.view.addSubview(validIdLabel)
    }
    
    private func setPswLabel(){
        pswLabel = UILabel(frame: CGRect(x: 40, y: idTextField.frame.maxY + 30, width: view.frame.width - 80, height: 30))
        pswLabel.text = "비밀번호"
        pswLabel.font = UIFont.boldSystemFont(ofSize: 15)
        pswLabel.textColor = .black
        
        self.view.addSubview(pswLabel)
    }
    
    private func setPswTextField(){
        pswTextField = UITextField(frame: CGRect(x: 40, y: pswLabel.frame.maxY, width: view.frame.width - 80, height: 30))
        pswTextField.attributedPlaceholder = NSAttributedString(string: "영문 대/소문자, 숫자, 특수문자(!@#$%), 8-16자", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)])
        
        textFieldCommonSetting(textField: pswTextField)
        
        self.view.addSubview(pswTextField)
    }
    
    private func setValidPswLabel(){
        validPswLabel = UILabel(frame: CGRect(x: 40, y: pswTextField.frame.maxY, width: view.frame.width - 80, height: 30))
        validPswLabel.font = UIFont.systemFont(ofSize: 10)
        
        self.view.addSubview(validPswLabel)
    }
    
    private func setRecheckPswLabel(){
        recheckPswLabel = UILabel(frame: CGRect(x: 40, y: pswTextField.frame.maxY + 30, width: view.frame.width - 80, height: 30))
        recheckPswLabel.text = "비밀번호 재확인"
        recheckPswLabel.font = UIFont.boldSystemFont(ofSize: 15)
        recheckPswLabel.textColor = .black
        
        self.view.addSubview(recheckPswLabel)
    }
    
    private func setRecheckPswTextField(){
        recheckPswTextField = UITextField(frame: CGRect(x: 40, y: recheckPswLabel.frame.maxY, width: view.frame.width - 80, height: 30))
        textFieldCommonSetting(textField: recheckPswTextField)
        
        self.view.addSubview(recheckPswTextField)
    }
    
    private func setValidRecheckPswLabel(){
        validRecheckPswLabel = UILabel(frame: CGRect(x: 40, y: recheckPswTextField.frame.maxY, width: view.frame.width - 80, height: 30))
        validRecheckPswLabel.font = UIFont.systemFont(ofSize: 10)
        
        self.view.addSubview(validRecheckPswLabel)
    }
    
    private func setNameLabel(){
        nameLabel = UILabel(frame: CGRect(x: 40, y: recheckPswTextField.frame.maxY + 30, width: view.frame.width - 80, height: 30))
        nameLabel.text = "이름"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.textColor = .black
        
        self.view.addSubview(nameLabel)
    }
    
    private func setNameTextField(){
        nameTextField = UITextField(frame: CGRect(x: 40, y: nameLabel.frame.maxY, width: view.frame.width - 80, height: 30))
        textFieldCommonSetting(textField: nameTextField)
        
        self.view.addSubview(nameTextField)
    }
    
    private func setValidNameLabel(){
        validNameLabel = UILabel(frame: CGRect(x: 40, y: nameTextField.frame.maxY, width: view.frame.width - 80, height: 30))
        validNameLabel.font = UIFont.systemFont(ofSize: 10)
        
        self.view.addSubview(validNameLabel)
    }
    
    private func setNextButton(){
        nextButton = UIButton(frame: CGRect(x: self.view.center.x - 50, y: validNameLabel.frame.maxY + 20, width: 100, height: 40))
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor.systemGray.cgColor
        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(.systemGray, for: .normal)
        nextButton.isEnabled = false
        
        self.view.addSubview(nextButton)
    }
    
    private func textFieldCommonSetting(textField: UITextField){
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = UITextField.ViewMode.always
        
        textField.layer.cornerRadius = 2
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.cgColor
    }
}

