package registry.extra.entry

import registry.core.{Builder, Entry, Registry}
import registry.extra.FromRegistry

public struct Transient<T> {
    public Transient(protected let _factory: (Registry) -> T) {}
}

extend<T> Transient<T> <: Entry<T> {
    public func get(registry: Registry): T {
        _factory(registry)
    }
}

public interface AddTransient<BuilderT> {
    func addTransient<InterfaceT>(): BuilderT where InterfaceT <: FromRegistry<InterfaceT>
    func addTransient<InterfaceT>(label: String): BuilderT where InterfaceT <: FromRegistry<InterfaceT>
    func addTransient<InterfaceT>(factory: (Registry) -> InterfaceT): BuilderT
    func addTransient<InterfaceT>(label: String, factory: (Registry) -> InterfaceT): BuilderT
    func addTransientImpl<InterfaceT, ImplementationT>(): BuilderT where ImplementationT <: FromRegistry<InterfaceT>
    func addTransientImpl<InterfaceT, ImplementationT>(label: String): BuilderT where ImplementationT <: FromRegistry<InterfaceT>
}

extend Builder <: AddTransient<Builder> {
    public func addTransient<InterfaceT>(): Builder where InterfaceT <: FromRegistry<InterfaceT> {
        addTransient(InterfaceT.fromRegistry)
    }

    public func addTransient<InterfaceT>(label: String): Builder where InterfaceT <: FromRegistry<InterfaceT> {
        addTransient(label, InterfaceT.fromRegistry)
    }

    public func addTransient<InterfaceT>(factory: (Registry) -> InterfaceT): Builder {
        add(Transient(factory))
    }

    public func addTransient<InterfaceT>(label: String, factory: (Registry) -> InterfaceT): Builder {
        add(label, Transient(factory))
    }

    public func addTransientImpl<InterfaceT, ImplementationT>(): Builder where ImplementationT <: FromRegistry<InterfaceT> {
        addTransient<InterfaceT>(ImplementationT.fromRegistry)
    }

    public func addTransientImpl<InterfaceT, ImplementationT>(label: String): Builder where ImplementationT <: FromRegistry<InterfaceT> {
        addTransient<InterfaceT>(label, ImplementationT.fromRegistry)
    }
}
