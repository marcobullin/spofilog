#import <Realm/Realm.h>
#import "SBSet.h"

@interface SBExerciseSet : RLMObject
@property NSString *name;
@property NSDate *date;
@property RLMArray<SBSet> *sets;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SBExercise>
RLM_ARRAY_TYPE(SBExerciseSet)