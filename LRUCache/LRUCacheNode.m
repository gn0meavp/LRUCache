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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _value = [aDecoder decodeObjectForKey:@"kLRUCacheNodeValueKey"];
        _key = [aDecoder decodeObjectForKey:@"kLRUCacheNodeKey"];
        _next = [aDecoder decodeObjectForKey:@"kLRUCacheNodeNext"];
        _prev = [aDecoder decodeObjectForKey:@"kLRUCacheNodePrev"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.value forKey:@"kLRUCacheNodeValueKey"];
    [aCoder encodeObject:self.key forKey:@"kLRUCacheNodeKey"];
    [aCoder encodeObject:self.next forKey:@"kLRUCacheNodeNext"];
    [aCoder encodeObject:self.prev forKey:@"kLRUCacheNodePrev"];
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
