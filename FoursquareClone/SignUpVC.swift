//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Atil Samancioglu on 9.08.2019.
//  Copyright © 2019 Atil Samancioglu. All rights reserved.
//

import UIKit
import Parse

// cocoapods kullanarak parse ı alıp uygulamamıza entegre edicez. parse ile firebase aynı amaçla kullanılıyor aslında. hoca firebase i chat gibi hızlı işlem yapılması gereken uygulamalar için tavsiye ediyor. onun dışında parse kullanılabilir daha kolay. 

class SignUpVC: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != "" {
            
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { (user, error) in // login işlemi başarılıysa kullanıcı oluşturucaz yoksa hata vericek
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    
                    // Segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
            }
            
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username / Password??")
        }
        
        
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != "" {
            
            let user = PFUser()
            user.username = userNameText.text! // kullanıcının adı userNameText te yazandır
            user.password = passwordText.text!
            
            user.signUpInBackground { (success, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error!!") // self yazıyoruz çünkü closure içindeyiz
                } else { // kullanıcı sign up olunca placesvc a götür
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)

                }
            }
            
        } else { // kullanıcı adı ve şifre boşsa bu hata mesajı çıkıcak
            makeAlert(titleInput: "Error", messageInput: "Username / Password??")
        }
        
        
    }
    
    func makeAlert(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

