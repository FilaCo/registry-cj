package registry.extra.entry

import registry.core.{Builder, Entry, Registry}

public struct Independent<T> {
    protected let inner: Box<T>

    public Independent(v: T) {
        inner = Box(v)
    }
}

extend<T> Independent<T> <: Entry<T> {
    public func get(_: Registry): T {
        inner.value
    }
}

public interface AddIndependent<BuilderT> {
    func addIndependent<InterfaceT>(value: InterfaceT): BuilderT
    func addIndependent<InterfaceT>(factory: () -> InterfaceT): BuilderT
    func addIndependent<InterfaceT>(label: String, value: InterfaceT): BuilderT
    func addIndependent<InterfaceT>(label: String, factory: () -> InterfaceT): BuilderT
}

extend Builder <: AddIndependent<Builder> {
    public func addIndependent<InterfaceT>(value: InterfaceT): Builder {
        add(Independent(value))
    }

    public func addIndependent<InterfaceT>(factory: () -> InterfaceT): Builder {
        addIndependent(factory())
    }

    public func addIndependent<InterfaceT>(label: String, value: InterfaceT): Builder {
        add(label, Independent(value))
    }

    public func addIndependent<InterfaceT>(label: String, factory: () -> InterfaceT): Builder {
        addIndependent(label, factory())
    }
}
