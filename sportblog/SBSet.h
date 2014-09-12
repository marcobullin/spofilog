//
//  SBSet.h
//  sportblog
//
//  Created by Bullin, Marco on 12.09.14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import <Realm/Realm.h>

@interface SBSet : RLMObject
@property int number;
@property float weight;
@property int repetitions;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SBSet>
RLM_ARRAY_TYPE(SBSet)
