package registry.extra.entry

import std.sync.ReadWriteLock
import registry.core.{Builder, Entry, Registry}
import registry.extra.FromRegistry

public class Lazy<T> {
    protected var _instance = None<T>
    protected var _locker = ReadWriteLock()

    public Lazy(protected let _factory: (Registry) -> T) {}
}

extend<T> Lazy<T> <: Entry<T> {
    public func get(registry: Registry): T {
        _locker.readLock.lock()
        match (_instance) {
            case Some(result) =>
                _locker.readLock.unlock()
                result
            case _ =>
                _locker.readLock.unlock()

                _locker.writeLock.lock()
                // Double check if another thread has initialized the instance
                match (_instance) {
                    case Some(result) =>
                        _locker.writeLock.unlock()
                        result
                    case _ =>
                        let result = _factory(registry)
                        _instance = Some(result)
                        _locker.writeLock.unlock()
                        result
                }
        }
    }
}

public interface AddLazy<BuilderT> {
    func addLazy<InterfaceT>(): BuilderT where InterfaceT <: FromRegistry<InterfaceT>
    func addLazy<InterfaceT>(label: String): BuilderT where InterfaceT <: FromRegistry<InterfaceT>
    func addLazy<InterfaceT>(factory: (Registry) -> InterfaceT): BuilderT
    func addLazy<InterfaceT>(label: String, factory: (Registry) -> InterfaceT): BuilderT
    func addLazyImpl<InterfaceT, ImplementationT>(): BuilderT where ImplementationT <: FromRegistry<InterfaceT>
    func addLazyImpl<InterfaceT, ImplementationT>(label: String): BuilderT where ImplementationT <: FromRegistry<InterfaceT>
}

extend Builder <: AddLazy<Builder> {
    public func addLazy<InterfaceT>(): Builder where InterfaceT <: FromRegistry<InterfaceT> {
        addLazy(InterfaceT.fromRegistry)
    }

    public func addLazy<InterfaceT>(label: String): Builder where InterfaceT <: FromRegistry<InterfaceT> {
        addLazy(label, InterfaceT.fromRegistry)
    }

    public func addLazy<InterfaceT>(factory: (Registry) -> InterfaceT): Builder {
        add(Lazy(factory))
    }

    public func addLazy<InterfaceT>(label: String, factory: (Registry) -> InterfaceT): Builder {
        add(label, Lazy(factory))
    }

    public func addLazyImpl<InterfaceT, ImplementationT>(): Builder where ImplementationT <: FromRegistry<InterfaceT> {
        addLazy<InterfaceT>(ImplementationT.fromRegistry)
    }

    public func addLazyImpl<InterfaceT, ImplementationT>(label: String): Builder where ImplementationT <: FromRegistry<InterfaceT> {
        addLazy<InterfaceT>(label, ImplementationT.fromRegistry)
    }
}
