//
//  main.m
//  LRUCache
//
//  Created by Alexey Patosin on 26/02/15.
//  Copyright (c) 2015 TestOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRUCache.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        // initial state of cache with capacity 3
        //      -,-,-
        LRUCache *cache = [[LRUCache alloc] initWithCapacity:3];
        
        // add 1
        //      1,-,-
        [cache setObject:@"1" forKey:@"1"];

        // add 2
        //      2,1,-
        [cache setObject:@"2" forKey:@"2"];
        
        // add 3
        //      3,2,1
        [cache setObject:@"3" forKey:@"3"];
        
        // add 4
        //      4,3,2       (1 removed as least recently used)
        [cache setObject:@"4" forKey:@"4"];

        // request 2
        //      2,4,3       (2 goes to the top as most recently used)
        NSLog(@"%@", [cache objectForKey:@"2"]);

        // add 5
        //      5,2,4       (3 removed as least recently used)
        [cache setObject:@"5" forKey:@"5"];
    
    }
    return 0;
}
