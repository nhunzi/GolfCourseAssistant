//
// ViewController.swift
// iOS UIKit Login
// 3 June 2022
//
// Companion project for the Auth0 blog article
// “Get Started with iOS Authentication Using Swift and UIKit”.
//
// See the end of the file for licensing information.
//


import UIKit
import Auth0
import AWSSigner



var courseMeta: CourseMeta?
var MyUserid: String = ""
var MyEmail: String = ""
class ViewController: UIViewController, UITextFieldDelegate {
    
 var db: OpaquePointer?
    var playbtn: Int = 0 ;
    //var newbtn: Int = 10;
  
  // On-screen controls
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var logoutButton: UIButton!
  @IBOutlet weak var userInfoStack: UIStackView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userEmailLabel: UILabel!
  @IBOutlet weak var userPicture: UIImageView!
  
    @IBOutlet weak var SegueLabel1: UIButton!
    

    @IBOutlet weak var flagImage: UIImageView!
    var CourseName: String = ""
    
    
    // App and user status
    private var appJustLaunched = true
      private var userIsAuthenticated = false
  
  // Auth0 data
    private var user = User.empty
  
    
    @IBAction func PressPlay(_ sender: UIButton) {
        playbtn = 5;
    }
    
    
    @IBAction func FirstTimeUser(_ sender: UIButton) {
        
        playbtn = 10;
    }
    
    
}


extension ViewController {
  
  // MARK: View events
  // =================

  override func viewDidLoad() {
    super.viewDidLoad()
     
         updateTitle()
         userInfoStack.isHidden = true
         loginButton.isEnabled = true
         logoutButton.isEnabled = false
      
      
    
      
      // -------------------------------  START Fetching meta data -------------------------------
      let credentials = StaticCredential(accessKeyId: "AKIAY4WGH3URC5UYE24U", secretAccessKey: "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")
      let signer = AWSSigner(credentials: credentials, name: "execute-api", region: "us-east-1")
      var signedURL = signer.signURL(
          url: URL(string:"https://api.golfbert.com/v1/courses/13607")!,
          method: .GET)
      
      var request = URLRequest(url: signedURL, timeoutInterval: Double.infinity)
      request.addValue("xZsYxHwK7L9eiYeSzhBzf8svKqjOwwrUauEOKOKH", forHTTPHeaderField: "x-api-key")
      
      request.httpMethod = "GET"
      
      var task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
              print(String(describing: error))
              return
          }
          //rint(String(data: data, encoding: .utf8)!)
          let courseMetaResponse = try? JSONDecoder().decode(CourseMeta.self, from: data)
          courseMeta = courseMetaResponse
          print("!!!!!!!!!!!! course name: \((courseMeta?.name)!)")
          self.CourseName = ("\((courseMeta?.name)!)")
      }
      task.resume()
  }
  
  
  // MARK: Actions
  // =============

  @IBAction func loginButtonPressed(_ sender: UIButton) {
      if !userIsAuthenticated {
            login()
          }
  }
  
  @IBAction func logoutButtonPressed(_ sender: UIButton) {
      if userIsAuthenticated {
          logout()
        }
  }
  
  
  // MARK: UI updaters
  // =================

  func updateTitle() {
      if appJustLaunched {
            titleLabel.text = "Welcome!"
         // loginButton.backgroundColor = UIColor.red
            appJustLaunched = false
          logoutButton.isHidden = true
          } else {
            if userIsAuthenticated {
              titleLabel.text = "You’re logged in."
                logoutButton.isHidden = false
                loginButton.isHidden = true
            } else {
              titleLabel.text = "You’re logged out."
                loginButton.isHidden = false
                
            }
          }
  }

  func updateButtonsAndStack() {
      loginButton.isEnabled = !userIsAuthenticated
         logoutButton.isEnabled = userIsAuthenticated
         userInfoStack.isHidden = !userIsAuthenticated
  }
  
  func updateUserInfoUI() {
      userNameLabel.text = user.name
         userEmailLabel.text = user.email
         userPicture.load(url: URL(string: user.picture)!)
      MyUserid = user.id
        MyEmail = user.email
      print("!!!!!!!!!!!! USERID: \((MyUserid))")
      print("!!!!!!!!!!!! USEREMAIL: \((MyEmail))")
      
  }
    
    
  
  
  // MARK: Login, logout, and user information
  // =========================================

  func login() {
      Auth0
            .webAuth()
            .start { result in
         
              switch result {
                        
                case .failure(let error):
                  // The user either pressed the “Cancel” button
                  // on the Universal Login screen or something
                  // unusual happened.
                  if error == .userCancelled {
                                let alert = UIAlertController(
                                  title: "Please log in.",
                                  message: "You need to log in to use the app.",
                                  preferredStyle: .alert)
                                alert.addAction(
                                  UIAlertAction(
                                    title: NSLocalizedString(
                                      "OK",
                                      comment: "Default action"
                                    ),
                                    style: .default,
                                    handler: { _ in
                                      NSLog("Displayed the \"Please log in\" alert.")
                                }))
                                self.present(alert, animated: true, completion: nil)
                              
                              } else {
                                print("An unexpected error occurred: \(error.localizedDescription)")
                              }
                  
                case .success(let credentials):
                  // The user successfully logged in.
                  self.userIsAuthenticated = true
                  self.user = User.from(credentials.idToken)
                  self.SegueLabel1.isHidden = false //MyCode
                  self.userEmailLabel.isHidden = true//MyCode
                  self.userNameLabel.isHidden = true//MyCode
                  self.flagImage.isHidden = false //MyCode
                  //self.SegueLabel1.titleLabel?.font = UIFont.systemFont(ofSize: 42, weight: .bold)
                   
                  
                  
                                          
                              DispatchQueue.main.async {
                                self.updateTitle()
                                self.updateButtonsAndStack()
                                self.updateUserInfoUI()
                                
                              }
                  
                  
              } // switch
                
                
            } // start()
     
  }
    
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue)
    {
        
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
       if (playbtn == 5)
        {
           let destController = segue.destination as! SearchViewController
           destController.receiverStr = self.userNameLabel.text ?? ""
           destController.nameString = self.CourseName
           
       }
        else if (playbtn == 10)
        {
            let destController = segue.destination as! UserNameViewController
            //destController.receiverStr = self.userNameLabel.text ?? ""
            //destController.nameString = self.CourseName
    
        }
            
       
    }
    
   
    
  func logout() {
      Auth0
           .webAuth()
           .clearSession { result in
             switch result {

               case .failure(let error):
                 print("Failed with: \(error)")
               
               case .success():
                 self.userIsAuthenticated = false
                 self.user = User.empty
                 self.SegueLabel1.isHidden = true

                 DispatchQueue.main.async {
                   self.updateTitle()
                   self.updateButtonsAndStack()
                 }
               
             } // switch
                 
         } // clearSession()
  }
  
}


// MARK: Utilities
// ===============

func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
  guard
    let path = bundle.path(forResource: "Auth0", ofType: "plist"),
    let values = NSDictionary(contentsOfFile: path) as? [String: Any]
    else {
      print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
      return nil
    }

  guard
    let clientId = values["ClientId"] as? String,
    let domain = values["Domain"] as? String
    else {
      print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
      print("File currently has the following entries: \(values)")
      return nil
    }
  
  return (clientId: clientId, domain: domain)
}


//
// License information
// ===================
//
// Copyright (c) 2022 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
