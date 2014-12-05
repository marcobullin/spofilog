#import "SBStatisticExerciseListPresenter.h"

@implementation SBStatisticExerciseListPresenter

- (void)findDistinctExerciseNames {
    [self.interactor findDistinctExerciseNames];
}

- (void)foundDistinctExerciseNames:(NSArray *)names {
    [self.view displayExerciseNames:names];
}

@end
