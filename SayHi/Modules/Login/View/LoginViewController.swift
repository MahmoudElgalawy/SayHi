//
//  ViewController.swift
//  SayHi
//
//  Created by Mahmoud on 22/12/2024.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    // Labels
    @IBOutlet weak var lblRegister: UILabel!
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var lblHaveAccount: UILabel!
    
    // Text Fields
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    // Buttons Outlet
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var showConfirmPasswordBtn: UIButton!
    @IBOutlet weak var registerLoginBtn: UIButton!
    @IBOutlet weak var resendemailBtnOutlet: UIButton!
    @IBOutlet weak var forgetPasswordBtnOutlet: UIButton!
    @IBOutlet weak var loginBtnOutlet: UIButton!
    
    var isLogin = false
    var viewModel: LoginRegisterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        viewModel = LoginRegisterViewModel(userListener: UserListener.shared)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        registerLoginBtn.tintColor = UIColor(named: "Color1")
        resendemailBtnOutlet.isEnabled = false
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func resendEmailBtn(_ sender: Any) {
        resendEmail()
        startCountdownForResendButton()
    }
    
    @IBAction func forgetPasswordBtn(_ sender: Any) {
        if isDataInput(mode: "forgetPassword"){
            print("Data is input correctly")
            forgetPassword()
        }else{
            print("All field required!!")
            SVProgressHUD.showError(withStatus: "Email Is Required")
        }
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        if isDataInput(mode: isLogin ? "login":"register"){
            print("Data is input correctly")
            isLogin ? loginUser() : registerUSer()
        }else{
            print("All field required!!")
            SVProgressHUD.showError(withStatus: "All Data Are Required")
        }
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        drawRegisterView(flag: isLogin)
    }
    
    @IBAction func showPassBtn(_ sender: Any) {
        txtPassword.isSecureTextEntry.toggle()
        if txtPassword.isSecureTextEntry {
            showPasswordBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            showPasswordBtn.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
    @IBAction func showConfirmPassBtn(_ sender: Any) {
        txtConfirmPassword.isSecureTextEntry.toggle()
        if txtConfirmPassword.isSecureTextEntry {
            showConfirmPasswordBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            showConfirmPasswordBtn.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
}


// Mark:- Draw The View

extension LoginViewController:UITextFieldDelegate{
    
    private func isDataInput(mode: String) -> Bool {
        switch mode {
        case "login":
            return txtEmail.text != "" && txtPassword.text != ""
        case "register":
            return txtEmail.text != "" && txtPassword.text != "" && txtConfirmPassword.text != ""
        case "forgetPassword":
            return txtEmail.text != ""
        default:
            return false
        }
    }
    
    private func drawRegisterView(flag: Bool){
        if !flag{
            txtEmail.text = ""
            txtPassword.text = ""
            lblRegister.text = "Login"
            registerLoginBtn.setTitle("Login", for: .normal)
            txtConfirmPassword.isHidden = true
            lblConfirmPassword.isHidden = true
            showConfirmPasswordBtn.isHidden = true
            forgetPasswordBtnOutlet.isHidden = false
            resendemailBtnOutlet.isHidden = true
            lblHaveAccount.text = "Are you new here"
            loginBtnOutlet.setTitle("Register", for: .normal)
            isLogin = !isLogin
        }else{
            txtEmail.text = ""
            txtPassword.text = ""
            txtConfirmPassword.text = ""
            lblRegister.text = "Register"
            txtConfirmPassword.isHidden = false
            lblConfirmPassword.isHidden = false
            showConfirmPasswordBtn.isHidden = false
            registerLoginBtn.setTitle("Register", for: .normal)
            forgetPasswordBtnOutlet.isHidden = true
            resendemailBtnOutlet.isHidden = false
            lblHaveAccount.text = "Have an Account?"
            loginBtnOutlet.setTitle("Login", for: .normal)
            isLogin = !isLogin
        }
    }
    
    //    private func showAlert(msg: String){
    //        let alertController = UIAlertController(title: "Invalid Data", message: msg, preferredStyle: .alert)
    //        let ok = UIAlertAction(title: "Ok", style: .default)
    //        alertController.addAction(ok)
    //        self.present(alertController, animated: true, completion: nil)
    //    }
}


// Mark:- Confirm Registeration and Login

extension LoginViewController{
    private func registerUSer(){
        if txtPassword.text == txtConfirmPassword.text {
            viewModel.register(email: txtEmail.text!, password: txtPassword.text!) { error in
                if error == nil {
                    SVProgressHUD.showSuccess(withStatus: "Verfication email sent, please verify your email and confirm the registeration")
                    self.startCountdownForResendButton()
                }else{
                    SVProgressHUD.showError(withStatus: "Can not register !!                    \(error!.localizedDescription)")
                }
            }
        }else{
            SVProgressHUD.showError(withStatus: "password and confirm Password should be identical !")
        }
    }
    
    private func loginUser(){
        viewModel.login(email: txtEmail.text!, password: txtPassword.text!) { error, isEmailVerfied in
            if error == nil{
                if isEmailVerfied{
                    // Todo go to the app
                    self.gotoApp()
                    print("Go To App")
                }else{
                    SVProgressHUD.showError(withStatus: "Please check your email or password and verify your registration !")
                }
            }else{
                SVProgressHUD.showError(withStatus:" Login Failed !!                     \( error!.localizedDescription)")
            }
        }
    }
    
    private func resendEmail(){
        viewModel.resendVerficationEmail(email: txtEmail.text!) { error in
            if error == nil {
                SVProgressHUD.showSuccess(withStatus: "Verfication email sent successfully")
            }else{
                SVProgressHUD.showError(withStatus:"can not send verfication email !!                            \( error!.localizedDescription)")
            }
        }
    }
    
    private func forgetPassword(){
        viewModel.resetPasswordFor(email:  txtEmail.text!) { error in
            if error == nil{
                SVProgressHUD.showSuccess(withStatus: "Reset password email has been sent")
            }else{
                SVProgressHUD.showError(withStatus:"can not send Reset password email !!                            \( error!.localizedDescription)")
            }
        }
    }
    
    private func startCountdownForResendButton() {
        
        resendemailBtnOutlet.isEnabled = false
        var remainingSeconds = 60
        
        resendemailBtnOutlet.setTitle("Wait \(remainingSeconds)s", for: .disabled)
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if remainingSeconds > 1 {
                remainingSeconds -= 1
                self.resendemailBtnOutlet.setTitle("Wait \(remainingSeconds)s", for: .disabled)
            } else {
                timer.invalidate()
                self.resendemailBtnOutlet.isEnabled = true
                self.resendemailBtnOutlet.setTitle("Resend Email", for: .normal)
            }
        }
    }
    
    private func gotoApp(){
        let mainView = storyboard?.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true)
    }
}
