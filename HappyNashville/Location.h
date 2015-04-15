//
//  Location.h
//  HappyNashville
//
//  Created by Richmond Watkins on 4/14/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DealDay;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSSet *dealDays;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addDealDaysObject:(DealDay *)value;
- (void)removeDealDaysObject:(DealDay *)value;
- (void)addDealDays:(NSSet *)values;
- (void)removeDealDays:(NSSet *)values;

@end
