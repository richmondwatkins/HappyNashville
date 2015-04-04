//
//  Deal.h
//  HappyNashville
//
//  Created by Richmond Watkins on 4/4/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, Special;

@interface Deal : NSManagedObject

@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSSet *specials;
@end

@interface Deal (CoreDataGeneratedAccessors)

- (void)addSpecialsObject:(Special *)value;
- (void)removeSpecialsObject:(Special *)value;
- (void)addSpecials:(NSSet *)values;
- (void)removeSpecials:(NSSet *)values;

@end
