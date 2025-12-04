package registry.extra

import registry.core.{Builder, Entry, Registry}

public class Transient<T> {
    public Transient(protected let _factory: (Registry) -> T) {}
}

extend<T> Transient<T> <: Entry<T> {
    public func get(registry: Registry): T {
        _factory(registry)
    }
}

public interface AddTransient<T> {
    func addTransient<InterfaceT>(factory: (Registry) -> InterfaceT): T
    func addTransient<InterfaceT>(label: String, factory: (Registry) -> InterfaceT): T
}

extend Builder <: AddTransient<Builder> {
    public func addTransient<InterfaceT>(factory: (Registry) -> InterfaceT): Builder {
        add(Transient(factory))
    }

    public func addTransient<InterfaceT>(label: String, factory: (Registry) -> InterfaceT): Builder {
        add(label, Transient(factory))
    }
}
