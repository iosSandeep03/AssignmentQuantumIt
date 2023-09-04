//
//  ViewController.swift
//  AssignmentQuantumIt
//
//  Created by Sandeep kumar on 02/09/23.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTableView : UITableView!
    
    var modelObj = modelClass()
    var isloginGoogle = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTableView.delegate = self
        loginTableView.dataSource = self
        // GIDSignIn.sharedInstance.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func GoogleSignInTapped(_ sender: UIButton) {
      
            googleLogin{ (success: Bool, error: Error?) in
                if success {
                   
                    DispatchQueue.main.async {
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "HeadLinesViewController") as! HeadLinesViewController
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                } else if let error = error {
                    
                    print("Sign-in error: \(error.localizedDescription)")
                } else {
                   
                    print("Sign-in failed for an unknown reason.")
                }
            }
        }

        
    
    
    
    
    @IBAction func forgotBtn(_ sender: UIButton)
    {
        
    }
    @IBAction func signInBtn(_ sender: Any)
    {
        
        let headLinesVC = self.storyboard?.instantiateViewController(withIdentifier: "HeadLinesViewController") as! HeadLinesViewController
        self.navigationController?.pushViewController(headLinesVC, animated: true)
        
    }
    
    
    
    @IBAction func SignUpBtn(_ sender: UIButton)
    {
        
    }
    
    func googleLogin(completion: @escaping (Bool, Error?) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { authentication, error in
            if let error = error {
                print("There is an error signing the user in ==> \(error)")
                completion(false, error)
                return
            }
            
            guard let user = authentication?.user, let idToken = user.idToken?.tokenString else {
                completion(false, nil)
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase authentication error: \(error)")
                    completion(false, error)
                } else {
                   print("signed in")
                    let name = user.profile?.name
                    let email = user.profile?.email
                    print("User's name: \(name ?? "")")
                    print("User's email: \(email ?? "")")
                    completion(true, nil)
                }
            }
        }
    }

}

extension LoginViewController : UITableViewDelegate, UITableViewDataSource
{
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
{
    return 82
}


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    return 2
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
    if indexPath.row == 0
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loginTableViewCell") as! loginTableViewCell
        
        cell.textField.placeholder = "Email"
        
        cell.textField.tag = indexPath.row + 100
        cell.textField.delegate = self
        cell.textField.text = modelObj.email
        cell.textField.layer.borderWidth = 2
        cell.textField.placeholder = "Enter Your Email Address"
        cell.textField.layer.cornerRadius = 24
        cell.errorLbl.text = (indexPath.row == modelObj.errorIndex ? modelObj.errormessage : "")
        cell.textField.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return cell
        
    }
    
    
    else if indexPath.row == 1
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loginTableViewCell") as! loginTableViewCell
        
        cell.textField.placeholder = "Password"
        cell.textField.tag = indexPath.row + 100
        cell.textField.delegate = self
        cell.textField.isSecureTextEntry = true
        cell.textField.layer.borderWidth = 2
        cell.textField.layer.cornerRadius = 24
        cell.textField.placeholder = "Enter Your Password"
        cell.textField.text = modelObj.setPassword
        cell.errorLbl.text = (indexPath.row == modelObj.errorIndex ? modelObj.errormessage : "")
        cell.textField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return cell
    }
    return UITableViewCell()
}
}

