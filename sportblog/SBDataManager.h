//
//  SBDataManager.h
//  sportblog
//
//  Created by Marco Bullin on 03/10/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBWorkout.h"

@interface SBDataManager : NSObject

+ (void)deleteWorkout:(SBWorkout *)workout;

@end
