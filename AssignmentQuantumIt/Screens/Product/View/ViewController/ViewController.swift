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
                        if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "HeadLinesViewController") as? HeadLinesViewController {
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
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
        
        if self.registration(){
            
            if let headLinesVC = self.storyboard?.instantiateViewController(withIdentifier: "HeadLinesViewController") as? HeadLinesViewController{
                self.navigationController?.pushViewController(headLinesVC, animated: true)
                
            }
        }
        
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
        

        
        cell.textField.tag = indexPath.row + 100
        cell.textField.delegate = self
        cell.textField.text = modelObj.phonenumber
        cell.textField.layer.borderWidth = 2
        
        cell.textField.layer.cornerRadius = 24
        cell.errorLbl.text = (indexPath.row == modelObj.errorIndex ? modelObj.errormessage : "")
        cell.textField.attributedPlaceholder = NSAttributedString(string:"Enter Your Phone Number", attributes:[NSAttributedString.Key.foregroundColor: UIColor.black])
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: cell.textField.frame.size.height))
        cell.textField.leftView = paddingView
        cell.textField.leftViewMode = .always
        
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
        cell.textField.attributedPlaceholder = NSAttributedString(string:"Enter Your Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.black])
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: cell.textField.frame.size.height))
        cell.textField.leftView = paddingView
        cell.textField.leftViewMode = .always
        
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
            modelObj.phonenumber = newstring
            _ = isAllFieldForPhone()
            if let cell : loginTableViewCell = loginTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? loginTableViewCell {
                
                if(modelObj.errorIndex == 0){
                    
                    cell.errorLbl.text = modelObj.errormessage
                    
                }
                else if (numofchar < 8) {
                    
                    cell.errorLbl.text = "*Please enter correct phone number."
                }
                
                else if (!isAllFieldForPhone()) {
                    cell.errorLbl.text = "*Please enter correct phone number."
                    
                }
                else if (numofchar == 11){
                    
                    return false
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
    
    func isAllFieldForPhone() -> Bool {
        var isVerified = false
        
        
        if modelObj.phonenumber.count == 0 {
            modelObj.errorIndex = 0
            modelObj.errormessage = "*Please enter phone number."
        }
        else if modelObj.phonenumber.count < 8 {
            modelObj.errorIndex = 0
            modelObj.errormessage = "*Please enter your correct phone number."
        }
        else {
            isVerified = true
            modelObj.errorIndex = -1
            modelObj.errormessage = ""
            let isValid = isContainsAllZeros(testStr: modelObj.phonenumber)
            if !isValid {
                // correct mail
            } else {
                isVerified = false
                modelObj.errorIndex = 0
                modelObj.errormessage = "*Please enter your correct mobile number."
            }
            
        }
        // self.TableView.reloadData()
        return isVerified
    }
    func isContainsAllZeros(testStr: String) -> Bool {
        
        
        let mobileNoRegEx = "^0{2,15}$"
        
        let mobileNoTest = NSPredicate(format: "SELF MATCHES %@", mobileNoRegEx)
        
        return mobileNoTest.evaluate(with: testStr)
        
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

func registration() -> Bool {
    
    var login = false
    
    if (!isAllFieldForPhone())
    {
        
        modelObj.errorIndex = 0
        modelObj.errormessage = "*Please enter your correct phone number."
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


