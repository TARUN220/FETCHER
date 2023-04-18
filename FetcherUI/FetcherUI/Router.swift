//
//  Router.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 22/02/23.
//

import Foundation
import FetcherBackEnd
import AppKit

class Router {

    var window: NSWindow
    
    init(window: NSWindow) {
//        print("init")
        self.window = window
    }
    
    func getEmail() -> String {
        let emailId: String = readLine()!
        let emailPattern = #"^\S+@gmail.\S+$"#
        let result = emailId.range(
            of: emailPattern,
            options: .regularExpression
        )

        if result != nil {
            return getEmailId(emailId: emailId)
//            return emailId
        }
        
        print("\tPlease enter a valid email Id..👺\n\n")
        return getEmail()
    }
    
    func getEmailId(emailId: String) -> String {
        self.window.contentView = Assembler.searchConsumerView(columnName: "emailId", columnValue: emailId, router: self)
        if Assembler.searchConsumerPresenter?.flag == true {
            print("\tThe EMail ID Already EXISTS..\n Try Again with another EMAIL ID..")
            return getEmail()
        }
        print("Its an valid EMAIL ID..")
        return emailId

    }
    
    func isValidPhoneNumber() -> String {
        print("\tPlease enter an phone Number..")
        let phoneNumber: String = readLine()!
        var isValidContact: Bool {
            let phoneNumberRegex = "^[6-9]\\d{9}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
            let isValidPhone = phoneTest.evaluate(with: phoneNumber)
            return isValidPhone
        }
        if isValidContact == true {
            return phoneNumber
        } else {
            print("\tPlease enter a valid phoneNo..👹\n\n")
            return isValidPhoneNumber()
        }
    }
    
    
    func getPassword() -> String {
        let password: String = readLine()!
        let passwordPattern =
            // At least 6 characters
            #"(?=.{6,})"# +

            // At least one capital letter
            #"(?=.*[A-Z])"# +

//            // At least one lowercase letter
            #"(?=.*[a-z])"# +
//
//            // At least one digit
            #"(?=.*\d)"# +
//
            // At least one special character
            #"(?=.*[ !$%&?#@._-])"#
        let result = password.range(
            of: passwordPattern,
            options: .regularExpression
        )

        if result != nil {
            return password
        }
        
        print("Please enter a valid password..🤡")
        return getPassword()
        
    }
    
    func addServiceProviderRole() {
        print("\tEnter the role to be added..")
        let role: String = readLine()!
        let serviceProviderRole: ServiceProviderRole = ServiceProviderRole(id: 4, role: role)
        self.window.contentView = Assembler.addServiceProviderRoleView(serviceProviderRole: serviceProviderRole, router: self)
    }
    
    func addPinCode() {
        print("Enter the pinCode to be added..")
        let pinCode: String = readLine()!
        let pinCodeInstance = PinCode(id: 0, pinCode: pinCode)
        self.window.contentView = Assembler.addPinCodeView(pinCode: pinCodeInstance, router: self)
    }
    
    func getServiceRequestList(serviceProvider: ServiceProvider) {
        self.window.contentView = Assembler.getServiceRequestListView(columnName: "serviceProviderId,serviceProviderStatus", columnValue: "\(serviceProvider.id),offline", router: self)
    }
    
    func getPinCodeList() {
        print("PIN CODE LIST:")
        self.window.contentView = Assembler.getPinCodeListView(router: self)
    }
    
    func getServiceProviderList() {
        print("SP LIST:")
        self.window.contentView = Assembler.getServiceProviderListView(router: self)
    }
    
    func searchServiceProviderRole() {
        print("\tEnter the role id, you want to search..")
        let id: Int = Int(readLine()!) ?? 0
        self.window.contentView = Assembler.searchServiceProviderRoleView(columnName: "id", columnValue: id, router: self)
        if Assembler.searchServiceProviderRolePresenter?.flag == true {
            print("Yes, the \(id) role does EXISTS..🤩")
        }
        else {
            print("No, the \(id) role does not EXISTS..🫥")
        }
    }
    
