#import <UIKit/UIKit.h>
#import "PCLineChartView.h"
#import "SBAbstractViewController.h"
#import "SBStatisticExercisePresenter.h"
#import "SBStatisticExerciseView.h"

@interface SBStatisticViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, SBStatisticExerciseView>
@property (nonatomic, strong) NSString *exerciseName;
@property (nonatomic, strong) PCLineChartView *lineChartView;
@property (nonatomic, strong) SBStatisticExercisePresenter *presenter;
@end
