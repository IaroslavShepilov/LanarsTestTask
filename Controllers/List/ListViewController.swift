//
//  ListViewController.swift
//  LanarsTestTask
//
//  Created by Yaroslav Shepilov on 01.03.2022.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var presenter = ListPresenter()
    var isTableViewEditing: Bool = false
        
    @IBOutlet weak var listTableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.prepareDataSource()
        self.title = "List"
        self.listTableViewOutlet.delegate = self
        self.listTableViewOutlet.dataSource = self
        listTableViewOutlet.register(UINib.init(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(didTapAddButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(didTapEditButton))
    }
    
    @objc private func didTapAddButton() {
        let addVC = AddController(staff: nil)
        addVC.delegate = self
        navigationController?.pushViewController(addVC, animated: true)
    }
        
    @objc private func didTapEditButton() {
        isTableViewEditing.toggle()
        listTableViewOutlet.setEditing(isTableViewEditing, animated: true)
    }
    
     // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.groupedDataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.groupedDataSource[section].staff.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CustomTableViewCell
        let staff: Staff = presenter.groupedDataSource[indexPath.section].staff[indexPath.row]
        cell.titleLabel.text = staff.name
        cell.salaryLabel.text = "Salary: \(staff.salary) USD"
        
        switch staff.type {
        case .managment:
            guard let staff = staff as? Management else { return cell }
            cell.receptionHoursLabel.text = "Reception hours: \(staff.receptionHours)"
            cell.receptionHoursLabel.isHidden = false
        case .employee:
            guard let staff = staff as? Employee else { return cell }
            cell.lunchTimeLabel.text = "Lunch time: \(staff.lunchTime) min."
            cell.lunchTimeLabel.isHidden = false
            cell.workPlaceNumberLabel.text = "Workplace number: \(staff.workplaceNumber)"
            cell.workPlaceNumberLabel.isHidden = false
        case .accountant:
            guard let staff = staff as? Accountant else { return cell }
            cell.workPlaceNumberLabel.text = "Workplace number: \(staff.workplaceNumber)"
            cell.workPlaceNumberLabel.isHidden = false
            cell.accountantType.text = "Accountant type: " + staff.accountantType
            cell.accountantType.isHidden = false
            cell.lunchTimeLabel.text = "Lunch time: \(staff.lunchTime) min."
            cell.lunchTimeLabel.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addVC = AddController(staff: presenter.groupedDataSource[indexPath.section].staff[indexPath.row])
        addVC.delegate = self
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let staff: Staff = presenter.groupedDataSource[indexPath.section].staff[indexPath.row]
            presenter.deleteElement(staff: staff)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.groupedDataSource[section].title
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ListViewController: AddControllerDelegate {
    func sendStaff(_ staff: Staff) {
        presenter.addStaff(staff: staff)
        listTableViewOutlet.reloadData()
    }
}



