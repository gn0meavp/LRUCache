//
//  LRUCacheTests.m
//  LRUCache
//
//  Created by Alexey Patosin on 26/02/15.
//  Copyright (c) 2015 TestOrg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "LRUCache.h"

@interface LRUCacheTests : XCTestCase
@property (nonatomic, strong) LRUCache *cache;
@end

@interface TestClass : NSObject
@property (nonatomic, strong) NSString *value;
+ (instancetype)objectWithValue:(NSString *)value;
@end

@implementation LRUCacheTests

- (void)setUp {
    [super setUp];

    self.cache = [[LRUCache alloc] initWithCapacity:5];
}

- (void)tearDown {

    self.cache = nil;
    
    [super tearDown];
}

- (void)testCacheShouldStoreValue {
    
    TestClass *obj1 = [TestClass objectWithValue:@"1"];
    NSString *key1 = @"a";
    
    [self.cache setObject:obj1 forKey:key1];
    XCTAssert([[self.cache objectForKey:key1] isEqual:obj1], @"cache should store value");
}

- (void)testCacheShouldStoreMultipleValues {
    TestClass *obj1 = [TestClass objectWithValue:@"1"];
    NSString *key1 = @"a";

    TestClass *obj2 = [TestClass objectWithValue:@"2"];
    NSString *key2 = @"b";

    TestClass *obj3 = [TestClass objectWithValue:@"3"];
    NSString *key3 = @"c";
    
    [self.cache setObject:obj1 forKey:key1];
    [self.cache setObject:obj2 forKey:key2];
    [self.cache setObject:obj3 forKey:key3];
    
    XCTAssert([[self.cache objectForKey:key1] isEqual:obj1] &&
              [[self.cache objectForKey:key2] isEqual:obj2] &&
              [[self.cache objectForKey:key3] isEqual:obj3], @"cache should store multiple values");
}

- (void)testCacheShouldStoreLastValues {
    
    self.cache = [[LRUCache alloc] initWithCapacity:2];
    
    TestClass *obj1 = [TestClass objectWithValue:@"1"];
    NSString *key1 = @"a";
    
    TestClass *obj2 = [TestClass objectWithValue:@"2"];
    NSString *key2 = @"b";
    
    TestClass *obj3 = [TestClass objectWithValue:@"3"];
    NSString *key3 = @"c";
    
    [self.cache setObject:obj1 forKey:key1];
    [self.cache setObject:obj2 forKey:key2];
    [self.cache setObject:obj3 forKey:key3];
    
    XCTAssert([[self.cache objectForKey:key2] isEqual:obj2] &&
              [[self.cache objectForKey:key3] isEqual:obj3], @"cache should store last values");
 
    XCTAssertNil([self.cache objectForKey:key1], @"cache should not store value which did not used recently");
    
}

- (void)testCacheShouldNotStoreValueThatWasNotUsedRecently {
    
    self.cache = [[LRUCache alloc] initWithCapacity:2];
    
    TestClass *obj1 = [TestClass objectWithValue:@"1"];
    NSString *key1 = @"a";
    
    TestClass *obj2 = [TestClass objectWithValue:@"2"];
    NSString *key2 = @"b";
    
    TestClass *obj3 = [TestClass objectWithValue:@"3"];
    NSString *key3 = @"c";
    
    [self.cache setObject:obj1 forKey:key1];
    [self.cache setObject:obj2 forKey:key2];
    [self.cache setObject:obj3 forKey:key3];

    XCTAssertNil([self.cache objectForKey:key1], @"cache should not store value which did not used recently");
    
}

- (void)testCacheShouldStoreRecentlyValueEventIfItWasAppendedFirst {
    
    self.cache = [[LRUCache alloc] initWithCapacity:2];
    
    TestClass *obj1 = [TestClass objectWithValue:@"1"];
    NSString *key1 = @"a";
    
    TestClass *obj2 = [TestClass objectWithValue:@"2"];
    NSString *key2 = @"b";
    
    TestClass *obj3 = [TestClass objectWithValue:@"3"];
    NSString *key3 = @"c";
    
    [self.cache setObject:obj1 forKey:key1];
    [self.cache setObject:obj2 forKey:key2];
    
    [self.cache objectForKey:key1];
    
    [self.cache setObject:obj3 forKey:key3];
    
    XCTAssert([[self.cache objectForKey:key1] isEqual:obj1], @"cache should store recently used value even if it was appended earlier");
    
}

