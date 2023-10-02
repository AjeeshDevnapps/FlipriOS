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
import IQKeyboardManagerSwift

class FliprAIViewController: UIViewController {
    
    @IBOutlet weak var inputToolbar: UIView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var tNcButton: UIButton!

    //@IBOutlet weak
    var resetButton: UIButton!
    var creditInfoLbl: UILabel!
    
    var intro : FliprAIList?
    var chats = [AIQustnNreply]()
    var chatTextLimit =  200
    var limitDetails:FliprAI?
    var isHaveAccept = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomNavigation()
        hideKeyboardWhenTappedAround()
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false

        if #available(iOS 11.0, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }        // *** Customize GrowingTextView ***
        textView.layer.cornerRadius = 4.0
        textView.maxLength = chatTextLimit
        textView.maxHeight = 80
        resetButton.isHidden = true
        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

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
    
     func setCustomNavigation() {
         let button1 = UIBarButtonItem(image: UIImage(named: "AlClose"), style: .plain, target: self, action: #selector(self.closeBtnAction)) // action:#selector(Class.MethodName) for swift 3
         self.navigationItem.leftBarButtonItem  = button1
         
         let logo = UIImage(named: "AIlogoBig")
         let imageView = UIImageView(image:logo)
         self.navigationItem.titleView = imageView

         resetButton = UIButton(type: .custom)
         resetButton.setImage(UIImage(named: "AiReset"), for: .normal)
         resetButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
         resetButton.addTarget(self, action: #selector(resetBtnAction), for: .touchUpInside)
         
         creditInfoLbl = UILabel.init(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
         creditInfoLbl.textColor = .black
         creditInfoLbl.backgroundColor = .clear
         creditInfoLbl.font = UIFont.systemFont(ofSize: 12.0)
         
         let creditBarButton    = UIBarButtonItem.init(customView: creditInfoLbl)
         let resetBarButton    = UIBarButtonItem.init(customView: resetButton)

         self.creditInfoLbl.isHidden = true
         self.navigationItem.rightBarButtonItems = [resetBarButton,creditBarButton]
//         self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: resetButton)
    }
    
    
    @objc func closeBtnAction(){
        self.dismiss(animated: true)
    }
    
    
    @objc func resetBtnAction(){
        self.showResetAI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
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
        
        let used = self.limitDetails?.creditUsed ?? 0
        let allowed = self.limitDetails?.creditAllowed ?? 0

        if used == allowed{
            self.showNoCreditMessage()
        }else{
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
        
      
    }
    
    func sentMsg(msg:String){
        view.endEditing(true)
        self.inputToolbar.isHidden = true
        resetButton.isHidden = false
//        let hud = JGProgressHUD(style:.dark)
//        hud?.show(in: self.view)
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
//                UIView.transition(with: self.inputToolbar, duration: 0.4,
//                                  options: .transitionCrossDissolve,
//                                  animations: {
//                    self.inputToolbar.isHidden = false
//                              })
                    print(value)
                    if let JSON = value as? [String:Any] {
                        let reply:AIReply = AIReply(fromDictionary: JSON)
                        let obj = self.chats[self.chats.count - 1]
                        obj.message = reply.message
                        self.limitDetails = reply.fliprAI
//                        self.chatTableView
//                        self.chats.append(reply)
                    }
                    self.checkLimit()
                    self.showCreditInfo()
//                    hud?.dismiss(afterDelay: 0)
                    self.chatTableView.reloadData()
                case .failure(let error):
                    self.inputToolbar.isHidden = false
//                    hud?.dismiss(afterDelay: 0)
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
                let hasAccept = self.limitDetails?.hasAccept ?? true
               // hasAccept = false
                self.isHaveAccept = hasAccept
                if hasAccept == false{
                    self.showAcceptScreen()
                    self.chatTableView.reloadData()
//                    self.checkLimit()
                }
                else{
                    self.showCreditInfo()
                    self.tNcButton.isHidden = true
                    self.inputToolbar.isHidden = false
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
    
    func showCreditInfo(){
        let used = self.limitDetails?.creditUsed ?? 0
        let allowed = self.limitDetails?.creditAllowed ?? 0
        self.creditInfoLbl.isHidden = false
        self.creditInfoLbl.text = "\(used)/\(allowed)"

    }
    
    func showAcceptScreen(){
        self.creditInfoLbl.isHidden = false
        self.tNcButton.isHidden = false
        self.inputToolbar.isHidden = true
    }
    
    func showNoCreditMessage(){
        self.inputToolbar.isHidden = true
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
                    let reply:AIReply = AIReply(fromDictionary: JSON)
                    self.limitDetails = reply.fliprAI
                    //                    let obj = self.chats[self.chats.count - 1]
                    //                    obj.message = reply.message
                    //                        self.chatTableView
                    //                        self.chats.append(reply)
                }
                hud?.dismiss(afterDelay: 0)
                self.isHaveAccept = true
                self.tNcButton.isHidden = true
                self.inputToolbar.isHidden = false
                self.showCreditInfo()
                self.chatTableView.reloadData()
            case .failure(let error):
                hud?.dismiss(afterDelay: 0)
                //                self.showError(title: "Error".localized, message: "Oups, we're sorry but something went wrong :/".localized)
                print(" GetAIinfo did fail with error: \(error)")
            }
        })
        
    }
    
    func checkLimit(){
        let used = self.limitDetails?.creditUsed ?? 0
        let allowed = self.limitDetails?.creditAllowed ?? 0
        if used == allowed{
            self.showNoCreditMessage()
        }
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
                cell.chatLabel.text = "Terms of Use - Flipr AI\n\nFlipr AI is an artificial intelligence that will attempt to answer your questions related to swimming pools and water treatment.\n\nThis service is in trial version and is free for a limited period of time.\n\nBy using this service, you agree to Flipr's Terms of Use for the use of Flipr AI.\n\nGeneral Terms of Use - Flipr AI Response Liability\n\nThese general terms of use (hereinafter referred to as the \"Terms\") govern the use of the Flipr AI service (hereinafter referred to as \"the Service\") provided by OpenAI. By using the Service, you agree to be bound by these Terms. Please read them carefully before accessing the Service.\n\nNature of the Service\nThe Service provides conversational assistance based on advanced language models and artificial intelligence. The responses generated by Flipr AI are based on pre-collected training data and do not represent the opinions, advice, or positions of Flipr. They are generated automatically and do not necessarily reflect the reality, accuracy, or completeness of the information provided.\n\nLimitation of Liability\na. Use at Your Own Risk: You acknowledge and agree that the use of the Service is at your own risk. Flipr (CTAC Tech) cannot guarantee the accuracy, relevance, reliability, or completeness of the responses generated by Flipr AI. You should independently verify and evaluate the information obtained through the Service.\n\nb. Disclaimer of Liability: To the fullest extent permitted by applicable law, Flipr AI expressly disclaims all liability arising from the use of the Service or reliance on the responses generated by Flipr AI. Flipr AI shall not be liable for any direct, indirect, incidental, consequential, or special damages resulting from the use or inability to use the Service.\n\nc. User Content: Users of the Service are responsible for the content they submit or share when using the Service. Flipr AI does not verify or assume responsibility for user-generated content. You understand that the responses generated by Flipr AI may contain incorrect, misleading, offensive, or illegal information due to user-generated content.\n\nUser Obligations\na. Reasonable Use: You agree to use the Service in a reasonable manner and comply with applicable laws and regulations when using it. You must not use the Service abusively, fraudulently, defamatorily, harmfully, offensively, or unethically.\n\nb. Independent Validation: You acknowledge that you are solely responsible for evaluating, verifying, and using the information obtained through the Service. You should consult additional sources and seek appropriate professional advice before making decisions or taking action based on Flipr AI's responses.\n\nModifications and Interruption of the Service\nFlipr reserves the right to modify, suspend, or discontinue the Service at any time, temporarily or permanently, without notice or liability to you or any third party.\n\nIntellectual Property\nAll intellectual property rights relating to the Service and the responses generated by Flipr AI remain the exclusive property of Flipr. You may not reproduce, distribute, modify, create derivative works, publicly display, publicly perform, republish, download, store, or transmit any content from the Service without prior written permission from Flipr.\n\nGeneral Provisions\na. Severability: If any provision of these Terms is deemed invalid or unenforceable, the remaining provisions shall remain in full force and effect.\n\nb. Applicable Law: These Terms shall be governed and interpreted in accordance with the prevailing laws.\n\nc. Termination: Flipr reserves the right to terminate or restrict your access to the Service in case of a violation of these Terms.\n\nBy using the Service, you acknowledge that you have read, understood, and agreed to these Terms of Use. If you do not agree to these terms, please do not use the Service.".localized
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
                    if chats.count == indexPath.section{
                        cell.chatLabel.typingTimeInterval = 0.03
                        cell.chatLabel.startTypewritingAnimation{
                            let used = self.limitDetails?.creditUsed ?? 0
                            let allowed = self.limitDetails?.creditAllowed ?? 0
                            if used == allowed{
                                self.showNoCreditMessage()
                            }else{
                                self.inputToolbar.isHidden = false
                            }
                        }
                    }else{
                        
                    }
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
