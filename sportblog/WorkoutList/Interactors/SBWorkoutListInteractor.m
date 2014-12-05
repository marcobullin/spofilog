#import "SBWorkoutListInteractor.h"
#import "SBWorkoutDataSource.h"
#import "SBWorkout.h"

@implementation SBWorkoutListInteractor

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.datasource = [SBWorkoutDataSource new];
    }
    
    return self;
}

- (void)findAllWorkoutsOrderedByDate {
    RLMResults *workouts = [self.datasource allWorkoutsOrderedByDate];
    
    NSMutableArray *workoutsArray = [NSMutableArray new];
    for (SBWorkout *workout in workouts) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:workout.workoutId forKey:@"workoutId"];
        [dict setObject:workout.name forKey:@"name"];
        [dict setObject:workout.date forKey:@"date"];
        
        [workoutsArray addObject:dict];
    }
    
    [self.output foundWorkouts:workoutsArray];
}

- (void)createWorkout {
    SBWorkout *createdWorkout = [self.datasource createWorkoutWithName:NSLocalizedString(@"Workout", nil) andDate:[NSDate date]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[
                                                               createdWorkout.workoutId,
                                                               createdWorkout.name,
                                                               createdWorkout.date] forKeys:@[@"workoutId", @"name", @"date"]];
    
    [self.output workoutCreated:dict];
}

- (void)deleteWorkout:(NSDictionary *)workout atIndex:(int)index {
    [self.datasource deleteWorkoutWithId:workout[@"workoutId"]];
    
    [self.output workoutDeletedAtIndex:index];
}

@end
