#import <Foundation/Foundation.h>
#import "SBStatisticExerciseListInteractorIO.h"
#import "SBStatisticExerciseListView.h"

@interface SBStatisticExerciseListPresenter : NSObject <SBStatisticExerciseListInteractorOutput>

@property (nonatomic, strong) id<SBStatisticExerciseListInteractorInput> interactor;
@property (nonatomic, strong) id<SBStatisticExerciseListView> view;

- (void)findDistinctExerciseNames;

@end
