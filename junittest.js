// for Java ScriptEngine(Rhino)

importPackage( Packages.junit.framework )

var JString = java.lang.String

function assert(expected, script) {
  var msg = JString.format("testcode=[%s]", [script])
  var assertEquals = Assert["assertEquals(java.lang.String,java.lang.String,java.lang.String)"]
  assertEquals( msg, expected, eval(script) )
}

assert('cde', 'JString.valueOf("abcde").substring(2, 4)')
