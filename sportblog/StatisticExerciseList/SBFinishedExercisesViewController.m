#import "SBFinishedExercisesViewController.h"
#import "SBStatisticViewController.h"
#import "SBStandardCell.h"
#import "SBDescriptionCell.h"
#import "UIColor+SBColor.h"
#import "SBStatisticExerciseInteractor.h"

@interface SBFinishedExercisesViewController ()

@property (nonatomic, strong) NSArray *exercises;

@end

static NSString * const ExerciseCellIdentifier = @"ExerciseCell";
static NSString * const DescriptionCellIdentifier = @"DescriptionCell";

@implementation SBFinishedExercisesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Exercises", nil);
        self.tabBarItem.title = NSLocalizedString(@"Statistics", nil);
        self.tabBarItem.image = [[UIImage imageNamed:@"statsUnselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"stats"];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Statistic Exercises Screen";
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.presenter findDistinctExerciseNames];
}

#pragma mark - Actions
- (void)displayExerciseNames:(NSArray *)names {
    self.exercises = names;
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.exercises count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        SBDescriptionCell *descCell = (SBDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:DescriptionCellIdentifier];
        
        if (descCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBDescriptionCell" owner:self options:nil];
            descCell = [nib objectAtIndex:0];
        }
        
        descCell.descriptionLabel.numberOfLines = 0;
        descCell.selectionStyle = UITableViewCellSelectionStyleNone;

        if ([self.exercises count] == 0) {
            descCell.descriptionLabel.text = NSLocalizedString(@"No Finished Exercises", nil);
            descCell.descriptionLabel.textColor = [UIColor lightGrayColor];

            self.tableView.tableFooterView = [UIView new];
        } else {
            descCell.descriptionLabel.text = NSLocalizedString(@"Finished Exercises Description", nil);
            descCell.descriptionLabel.textColor = [UIColor grayColor];
        }
        
        return descCell;
    }
    
    
    SBStandardCell *exerciseCell = (SBStandardCell *)[tableView dequeueReusableCellWithIdentifier:ExerciseCellIdentifier];
    
    if (exerciseCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBStandardCell" owner:self options:nil];
        exerciseCell = [nib objectAtIndex:0];
    }
    int index = (int)indexPath.row - 1;
    
    exerciseCell.label.text = [self.exercises objectAtIndex:index];
    exerciseCell.label.textColor = [UIColor headlineColor];
    
    return exerciseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    
    SBStatisticViewController *stats = [[SBStatisticViewController alloc] initWithNibName:@"SBStatisticViewController" bundle:nil];
    
    SBStatisticExerciseInteractor *interactor = [SBStatisticExerciseInteractor new];
    SBStatisticExercisePresenter *presenter = [SBStatisticExercisePresenter new];
    
    stats.presenter = presenter;
    presenter.view = stats;
    presenter.interactor = interactor;
    interactor.output = presenter;
    
    int index = (int)indexPath.row - 1;
    
    stats.exerciseName = [self.exercises objectAtIndex:index];
    
    [self.navigationController pushViewController:stats animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && [self.exercises count] == 0) {
        return 120;
    }
    
    if (indexPath.row == 0 && [self.exercises count] > 0) {
        return 80;
    }
    
    return 60;
}

@end
