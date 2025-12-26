package registry.core

import std.collection.ReadOnlyMap

public class Registry {
    private let _entries: ReadOnlyMap<Tag, Box<Any>>

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

    public func tryGet<T>(): ?T {
        let tag = Tag.of<T>()
        tryGet(tag)
    }

    public func tryGet<T>(label: String): ?T {
        let tag = Tag.of<T>(label: label)
        tryGet(tag)
    }

    private func get<T>(tag: Tag): T {
        tryGet<T>(tag).getOrThrow {=> EntryNotFoundException(tag)}
    }

    private func tryGet<T>(tag: Tag): ?T {
        _entries.get(tag).map {item => item.value as Entry<T>}.flatten()?.get(this)
    }
}

protected class EntryNotFoundException <: Exception {
    protected EntryNotFoundException(tag: Tag) {
        super("entry for tag `${tag}` not found")
    }
    protected func getClassName() {
        "EntryNotFoundException"
    }
}
