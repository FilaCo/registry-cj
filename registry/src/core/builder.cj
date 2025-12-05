package registry.core

import std.collection.HashMap

public class Builder {
    private var _entries = HashMap<Tag, Box<Any>>()

    public func build(): Registry {
        Registry(this)
    }

    public func add<InterfaceT, EntryT>(entry: EntryT): This where EntryT <: Entry<InterfaceT> {
        add<InterfaceT, EntryT>(Tag.of<InterfaceT>(), entry)
    }

    public func add<InterfaceT, EntryT>(label: String, entry: EntryT): This where EntryT <: Entry<InterfaceT> {
        add<InterfaceT, EntryT>(Tag.of<InterfaceT>(label: label), entry)
    }

    protected func getEntries() {
        _entries
    }

    private func add<InterfaceT, EntryT>(tag: Tag, entry: EntryT): This where EntryT <: Entry<InterfaceT> {
        _entries.add(tag, Box(entry))

        this
    }
}
