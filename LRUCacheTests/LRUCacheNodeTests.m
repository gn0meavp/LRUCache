//
//  LRUCacheNodeTests.m
//  LRUCache
//
//  Created by Alexey Patosin on 26/02/15.
//  Copyright (c) 2015 TestOrg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "LRUCacheNode.h"

@interface LRUCacheNodeTests : XCTestCase
@end

@implementation LRUCacheNodeTests

- (void)testNodeShouldStoreValue {
    NSString *value = @"value";
    NSString *key = @"key";
    LRUCacheNode *node = [LRUCacheNode nodeWithValue:value key:key];
    XCTAssert([node.value isEqual:value], @"Node should store value");
}

- (void)testNodeShouldStoreKey {
    NSString *value = @"value";
    NSString *key = @"key";
    LRUCacheNode *node = [LRUCacheNode nodeWithValue:value key:key];
    
    NSString *receivedKey = (NSString *)node.key;
    
    XCTAssert([receivedKey isEqual:key], @"Node should store key");
}

- (void)testNodeShouldStorePrevBySpecifingNext {
    NSString *value1 = @"value1";
    NSString *key1 = @"key1";
    LRUCacheNode *node1 = [LRUCacheNode nodeWithValue:value1 key:key1];

    NSString *value2 = @"value2";
    NSString *key2 = @"key2";
    LRUCacheNode *node2 = [LRUCacheNode nodeWithValue:value2 key:key2];
    
    node1.next = node2;
    
    XCTAssert(node2.prev == node1 , @"Node should store prev by specifying next");
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
