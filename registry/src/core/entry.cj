package registry.core

public interface Entry<T> {
    func get(registry: Registry): T
}
