@protocol SBStatisticExerciseInteractorInput <NSObject>

- (void)findExerciseSetsByName:(NSString *)name;

@end

@protocol SBStatisticExerciseInteractorOutput <NSObject>

- (void)foundExerciseSets:(NSArray *)exercises;

@end