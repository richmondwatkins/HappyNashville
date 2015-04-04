//
//  Special.h
//  HappyNashville
//
//  Created by Richmond Watkins on 4/4/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Deal;

@interface Special : NSManagedObject

@property (nonatomic, retain) NSString * specialDescription;
@property (nonatomic, retain) NSNumber * allDay;
@property (nonatomic, retain) NSNumber * hourStart;
@property (nonatomic, retain) NSNumber * minuteStart;
@property (nonatomic, retain) NSNumber * hourEnd;
@property (nonatomic, retain) NSNumber * minuteEnd;
@property (nonatomic, retain) Deal *deal;

@end
