package registry.core

import std.collection.ReadOnlyMap
import std.reflect.TypeInfo

public class Registry {
    private let _entries: ReadOnlyMap<Tag, Any>

    public static func builder(): Builder {
        Builder()
    }

    protected Registry(builder: Builder) {
        _entries = builder.getEntries()
    }

    public func get<T>(): T {
        let tag = Tag.of<T>()
        get(tag)
    }

    public func get<T>(label: String): T {
        let tag = Tag.of<T>(label: label)
        get(tag)
    }

    private func get<T>(tag: Tag): T {
        (_entries[tag] as Entry<T>).getOrThrow {
            => RegistryEntryHasWrongTypeException(tag, expected: TypeInfo.of<T>(), actual: TypeInfo.of(_entries[tag]))
        }.get(this)
    }
}

private class RegistryEntryHasWrongTypeException <: Exception {
    RegistryEntryHasWrongTypeException(tag: Tag, expected!: TypeInfo, actual!: TypeInfo) {
        super("entry for tag `${tag}` has wrong type. Expected type: ${expected}, actual: ${actual}")
    }
    protected func getClassName() {
        "RegistryEntryHasWrongTypeException"
    }
}
