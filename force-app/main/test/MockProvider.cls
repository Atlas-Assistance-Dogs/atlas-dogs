/* This class uses the StubProvider interface.  Use it by instantiating it in
each test case, creating mock classes to inject, then setting the expectedCalls
    using MockCallData objects.

Calls that are not expected return null/void.

The actual calls can be checked as part of the test assertions.
     */
@isTest
/**
 * @description add your description here
 * @Date 30 October 2024
 */
public class MockProvider implements System.StubProvider {
  static Integer fakeIdCount = 42;

  public static Id createId(System.Type type) {
    String typeName = type.getName();
    List<Schema.DescribeSObjectResult> describes = Schema.describeSObjects(
      new List<String>{ typeName },
      SObjectDescribeOptions.DEFERRED
    );
    String code =
      describes[0].getKeyPrefix() + (fakeIdCount++ + '').leftPad(15, '0');
    return code;
  }

  static Integer fakeIdCount = 42;

  public static Id createId(System.Type type) {
    String typeName = type.getName();
    List<Schema.DescribeSObjectResult> describes = Schema.describeSObjects(
      new List<String>{ typeName },
      SObjectDescribeOptions.DEFERRED
    );
    String code =
      describes[0].getKeyPrefix() + (fakeIdCount++ + '').leftPad(15, '0');
    return code;
  }
public
  MockProvider() {
    expectedCalls = new List<MockCallData>();
    actualCalls = new List<MockCallData>();
  }

  public Object createMock(Type typeToMock) {
    // Invoke the stub API and pass it our mock provider to create a
    // mock class of typeToMock.
    return Test.createStub(typeToMock, this);
  }

  public List<MockCallData> expectedCalls { get; set; }
  public List<MockCallData> actualCalls { get; set; }

  // handle the mocked method call
  public Object handleMethodCall(
    Object stubbedObject,
    String stubbedMethodName,
    Type returnType,
    List<Type> listOfParamTypes,
    List<String> listOfParamNames,
    List<Object> listOfArgs
  ) {
    // create MockCallData to track the call
    MockCallData actual = new MockCallData();

    actual.obj = stubbedObject;
    actual.methodName = stubbedMethodName;
    actual.returnType = returnType;
    actual.paramTypes = listOfParamTypes;
    actual.paramNames = listOfParamNames;
    actual.args = listOfArgs;
    actualCalls.add(actual);

    // See if this call was expected, for now we will just match object and
    // methodName
    for (MockCallData expected : expectedCalls) {
      if (
        stubbedObject == expected.obj &&
        stubbedMethodName == expected.methodName
      ) {
        expected.matched = true;
        actual.matched = true;
        return expected.returnValue;
      }
    }

    return null;
  }

  // validate that all actual calls were expected
  public void validateCalls() {
    for (MockCallData actual : actualCalls) {
      System.assert(actual.matched);
    }
  }
}
