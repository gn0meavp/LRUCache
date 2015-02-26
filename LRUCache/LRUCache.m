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
@property (nonatomic, strong) LRUCacheNode *tail;
@property (nonatomic) NSUInteger size;
@end

@implementation LRUCache

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        _capacity = capacity;
        _dictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {

    NSAssert(object != nil, @"LRUCache cannot store nil object!");
    
    LRUCacheNode *node = self.dictionary[key];
    if (node == nil) {
        node = [LRUCacheNode nodeWithValue:object key:key];
        self.dictionary[key] = node;
        self.size++;
        
        if (self.tail == nil) {
            self.tail = node;
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
    
    if (node == self.tail) {
        self.tail = self.tail.prev;
    }
    
    self.rootNode.prev.next = node.next;
    
    LRUCacheNode *prevRoot = self.rootNode;
    self.rootNode = node;
    self.rootNode.next = prevRoot;
}

- (void)checkSpace {
    if (self.size > self.capacity) {
        LRUCacheNode *nextTail = self.tail.prev;
        [self.dictionary removeObjectForKey:self.tail.key];
        self.tail = nextTail;
        self.tail.next = nil;
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
