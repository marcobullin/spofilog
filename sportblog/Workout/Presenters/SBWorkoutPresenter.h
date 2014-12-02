#import <Foundation/Foundation.h>
#import "SBWorkoutView.h"
#import "SBWorkoutInteractorIO.h"

@interface SBWorkoutPresenter : NSObject <SBWorkoutInteractorOutput>

@property(nonatomic, strong) id<SBWorkoutInteractorInput> workoutInteractor;
@property(nonatomic, strong) id<SBWorkoutView> view;

- (void)findExercisesFromWorkout:(NSDictionary *)workout;
- (void)addExercise:(NSDictionary *)exercise toWorkout:(NSDictionary *)workout;
- (void)removeExercise:(NSDictionary *)exercise fromWorkout:(NSDictionary *)workout atIndex:(int)index;
- (void)updateWorkout:(NSDictionary *)workout withName:(NSString *)name andDate:(NSDate *)date;

@end
