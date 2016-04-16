//
//  ScaryBugData.m
//  ScaryBugsMac
//
//  Created by 刘振兴 on 16/4/15.
//  Copyright © 2016年 zoneland. All rights reserved.
//

#import "ScaryBugData.h"

@implementation ScaryBugData

-(id)initWithTitle:(NSString *)title rating:(float)rating{
    if (self = [super init]) {
        self.title = title;
        self.rating = rating;
    }
    return self;
}

@end
