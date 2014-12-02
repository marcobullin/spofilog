#import <UIKit/UIKit.h>
#import "SBExerciseSet.h"
#import "SBSetViewController.h"
#import "SBAbstractViewController.h"
#import "SBSetListView.h"
#import "SBSetListPresenter.h"

@interface SBSetsViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, SBSetListView>

@property (nonatomic, strong) NSDictionary *exercise;
@property (nonatomic, strong) NSMutableArray *sets;
@property (nonatomic, strong) SBSetListPresenter *presenter;

@end
