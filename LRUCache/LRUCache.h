//
//  LRUCache.h
//  LRUCache
//
//  Created by Alexey Patosin on 26/02/15.
//  Copyright (c) 2015 TestOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRUCache : NSObject <NSCoding>

@property (nonatomic, readonly, assign) NSUInteger capacity;

- (instancetype)initWithCapacity:(NSUInteger)capacity;
- (void)setObject:(id)object forKey:(id<NSCopying>)key;
- (id)objectForKey:(id<NSCopying>)key;

@end
