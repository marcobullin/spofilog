#import "SBIconListInteractor.h"
#import "SBWorkoutDataSource.h"

@implementation SBIconListInteractor

- (void)updateExercise:(NSDictionary *)exercise withFrontImages:(NSArray *)images atIndexPath:(NSIndexPath *)indexPath {
    SBWorkoutDataSource *datasource = [SBWorkoutDataSource new];
    [datasource updateExerciseWithName:exercise[@"name"] withFrontImages:images];
    
    NSDictionary *icons = @{@"frontImages": images};
    
    [self.output updatedIcons:icons atIndexPath:indexPath];
}

- (void)updateExercise:(NSDictionary *)exercise withBackImages:(NSArray *)images atIndexPath:(NSIndexPath *)indexPath {
    SBWorkoutDataSource *datasource = [SBWorkoutDataSource new];
    [datasource updateExerciseWithName:exercise[@"name"] withBackImages:images];
    
    NSDictionary *icons = @{@"backImages" : images};
    
    [self.output updatedIcons:icons atIndexPath:indexPath];
}

@end
