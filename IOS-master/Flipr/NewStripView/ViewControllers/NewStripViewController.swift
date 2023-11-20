//
//  ViewController.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 11/11/23.
//

import UIKit

class NewStripViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var colors: [Color]?
    var numberOfRows = 7
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .systemGray5
        tableView.backgroundColor = .clear
        colors = loadColorsFromJSONFile()
        tableView.register(UINib(nibName: "LabelTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "LabelTableViewCell")
        tableView.separatorColor = .clear
        let titleLabel = UILabel()
        titleLabel.text = numberOfRows == 7 ? "Strip7" : "Strip6"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 30.0, weight: .bold) // Adjust font size and weight as needed
        titleLabel.sizeToFit() // Adjust the size of the label based on its content
        
        // Create a custom view to hold the title label
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleView.addSubview(titleLabel)
        
        // Set the custom view as the titleView of the navigationItem
        navigationItem.titleView = titleView

    }

    func loadColorsFromJSONFile() -> [Color]? {
        // Get the path to the JSON file
        guard let path = Bundle.main.path(forResource: "Colors", ofType: "json") else {
            print("Unable to find Colors.json")
            return nil
        }

        // Read the content of the file
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            
            // Decode JSON data into an array of Color objects
            let decoder = JSONDecoder()
            let colorBase = try decoder.decode(ColorBase.self, from: data)
            
            return colorBase.colors
        } catch {
            print("Error loading JSON data: \(error)")
            return nil
        }
    }
}

extension NewStripViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell") as! LabelTableViewCell
            cell.contentLabel.text = "Take the provided strips without touching the colored tabs, then immerse it in your pool water halfway up your arm for 2 seconds. Then record the colors obtained, line by line"
            cell.contentImage.image = UIImage(named: "handIcon")
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell") as! LabelTableViewCell
            cell.contentLabel.text = "Set screen brightness to maximum"
            cell.contentImage.image = UIImage(named: "sun")

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StripTableViewCell") as! StripTableViewCell
            cell.backgroundColor = .clear
            cell.stripView.delegate = self
            cell.stripView.numberOfRows = numberOfRows
            if let colors = colors {
                cell.stripView.allColors = colors
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return UITableView.automaticDimension
        case 1: return UITableView.automaticDimension
        case 2: return 450
        default: return 0
        }
    }
}

extension NewStripViewController: StripsViewDelegate {
    func selectedStripColors(stripView: StripsView, colors: [Color]) {
        print(colors)
    }
}
