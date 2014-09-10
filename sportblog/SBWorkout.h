//
//  SBWorkout.h
//  sportblog
//
//  Created by Bullin, Marco on 10.09.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <Realm/Realm.h>

@interface SBWorkout : RLMObject
@property NSString *name;
@property NSDate *date;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SBWorkout>
RLM_ARRAY_TYPE(SBWorkout)
