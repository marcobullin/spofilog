@protocol SBSetListInteractorInput <NSObject>

- (void)deleteSet:(NSDictionary *)set fromExercise:(NSDictionary *)exercise atIndex:(int)index;
- (void)createSetDependingOnSet:(NSDictionary *)set andAddToExercise:(NSDictionary *)exercise;
- (void)createSetDependingOnLastExerciseWithNumber:(int)number andAddToExercise:(NSDictionary *)exercise withFallbackWeight:(float)weight andFallbackRepetitions:(int)repetitions;

@end

@protocol SBSetListInteractorOutput <NSObject>

- (void)deletedSetAtIndex:(int)index;
- (void)createdSet:(NSDictionary *)set;

@end