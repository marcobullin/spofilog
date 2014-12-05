@protocol SBStatisticExerciseListInteractorInput <NSObject>

- (void)findDistinctExerciseNames;

@end

@protocol SBStatisticExerciseListInteractorOutput <NSObject>

- (void)foundDistinctExerciseNames:(NSArray *)names;

@end