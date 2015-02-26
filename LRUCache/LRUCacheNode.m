//
//  LRUCacheNode.m
//  LRUCache
//
//  Created by Alexey Patosin on 26/02/15.
//  Copyright (c) 2015 TestOrg. All rights reserved.
//

#import "LRUCacheNode.h"

@interface LRUCacheNode ()
@property (nonatomic, strong, readwrite) id value;
@property (nonatomic, strong, readwrite) id<NSCopying> key;
@end

@implementation LRUCacheNode

- (instancetype)initWithValue:(id)value key:(id<NSCopying>)key {
    if (value == nil) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _value = value;
        _key = key;
    }
    return self;
}

+ (instancetype)nodeWithValue:(id)value key:(id<NSCopying>)key {
    return [[LRUCacheNode alloc] initWithValue:value key:key];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.value, self.next];
}

- (void)setNext:(LRUCacheNode *)next {
    if (_next != next) {
        _next = next;
        next.prev = self;
    }
}

@end