extension LoginViewController : UITextFieldDelegate {

func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)-> Bool {
    if let text = textField.text as NSString? {
        
        let newstring = text.replacingCharacters(in: range, with: string)
        let numofchar = newstring.count
        
        switch textField.tag - 100{
            case 0:
                modelObj.email = newstring
                _ = isAllFieldForEmail()
                if let cell : loginTableViewCell = loginTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? loginTableViewCell {
                    if(modelObj.errorIndex == 0)
                    {
                        cell.errorLbl.text = modelObj.errormessage
                    }
                    else if (numofchar < 8)
                    {
                        cell.errorLbl.text = "*Please enter valid email address."
                    }
                    else {
                        cell.errorLbl.text = ""
                    }
                }
                return true
            case 1:
                modelObj.setPassword = newstring
                
                if let cell : loginTableViewCell = loginTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? loginTableViewCell
                
                {
                    if(modelObj.errorIndex == 1){
                        cell.errorLbl.text = modelObj.errormessage
                        
                    } else if (numofchar < 6)
                    {
                        cell.errorLbl.text = "*Please enter your password ."
                    }
                    
                    else if (numofchar == 15){
                        
                        return false
                    }
                    else {
                        
                        cell.errorLbl.text = ""
                    }
                }
                return true
                
            default:
                return true
        }
    }
    
    return true
}


func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.returnKeyType == .next {
        let nexttextfield = self.view.viewWithTag(textField.tag + 1) as! UITextField
        nexttextfield.becomeFirstResponder()
        
    }
    else{
        textField.resignFirstResponder()
    }
    return true
}
}

extension LoginViewController {

func isAllFieldForEmail() -> Bool {
    var isVerified = false
    
    if modelObj.email.count == 0 {
        
        modelObj.errorIndex = 0
        modelObj.errormessage = "*Please enter your email address."
    }
    else {
        isVerified = true
        modelObj.errorIndex = -1
        modelObj.errormessage = ""
        let isValid = isValidEmail(testStr: modelObj.email)
        if isValid {
            
        } else {
            isVerified = false
            
            modelObj.errorIndex = 0
            
            modelObj.errormessage = "*Please enter your correct email address."
        }
    }
    
    // self.TableView.reloadData()
    return isVerified
}
func isValidEmail(testStr:String) -> Bool {
    
    let emailRegEx = "^(((([a-zA-Z]|\\d|[!#\\$%&'\\*\\+\\-\\/=\\?\\^_`{\\|}~]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])+(\\.([a-zA-Z]|\\d|[!#\\$%&'\\*\\+\\-\\/=\\?\\^_`{\\|}~]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])+)*)|((\\x22)((((\\x20|\\x09)*(\\x0d\\x0a))?(\\x20|\\x09)+)?(([\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x7f]|\\x21|[\\x23-\\x5b]|[\\x5d-\\x7e]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])|(\\([\\x01-\\x09\\x0b\\x0c\\x0d-\\x7f]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}]))))*(((\\x20|\\x09)*(\\x0d\\x0a))?(\\x20|\\x09)+)?(\\x22)))@((([a-zA-Z]|\\d|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])|(([a-zA-Z]|\\d|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])([a-zA-Z]|\\d|-|\\.|_|~|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])*([a-zA-Z]|\\d|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])))\\.)+(([a-zA-Z]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])|(([a-zA-Z]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])([a-zA-Z]|\\d|-|_|~|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])*([a-zA-Z]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])))\\.?$"
    let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = email.evaluate(with: testStr)
    return result
}

}
extension LoginViewController {

func registration() -> Bool {
    
    var login = false
    
    if (modelObj.email.isEmpty){
        
        modelObj.errorIndex = 0
        modelObj.errormessage = "*Please enter your email address."
        self.loginTableView.scrollToRow(at : IndexPath(row: 0, section: 0), at: .top, animated: true)
        
    }
    else if (!isAllFieldForEmail())
    {
        
        modelObj.errorIndex = 0
        modelObj.errormessage = "*Please enter your correct e-mail address."
        self.loginTableView.scrollToRow(at : IndexPath(row: 0, section: 0), at: .top, animated: true)
        
    }
    
    
    else if (modelObj.setPassword.isEmpty) {
        
        modelObj.errorIndex = 1
        modelObj.errormessage = "*Please enter your password ."
        self.loginTableView.scrollToRow(at : IndexPath(row: 1, section: 0), at: .top, animated: true)
        
    }
    
    else{
        login = true
        
    }
    self.loginTableView.reloadData()
    return login
}

}


