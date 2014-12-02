#import "SBSetListPresenter.h"

@implementation SBSetListPresenter

- (void)deleteSet:(NSDictionary *)set fromExercise:(NSDictionary *)exercise atIndex:(int)index {
    [self.interactor deleteSet:set fromExercise:exercise atIndex:index];
}

- (void)deletedSetAtIndex:(int)index {
    [self.view deleteSetAtIndex:index];
}

- (void)createSetDependingOnSet:(NSDictionary *)set andAddToExercise:(NSDictionary *)exercise {
    [self.interactor createSetDependingOnSet:set andAddToExercise:exercise];
}

- (void)createSetDependingOnLastExerciseWithNumber:(int)number andAddToExercise:(NSDictionary *)exercise withFallbackWeight:(float)weight andFallbackRepetitions:(int)repetitions {
    [self.interactor createSetDependingOnLastExerciseWithNumber:number andAddToExercise:exercise withFallbackWeight:weight andFallbackRepetitions:repetitions];
}

- (void)createdSet:(NSDictionary *)set {
    [self.view displayCreatedSet:set];
}

@end
