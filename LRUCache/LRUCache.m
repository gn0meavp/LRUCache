//
//  LRUCache.m
//  LRUCache
//
//  Created by Alexey Patosin on 26/02/15.
//  Copyright (c) 2015 TestOrg. All rights reserved.
//

#import "LRUCache.h"
#import "LRUCacheNode.h"

@interface LRUCache ()
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) LRUCacheNode *rootNode;
@property (nonatomic, strong) LRUCacheNode *tailNode;
@property (nonatomic) NSUInteger size;
@end

@implementation LRUCache

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        [self commonSetup];        
        _capacity = capacity;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self commonSetup];
        _capacity = [aDecoder decodeIntegerForKey:@"kLRUCacheCapacityCoderKey"];
        _rootNode = [aDecoder decodeObjectForKey:@"kLRUCacheRootNodeCoderKey"];
        _tailNode = [aDecoder decodeObjectForKey:@"kLRUCacheTailNodeCoderKey"];
        _dictionary = [aDecoder decodeObjectForKey:@"kLRUCacheDictionaryCoderKey"];
        _size = [aDecoder decodeIntegerForKey:@"kLRUCacheSizeCoderKey"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.capacity forKey:@"kLRUCacheCapacityCoderKey"];
    [aCoder encodeObject:self.rootNode forKey:@"kLRUCacheRootNodeCoderKey"];
    [aCoder encodeObject:self.rootNode forKey:@"kLRUCacheTailNodeCoderKey"];
    [aCoder encodeObject:self.dictionary forKey:@"kLRUCacheDictionaryCoderKey"];
    [aCoder encodeInteger:self.size forKey:@"kLRUCacheSizeCoderKey"];
}

- (void)commonSetup {
    _dictionary = [NSMutableDictionary dictionary];
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {

    NSAssert(object != nil, @"LRUCache cannot store nil object!");
    
    LRUCacheNode *node = self.dictionary[key];
    if (node == nil) {
        node = [LRUCacheNode nodeWithValue:object key:key];
        self.dictionary[key] = node;
        self.size++;
        
        if (self.tailNode == nil) {
            self.tailNode = node;
        }
        if (self.rootNode == nil) {
            self.rootNode = node;
        }
    }
    
    [self putNodeToTop:node];
    
    [self checkSpace];
}

- (void)putNodeToTop:(LRUCacheNode *)node {
    
    if (node == self.rootNode) {
        return;
    }
    
    if (node == self.tailNode) {
        self.tailNode = self.tailNode.prev;
    }
    
    self.rootNode.prev.next = node.next;
    
    LRUCacheNode *prevRoot = self.rootNode;
    self.rootNode = node;
    self.rootNode.next = prevRoot;
}

- (void)checkSpace {
    if (self.size > self.capacity) {
        LRUCacheNode *nextTail = self.tailNode.prev;
        [self.dictionary removeObjectForKey:self.tailNode.key];
        self.tailNode = nextTail;
        self.tailNode.next = nil;
        self.size--;
    }
}

- (id)objectForKey:(id<NSCopying>)key {
    LRUCacheNode *node = self.dictionary[key];
    if (node) {
        [self putNodeToTop:node];
    }
    return node.value;
}

@end
