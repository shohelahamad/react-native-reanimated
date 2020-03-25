//
//  SharedDoubleTest.mm
//  ReanimatedExampleTests
//
//  Created by Karol Bisztyga on 3/25/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
#import <XCTest/XCTest.h>
#import <jsi/JSCRuntime.h>
#include <jsi/jsi.h>
#import "SharedDouble.h"

@interface SharedDoubleTest : XCTestCase
{
  double initialValue;
  int currentId;
  std::unique_ptr<jsi::Runtime> rt;
  std::unique_ptr<SharedDouble> sd;
}
@end

@implementation SharedDoubleTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  currentId = 0;
  initialValue = 14;
  rt.reset(static_cast<jsi::Runtime*>(facebook::jsc::makeJSCRuntime().release()));
  sd.reset(new SharedDouble(currentId, initialValue));
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  ;
  [super tearDown];
}

- (void)testInitializatio {
  XCTAssert(sd->id == currentId, @"id assigned properly");
  XCTAssert(sd->value == initialValue, @"value assigned properly");
}

- (void)testAsValue {
  jsi::Value result = sd->asValue(*rt);
  XCTAssert(result.isNumber(), @"value is number");
  XCTAssert(result.getNumber() == sd->value, @"value is correct");
}

- (void)testSetNewValue {
  XCTAssert(sd->value == initialValue, @"proper initial value");
  const double modifiedValue = 91;
  std::shared_ptr<SharedValue> sv((SharedValue*) new SharedDouble(++currentId, modifiedValue));
  sd->setNewValue(sv);
  XCTAssert(sd->value == modifiedValue, @"proper modified value");
}

- (void)testAsParameter {
  // todo
}

- (void)getSharedValues {
  std::vector<int> result = sd->getSharedValues();
  XCTAssert(result.size() == 1, @"shared values length valid");
  XCTAssert(result.at(0) == currentId, @"");
}

@end
