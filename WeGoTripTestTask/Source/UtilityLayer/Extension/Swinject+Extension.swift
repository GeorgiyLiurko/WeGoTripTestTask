import Swinject

extension Resolver {
	func forceResolve<Service>(_ serviceType: Service.Type, name: String? = nil) -> Service {
		resolve(serviceType, name: name)! 
	}
}
