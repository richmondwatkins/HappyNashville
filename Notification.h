//
//  Notification.h
//  HappyNashville
//
//  Created by Richmond Watkins on 4/14/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DealDay;

@interface Notification : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * notifId;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSNumber * isRecurring;

@end
