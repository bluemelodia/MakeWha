//
//  WishList.m
//  BuyBuyBye
//
//  Created by Nina Baculinao on 1/17/15.
//  Copyright (c) 2015 JohnnyChen. All rights reserved.
//

#import "WishList.h"

static NSString *const LIST_ARRAY = @"ListArray";

@implementation WishList {
    NSMutableArray *_list;
}

+(id) sharedHelper {
    static WishList *sharedHelper = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{sharedHelper = [[self alloc] init];});
    return sharedHelper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (![[NSUserDefaults standardUserDefaults]dataForKey:LIST_ARRAY]) {
            _list = [[NSMutableArray alloc] init];
            NSLog(@"NEW ARRAY");
            [[NSUserDefaults standardUserDefaults]setObject:_list forKey:LIST_ARRAY];
        }
        else {
            NSData *savedData = [[NSUserDefaults standardUserDefaults]dataForKey:LIST_ARRAY];
            _list = [NSKeyedUnarchiver unarchiveObjectWithData:savedData];
            NSLog(@"USE PREVIOUS");
            
            int size = [_list count];
            NSLog(@"there are %d objects in the array", size);
        }
    }
   
    return self;
}

- (void)addItem:(Item *) item {
    [_list addObject:item];
    //must do this for all custom objects that don't fit property list
    NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:_list];
    

    
    // Updates LIST_ARRAY with newest _list
    [[NSUserDefaults standardUserDefaults]setObject:savedData forKey:LIST_ARRAY];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"%@", _list);
    for (Item *item in _list){
        NSLog(@"%@", item.name);
        NSLog(@"%@", item.time);
    }
    
    int size = [_list count];
    NSLog(@"there are %d objects in the array", size);
}

- (void)expired {
    for (Item *entry in _list) {
        Boolean expired = [self expirycheck:entry.time];
        NSLog(@"%d", expired);
    }
}

- (BOOL)expirycheck:(NSDate *)expiry
{
    NSDate* enddate = expiry;
    NSDate* currentdate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}

- (void)deleteItem:(Item *) item {
    //TODO: find the SPECIFIC item you must delete
    NSString *target = [NSString stringWithFormat:@"%@",item];
    for (Item *entry in _list) {
        if ([entry.name isEqualToString:target]) {
            [_list removeObject:entry];
        }
    }
    for (Item *item in _list){
        NSLog(@"%@", item.name);
        NSLog(@"%@", item.time);
    }
    
    int size = [_list count];
    NSLog(@"there are %d objects in the array", size);
}

- (NSArray *)list {
    return _list;
}

@end
