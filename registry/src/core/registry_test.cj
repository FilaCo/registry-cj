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
}
