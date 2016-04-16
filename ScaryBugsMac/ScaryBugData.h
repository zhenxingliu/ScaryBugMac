//
//  ScaryBugData.h
//  ScaryBugsMac
//
//  Created by 刘振兴 on 16/4/15.
//  Copyright © 2016年 zoneland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaryBugData : NSObject

@property(strong) NSString *title;
@property(assign) float rating;

-(id)initWithTitle:(NSString *)title rating:(float)rating;

@end
