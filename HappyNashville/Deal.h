//
//  Deal.h
//  HappyNashville
//
//  Created by Richmond Watkins on 4/1/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Deal : NSManagedObject

@property (nonatomic, retain) NSNumber * allDay;
@property (nonatomic, retain) NSString * dealDescription;
@property (nonatomic, retain) NSString * timeEnd;
@property (nonatomic, retain) NSString * timeStart;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) Location *location;

@end
