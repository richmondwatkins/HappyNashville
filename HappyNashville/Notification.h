//
//  Notification.h
//  HappyNashville
//
//  Created by Richmond Watkins on 4/5/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Deal;

@interface Notification : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Deal *deal;

@end
