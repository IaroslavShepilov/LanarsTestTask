//
//  Staff.swift
//  LanarsTestTask
//
//  Created by Yaroslav Shepilov on 01.03.2022.
//

import UIKit

enum StaffType: String {
    case managment = "Managment"
    case employee = "Employee"
    case accountant = "Accountant"
}

protocol Staff {
    var name: String { get set }
    var salary: Int { get set }
    var type: StaffType { get set}
    var uuid: UUID { get set }
}

struct Management: Staff {
    var name: String
    var salary: Int
    var receptionHours: Int
    var type: StaffType = .managment
    var uuid: UUID
    
    static func map(_ from: ManagementDB) -> Management {
        return Management(
            name: from.name ?? "",
            salary: Int(from.salary),
            receptionHours: Int(from.receptionHours),
            uuid: from.id ?? UUID()
        )
    }
}

struct Employee: Staff {
    var name: String
    var salary: Int
    var workplaceNumber: Int
    var lunchTime: Int
    var type: StaffType = .employee
    var uuid: UUID
    
    static func map(_ from: EmployeeDB) -> Employee {
        return Employee(
            name: from.name ?? "",
            salary: Int(from.salary),
            workplaceNumber: Int(from.workplaceNumber),
            lunchTime: Int(from.lunchTime),
            uuid: from.id ?? UUID()
        )
    }
}
    
struct Accountant: Staff {
    var name: String
    var salary: Int
    var workplaceNumber: Int
    var lunchTime: Int
    var accountantType: String
    var type: StaffType = .accountant
    var uuid: UUID
    
    static func map(_ from: AccountantDB) -> Accountant {
        return Accountant(
            name: from.name ?? "",
            salary: Int(from.salary),
            workplaceNumber: Int(from.workplaceNumber),
            lunchTime: Int(from.lunchTime),
            accountantType: from.accountantType ?? "",
            uuid: from.id ?? UUID()
        )
    }
}

