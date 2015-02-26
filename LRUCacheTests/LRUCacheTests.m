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

@interface TestClass : NSObject <NSCoding>
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
    
    [self.cache setObject:[self testObj1] forKey:[self key1]];
    XCTAssert([[self.cache objectForKey:[self key1]] isEqual:[self testObj1]], @"cache should store value");
}

- (void)testCacheShouldStoreMultipleValues {
    
    [self.cache setObject:[self testObj1] forKey:[self key1]];
    [self.cache setObject:[self testObj2] forKey:[self key2]];
    [self.cache setObject:[self testObj3] forKey:[self key3]];
    
    XCTAssert([[self.cache objectForKey:[self key1]] isEqual:[self testObj1]] &&
              [[self.cache objectForKey:[self key2]] isEqual:[self testObj2]] &&
              [[self.cache objectForKey:[self key3]] isEqual:[self testObj3]], @"cache should store multiple values");
}

- (void)testCacheShouldStoreLastValues {
    
    self.cache = [[LRUCache alloc] initWithCapacity:2];
    
    [self.cache setObject:[self testObj1] forKey:[self key1]];
    [self.cache setObject:[self testObj2] forKey:[self key2]];
    [self.cache setObject:[self testObj3] forKey:[self key3]];
    
    XCTAssert([[self.cache objectForKey:[self key2]] isEqual:[self testObj2]] &&
              [[self.cache objectForKey:[self key3]] isEqual:[self testObj3]], @"cache should store last values");
 
    XCTAssertNil([self.cache objectForKey:[self key1]], @"cache should not store value which did not used recently");
    
}

- (void)testCacheShouldNotStoreValueThatWasNotUsedRecently {
    
    self.cache = [[LRUCache alloc] initWithCapacity:2];
    
    [self.cache setObject:[self testObj1] forKey:[self key1]];
    [self.cache setObject:[self testObj2] forKey:[self key2]];
    [self.cache setObject:[self testObj3] forKey:[self key3]];

    XCTAssertNil([self.cache objectForKey:[self key1]], @"cache should not store value which did not used recently");
    
}

- (void)testCacheShouldStoreRecentlyValueEventIfItWasAppendedFirst {
    
    self.cache = [[LRUCache alloc] initWithCapacity:2];
    
    [self.cache setObject:[self testObj1] forKey:[self key1]];
    [self.cache setObject:[self testObj2] forKey:[self key2]];
    
    [self.cache objectForKey:[self key1]];
    
    [self.cache setObject:[self testObj3] forKey:[self key3]];
    
    XCTAssert([[self.cache objectForKey:[self key1]] isEqual:[self testObj1]], @"cache should store recently used value even if it was appended earlier");
    
}

- (void)testCacheShouldNotStoreValueThatWasNotUsedRecentlyEvenIfItWasAppendedLater {
    self.cache = [[LRUCache alloc] initWithCapacity:2];
    
    [self.cache setObject:[self testObj1] forKey:[self key1]];
    [self.cache setObject:[self testObj2] forKey:[self key2]];
    
    [self.cache objectForKey:[self key1]];
    
    [self.cache setObject:[self testObj3] forKey:[self key3]];
    
    XCTAssertFalse([self.cache objectForKey:[self key2]], @"cache should not store value which did not used recently, even if it was appended later");
    
}

- (void)testCacheShouldStoreTheSameValueTwiceWithDifferentKeys {

    TestClass *obj1 = [self testObj1];
    
    [self.cache setObject:obj1 forKey:[self key1]];
    [self.cache setObject:obj1 forKey:[self key2]];
    
    XCTAssert([self.cache objectForKey:[self key1]] != nil &&
              [[self.cache objectForKey:[self key1]] isEqual:[self.cache objectForKey:[self key2]]], @"cache should store the same value with different keys");
    
}

- (void)testCacheShouldNotStoreNilValue {
    XCTAssertThrows([self.cache setObject:nil forKey:[self key1]], @"should throw exception for nil value");
    
    XCTAssertNil([self.cache objectForKey:[self key1]], @"cache should not store nil value");
}

- (void)testCacheShouldNotReplaceValuesWithNilValue {
    self.cache = [[LRUCache alloc] initWithCapacity:2];
    
    TestClass *obj3 = nil;
    
    [self.cache setObject:[self testObj1] forKey:[self key1]];
    [self.cache setObject:[self testObj2] forKey:[self key2]];
    
    XCTAssertThrows([self.cache setObject:obj3 forKey:[self key3]], @"should throw exception for nil value");
    XCTAssert([[self.cache objectForKey:[self key1]] isEqual:[self testObj1]] &&
              [[self.cache objectForKey:[self key2]] isEqual:[self testObj2]],  @"cache should not replace values with nil value");
    
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

- (void)testCacheShouldBeArchivedWithValues {
    [self.cache setObject:[self testObj1] forKey:[self key1]];
    [self.cache setObject:[self testObj2] forKey:[self key2]];
    [self.cache setObject:[self testObj3] forKey:[self key3]];
    
    NSData *archivedCache = [NSKeyedArchiver archivedDataWithRootObject:self.cache];
    
    LRUCache *cache2 = [NSKeyedUnarchiver unarchiveObjectWithData:archivedCache];
    
    XCTAssert([[cache2 objectForKey:[self key1]] isEqual:[self testObj1]] &&
              [[cache2 objectForKey:[self key2]] isEqual:[self testObj2]] &&
              [[cache2 objectForKey:[self key3]] isEqual:[self testObj3]], @"Cache should contains objects equal to original after archive/unarchive");
}

#pragma mark - helper methods

- (TestClass *)testObj1 {
    return [TestClass objectWithValue:@"1"];
}

- (TestClass *)testObj2 {
    return [TestClass objectWithValue:@"2"];
}

- (TestClass *)testObj3 {
    return [TestClass objectWithValue:@"3"];
}

- (NSString *)key1 {
    return @"key1";
}

- (NSString *)key2 {
    return @"key2";
}

- (NSString *)key3 {
    return @"key3";
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _value = [aDecoder decodeObjectForKey:@"value"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.value forKey:@"value"];
}
@end