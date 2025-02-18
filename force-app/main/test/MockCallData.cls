@isTest public class MockCallData {
public
  Object obj {
    get;
    set;
  }
public
  String methodName {
    get;
    set;
  }
public
  Type returnType {
    get;
    set;
  }
public
  Object returnValue {
    get;
    set;
  }
public
  List<Type> paramTypes {
    get;
    set;
  }
public
  List<String> paramNames {
    get;
    set;
  }
public
  List<Object> args {
    get;
    set;
  }
public
  Boolean matched {
    get;
    set;
  }

public
  MockCallData() {}

public
  MockCallData(Object obj, String methodName) {
    this.obj = obj;
    this.methodName = methodName;
  }

public
  MockCallData(Object obj, String methodName, Object returnValue) {
    this.obj = obj;
    this.methodName = methodName;
    this.returnValue = returnValue;
  }
}