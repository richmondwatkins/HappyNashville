//
//  DealDay.h
//  HappyNashville
//
//  Created by Richmond Watkins on 4/22/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, Notification, Special;

@interface DealDay : NSManagedObject

@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * isOpen;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) Notification *notification;
@property (nonatomic, retain) NSSet *specials;
@end

@interface DealDay (CoreDataGeneratedAccessors)

- (void)addSpecialsObject:(Special *)value;
- (void)removeSpecialsObject:(Special *)value;
- (void)addSpecials:(NSSet *)values;
- (void)removeSpecials:(NSSet *)values;

@end
