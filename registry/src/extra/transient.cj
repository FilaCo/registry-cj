package registry.extra

import registry.core.{Entry, Registry}

public class Transient<T> {
    public Transient(protected let _factory: (Registry) -> T) {}
}

extend<T> Transient<T> <: Entry<T> {
    public func get(registry: Registry): T {
        _factory(registry)
    }
}
