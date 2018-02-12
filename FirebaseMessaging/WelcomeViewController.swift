//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thing the user sees
//

import UIKit
import ChameleonFramework
import Firebase

class WelcomeViewController: UIViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if there is a user logged in, bypass this screen and use segue: "goToChat"
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "goToChat", sender: self)
        }
            
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
    
}
