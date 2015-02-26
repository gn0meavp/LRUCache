//
//  LRUCacheNode.h
//  LRUCache
//
//  Created by Alexey Patosin on 26/02/15.
//  Copyright (c) 2015 TestOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRUCacheNode : NSObject<NSCoding>

@property (nonatomic, strong, readonly) id value;
@property (nonatomic, strong, readonly) id<NSCopying> key;
@property (nonatomic, strong) LRUCacheNode *next;
@property (nonatomic, strong) LRUCacheNode *prev;

+ (instancetype)nodeWithValue:(id)value key:(id<NSCopying>)key;
- (instancetype)initWithValue:(id)value key:(id<NSCopying>)key;

@end
