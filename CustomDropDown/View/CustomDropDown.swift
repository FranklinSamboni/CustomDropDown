//
//  CustomDropDown.swift
//  CustomDropDown
//
//  Created by Amirthy Tejeshwar on 04/10/20.
//  Copyright © 2020 Amirthy Tejeshwar. All rights reserved.
//

import UIKit

class DropDownDisplayView: UIView {
    open var title: UILabel!
    open var button: UIButton!
    init() {
        super.init(frame: .zero)
        title = UILabel()
        button = UIButton()
        self.addSubview(title)
        self.addSubview(button)
        title.addAnchors(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, right: button.leftAnchor, padding: 8, widthConstraint: nil, heightConstraint: title.heightAnchor.constraint(greaterThanOrEqualToConstant: 32))
        title.attributedText = NSAttributedString(string: "Select-hello", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        button.addAnchors(top: self.topAnchor, bottom: self.bottomAnchor, left: title.rightAnchor, right: self.rightAnchor, padding: 8, widthConstraint: button.widthAnchor.constraint(equalToConstant: 60), heightConstraint: button.heightAnchor.constraint(equalToConstant: 32))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomDropDownView<T>: UIView, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = presenter?.datasource?.tableView(tableView, cellForRowAt: indexPath) {
            return cell
        }
        return getStringLabelCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = self.presenter else {
            return
        }
        self.dropDownDisplayView.title.attributedText = NSAttributedString(string: presenter.items[indexPath.row] as? String ?? "Hello", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        presenter.delegate?.tableView(tableView, didSelectRowAt: indexPath)
    }

    func getStringLabelCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let label = UILabel()
        label.attributedText = NSAttributedString(string: presenter?.items[indexPath.row] as? String ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        cell.contentView.addSubview(label)
        cell.contentView.backgroundColor = .gray
        label.addAnchors(top: cell.contentView.topAnchor, bottom: cell.contentView.bottomAnchor, left: cell.contentView.leftAnchor, right: cell.contentView.rightAnchor, padding: 8, widthConstraint: nil, heightConstraint: label.heightAnchor.constraint(greaterThanOrEqualToConstant: 32))
        return cell
    }
    
    var dropDown: CustomDropDown<T>?
    var isOpen = true
    var presenter: CustomDropDownPresenter<T>?
    var heightConstraint = NSLayoutConstraint()
    var dropDownDisplayView: DropDownDisplayView!
    
    init(delegate: CustomDropDownPresenter<T>) {
        super.init(frame: .zero)
        self.presenter = delegate
        if let view = delegate.overrideDropDownView() as? DropDownDisplayView {
            dropDownDisplayView = view
        } else{
            setupDropDownDisplayView()
        }
        self.addSubview(dropDownDisplayView)
        dropDownDisplayView.addAnchors(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, padding: 8, widthConstraint: nil, heightConstraint: nil)
        setupDropDown()
    }
    
    func setupDropDownDisplayView() {
        dropDownDisplayView = DropDownDisplayView()
    }
    
    func setupDropDown() {
        dropDown = CustomDropDown<T>(dropDownView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //location is relative to the current view
        // do something with the touched point
        super.touchesBegan(touches, with: event)
        toggleDropDown()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let dropDown = self.dropDown else {
            return
        }
        self.superview?.addSubview(dropDown)
        self.superview?.bringSubviewToFront(dropDown)
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        dropDown.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        dropDown.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        dropDown.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 30).isActive = true
        heightConstraint = dropDown.heightAnchor.constraint(equalToConstant: 0)
    }
    
    func getDisplayView() {
        return 
    }
    
    func toggleDropDown() {
        guard let dropDown = self.dropDown else {
            return
        }
        if isOpen {
            isOpen = false
            NSLayoutConstraint.deactivate([heightConstraint])
            var height: CGFloat = 200
            if height > dropDown.tableView.contentSize.height {
                height = dropDown.tableView.contentSize.height
            }
            self.superview?.bringSubviewToFront(dropDown)
            self.heightConstraint.constant = height
            NSLayoutConstraint.activate([heightConstraint])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                dropDown.layoutIfNeeded()
                dropDown.center.y += dropDown.frame.height/2
            })
        } else {
            isOpen = true
            NSLayoutConstraint.deactivate([heightConstraint])
            heightConstraint.constant = 0
            NSLayoutConstraint.activate([heightConstraint])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                dropDown.center.y -= dropDown.frame.height/2
                dropDown.layoutIfNeeded()
            })
        }
    }
}


class CustomDropDown<T>: UIView {
    
    var tableView: UITableView = UITableView()
    
    init(dropDownView: CustomDropDownView<T>) {
        super.init(frame: .zero)
        tableView.dataSource = dropDownView
        tableView.delegate = dropDownView
        tableView.backgroundColor = .lightGray
        self.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIView {
    func addAnchors(top: NSLayoutYAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, padding: CGFloat = 5, widthConstraint: NSLayoutConstraint? = nil, heightConstraint: NSLayoutConstraint? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: padding).isActive = true
        }

        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -padding).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: padding).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -padding).isActive = true
        }
        
        if let widthConstraint = widthConstraint {
            widthConstraint.isActive = true
        }
        
        if let heightConstraint = heightConstraint {
            heightConstraint.isActive = true
        }
    }
}