    func searchPinCode() {
        print("\tEnter the pinCode id, you want to search..")
        let id: Int = Int(readLine()!)!
        self.window.contentView = Assembler.searchPinCodeView(columnName: "id", columnValue: id, router: self)
        if Assembler.searchPinCodePresenter?.flag == true {
            print("Yes, the \(id) pinCode does EXISTS..🤩")
        }
        else {
            print("No, the \(id) pinCode does not EXISTS..🫥")
        }
    }
    
    func searchConsumer() {
        print("\tEnter the consumer id, you want to search..")
        let id: Int = Int(readLine()!)!
        self.window.contentView = Assembler.searchConsumerView(columnName: "id", columnValue: id, router: self)
        if Assembler.searchConsumerPresenter?.flag == true {
            print("Yes, the \(id) Consumer does EXISTS..🤩")
        }
        else {
            print("No, the \(id) Consumer does not EXISTS..🫥")
        }
    }
    
    func searchServiceProvider() {
        print("\tEnter the ServiceProvider id, you want to search..")
        let id: Int = Int(readLine()!)!
        self.window.contentView = Assembler.searchServiceProviderView(columnName: "id", columnValue: id, router: self)
        if Assembler.searchServiceProviderPresenter?.flag == true {
            print("Yes, the \(id) ServiceProvider does EXISTS..🤩")
        }
        else {
            print("No, the \(id) ServiceProvider does not EXISTS..🫥")
        }
    }
    
    func searchService() {
        print("Enter the service ID u wana search>?")
        let id: Int = Int(readLine()!)!
        self.window.contentView = Assembler.searchServiceView(columnName: "id", columnValue: id, router: self)
        if Assembler.searchServicePresenter?.flag == true {
            print("Yes, the service id \(id) does EXISTS..🤩")
        }
        else {
            print("No, the service id \(id) does not EXISTS..🫥")
        }
    }
    
    func consumerLogin() {
        print("\tEnter the details of the consumer to LOGIN..")
        self.window.contentView = Assembler.consumerLoginView(columnName: "emailId", emailId: "arun21@gmail.com", password: "Password#32", router: self)
        let consumer = Assembler.consumerLoginPresenter?.consumer
        if var consumerLoginsSuccess = Assembler.consumerLoginPresenter?.isLogged {
            while consumerLoginsSuccess {
                print("1. ...Book A Service..")
                print("2. ...Get SP Conformance List")
                print("3. ...Service Conformance")
                print("4. ...Fetch SP's")
                print("5. ...Change Password")
                print("6. ...Service History List")
                print("7. ...Log OUT")
                print("Enter your choice..")
                let choice = Int(readLine()!)
                switch choice {
                case 1:
                    self.bookService(consumer: consumer!)
                case 2:
                    self.getServiceProviderConformanceList(consumer: consumer!)
                case 3:
                    self.consumerServiceConformance(consumer: consumer!)
                
                case 4:
                    print("Fetch Sp's")
                    var serviceProviderListFlag = true
                    self.fetchServiceProvider(consumer: consumer!, serviceProviderListFlag: &serviceProviderListFlag)
                case 5:
                    print("Enter the password..")
                    let password = readLine()!
                    let newValue: [String: Any] = ["password": password]
                    self.window.contentView = Assembler.updateConsumerView(newValues: newValue, consumerId: consumer!.id, router: self)
                    consumer?.password = password
                case 6:
                    self.window.contentView = Assembler.searchServiceView(columnName: "consumerId,serviceStatus", columnValue: "\(consumer!.id),booked", router: self)
                case 7:
                    print("Logged OUT Successfully..")
                    consumerLoginsSuccess = false
                default:
                    print("Enter valid input")
                        
                }
            }
        }
        
    }
    
