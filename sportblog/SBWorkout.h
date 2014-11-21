#import "SBExerciseSet.h"

@interface SBWorkout : RLMObject
@property NSString *workoutId;
@property NSString *name;
@property NSDate *date;
@property RLMArray<SBExerciseSet> *exercises;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SBWorkout>
RLM_ARRAY_TYPE(SBWorkout)
