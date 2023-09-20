//
//  FliprAIViewController.swift
//  Flipr
//
//  Created by Ajish on 13/09/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit
import GrowingTextView
import JGProgressHUD
import Alamofire

class FliprAIViewController: UIViewController {
    
    @IBOutlet weak var inputToolbar: UIView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var tNcButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!


    var intro : FliprAIList?
    var chats = [AIQustnNreply]()
    var chatTextLimit =  200
    var limitDetails:FliprAI?
    var isHaveAccept = true

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }        // *** Customize GrowingTextView ***
        textView.layer.cornerRadius = 4.0
        textView.maxLength = chatTextLimit
        textView.maxHeight = 100
        resetButton.isHidden = true
        // *** Listen to keyboard show / hide ***
       // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
        callAIinfoApi()
        /*
        let obj = AIQustnNreply()
        obj.qustion = "what is flipr ai"
        self.chats.append(obj)
      //  sentMsg(msg:"\"what is flipr ai\"")
        self.sentMsg(msg:"\" Flipr srip test \"")
        */

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = keyboardHeight + 8
            view.layoutIfNeeded()
        }
    }

    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
    
    
    @IBAction func closeButtonClicked(){
        self.dismiss(animated: true)
    }
    
    @IBAction func resetButtonClicked(){
        self.showResetAI()
    }
    
    @IBAction func tncAcceptButtonClicked(){
        self.callAcceptAI()
    }
    
    
    func showResetAI(){
        let alertController = UIAlertController(title: nil, message: "Reset conversation".localized, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
        
        let okAction = UIAlertAction(title: "Confirm".localized, style: UIAlertAction.Style.destructive)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            
            self.callResetAiApi()
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showNoCreditAlert(){
        let alertController = UIAlertController(title: nil, message: "Your trial quota has been exceeded. Please contact our sales department for further information.".localized, preferredStyle: UIAlertController.Style.alert)
        
//        let cancelAction =  UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel)
        
        let okAction = UIAlertAction(title: "Confirm".localized, style: UIAlertAction.Style.destructive)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            
//            self.callResetAiApi()
            
        }
        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func sendButtonClicked(){
        view.endEditing(true)
        if textView.text.isValidString{
            let qustn = textView.text ?? ""
            let obj = AIQustnNreply()
            obj.qustion = qustn
            self.chats.append(obj)
            self.chatTableView.reloadData()
            textView.text = ""
            sentMsg(msg:"\"\(String(describing: qustn)) \"")
//            sentMsg(msg:"\"\(String(describing: textView.text))\"")

        }else{
            
        }
    }
    
    func sentMsg(msg:String){
        resetButton.isHidden = false
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        var headers: HTTPHeaders = [
                    "Content-Type": "application/json"
                ]
        if let userToken = User.currentUser?.token {
            headers["Authorization"] = "bearer " + userToken
        }
//        if let preferredLanguage = Locale.current.languageCode {
//            headers["Accept-Language"] =  preferredLanguage
//        }
        var url = Router.baseURLString
        let severType = UserDefaults.standard.bool(forKey: K.AppConstant.CurrentServerIsDev)
        if severType == true {
            url =  Router.baseDevURLString
        }
        let apiurl = url + "fliprAI/tchat"
        Alamofire.request(apiurl, method: .put, parameters: nil, encoding: BodyStringEncoding(body: msg), headers: headers).validate(statusCode: 200..<501).responseJSON(completionHandler: { (response) in
            switch response.result {
                case .success(let value):
                    print(value)
                    if let JSON = value as? [String:Any] {
                        let reply:AIReply = AIReply(fromDictionary: JSON)
                        let obj = self.chats[self.chats.count - 1]
                        obj.message = reply.message
//                        self.chatTableView
//                        self.chats.append(reply)
                    }
                    hud?.dismiss(afterDelay: 0)
                    self.chatTableView.reloadData()
                case .failure(let error):
                    hud?.dismiss(afterDelay: 0)
                    print(" sentMsg did fail with error: \(error)")
                    
            }
        })

        
    
        
    }

    
    func callAIinfoApi(){
        
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        Alamofire.request(Router.getAIinfo).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            switch response.result {
                case .success(let value):
                    if let JSON = value as? [String:Any] {
                        let info:FliprAIList = FliprAIList(fromDictionary: JSON)
                        self.intro = info
                        self.limitDetails = info.fliprAI
                        self.chatTextLimit = self.intro?.limitCharact ?? 0
                    }
                hud?.dismiss(afterDelay: 0)
                let used = self.limitDetails?.creditUsed ?? 0
                let allowed = self.limitDetails?.creditAllowed ?? 0
                var hasAccept = self.limitDetails?.hasAccept ?? true
//                hasAccept = false
                self.isHaveAccept = hasAccept
                if hasAccept == false{
                    self.showAcceptScreen()
                    self.chatTableView.reloadData()
                }
                else{
                    self.tNcButton.isHidden = true
                    if used == allowed{
                        self.showNoCreditMessage()
                    }else{
                        self.chatTableView.reloadData()
                    }
                }
                
               
                case .failure(let error):
                    hud?.dismiss(afterDelay: 0)
                    //                self.showError(title: "Error".localized, message: "Oups, we're sorry but something went wrong :/".localized)
                    print(" GetAIinfo did fail with error: \(error)")
                    
            }
        })
                          
    }
    
    
    func showAcceptScreen(){
        self.tNcButton.isHidden = false
    }
    
    func showNoCreditMessage(){
        self.showNoCreditAlert()
    }
    
       
    func callResetAiApi(){
        resetButton.isHidden = true
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        Alamofire.request(Router.deleteAiMsg).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String:Any] {
                    let reply:AIReply = AIReply(fromDictionary: JSON)
                    //                    let obj = self.chats[self.chats.count - 1]
                    //                    obj.message = reply.message
                    //                        self.chatTableView
                    //                        self.chats.append(reply)
                }
                self.chats.removeAll()
                hud?.dismiss(afterDelay: 0)
                self.chatTableView.reloadData()
            case .failure(let error):
                hud?.dismiss(afterDelay: 0)
                //                self.showError(title: "Error".localized, message: "Oups, we're sorry but something went wrong :/".localized)
                print(" GetAIinfo did fail with error: \(error)")
            }
        })
        
    }
    
    func callAcceptAI(){
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)
        Alamofire.request(Router.acceptAI).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String:Any] {
//                    let reply:AIReply = AIReply(fromDictionary: JSON)
                    //                    let obj = self.chats[self.chats.count - 1]
                    //                    obj.message = reply.message
                    //                        self.chatTableView
                    //                        self.chats.append(reply)
                }
                hud?.dismiss(afterDelay: 0)
                self.isHaveAccept = true
                self.tNcButton.isHidden = true
                self.chatTableView.reloadData()
            case .failure(let error):
                hud?.dismiss(afterDelay: 0)
                //                self.showError(title: "Error".localized, message: "Oups, we're sorry but something went wrong :/".localized)
                print(" GetAIinfo did fail with error: \(error)")
            }
        })
        
    }
    
    
    
                 
}

