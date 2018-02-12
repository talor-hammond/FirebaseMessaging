// ChatViewController.swift

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]() // creating a blank messageArray -- appended by Database messages
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        
        retrieveMessages()
        
        messageTableView.separatorStyle = .none // gets rid of horizontal-line separating each cell
    }

    ///////////////////////////////////////////
    
    //MARK: TableView Protocols
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // creating a CustomMessageCell object with the constant "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        // accessing; dynamically changing the properties
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            
            // if the currentUser was the one who sent the message...

            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        }
        else {
            
            // if it was anyone that isn't the currentUser...
            
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            
        }
        
        return cell
        
    }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count // dynamically changing the amount of rows
        
    }
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped() {
        
        messageTextfield.endEditing(true)
        
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView() {
        
        messageTableView.rowHeight = UITableViewAutomaticDimension // automatically configures row height
        messageTableView.estimatedRowHeight = 120.0
        
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods;
    
    //TODO: Declare textFieldDidBeginEditing here:
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 300
            
            self.view.layoutIfNeeded() // if constraint is changed, redraw the whole thing...
        }
        
    }
    
    
    // what happens when you are out of the textField...
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
    }
    
    //MARK: - Send & Recieve from Firebase
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        // dismiss keyboard:
        messageTextfield.endEditing(true) // resigns the keyboard
        
        // disabling UI whilst loading:
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false

        //TODO: Send the message to Firebase and save it in database
        
        let messagesDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "Message" : messageTextfield.text!]
        
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in

            if error != nil {
                print(error!)
            }
            else {
                print("Message saved successfully")
                
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
    
        }
    }
    
    //TODO: Create method to retrieveMessages from database w reference to child "Messages":
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages") // creating a database object to draw from "Messages"
        
        messageDB.observe(.childAdded) { (snapshot) in // observes for when a 'snapshot' of data is added to the db object
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let messageText = snapshotValue["Message"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message() // creating a Message() object to access the messageBody, sender properties
            
            message.messageBody = messageText
            message.sender = sender
            
            self.messageArray.append(message) // appending the messageArray with the message object created
            self.configureTableView() // reconfiguring the tableview to accompany another message
            self.messageTableView.reloadData()
            
        }
        
    }
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            
            try Auth.auth().signOut() // try this, and if it doesn't work...
            
            // back to the WelcomeViewController:
            navigationController?.popToRootViewController(animated: true)
            
        }
        catch { // ... try this
            
            print("Error, there was a problem signing out.")
            
        }
        
    }
    


}
