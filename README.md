# LRUCache
Objective-C Implementation of the LRU Cache.
http://en.wikipedia.org/wiki/Cache_algorithms

Provide easy access to the most recently used objects by key (used NSDictionary and Linked List inside).

## Complexity
Getting an element: O(1)

Adding an element: O(1)

## Sample of usage

```objectivec
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
```

## NSCoding

Supports NSCoding protocol, so the cache can be archived/unarchived with all stored values (which also should support NSCoding protocol in that way).
