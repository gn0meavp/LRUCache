//
//  LRUCache.m
//  LRUCache
//
//  Created by Alexey Patosin on 26/02/15.
//  Copyright (c) 2015 TestOrg. All rights reserved.
//

#import "LRUCache.h"
#import "LRUCacheNode.h"

static const char *kLRUCacheQueue = "kLRUCacheQueue";

@interface LRUCache ()
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) LRUCacheNode *rootNode;
@property (nonatomic, strong) LRUCacheNode *tailNode;
@property (nonatomic) NSUInteger size;
@property (nonatomic, strong) dispatch_queue_t queue;
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
    _queue = dispatch_queue_create(kLRUCacheQueue, 0);
}

#pragma mark - set object / get object methods

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
    
    NSAssert(object != nil, @"LRUCache cannot store nil object!");
    
    dispatch_barrier_async(self.queue, ^{
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
        
    });
}


- (id)objectForKey:(id<NSCopying>)key {
    __block LRUCacheNode *node = nil;
    
    dispatch_sync(self.queue, ^{
        node = self.dictionary[key];
        
        if (node) {
            [self putNodeToTop:node];
        }
        
    });
    
    return node.value;
}

#pragma mark - helper methods

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

@end