- (void)testCacheShouldNotStoreValueThatWasNotUsedRecentlyEvenIfItWasAppendedLater {
    self.cache = [[LRUCache alloc] initWithCapacity:2];
    
    TestClass *obj1 = [TestClass objectWithValue:@"1"];
    NSString *key1 = @"a";
    
    TestClass *obj2 = [TestClass objectWithValue:@"2"];
    NSString *key2 = @"b";
    
    TestClass *obj3 = [TestClass objectWithValue:@"3"];
    NSString *key3 = @"c";
    
    [self.cache setObject:obj1 forKey:key1];
    [self.cache setObject:obj2 forKey:key2];
    
    [self.cache objectForKey:key1];
    
    [self.cache setObject:obj3 forKey:key3];
    
    XCTAssertFalse([self.cache objectForKey:key2], @"cache should not store value which did not used recently, even if it was appended later");
    
}

- (void)testCacheShouldStoreTheSameValueTwiceWithDifferentKeys {
    TestClass *obj1 = [TestClass objectWithValue:@"1"];
    NSString *key1 = @"a";

    NSString *key2 = @"b";

    [self.cache setObject:obj1 forKey:key1];
    [self.cache setObject:obj1 forKey:key2];
    
    XCTAssert([self.cache objectForKey:key1] != nil &&
              [[self.cache objectForKey:key1] isEqual:[self.cache objectForKey:key2]], @"cache should store the same value with different keys");
    
}

- (void)testCacheShouldNotStoreNilValue {
    NSString *key1 = @"a";
    
    XCTAssertThrows([self.cache setObject:nil forKey:key1], @"should throw exception for nil value");
    
    XCTAssertNil([self.cache objectForKey:key1], @"cache should not store nil value");
}

- (void)testCacheShouldNotReplaceValuesWithNilValue {
    self.cache = [[LRUCache alloc] initWithCapacity:2];
    
    TestClass *obj1 = [TestClass objectWithValue:@"1"];
    NSString *key1 = @"a";
    
    TestClass *obj2 = [TestClass objectWithValue:@"2"];
    NSString *key2 = @"b";
    
    TestClass *obj3 = nil;
    NSString *key3 = @"c";
    
    [self.cache setObject:obj1 forKey:key1];
    [self.cache setObject:obj2 forKey:key2];
    
    XCTAssertThrows([self.cache setObject:obj3 forKey:key3], @"should throw exception for nil value");
    XCTAssert([[self.cache objectForKey:key1] isEqual:obj1] && [[self.cache objectForKey:key2] isEqual:obj2],  @"cache should not replace values with nil value");
    
}

- (void)testPerformanceInsertObjectsInLargeCache {
    self.cache = [[LRUCache alloc] initWithCapacity:1000];
    
    [self measureBlock:^{
        for (NSUInteger i=0;i<1000;i++) {
            TestClass *obj = [TestClass objectWithValue:[NSString stringWithFormat:@"value %lu", i]];
            NSString *key = [NSString stringWithFormat:@"key %lu", i];
            [self.cache setObject:obj forKey:key];
        }
    }];
}

- (void)testPerformanceInsertObjectsInSmallCache {
    self.cache = [[LRUCache alloc] initWithCapacity:5];
    [self measureBlock:^{
        for (NSUInteger i=0;i<1000;i++) {
            TestClass *obj = [TestClass objectWithValue:[NSString stringWithFormat:@"value %lu", i]];
            NSString *key = [NSString stringWithFormat:@"key %lu", i];
            [self.cache setObject:obj forKey:key];
        }
    }];
}

- (void)testPerformanceReceiveLessRecentlyUsedValues {
    self.cache = [[LRUCache alloc] initWithCapacity:1001];      // 1000 + 1

    TestClass *firstObj = [TestClass objectWithValue:@"first value"];
    NSString *firstKey = @"first key";
    
    [self.cache setObject:firstObj forKey:firstKey];
    
    for (NSUInteger i=0;i<1000;i++) {
        TestClass *obj = [TestClass objectWithValue:[NSString stringWithFormat:@"value %lu", i]];
        NSString *key = [NSString stringWithFormat:@"key %lu", i];
        [self.cache setObject:obj forKey:key];
    }

    [self measureBlock:^{
        [self.cache objectForKey:firstKey];
    }];
}

- (void)testPerformanceReceiveRandomValues {
    self.cache = [[LRUCache alloc] initWithCapacity:1000];

    for (NSUInteger i=0;i<1000;i++) {
        TestClass *obj = [TestClass objectWithValue:[NSString stringWithFormat:@"value %lu", i]];
        NSString *key = [NSString stringWithFormat:@"key %lu", i];
        [self.cache setObject:obj forKey:key];
    }
    
    [self measureBlock:^{
        for (NSUInteger i=0;i<1000;i++) {
            NSString *key = [NSString stringWithFormat:@"key %i", arc4random()%1000];
            [self.cache objectForKey:key];
        }
    }];
}


@end

@implementation TestClass
+ (instancetype)objectWithValue:(NSString *)value {
    TestClass *obj = [TestClass new];
    obj.value = value;
    return obj;
}

- (NSUInteger)hash {
    return [self.value hash];
}

- (BOOL)isEqual:(TestClass *)object {
    return [self.value isEqualToString:object.value];
}

@end