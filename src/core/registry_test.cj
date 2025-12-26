package registry.core

import std.unittest.*
import std.unittest.testmacro.*

@Test
class RegistryTest {
    @TestCase
    func testEmpty() {
        // arrange
        let builder = Registry.builder()

        // act
        let sut = builder.build()

        // assert
        @AssertThrows[EntryNotFoundException](sut.get<String>("whatever"))
        @PowerAssert(None<Int64> == sut.tryGet<Int64>())
    }

    @TestCase
    func testBasic() {
        // arrange
        let sut: Registry = Registry.builder().add<TestItem, TestEntry>(TestEntry()).build()

        // act
        let res = sut.get<TestItem>()

        // assert
        @PowerAssert(res is TestItem)
    }
}

interface TestItem {}

class TestItemImpl <: TestItem {}

struct TestEntry <: Entry<TestItem> {
    public func get(_: Registry): TestItem {
        TestItemImpl()
    }
}