    func fetchServiceProvider(consumer: Consumer, serviceProviderListFlag: inout Bool) {
        let pinCode = consumer.pinCode?.id
        print("Enter the service u require?")
        self.window.contentView = Assembler.getServiceProviderRoleListView(router: self)
        self.searchServiceProviderRole()
        if let role = Assembler.searchServiceProviderRolePresenter?.searchServiceProviderRole.searchServiceProviderRoleResponse?.serviceProviderRole[0] {
            self.window.contentView = Assembler.searchServiceProviderView(columnName: "pincodeId,serviceProviderRoleId", columnValue: "\(pinCode!),\(role.id)", router: self)
            if Assembler.searchServiceProviderPresenter?.flag != true {
                print("NO..S")
                serviceProviderListFlag = false
                return
            }
            print("SP's does exist on ur area..")
        }
        else {
            print("Enter a valid role id..")
        }
    }
    
    func getServiceProviderConformanceList(consumer: Consumer) {
        print("Enter 1 -> Accepted services\n2 -> Declined Services\n0 -> Go Back")
        let choice: Int = Int(readLine()!) ?? 0
        if choice == 1 {
            self.window.contentView = Assembler.searchServiceView(columnName: "consumerId,serviceProviderStatus", columnValue: "\(consumer.id),accepted", router: self)
        }
        else if choice == 2 {
            self.window.contentView = Assembler.searchServiceView(columnName: "consumerId,serviceProviderStatus", columnValue: "\(consumer.id),declined", router: self)
        }
        else {
            return
        }
    }
    
    func consumerServiceConformance(consumer: Consumer) {
        self.window.contentView = Assembler.searchServiceView(columnName: "serviceProviderStatus,consumerId,consumerStatus", columnValue: "accepted,\(consumer.id),requested", router: self)
        if Assembler.searchServicePresenter?.searchService.searchServiceResponse?.service.count == nil {
            print("There are no services to acc/dec..")
            return
        }
        
        print("Enter the serviceId for the conformance for the service..")
        let id = Int(readLine()!)!
        self.window.contentView = Assembler.searchServiceView(columnName: "id,consumerId", columnValue: "\(id),\(consumer.id)", router: self)
        if Assembler.searchServicePresenter?.flag != true {
            print("The id \(id) does not exist..")
            return
        }
        
        print("Acc/Dec the service.. 1->ACC  2->DEC  0->GO BACK")
        let serviceApproval = Int(readLine()!) ?? 0
        if serviceApproval == 2 {
            let newValue = ["consumerStatus": "declined", "serviceStatus": "declined"]
            self.window.contentView = Assembler.updateServiceView(newValue: newValue, serviceId: id, router: self)
            return
        }
        else if serviceApproval == 1 {
//            print("Enter amount: ")
//            let amount: String = readLine()!
//            print("Enter timeInMinutes: ")
//            let time: String = readLine()!
//            let newValue = ["serviceProviderStatus": "accepted"]
            let newValue = ["consumerStatus": "accepted", "serviceStatus": "booked"]

            self.window.contentView = Assembler.updateServiceView(newValue: newValue, serviceId: id, router: self)
            return
        }
        else {
            return
        }
    }
    
