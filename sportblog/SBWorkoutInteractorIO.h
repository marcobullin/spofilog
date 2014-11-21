@protocol SBWorkoutInteractorInput <NSObject>

- (void)findExercisesFromWorkout:(NSDictionary *)workout;

- (void)removeExercise:(NSDictionary *)exercise fromWorkout:(NSDictionary *)workout atIndex:(int)index;
- (void)addExercise:(NSDictionary *)exercise toWorkoutWithId:(NSString *)workoutId;
- (void)updateWorkout:(NSDictionary *)workout withName:(NSString *)workoutName andDate:(NSDate *)workoutDate;
@end

@protocol SBWorkoutInteractorOutput <NSObject>
- (void)exerciseDeletedAtIndex:(int)index;
- (void)addedExercise:(NSDictionary *)exercise;
- (void)updatedWorkoutWithName:(NSString *)name andDate:(NSDate *)date;
- (void)foundExercises:(NSArray *)exercises;
@end