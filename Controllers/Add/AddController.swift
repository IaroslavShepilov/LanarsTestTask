//
//  AddController.swift
//  LanarsTestTask
//
//  Created by Yaroslav Shepilov on 08.03.2022.
//

import UIKit

protocol AddControllerDelegate {
    func sendStaff(_ staff: Staff)
}

class AddController: UIViewController {
    
    @IBOutlet var control: UISegmentedControl!
    @IBOutlet weak var accTypeControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var workPlaceNumberTextField: UITextField!
    @IBOutlet weak var lunchTimeTextField: UITextField!
    @IBOutlet weak var receptionHoursTextField: UITextField!
    @IBOutlet weak var accountantTypeTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var workPlaceNumberLabel: UILabel!
    @IBOutlet weak var lunchTimeLabel: UILabel!
    @IBOutlet weak var accountanTypeLabel: UILabel!
    @IBOutlet weak var receptionHoursLabel: UILabel!
    
    var delegate: AddControllerDelegate?
    var currentStaff: Staff?
    var textFields: [UITextField] = []
    
    init(staff: Staff?) {
        self.currentStaff = staff
        super.init(nibName: "AddController", bundle: nil)
    }
    
        required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        receptionHoursTextField.isHidden = true
        accountantTypeTextField.isHidden = true
        workPlaceNumberTextField.isHidden = true
        lunchTimeTextField.isHidden = true
        workPlaceNumberLabel.isHidden = true
        lunchTimeLabel.isHidden = true
        receptionHoursLabel.isHidden = true
        accountanTypeLabel.isHidden = true
        accTypeControl.isHidden = true
        
        control.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(didTapSaveButton))
        setupUI()
        
        textFields = [nameTextField, salaryTextField, workPlaceNumberTextField, lunchTimeTextField, receptionHoursTextField, accountantTypeTextField]
        textFields .forEach { (textElemet) in
            textElemet.delegate = self
        }
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        onChange(index: sender.selectedSegmentIndex)
    }
    
    @IBAction func accTupeDidChange(_ sender: UISegmentedControl) {
        accTypeOnChange(index: sender.selectedSegmentIndex)
    }
    
    @objc func didTapSaveButton() {
       
        var staff: Staff?
        
        if control.selectedSegmentIndex == 0 {  // Accountant
            let name: String = nameTextField.text ?? ""
            var salary = 0
            if let salaryText = salaryTextField.text, !salaryText.isEmpty {
                salary = Int(salaryText) ?? 0
            }
            var workplaceNumber = 0
            if let workplaceNumberText = workPlaceNumberTextField.text, !workplaceNumberText.isEmpty {
                workplaceNumber = Int(workplaceNumberText) ?? 0
            }
            var lunchTime = 0
            if let lunchTimeText = lunchTimeTextField.text, !lunchTimeText.isEmpty {
                lunchTime = Int(lunchTimeText) ?? 0
            }
            let accountantType : String = accountantTypeTextField.text ?? ""
            staff = Accountant(name: name, salary: salary, workplaceNumber: workplaceNumber, lunchTime: lunchTime, accountantType: accountantType, uuid: UUID())
        }
        if control.selectedSegmentIndex == 1 {  // Employee
            let name: String = nameTextField.text ?? ""
            var salary = 0
            if let salaryText = salaryTextField.text, !salaryText.isEmpty {
                salary = Int(salaryText) ?? 0
            }
            var workplaceNumber = 0
            if let workplaceNumberText = workPlaceNumberTextField.text, !workplaceNumberText.isEmpty {
                workplaceNumber = Int(workplaceNumberText) ?? 0
            }
            var lunchTime = 0
            if let lunchTimeText = lunchTimeTextField.text, !lunchTimeText.isEmpty {
                lunchTime = Int(lunchTimeText) ?? 0
            }
            staff = Employee(name: name, salary: salary, workplaceNumber: workplaceNumber, lunchTime: lunchTime, uuid: UUID())
        }
        if control.selectedSegmentIndex == 2 {  // Management
            let name: String = nameTextField.text ?? ""
            var salary = 0
            if let salaryText = salaryTextField.text, !salaryText.isEmpty {
                salary = Int(salaryText) ?? 0
            }
            var receptionHours = 0
            if let receptionHoursText = receptionHoursTextField.text, !receptionHoursText.isEmpty {
                receptionHours = Int(receptionHoursText) ?? 0
            }
            staff = Management(name: name, salary: salary, receptionHours: receptionHours, uuid: UUID())
        }
        if let uuid = currentStaff?.uuid {
            staff?.uuid = uuid
        }
        
        guard let newStaff: Staff = staff else { return }
        delegate?.sendStaff(newStaff)
        navigationController?.popViewController(animated: true)
    }
    
    func accTypeOnChange (index: Int) {
        accTypeControl.selectedSegmentIndex = index
        
        switch index {
        case 0: // payroll
            accountantTypeTextField.text = "payroll"
        case 1: // materials
            accountantTypeTextField.text = "materials"
        default:
            break
        }
    }
    
    func onChange(index: Int) {
        control.selectedSegmentIndex = index
        
        switch index {
        case 0: // Accountant
            receptionHoursTextField.isHidden = true
            accountantTypeTextField.isHidden = false
            workPlaceNumberTextField.isHidden = false
            lunchTimeTextField.isHidden = false
            
            accTypeControl.isHidden = false
                   
            workPlaceNumberLabel.isHidden = false
            lunchTimeLabel.isHidden = false
            receptionHoursLabel.isHidden = true
            accountanTypeLabel.isHidden = false
        case 1: // Employee
            accountantTypeTextField.isHidden = true
            receptionHoursTextField.isHidden = true
            workPlaceNumberTextField.isHidden = false
            lunchTimeTextField.isHidden = false
            
            accTypeControl.isHidden = true
           
            workPlaceNumberLabel.isHidden = false
            lunchTimeLabel.isHidden = false
            receptionHoursLabel.isHidden = true
            accountanTypeLabel.isHidden = true
        case 2: // Management
            receptionHoursTextField.isHidden = false
            workPlaceNumberTextField.isHidden = true
            lunchTimeTextField.isHidden = true
            accountantTypeTextField.isHidden = true
            
            accTypeControl.isHidden = true

            workPlaceNumberLabel.isHidden = true
            lunchTimeLabel.isHidden = true
            receptionHoursLabel.isHidden = false
            accountanTypeLabel.isHidden = true
        default:
            break
        }
    }
    
    func setupUI() {
        guard let staff = currentStaff else { return }
        
        switch staff.type {
        case .accountant:
            guard let staff = staff as? Accountant else { return }
            onChange(index: 0)
            nameTextField.text = staff.name
            salaryTextField.text = "\(staff.salary)"
            lunchTimeTextField.text = "\(staff.lunchTime)"
            workPlaceNumberTextField.text = "\(staff.workplaceNumber)"
            accountantTypeTextField.text = "\(staff.accountantType)"
        case .employee:
            guard let staff = staff as? Employee else { return }
            onChange(index: 1)
            nameTextField.text = staff.name
            salaryTextField.text = "\(staff.salary)"
            lunchTimeTextField.text = "\(staff.lunchTime)"
            workPlaceNumberTextField.text = "\(staff.workplaceNumber)"
        case .managment:
            guard let staff = staff as? Management else { return }
            onChange(index: 2)
            nameTextField.text = staff.name
            salaryTextField.text = "\(staff.salary)"
            receptionHoursTextField.text = "\(staff.receptionHours)"
        }
    }
}

extension AddController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFields.forEach { (textElement) in
            textElement.resignFirstResponder()
        }
        return true
    }
}

