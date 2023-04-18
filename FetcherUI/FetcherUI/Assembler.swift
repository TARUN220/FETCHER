//
//  Assembler.swift
//  FetcherUI
//
//  Created by tarun-pt6229 on 22/02/23.
//

import Foundation
import FetcherBackEnd

class Assembler {
    static var searchConsumerPresenter: SearchConsumerPresenter?
    static var searchServiceProviderPresenter: SearchServiceProviderPresenter?
    static var consumerLoginPresenter: ConsumerLoginPresenter?
    static var adminLoginPresenter: AdminLoginPresenter?
    static var serviceProviderLoginPresenter: ServiceProviderLoginPresenter? 
    static var addServiceProviderRolePresenter: AddServiceProviderRolePresenter?
    static var addPinCodePresenter: AddPinCodePresenter?
    static var searchServiceProviderRolePresenter: SearchServiceProviderRolePresenter?
    static var searchServicePresenter: SearchServicePresenter?
    static var searchPinCodePresenter: SearchPinCodePresenter?

    
    static func addConsumerView(consumer: Consumer, router: AddConsumerRouterContract?) -> AddConsumerView {

        let database = AddConsumerDatabaseService()
        let dataManager = AddConsumerDataManager(database: database)
        let usecase = AddConsumer(dataManager: dataManager)
        let presenter = AddConsumerPresenter(addConsumer: usecase)
        presenter.router = router
        let view = AddConsumerView(consumer: consumer, presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func newServiceView(service: Service, router: NewServiceRouterContract) -> NewServiceView {
        let database = NewServiceDatabaseService()
        let dataManager = NewServiceDataManager(database: database)
        let usecase = NewService(dataManager: dataManager)
        let presenter = NewServicePresenter(newService: usecase)
        presenter.router = router
        let view = NewServiceView(service: service, presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func addServiceProviderView(serviceProvider: ServiceProvider, router: AddServiceProviderRouterContract?) -> AddServiceProviderView {
        
        let database = AddServiceProviderDatabaseService()
        let dataManager = AddServiceProviderDataManager(database: database)
        let usecase = AddServiceProvider(dataManager: dataManager)
        let presenter = AddServiceProviderPresenter(addServiceProvider: usecase)
        presenter.router = router
        let view = AddServiceProviderView(serviceProvider: serviceProvider, presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func addServiceProviderRoleView(serviceProviderRole: ServiceProviderRole, router: AddServiceProviderRoleRouterContract?) -> AddServiceProviderRoleView {
        
        let database = AddServiceProviderRoleDatabaseService()
        let dataManager = AddServiceProviderRoleDataManager(database: database)
        let usecase = AddServiceProviderRole(dataManager: dataManager)
        let presenter = AddServiceProviderRolePresenter(addServiceProviderRole: usecase)
        presenter.router = router
        let view = AddServiceProviderRoleView(serviceProviderRole: serviceProviderRole, presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func addPinCodeView(pinCode: PinCode, router: AddPinCodeRouterContract?) -> AddPinCodeView {
        
        let database = AddPinCodeDatabaseService()
        let dataManager = AddPinCodeDataManager(database: database)
        let usecase = AddPinCode(dataManager: dataManager)
        let presenter = AddPinCodePresenter(addPinCode: usecase)
        presenter.router = router
        let view = AddPinCodeView(pinCode: pinCode, presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func searchConsumerView(columnName: String, columnValue: Any, router: SearchConsumerRouterContract?) -> SearchConsumerView {
        
        let database = SearchConsumerDatabaseService()
        let dataManager = SearchConsumerDataManager(database: database, columnName: columnName, columnValue: columnValue)
        let searchConsumer = SearchConsumer(dataManager: dataManager)
        self.searchConsumerPresenter = SearchConsumerPresenter(searchConsumer: searchConsumer)
        let view = SearchConsumerView(columnName: columnName, columnValue: columnValue, presenter: self.searchConsumerPresenter!)
        self.searchConsumerPresenter?.view = view
        return view
    }
    
    static func searchServiceProviderView(columnName: String, columnValue: Any, router: SearchServiceProviderRouterContract?) -> SearchServiceProviderView {
        
        let database = SearchServiceProviderDatabaseService()
        let dataManager = SearchServiceProviderDataManager(database: database, columnName: columnName, columnValue: columnValue)
        let searchServiceProvider = SearchServiceProvider(dataManager: dataManager)
        self.searchServiceProviderPresenter = SearchServiceProviderPresenter(searchServiceProvider: searchServiceProvider)
        let view = SearchServiceProviderView(columnName: columnName, columnValue: columnValue, presenter: self.searchServiceProviderPresenter!)
        self.searchServiceProviderPresenter?.view = view
        return view
    }
    
    static func searchServiceProviderRoleView(columnName: String, columnValue: Any, router: SearchServiceProviderRoleRouterContract?) -> SearchServiceProviderRoleView {
        
        let database = SearchServiceProviderRoleDatabaseService()
        let dataManager = SearchServiceProviderRoleDataManager(database: database, columnName: columnName, columnValue: columnValue)
        let searchServiceProviderRole = SearchServiceProviderRole(dataManager: dataManager)
        self.searchServiceProviderRolePresenter = SearchServiceProviderRolePresenter(searchServiceProviderRole: searchServiceProviderRole)
        let view = SearchServiceProviderRoleView(columnName: columnName, columnValue: columnValue, presenter: self.searchServiceProviderRolePresenter!)
        self.searchServiceProviderRolePresenter?.view = view
        return view
    }
    
    static func searchServiceView(columnName: String, columnValue: Any, router: SearchServiceRouterContract?) -> SearchServiceView {
        
        let database = SearchServiceDatabaseService()
        let dataManager = SearchServiceDataManager(database: database, columnName: columnName, columnValue: columnValue)
        let searchService = SearchService(dataManager: dataManager)
        self.searchServicePresenter = SearchServicePresenter(searchService: searchService)
        let view = SearchServiceView(columnName: columnName, columnValue: columnValue, presenter: self.searchServicePresenter!)
        self.searchServicePresenter?.view = view
        return view
    }
    
    static func getServiceRequestListView(columnName: String, columnValue: Any, router: ServiceRequestListRouterContract) -> ServiceRequestListView {
        let database = ServiceRequestListDatabaseService()
        let dataManager = ServiceRequestListDataManager(database: database, columnName: columnName, columnValue: columnValue)
        let getServiceRequestList = GetServiceRequestList(dataManager: dataManager)
        let presenter = ServiceRequestListPresenter(serviceRequestList: getServiceRequestList)
        let view = ServiceRequestListView(presenter: presenter, columnName: columnName, columnValue: columnValue)
        presenter.view = view
        return view
    }
    
    static func searchPinCodeView(columnName: String, columnValue: Any, router: SearchPinCodeRouterContract?) -> SearchPinCodeView {
        
        let database = SearchPinCodeDatabaseService()
        let dataManager = SearchPinCodeDataManager(database: database, columnName: columnName, columnValue: columnValue)
        let searchPinCode = SearchPinCode(dataManager: dataManager)
        self.searchPinCodePresenter = SearchPinCodePresenter(searchPinCode: searchPinCode)
        let view = SearchPinCodeView(columnName: columnName, columnValue: columnValue, presenter: self.searchPinCodePresenter!)
        self.searchPinCodePresenter?.view = view
        return view
    }
    
    static func consumerLoginView(columnName: String, emailId: String, password: String, router: ConsumerLoginRouterContract) -> ConsumerLoginView {
        let database = SearchConsumerDatabaseService()
        let dataManager = SearchConsumerDataManager(database: database, columnName: columnName, columnValue: emailId)
        let searchConsumer = SearchConsumer(dataManager: dataManager)
        self.consumerLoginPresenter = ConsumerLoginPresenter(searchConsumer: searchConsumer, emailId: emailId, password: password)
        consumerLoginPresenter?.router = router
        let view = ConsumerLoginView(columnName: columnName, columnValue: emailId, presenter: consumerLoginPresenter!)
//        view.presenter = ConsumerLoginPresenter!
        self.consumerLoginPresenter?.view = view
        return view
    }
    
    static func serviceProviderLoginView(columnName: String, emailId: String, password: String, role: ServiceProviderRole, router: ServiceProviderLoginRouterContract) -> ServiceProviderLoginView {
        let database = SearchServiceProviderDatabaseService()
        let dataManager = SearchServiceProviderDataManager(database: database, columnName: columnName, columnValue: emailId)
        let searchServiceProvider = SearchServiceProvider(dataManager: dataManager)
        self.serviceProviderLoginPresenter = ServiceProviderLoginPresenter(searchServiceProvider: searchServiceProvider, emailId: emailId, password: password, role: role)
        serviceProviderLoginPresenter?.router = router
        let view = ServiceProviderLoginView(columnName: columnName, columnValue: columnName, presenter: serviceProviderLoginPresenter!)
        self.serviceProviderLoginPresenter?.view = view
        return view
    }
    
    static func adminLoginView(columnmName: String, emailId: String, password: String, router: AdminLoginRouterContract) -> AdminLoginView {
        let database = SearchAdminDatabaseService()
        let dataManager = SearchAdminDataManager(database: database, columnName: columnmName, columnValue: emailId)
        let searchAdmin = SearchAdmin(dataManager: dataManager)
        self.adminLoginPresenter = AdminLoginPresenter(searchAdmin: searchAdmin, emailId: emailId, password: password)
        adminLoginPresenter?.router = router
        let view = AdminLoginView(columnName: columnmName, columnValue: emailId, presenter: adminLoginPresenter!)
        self.adminLoginPresenter?.view = view
        return view
    }
    
    static func getServiceProviderRoleListView(router: ServiceProviderRoleListRouterContract) -> ServiceProviderRoleListView {
        let database = ServiceProviderRoleListDatabaseService()
        let dataManager = ServiceProviderRoleListDataManager(database: database)
        let getServiceProviderRoleList = GetServiceProviderRoleList(dataManager: dataManager)
        let presenter = ServiceProviderRoleListPresenter(serviceProviderRoleList: getServiceProviderRoleList)
        presenter.router = router
        let view = ServiceProviderRoleListView(presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func getServiceProviderListView(router: ServiceProviderListRouterContract) -> ServiceProviderListView {
        let database = ServiceProviderListDatabaseService()
        let dataManager = ServiceProviderListDataManager(database: database)
        let getServiceProviderList = GetServiceProviderList(dataManager: dataManager)
        let presenter = ServiceProviderListPresenter(serviceProviderList: getServiceProviderList)
        presenter.router = router
        let view = ServiceProviderListView(presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func getConsumerListView(router: ConsumerListRouterContract) -> ConsumerListView {
        let database = ConsumerListDatabaseService()
        let dataManager = ConsumerListDataManager(database: database)
        let getConsumerList = GetConsumerList(dataManager: dataManager)
        let presenter = ConsumerListPresenter(consumerList: getConsumerList)
        presenter.router = router
        let view = ConsumerListView(presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func getPinCodeListView(router: PinCodeListRouterContract) -> PinCodeListView {
        let database = PinCodeListDatabaseService()
        let dataManager = PinCodeListDataManager(database: database)
        let getPinCodeList = GetPinCodeList(dataManager: dataManager)
        let presenter = PinCodeListPresenter(pinCodeList: getPinCodeList)
        presenter.router = router
        let view = PinCodeListView(presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func updateServiceView(newValue: [String: Any], serviceId: Int, router: UpdateServiceRouterContract) -> UpdateServiceView {
        let database = UpdateServiceDatabaseService()
        let dataManager = UpdateServiceDataManager(database: database)
        let usecase = UpdateService(dataManager: dataManager)
        let presenter = UpdateServicePresenter(updateService: usecase)
        presenter.router = router
        let view = UpdateServiceView(newValues: newValue, serviceId: serviceId, presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func updateServiceProviderRoleView(newValue: [String: Any], serviceProviderRoleId: Int, router: UpdateServiceProviderRoleRouterContract) -> UpdateServiceProviderRoleView {
        let database = UpdateServiceProviderRoleDatabaseService()
        let dataManager = UpdateServiceProviderRoleDataManager(database: database)
        let usecase = UpdateServiceProviderRole(dataManager: dataManager)
        let presenter = UpdateServiceProviderRolePresenter(updateServiceProviderRole: usecase)
        presenter.router = router
        let view = UpdateServiceProviderRoleView(newValues: newValue, serviceProviderRoleId: serviceProviderRoleId, presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func updateAdminView(newValues: [String: Any], adminId: Int, router: UpdateAdminRouterContract) -> UpdateAdminView {
        let database = UpdateAdminDatabaseService()
        let dataManager = UpdateAdminDataManager(database: database)
        let usecase = UpdateAdmin(dataManager: dataManager)
        let presenter = UpdateAdminPresenter(updateAdmin: usecase)
        presenter.router = router
        let view = UpdateAdminView(newValues: newValues, adminId: adminId, presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func updateConsumerView(newValues: [String: Any], consumerId: Int, router: UpdateConsumerRouterContract) -> UpdateConsumerView {
        let database = UpdateConsumerDatabaseService()
        let dataManager = UpdateConsumerDataManager(database: database)
        let usecase = UpdateConsumer(dataManager: dataManager)
        let presenter = UpdateConsumerPresenter(updateConsumer: usecase)
        presenter.router = router
        let view = UpdateConsumerView(newValues: newValues, consumerId: consumerId, presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func updateServiceProviderView(newValues: [String: Any], serviceProviderId: Int, router: UpdateServiceProviderRouterContract) -> UpdateServiceProviderView {
        let database = UpdateServiceProviderDatabaseService()
        let dataManager = UpdateServiceProviderDataManager(database: database)
        let usecase = UpdateServiceProvider(dataManager: dataManager)
        let presenter = UpdateServiceProviderPresenter(updateServiceProvider: usecase)
        presenter.router = router
        let view = UpdateServiceProviderView(newValues: newValues, serviceProviderId: serviceProviderId, presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func updatePinCodeView(newValue: [String: Any], pinCodeId: Int, router: UpdatePinCodeRouterContract) -> UpdatePinCodeView {
        let database = UpdatePinCodeDatabaseService()
        let dataManager = UpdatePinCodeDataManager(database: database)
        let usecase = UpdatePinCode(dataManager: dataManager)
        let presenter = UpdatePinCodePresenter(updatePinCode: usecase)
        presenter.router = router
        let view = UpdatePinCodeView(newValues: newValue, pinCodeId: pinCodeId, presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func deleteServiceView(columnName: String, columnValue: Any, router: DeleteServiceRouterContract?) -> DeleteServiceView {
        let database = DeleteServiceDatabaseService()
        let dataManager = DeleteServiceDataManager(database: database)
        let usecase = DeleteService(dataManager: dataManager)
        let presenter = DeleteServicePresenter(deleteService: usecase)
        presenter.router = router
        let view = DeleteServiceView(columnName: columnName, columnValue: columnValue, presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func deleteConsumerView(consumerId: Int, router: DeleteConsumerRouterContract?) -> DeleteConsumerView {
        let database = DeleteConsumerDatabaseService()
        let dataManager = DeleteConsumerDataManager(database: database)
        let usecase = DeleteConsumer(dataManager: dataManager)
        let presenter = DeleteConsumerPresenter(deleteConsumer: usecase)
        presenter.router = router
        let view = DeleteConsumerView(consumerId: consumerId, presenter: presenter)
        presenter.view = view
        return view
    }
    
    static func deleteServiceProviderView(serviceProviderId: Int, router: DeleteServiceProviderRouterContract?) -> DeleteServiceProviderView {
        let database = DeleteServiceProviderDatabaseService()
        let dataManager = DeleteServiceProviderDataManager(database: database)
        let usecase = DeleteServiceProvider(dataManager: dataManager)
        let presenter = DeleteServiceProviderPresenter(deleteServiceProvider: usecase)
        presenter.router = router
        let view = DeleteServiceProviderView(serviceProviderId: serviceProviderId, presenter: presenter)
        presenter.view = view
        return view
    }
}
