#import <UIKit/UIKit.h>
#import "SBExercise.h"
#import "SBAbstractViewController.h"
#import "SBExercisesView.h"
#import "SBExercisesPresenter.h"

@class SBExercisesViewController;

@protocol SBExerciseViewControllerDelegate <NSObject>
- (void)addExercisesViewController:(SBExercisesViewController *)controller didSelectExercise:(NSDictionary *) exercise;
@end

@interface SBExercisesViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SBExercisesView>

@property (nonatomic, weak) id <SBExerciseViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *exercises;
@property (nonatomic, strong) SBExercisesPresenter *presenter;

@end
