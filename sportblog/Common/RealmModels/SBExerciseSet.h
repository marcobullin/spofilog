#import "SBSet.h"

@interface SBExerciseSet : RLMObject
@property NSString *exerciseId;
@property NSString *name;
@property NSDate *date;
@property RLMArray<SBSet> *sets;
@property int created;
@property NSString *frontImages;
@property NSString *backImages;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SBExercise>
RLM_ARRAY_TYPE(SBExerciseSet)
