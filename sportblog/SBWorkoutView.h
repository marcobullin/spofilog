#import <Foundation/Foundation.h>

@protocol SBWorkoutView <NSObject>

- (void)displayExerciseDetails:(NSDictionary *)exercise;
- (void)displayUpdatedWorkout;

@end

