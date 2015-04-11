//
//  Location.h
//  HappyNashville
//
//  Created by Richmond Watkins on 4/4/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Deal;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * locId;
@property (nonatomic, retain) NSString * coordinates;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSNumber * rating;
@property double lat;
@property double lng;
@property (nonatomic, retain) Deal *deal;

@end
