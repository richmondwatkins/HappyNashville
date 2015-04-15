//
//  DealDay.h
//  HappyNashville
//
//  Created by Richmond Watkins on 4/14/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, Notification, Special;

@interface DealDay : NSManagedObject

@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSSet *specials;
@property (nonatomic, retain) Notification *notification;
@end

@interface DealDay (CoreDataGeneratedAccessors)

- (void)addSpecialsObject:(Special *)value;
- (void)removeSpecialsObject:(Special *)value;
- (void)addSpecials:(NSSet *)values;
- (void)removeSpecials:(NSSet *)values;

@end
