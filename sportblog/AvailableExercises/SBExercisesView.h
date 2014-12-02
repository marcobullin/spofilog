@protocol SBExercisesView <NSObject>

- (void)displayExercises:(NSArray *)exercises;
- (void)deletedExerciseAtIndex:(int)index;
- (void)createdExercise:(NSDictionary *)exercise;
- (void)scrollToExerciseWithName:(NSString *)name;

@end