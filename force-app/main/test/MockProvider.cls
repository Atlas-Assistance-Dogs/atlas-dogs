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

public
  static Id createId(System.Type type) {
    String typeName = type.getName();
    List<Schema.DescribeSObjectResult> describes = Schema.describeSObjects(
        new String[]{typeName}, SObjectDescribeOptions.DEFERRED);
    String code =
        describes[0].getKeyPrefix() + (fakeIdCount++ +'').leftPad(15, '0');
    return code;
  }
public
  static final String[] teamids = new List<String>{
      'a1D000000000000042', 'a1BE200000K4ZN4MAN', 'a1BE200000K4ZN5MAN',
      'a1BE200000K4ZN6MAN', 'a1BE200000K4ZN7MAN', 'a1BE200000K4ZN8MAN',
      'a1BE200000K4ZN9MAN', 'a1BE200000K4ZNAMA3', 'a1BE200000K4ZNBMA3',
      'a1BE200000K4ZNCMA3'};

public
  static final String[] contactids = new List<String>{
      '003E200000WBWDeIAP', '003E200000WBWDfIAP', '003E200000WBWDgIAP',
      '003E200000WBWDhIAP', '003E200000WBWDiIAP', '003E200000WBWDjIAP',
      '003E200000WBWDkIAP', '003E200000WBWDlIAP', '003E200000WBWDmIAP',
      '003E200000WBWDnIAP'};

public
  static final String[] relationshipids = new List<String>{
      'a0FE2000003J7gsMAC', 'a0FE2000003J7gtMAC', 'a0FE2000003J9icMAC',
      'a0FE2000003J9idMAC', 'a0FE2000003JC6zMAG', 'a0FE2000003JC70MAG',
      'a0FE2000003JC8bMAG', 'a0FE2000003JC8cMAG'};
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

public
  Object createMock(Type typeToMock) {
    // Invoke the stub API and pass it our mock provider to create a
    // mock class of typeToMock.
    return Test.createStub(typeToMock, this);
  }

  public List<MockCallData> expectedCalls { get; set; }
  public List<MockCallData> actualCalls { get; set; }

  // handle the mocked method call
public
  Object handleMethodCall(Object stubbedObject, String stubbedMethodName,
                          Type returnType, List<Type> listOfParamTypes,
                          List<String> listOfParamNames,
                          List<Object> listOfArgs) {
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
      if (stubbedObject == expected.obj &&
          stubbedMethodName == expected.methodName) {
        expected.matched = true;
        actual.matched = true;
        return expected.returnValue;
      }
    }

    return null;
  }

  // validate that all actual calls were expected
public
  void validateCalls() {
    for (MockCallData actual : actualCalls) {
      System.assert(actual.matched);
    }
  }
}
