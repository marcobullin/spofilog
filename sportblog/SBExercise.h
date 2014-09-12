//
//  SBExercise.h
//  sportblog
//
//  Created by Bullin, Marco on 11.09.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <Realm/Realm.h>
#import "SBSet.h"

@interface SBExercise : RLMObject
@property NSString *name;
@property RLMArray<SBSet> *sets;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SBExercise>
RLM_ARRAY_TYPE(SBExercise)