extension FliprAIViewController: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}


extension FliprAIViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isHaveAccept == false{
            return 1
        }
        
        let counts = chats.count

        return counts + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHaveAccept == false{
            return 1
        }else{
            if section ==  0{
                if intro != nil{
                    return 1
                }else{
                    return 0
                }
            }else{
                return 2
               // return chats[section - 1].message == nil ? 1 : 2
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier:"ChatTableViewCell",
                                                  for: indexPath) as! ChatTableViewCell
        
        if indexPath.section ==  0{
            
            if self.isHaveAccept == false{
                cell.chatLabel.text = "AItnc".localized
                cell.chatCellBackGround.backgroundColor = UIColor.white
                cell.chatLabel.textColor = .black
                cell.removeLoader()
            }else{
                cell.chatLabel.text = self.intro?.message.content ?? ""
                cell.chatLabel.textColor = .white
                cell.chatCellBackGround.backgroundColor = UIColor(hexString: "#4BA6FF")
                if chats.count > 0{
                    cell.chatCellBackGround.backgroundColor = UIColor.white
                    cell.chatLabel.textColor = .black
                }
                cell.removeLoader()
            }
            
           
        }else{
            if indexPath.row == 0{
                cell.chatLabel.text = chats[indexPath.section - 1].qustion ?? ""
                cell.chatCellBackGround.backgroundColor = UIColor(hexString: "#4BA6FF")
                cell.chatLabel.textColor = .white
                cell.removeLoader()
            }else{
                if chats[indexPath.section - 1].message == nil{
                    cell.addLoader()
                    cell.chatLabel.text =  " \n  "
                    cell.chatCellBackGround.backgroundColor = UIColor.white

                }else{
                    cell.removeLoader()
                    cell.chatLabel.text = chats[indexPath.section - 1].message?.content ?? ""
                    cell.chatCellBackGround.backgroundColor = UIColor.white
                    cell.chatLabel.textColor = .black

                }
            }
//            if indexPath.row % 2 == 0{
//                cell.chatLabel.text = chats[indexPath.section - 1].dialog.first?.content ?? ""
//                cell.chatCellBackGround.backgroundColor = UIColor.blue
//            }else{
//                cell.chatLabel.text = chats[indexPath.section - 1].dialog[1].content ?? ""
//                cell.chatCellBackGround.backgroundColor = UIColor.lightGray
//            }
        }
        return cell
    }
    
}

//extension String: ParameterEncoding {
//
//    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
//        var request = try urlRequest.asURLRequest()
//        request.httpBody = data(using: .utf8, allowLossyConversion: false)
//        return request
//    }
//
//}


struct BodyStringEncoding: ParameterEncoding {

    private let body: String

    init(body: String) { self.body = body }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard var urlRequest = urlRequest.urlRequest else { throw Errors.emptyURLRequest }
        guard let data = body.data(using: .utf8) else { throw Errors.encodingProblem }
        urlRequest.httpBody = data
        return urlRequest
    }
}

extension BodyStringEncoding {
    enum Errors: Error {
        case emptyURLRequest
        case encodingProblem
    }
}

extension BodyStringEncoding.Errors: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .emptyURLRequest: return "Empty url request"
            case .encodingProblem: return "Encoding problem"
        }
    }
}