    func serviceProviderServiceConformance(serviceProvider: ServiceProvider) {
        self.window.contentView = Assembler.searchServiceView(columnName: "consumerStatus,serviceProviderId,serviceProviderStatus", columnValue: "requested,\(serviceProvider.id),offline", router: self)
        
//        print("cOUNT", Assembler.searchServicePresenter?.searchService.searchServiceResponse?.service.count)
        if Assembler.searchServicePresenter?.searchService.searchServiceResponse?.service.count == nil {
            print("There are no services to acc/dec..")
            return
        }
        
        print("Enter the serviceId for the conformance for the service..")
        let id = Int(readLine()!)!
        self.window.contentView = Assembler.searchServiceView(columnName: "id,serviceProviderId", columnValue: "\(id),\(serviceProvider.id)", router: self)
        if Assembler.searchServicePresenter?.flag != true {
            print("The id \(id) does not exist..")
            return
        }
        
        print("Acc/Dec the service.. 1->ACC  2->DEC  0->GO BACK")
        let serviceApproval = Int(readLine()!) ?? 0
        if serviceApproval == 2 {
            let newValue = ["serviceProviderStatus": "declined"]
            self.window.contentView = Assembler.updateServiceView(newValue: newValue, serviceId: id, router: self)
            return
        }
        else if serviceApproval == 1 {
            let newValue = ["serviceProviderStatus": "accepted", "serviceApproximateTimeInMinutes": "180", "serviceApproximateAmount": "40$"]

            self.window.contentView = Assembler.updateServiceView(newValue: newValue, serviceId: id, router: self)
            return
        }
        else {
            return
        }
        
    }
    
    func serviceProviderLogin() {
        print("\tEnter the details of the SP to LOGIN..")
        print("\tChoose role..")
        self.window.contentView = Assembler.getServiceProviderRoleListView(router: self)
        self.searchServiceProviderRole()
//        print("pppp")
//        print("wvcv")
        if let role = Assembler.searchServiceProviderRolePresenter?.searchServiceProviderRole.searchServiceProviderRoleResponse?.serviceProviderRole[0] {
            print("Role: \(String(describing: role.role))")
            self.window.contentView = Assembler.serviceProviderLoginView(columnName: "emailId", emailId: "peri@gmail.com", password: "jk2@34bdf", role: role, router: self)
            let serviceProvider = Assembler.serviceProviderLoginPresenter?.serviceProvider
            var serviceProviderLoginsSuccess = Assembler.serviceProviderLoginPresenter?.isLogged ?? false
            if serviceProviderLoginsSuccess == false {
                print("Enter the correct details..")
                return
            }
            //        if var serviceProviderLoginsSuccess = Assembler.serviceProviderLoginPresenter?.isLogged {
//            print(")(")
            while serviceProviderLoginsSuccess {
                print("\n1. ..")
                print("1. Service Req List ..")
                print("2. ...Acc/Dec Services")
                print("3. ...Service History")
                print("4. ...Change Password")
                print("5. ...Log OUT")
                print("Enter ur choice..")
                let choice = Int(readLine()!)
                switch choice {
                case 1:
                    print("1.")
                    self.getServiceRequestList(serviceProvider: serviceProvider!)
                case 2:
                    print("2.")
                    self.serviceProviderServiceConformance(serviceProvider: serviceProvider!)
                case 3:
                    self.window.contentView = Assembler.searchServiceView(columnName: "serviceProviderId,serviceStatus", columnValue: "\(serviceProvider!.id),booked", router: self)
                case 4:
                    print("Enter the password..")
                    let password = readLine()!
                    let newValue: [String: Any] = ["password": password]
                    self.window.contentView = Assembler.updateServiceProviderView(newValues: newValue, serviceProviderId: serviceProvider!.id, router: self)
                    serviceProvider?.password = password
                case 5:
                    print("Logged out successfully")
                    serviceProviderLoginsSuccess = false
                default:
                    print("Enter a valid choice..")
                }
            }
            
        } else {
            print("The role id does not exists..👹")
            return
        }
    }
    
