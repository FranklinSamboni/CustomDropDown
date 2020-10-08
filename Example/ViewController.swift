//
//  ViewController.swift
//  Example
//
//  Created by Amirthy Tejeshwar on 08/10/20.
//  Copyright © 2020 Amirthy Tejeshwar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let items = ["first new hey", "second name", "third name"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ccp = CustomDropDownPresenter<String>(items: items, delegate: self)
        let newView = ccp.getDropDownView()
        view.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        newView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        newView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        newView.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
}

//extension ViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        items.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        let label = UILabel()
//        label.attributedText = NSAttributedString(string: items[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
//        cell.contentView.addSubview(label)
//        cell.contentView.backgroundColor = .gray
//        label.addAnchors(top: cell.contentView.topAnchor, bottom: cell.contentView.bottomAnchor, left: cell.contentView.leftAnchor, right: cell.contentView.rightAnchor, padding: 8, widthConstraint: nil, heightConstraint: label.heightAnchor.constraint(greaterThanOrEqualToConstant: 32))
//        return cell
//    }
//}

extension ViewController: CustomDropDownDelegate, CustomDropDownDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = UIView()
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Headersection", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        cell.backgroundColor = .lightGray
        cell.addSubview(label)
        label.addAnchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, right: cell.rightAnchor, padding: 8, widthConstraint: nil, heightConstraint: label.heightAnchor.constraint(greaterThanOrEqualToConstant: 32))
        return cell
    }
    
    func overrideDropDownView() -> UIView? {
        let customView = UIView()
        let title = UILabel()
        let button = UIImageView()
        customView.addSubview(title)
        customView.addSubview(button)
        button.image = UIImage(named: "arrowtriangle.down.fill")?.withTintColor(.gray)
        title.addAnchors(top: customView.topAnchor, bottom: customView.bottomAnchor, left: customView.leftAnchor, right: button.leftAnchor, padding: 8, widthConstraint: nil, heightConstraint: title.heightAnchor.constraint(greaterThanOrEqualToConstant: 32))
        title.attributedText = NSAttributedString(string: "My Custom hello", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        button.addAnchors(top: customView.topAnchor, bottom: customView.bottomAnchor, left: nil, right: customView.rightAnchor, padding: 8, widthConstraint: button.widthAnchor.constraint(equalToConstant: 60), heightConstraint: nil)
        return customView
    }
}

