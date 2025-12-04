package registry.core

import std.deriving.Derive
import std.reflect.TypeInfo

@Derive[Equatable, Hashable]
protected struct Tag {
    private Tag(protected let typeName!: String, protected let label!: String = "default") {}

    static func of<T>(label!: String = "default"): Tag {
        Tag(typeName: TypeInfo.of<T>().qualifiedName, label: label)
    }
}

extend Tag <: ToString {
    public func toString(): String {
        typeName + label
    }
}