    func adminLogin() {
        self.window.contentView = Assembler.adminLoginView(columnmName: "emailId" , emailId: "admin007@gmail.com", password: "Pass#321", router: self)
        let admin = Assembler.adminLoginPresenter?.admin
        if var adminLoginSuccess = Assembler.adminLoginPresenter?.isLogged {
            while adminLoginSuccess {
                print("1. ..SP List")
                print("2. Consumer List")
                print("3. SP Role List ..")
                print("4. Pin COde List")
                print("5. Add New SP Role ..")
                print("6. Add New PinCode ..")
                print("7. Search SP Role ..")
                print("8. Search PinCode ..")
                print("9. Search Consumer ..")
                print("10. Search Service Provider..")
                print("11. Search Service ..")
                print("12. SP Role Conformance..")
                print("13. PinCode Conformance..")
                print("14. Delete a Consumer")
                print("15. Delete a SP")
                print("16. Delete a Service")
                print("17. Change Password")
                print("18. LOGOUT..")
                print("Enter ur choice..")
                let choice = Int(readLine()!)
                switch choice {
                case 1:
                     print("1. SP list")
                    self.getServiceProviderList()
                case 2:
                    print("2. Consumer List")
                    self.window.contentView = Assembler.getConsumerListView(router: self)
                case 3:
                    print("3. SP Role List..")
                    self.window.contentView = Assembler.getServiceProviderRoleListView(router: self)
                case 4:
                    print("4. PIN Code Role..")
                    self.getPinCodeList()
                case 5:
//                    print("5. Add SP")
                    self.addServiceProviderRole()
                case 6:
                    self.addPinCode()
                case 7:
                    print("4. Search SP Role..")
                    self.searchServiceProviderRole()
                case 8:
                    print("Search PinC")
                    self.searchPinCode()
                case 9:
                    print("Search Consumer")
                    self.searchConsumer()
                case 10:
                    print("Search SP")
                    self.searchServiceProvider()
                case 11:
                    print("Search Service")
                    self.searchService()
                case 12:
                    print("SP Role Conformance..")
                    self.window.contentView = Assembler.searchServiceProviderRoleView(columnName: "permission", columnValue: "requested", router: self)
                    
                    if Assembler.searchServiceProviderRolePresenter?.searchServiceProviderRole.searchServiceProviderRoleResponse?.serviceProviderRole.count == nil {
                        print("There are no serviceProviderRoles to acc/dec..")
                        return
                    }
                    
//                    print("Enter the serviceProviderRoleId for the conformance for the service..")
//                    let id = Int(readLine()!)!
                    self.window.contentView = Assembler.searchServiceProviderRoleView(columnName: "permission", columnValue: "requested", router: self)
                    if Assembler.searchServiceProviderRolePresenter?.flag != true {
                        print("The id role does not exist..")
                        return
                    }
                    let id = Assembler.searchServiceProviderRolePresenter?.searchServiceProviderRole.searchServiceProviderRoleResponse?.serviceProviderRole[0].id
                    print("Acc/Dec the serviceProviderRole.. 1->ACC  2->DEC  0->GO BACK")
                    let serviceApproval = Int(readLine()!) ?? 0
                    if serviceApproval == 2 {
                        let newValue = ["permission": "denied"]
                        self.window.contentView = Assembler.updateServiceView(newValue: newValue, serviceId: id!, router: self)
                        return
                    }
                    else if serviceApproval == 1 {
            //            print("Enter amount: ")
            //            let amount: String = readLine()!
            //            print("Enter timeInMinutes: ")
            //            let time: String = readLine()!
            //            let newValue = ["serviceProviderStatus": "accepted"]
                        let newValue = ["permission": "allowed"]

                        self.window.contentView = Assembler.updateServiceProviderRoleView(newValue: newValue, serviceProviderRoleId: id!, router: self)
                        return
                    }
                    else {
                        return
                    }
                case 13:
                    print("PIN Code Conformance..")
                    self.window.contentView = Assembler.searchPinCodeView(columnName: "permission", columnValue: "requested", router: self)
                    if Assembler.searchPinCodePresenter?.searchPinCode.searchPinCodeResponse?.pinCode.count == nil {
                        print("There are no pinCodes to conform..")
                        return
                    }
                    
//                    print("Enter the serviceProviderRoleId for the conformance for the service..")
//                    let id = Int(readLine()!)!
                    self.window.contentView = Assembler.searchPinCodeView(columnName: "permission", columnValue: "requested", router: self)
                    if Assembler.searchPinCodePresenter?.flag != true {
                        print("The id pinCode does not exist..")
                        return
                    }
                    let id = Assembler.searchPinCodePresenter?.searchPinCode.searchPinCodeResponse?.pinCode[0].id
                    print("Acc/Dec the serviceProviderRole.. 1->ACC  2->DEC  0->GO BACK")
                    let pinCodeApproval = Int(readLine()!) ?? 0
                    if pinCodeApproval == 2 {
                        let newValue = ["permission": "denied"]
                        self.window.contentView = Assembler.updatePinCodeView(newValue: newValue, pinCodeId: id!, router: self)
                        return
                    }
                    else if pinCodeApproval == 1 {
            //            print("Enter amount: ")
            //            let amount: String = readLine()!
            //            print("Enter timeInMinutes: ")
            //            let time: String = readLine()!
            //            let newValue = ["serviceProviderStatus": "accepted"]
                        let newValue = ["permission": "allowed"]

                        self.window.contentView = Assembler.updatePinCodeView(newValue: newValue, pinCodeId: id!, router: self)
                        return
                    }
                    else {
                        return
                    }
                    
                case 14:
                    self.window.contentView = Assembler.getConsumerListView(router: self)
                    print("Enter the consumer Id u wanna del..")
                    let consumerId = Int(readLine()!)
                    if consumerId == 0 {
                        continue
                    }
                    if let consumerId = consumerId {
                        self.window.contentView = Assembler.deleteConsumerView(consumerId: consumerId, router: self)
                    }
                    else {
                        print("Invalid Input...")
                    }
                case 15:
                    self.window.contentView = Assembler.getServiceProviderListView(router: self)
                    print("Enter the service Provider Id u wanna del..")
                    let serviceProviderId = Int(readLine()!)
                    if serviceProviderId == 0 {
                        continue
                    }
                    if let serviceProviderId = serviceProviderId {
                        self.window.contentView = Assembler.deleteServiceProviderView(serviceProviderId: serviceProviderId, router: self)
                    }
                    else {
                        print("Invalid Input...")
                    }
                case 16:
                    print("Del Service")
                    self.window.contentView = Assembler.getServiceRequestListView(columnName: "consumerStatus,consumerStatus,consumerStatus", columnValue: "accepted,requested,denied", router: self)
                    print("Enter a service Id which you want to delete:", "\tEnter 0 to go back")
                    let serviceId = Int(readLine()!)
                    if serviceId == 0 {
                        continue
                    }
                    if let serviceId = serviceId {
                        self.window.contentView = Assembler.deleteServiceView(columnName: "id", columnValue: serviceId, router: self)
                    }
                    else {
                        print("Invalid Input...")
                    }
                case 17:
                    print("Enter the password..")
                    let password = readLine()!
                    let newValue: [String: Any] = ["password": password]
                    self.window.contentView = Assembler.updateAdminView(newValues: newValue, adminId: admin!.id, router: self)
                    admin?.password = password
                case 18:
                    print("Logged out successfully")
                    adminLoginSuccess = false
                default:
                    print("Enter a valid choice..")
                }
            }
        }
    }
    
