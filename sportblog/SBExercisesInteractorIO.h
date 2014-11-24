@protocol SBExercisesInteractorInput <NSObject>

- (void)findExercisesOrderedByName;
- (void)deleteExercise:(NSDictionary *)exercise atIndex:(int)index;
- (void)createExerciseWithName:(NSString *)name;
- (void)createBulkOfExercises;

@end

@protocol SBExercisesInteractorOutput <NSObject>

- (void)foundExercises:(NSArray *)exercises;
- (void)deletedExerciseAtIndex:(int)index;
- (void)exerciseCreated:(NSDictionary *)exercise;
- (void)exerciseAllreadyExists:(NSString *)name;

@end