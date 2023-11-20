//
//  StripTestFirstViewController.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 16/11/23.
//

import UIKit

class StripTestFirstViewController: UIViewController {

    @IBOutlet weak var buyTestStrip: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel()
        titleLabel.text = "Strip Test"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 30.0, weight: .bold) // Adjust font size and weight as needed
        titleLabel.sizeToFit() // Adjust the size of the label based on its content
        
        // Create a custom view to hold the title label
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleView.addSubview(titleLabel)
        
        // Set the custom view as the titleView of the navigationItem
        navigationItem.titleView = titleView
        tableView.register(UINib(nibName: "StripImagwTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "StripImagwTableViewCell")
        tableView.register(UINib(nibName: "LabelTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "LabelTableViewCell")
        tableView.separatorColor = .clear
        // Do any additional setup after loading the view.
    }
    @IBAction func buyTestStrip(_ sender: UIButton) {
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "StripTestSecondViewController") as! StripTestSecondViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension StripTestFirstViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StripImagwTableViewCell", for: indexPath) as! StripImagwTableViewCell
            cell.cellImageView.image = UIImage(named: "cloudyrainbow")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as! LabelTableViewCell
            cell.contentLabel.text = "Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view."
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 120
        case 1: return UITableView.automaticDimension
        default: return 0
        }
    }

}
