//
//  ListPresenter.swift
//  LanarsTestTask
//
//  Created by Yaroslav Shepilov on 07.03.2022.
//

import Foundation
import CoreData

final class ListPresenter {
    
    private let coreDataManager = CoreDataManager()
    private lazy var context: NSManagedObjectContext = {
        coreDataManager.getMainContext()
    }()
    
    var groupedDataSource: [StaffStructure] = []
    
    func prepareDataSource() {
        groupedDataSource.removeAll()
        let dict = Dictionary(grouping: getDataFromDB()) { element in
            element.type
        }
        var accountantStaff: StaffStructure?
        var employeeStaff: StaffStructure?
        var managmentStaff: StaffStructure?
        
        dict.forEach { (key: StaffType, value: [Staff]) in
            switch key {
            case .managment:
                let sortedStaff = value.sorted { $0.name < $1.name }
                managmentStaff = StaffStructure(title: key.rawValue, staff: sortedStaff)
            case .accountant:
                let sortedStaff = value.sorted { $0.name < $1.name }
                accountantStaff = StaffStructure(title: key.rawValue, staff: sortedStaff)
            case .employee:
                let sortedStaff = value.sorted { $0.name < $1.name }
                employeeStaff = StaffStructure(title: key.rawValue, staff: sortedStaff)
            }
        }
        if let accountant = accountantStaff {
            groupedDataSource.append(accountant)
        }
        if let employee = employeeStaff {
            groupedDataSource.append(employee)
        }
        if let managment = managmentStaff {
            groupedDataSource.append(managment)
        }
    }
    
    func deleteElement(staff: Staff) {
        delete(staff)
        prepareDataSource()
    }
    
    func addStaff(staff: Staff) {
        if let accountant = staff as? Accountant {
            let item = coreDataManager.getOrCreateEntityBy(id: accountant.uuid, nameOfClass: "AccountantDB", context: context) as! AccountantDB
            item.id = accountant.uuid
            item.name = accountant.name
            item.salary = Int64(accountant.salary)
            item.accountantType = accountant.accountantType
            item.lunchTime = Int64(accountant.lunchTime)
            item.workplaceNumber = Int64(accountant.workplaceNumber)
        }
        if let employee = staff as? Employee {
            let item = coreDataManager.getOrCreateEntityBy(id: employee.uuid, nameOfClass: "EmployeeDB", context: context) as! EmployeeDB
            item.id = employee.uuid
            item.name = employee.name
            item.salary = Int64(employee.salary)
            item.lunchTime = Int64(employee.lunchTime)
            item.workplaceNumber = Int64(employee.workplaceNumber)
        }
        if let management = staff as? Management {
            let item = coreDataManager.getOrCreateEntityBy(id: management.uuid, nameOfClass: "ManagementDB", context: context) as! ManagementDB
            item.id = management.uuid
            item.name = management.name
            item.salary = Int64(management.salary)
            item.receptionHours = Int64(management.receptionHours)
        }
        save()
    }
    
    private func delete(_ staff: Staff) {
        guard let getElement = coreDataManager.getEntityBy(id: staff.uuid, name: "StaffDB", context: context) else { return }
        context.delete(getElement)
        save()
    }
    
    private func getDataFromDB() -> [Staff] {
        var resultDataSource: [Staff] = []
        guard let result = coreDataManager.getEntities(entityName: "StaffDB", keyForSort: "id", context: context) as? [StaffDB] else { return resultDataSource }
        
        let accountantDB = result
            .compactMap { $0 as? AccountantDB }
            .map { Accountant.map($0) }
        resultDataSource.append(contentsOf: accountantDB)
        
        let employeeDB = result
            .compactMap { $0 as? EmployeeDB }
            .map { Employee.map($0) }
        resultDataSource.append(contentsOf: employeeDB)
        
        let managementDB = result
            .compactMap { $0 as? ManagementDB }
            .map { Management.map($0) }
        resultDataSource.append(contentsOf: managementDB)
        
        return resultDataSource
    }
    
    private func save() {
        coreDataManager.saveMainContext()
        prepareDataSource()
    }
}

struct StaffStructure {
    let title: String
    let staff: [Staff]
}
