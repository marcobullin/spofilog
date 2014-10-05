
@interface SBExercise : RLMObject
@property NSString *name;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SBExercise>
RLM_ARRAY_TYPE(SBExercise)