    func bookService(consumer: Consumer) {
        var serviceProviderListFlag = true
        self.fetchServiceProvider(consumer: consumer, serviceProviderListFlag: &serviceProviderListFlag)
        if serviceProviderListFlag == false {
            print("No SP Available .. 👹")
            return
        }
        print("Enter the SP u want..")
        let id: Int = Int(readLine()!)!
        let serviceProvider = Assembler.searchServiceProviderPresenter?.searchServiceProvider.searchServiceProviderResponse?.serviceProvider
        if serviceProvider!.count > id {
            print("Enter a valid id..")
            return
        }
        print("SP Name", serviceProvider![id - 1].name)
        let service = Service(id: 0, dateAndTime: "March08 - 1.30PM", consumer: consumer, serviceProvider: serviceProvider![id - 1], description: "Certain wires to be fixed", consumerStatus: .requested, serviceProviderStatus: .offline, serviceStatus: .offline, approximateTimeInMinutes: "", amount: "0")
        self.window.contentView = Assembler.newServiceView(service: service, router: self)
    }
    
    func newUser() {
        print("\tEnter any of the option below..")
        print("\t0 -> to go back\n\t1 -> for Consumer\n\t2 -> for Service Provider\n\n")
        let userInput = Int(readLine()!)
        if userInput == 0 {
            return
        }
        if let userInput = userInput {
            switch userInput {
            case 1:
                //New Consumer
                print("1")
                self.getPinCodeList()
                print("Not looking for the pinCOde u wanna register?")
                print("Enter 1-> to req new PinCOde, 2-> to register with the given PinCode.. 0-> GO BACK")
                let choice: Int = Int(readLine()!) ?? 0
                if choice == 1 {
                    print("Nter the pinCode, u wanna register, it will be requested to the admin..")
                    let pinCode1: String = readLine()!
                    let pinCode2 = PinCode(id: 0, pinCode: pinCode1, newPinCode: true)
                    self.window.contentView = Assembler.addPinCodeView(pinCode: pinCode2, router: self)
                    print("Your pinCode has been requested, wait for the ADMIN to verify ur pinCode..")
                    break
                }
                else if choice == 0 {
                    break
                } else if choice == 2 {
                    print("Enter id:..")
                    let id = Int(readLine()!)
                    self.window.contentView = Assembler.searchPinCodeView(columnName: "id", columnValue: id!, router: self)
                    if Assembler.searchPinCodePresenter?.flag == false {
                        print("Sorry.. The pincode does not exist")
                        break
                    }
                    let pinCode = Assembler.searchPinCodePresenter?.searchPinCode.searchPinCodeResponse?.pinCode[0].pinCode
    //                print(pinCode!)
                    let pinCodeInstance = PinCode(id: id!, pinCode: pinCode!)
                    
                    self.window.contentView = Assembler.searchPinCodeView(columnName: "id", columnValue: id!, router: self)
                    let consumer = Consumer(id: 0, name: "Arun", emailId: "arun21@gmail.com", password: "Password#32", mobileNumber: "9876547210", pinCode: pinCodeInstance)
                    self.window.contentView = Assembler.addConsumerView(consumer: consumer, router: self)
                }
            case 2:
                //New SP
                print("\tChoose role..")
                self.window.contentView = Assembler.getServiceProviderRoleListView(router: self)
                print("Not looking for the role u wanna register?")
                print("Enter 1-> to req new Role, 2-> to register with the given role.. 0-> GO BACK")
                let choice: Int = Int(readLine()!) ?? 0
                if choice == 1 {
                    print("Nter the role, u wanna register, it will be requested to the admin..")
                    let role1: String = readLine()!
                    let role2 = ServiceProviderRole(id: 0, role: role1, newRole: true)
                    self.window.contentView = Assembler.addServiceProviderRoleView(serviceProviderRole: role2, router: self)
                    print("Your role has been requested, wait for the ADMIN to verify ur role..")
                    break
                }
                else if choice == 0 {
                    break
                }
                else if choice == 2 {
                    print("Enter the role id, u wanna register with..")
                    var id = Int(readLine()!) ?? 0
                    self.window.contentView = Assembler.searchServiceProviderRoleView(columnName: "id", columnValue: id, router: self)
                    if Assembler.searchServiceProviderRolePresenter?.flag == false {
                        print("\tTHE ROLE DOES NOT EXISTS..🫥")
                        break
                    }
                    let role = Assembler.searchServiceProviderRolePresenter?.searchServiceProviderRole.searchServiceProviderRoleResponse?.serviceProviderRole[0].role
                    let serviceProviderRole = ServiceProviderRole(id: id, role: role!)
                    
                    self.getPinCodeList()
                    print("Not looking for the pinCOde u wanna register?")
                    print("Enter 1-> to req new PinCOde, 2-> to register with the given PinCode.. 0-> GO BACK")
                    let choice: Int = Int(readLine()!) ?? 0
                    if choice == 1 {
                        print("Nter the pinCode, u wanna register, it will be requested to the admin..")
                        let pinCode1: String = readLine()!
                        let pinCode2 = PinCode(id: 0, pinCode: pinCode1, newPinCode: true)
                        self.window.contentView = Assembler.addPinCodeView(pinCode: pinCode2, router: self)
                        print("Your pinCode has been requested, wait for the ADMIN to verify ur pinCode..")
                        break
                    }
                    else if choice == 0 {
                        break
                    } else if choice == 2 {
                        print("Enter the pinCode Id u wanna register with..")
                        id = Int(readLine()!) ?? 0
                        self.window.contentView = Assembler.searchPinCodeView(columnName: "id", columnValue: id, router: self)
                        if Assembler.searchPinCodePresenter?.flag == false {
                            print("Sorry.. The pincode does not exist")
                            break
                        }
                        let pinCode = Assembler.searchPinCodePresenter?.searchPinCode.searchPinCodeResponse?.pinCode[0].pinCode
        //                print(pinCode)
                        let pinCodeInstance = PinCode(id: id, pinCode: pinCode!)
                        
//                        self.window.contentView = Assembler.searchPinCodeView(columnName: "id", columnValue: id, router: self)
                        let serviceProvider = ServiceProvider(id: 0, name: "Periyasamy", emailId: "peri@gmail.com", password: "jk2@34bdf", mobileNumber: "9876543211",  pinCode: pinCodeInstance, role: serviceProviderRole, experience: "2")
                        self.window.contentView = Assembler.addServiceProviderView(serviceProvider: serviceProvider, router: self)
                    }
                }
                
                
            default:
                print("\tInvalid Input 🔴\n\n")
            }
        }
        else {
            print("\tInvalid Input..❓\n\n")
        }
    }
    
