#import <UIKit/UIKit.h>
#import "SBAbstractViewController.h"
#import "SBIconListView.h"
#import "SBIconListPresenter.h"

@interface SBIconListViewController : SBAbstractViewController <UITableViewDataSource, UITableViewDelegate, SBIconListView>

@property (nonatomic, strong) NSDictionary *exercise;
@property (nonatomic, strong) NSArray *frontImages;
@property (nonatomic, strong) NSArray *backImages;
@property (nonatomic) BOOL isFrontBody;
@property (nonatomic, strong) SBIconListPresenter *presenter;

@end
