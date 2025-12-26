package registry.extra

import registry.core.Registry

public interface FromRegistry<T> {
    static func fromRegistry(registry: Registry): T
}
