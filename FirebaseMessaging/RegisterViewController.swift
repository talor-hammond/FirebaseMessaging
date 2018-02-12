// RegisterViewController.swift

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework

class RegisterViewController: UIViewController {
    
    let confirmPasswordWarning = "Passwords must match!"
    
    //Pre-linked IBOutlets
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet weak var secondPasswordTextfield: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var registrationErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting backgroundColor as a gradient:
        let colors:[UIColor] = [
            UIColor.flatPurpleColorDark(),
            UIColor.flatWhite()
        ]
        
        view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom, withFrame: view.frame, andColors: colors)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        if secondPasswordTextfield.text == passwordTextfield.text {
            
            SVProgressHUD.show()
            
            //TODO: Set up a new user on our Firebase database
            Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
                (user, error) in
                
                if error != nil {
                    print(error!)
                    SVProgressHUD.dismiss()
                    
                    self.registrationErrorLabel.alpha = 1
                    
                }
                else {
                   
                    SVProgressHUD.dismiss()
                    
                    // success...
                    print("Registration successful!")
                    
                    // segue to ChatViewController
                    self.performSegue(withIdentifier: "goToChat", sender: self)
                
                }
                
            }
            
        }
        else {
            
            print(confirmPasswordWarning)
            // TODO - make text appear with confirmPasswordWarning function
            
            warningLabel.textColor = UIColor.init(red: 255, green: 252, blue: 121, alpha: 1)
            
        }
        
    } 
    
    
    
}
