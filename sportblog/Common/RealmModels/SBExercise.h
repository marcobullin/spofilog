
@interface SBExercise : RLMObject
@property NSString *exerciseId;
@property NSString *name;
@property NSString *frontImages;
@property NSString *backImages;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SBExercise>
RLM_ARRAY_TYPE(SBExercise)
