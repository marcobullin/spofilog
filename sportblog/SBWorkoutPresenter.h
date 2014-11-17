#import <Foundation/Foundation.h>
#import "SBWorkoutView.h"
#import "SBWorkoutInteractorIO.h"

@interface SBWorkoutPresenter : NSObject <SBWorkoutInteractorOutput>

@property(nonatomic, strong) id<SBWorkoutInteractorInput> workoutInteractor;
@property(nonatomic, strong) id<SBWorkoutView> view;

- (void)removeExerciseWithId:(NSString *)exerciseId;
- (void)addExercise:(NSDictionary *)exercise toWorkoutWithId:(NSString *)workoutId;
- (void)updateWorkoutWithId:(NSString *)workoutId withName:(NSString *)workoutName andDate:(NSDate *)workoutDate;

@end
