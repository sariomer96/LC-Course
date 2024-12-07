//
//  RegisterViewController.swift
//  Learn Connect
//
//  Created by Omer on 6.12.2024.
//

import UIKit

class RegisterViewController: BaseViewController {
    
   
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var passwordConfirmTF: UITextField!
    
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var surnameTF: UITextField!
    
    
    @IBAction func changedEmailTF(_ sender: Any) {
    }
    
    @IBAction func nameTF(_ sender: Any) {
    }
    @IBAction func passwordTF(_ sender: Any) {
    }
    @IBAction func passwordConfirmTF(_ sender: Any) {
    }
    @IBAction func surnameTF(_ sender: Any) {
    }
    let registerViewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func clickedRegister(_ sender: Any) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty,
              let confirmPassword = passwordConfirmTF.text, !confirmPassword.isEmpty,
              let name = nameTF.text, !name.isEmpty,
              let surname = surnameTF.text, !surname.isEmpty else {
            showAlert(message: "Tüm alanları doldurduğunuzdan emin olun.")
            return
        }
        // Email formatını kontrol et
        if !registerViewModel.isValidEmail(email) {
                   showAlert(message: "Geçerli bir email adresi girin.")
                   return
               }
               
        if !registerViewModel.isPasswordValid(password: password) {
            showAlert(message: "Parola en az 6 karakter olmalı.")
            return
        }
        if !registerViewModel.isPasswordCorrect(p1: password, p2: confirmPassword) {
            showAlert(message: "Parolalar uyuşmuyor.")
        }
   
        if let hashedPassword = Helper.shared.hashPassword(password: password) {
                print("Hashed Password: \(hashedPassword)")
                registerViewModel.registerUser(email: String(email), password: hashedPassword, name: name, surname: surname) { isSuccess in
                    if isSuccess {
                        showAlert(message: "Kayıt başarılı!", isSuccess: true)
                    } else {
                        showAlert(message: "Bir Hata oluştu!", isSuccess: false)
                    }
                }
        } else {
            print("hash error")
        }
     
        
   
         
    
    }
    func showAlert(message: String, isSuccess: Bool = false) {
        let alert = UIAlertController(title: isSuccess ? "Başarılı" : "Hata",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) {
            _ in
            if isSuccess {
                self.performSegue(withIdentifier:  "toLoginVc", sender: nil)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
 }
