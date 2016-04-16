//
//  ScaryBugDoc.h
//  ScaryBugsMac
//
//  Created by 刘振兴 on 16/4/15.
//  Copyright © 2016年 zoneland. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ScaryBugData;

@interface ScaryBugDoc : NSObject

@property(strong) ScaryBugData *data;
@property(strong) NSImage *thumbImage;
@property(strong) NSImage *fullImage;

-(id)initWithTitle:(NSString *)title rating:(float)rating thumbImage:(NSImage *)thumbImage fullImage:(NSImage *)fullImage;

@end