    func launch() {
        while true {
            print("----------------------------------------\n----------------------------------------\n----------------------------------------\n\tEnter any of the option below:\n")
            print("\t1. Consumer \n\t2. Service Provider \n\t3. Admin \n\t4. New User\n----------------------------------------\n----------------------------------------\n----------------------------------------\n\t")
            let userInput = Int(readLine()!)
            switch(userInput) {
            case 1:
                print("\tConsumer")
                self.consumerLogin()
            case 2:
                print("\tServoice Provoider")
                self.serviceProviderLogin()
            case 3:
                print("\tAdmin")
                self.adminLogin()
            case 4:
                print("\tNew User..")
                self.newUser()
            case 5:
                self.searchServiceProviderRole()
            default:
                print("\tPlease enter a valid choice..🔫\n\n")
            }
        }
    }
}

extension Router: AddConsumerRouterContract, SearchConsumerRouterContract, ConsumerLoginRouterContract, AdminLoginRouterContract, AddServiceProviderRoleRouterContract, ServiceProviderRoleListRouterContract, SearchServiceProviderRoleRouterContract, AddServiceProviderRouterContract, ServiceProviderLoginRouterContract, PinCodeListRouterContract, SearchPinCodeRouterContract, ServiceProviderListRouterContract, SearchServiceProviderRouterContract, NewServiceRouterContract, ServiceRequestListRouterContract, SearchServiceRouterContract, UpdateServiceRouterContract, UpdateServiceProviderRoleRouterContract, AddPinCodeRouterContract, UpdatePinCodeRouterContract, ConsumerListRouterContract, DeleteServiceRouterContract, DeleteConsumerRouterContract, DeleteServiceProviderRouterContract, UpdateAdminRouterContract, UpdateConsumerRouterContract, UpdateServiceProviderRouterContract {
    func selected() {
        print("\tProcess Completed.. ✌️\n\n")
    }
    
    
}


