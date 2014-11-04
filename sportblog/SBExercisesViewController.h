#import <UIKit/UIKit.h>
#import "SBExercise.h"
#import "SBAbstractViewController.h"
#import "SBExerciseInteractor.h"

@class SBExercisesViewController;

@protocol SBExerciseViewControllerDelegate <NSObject>
- (void)addExercisesViewController:(SBExercisesViewController *)controller didSelectExercise:(SBExercise *) exercise;
@end

@interface SBExercisesViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id <SBExerciseViewControllerDelegate> delegate;
@property (nonatomic, strong) RLMResults *exercises;
@property (nonatomic, strong) SBExerciseInteractor *exerciseInteractor;

@end
