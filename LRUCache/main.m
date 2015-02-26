//
//  main.m
//  LRUCache
//
//  Created by Alexey Patosin on 26/02/15.
//  Copyright (c) 2015 TestOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRUCache.h"

// LRU Cache sample

// initial state for capacity 3
//      -,-,-
// add 1
//      1,-,-
// add 2
//      2,1,-
// add 3
//      3,2,1
// add 4
//      4,3,2
// request 2
//      2,4,3

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        LRUCache *cache = [[LRUCache alloc] initWithCapacity:3];
        
        [cache setObject:@"1" forKey:@"1"];
        [cache setObject:@"2" forKey:@"2"];
        [cache setObject:@"3" forKey:@"3"];
        [cache setObject:@"4" forKey:@"4"];

        NSLog(@"%@", [cache objectForKey:@"2"]);

        [cache setObject:@"5" forKey:@"5"];
    
    }
    return 0;
}
