// LogInViewController.swift

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet weak var secondPasswordTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var userDoesNotExistLabel: UILabel!
    
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

   
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        //TODO: Log in the user
        if secondPasswordTextField.text == passwordTextfield.text {
            
            SVProgressHUD.show()
            
            // log user in...
            Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: { (user, error) in
                
                if error != nil {
                    print(error!)
                    SVProgressHUD.dismiss()
                    self.userDoesNotExistLabel.alpha = 1
                    
                }
                else {
                    print("Login successful!")
                    
                    SVProgressHUD.dismiss()
                    
                    self.performSegue(withIdentifier: "goToChat", sender: self)
                }
            })
        }
        else {
            warningLabel.textColor = UIColor.init(red: 255, green: 252, blue: 121, alpha: 1)
        }
        
    }
    


    
}  
