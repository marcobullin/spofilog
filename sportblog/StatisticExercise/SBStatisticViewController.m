#import "SBStatisticViewController.h"
#import "PCHalfPieChart.h"
#import "SBStatisticCell.h"
#import "UIColor+SBColor.h"

@interface SBStatisticViewController ()

@property (nonatomic, strong) NSDictionary *data;

@end

static NSString * const StatisticCellIdentifier = @"StatisticCell";

@implementation SBStatisticViewController

NSArray *sectionTitles;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Statistic Screen";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sectionTitles = @[NSLocalizedString(@"Section Common", nil), NSLocalizedString(@"Section Sets", nil), NSLocalizedString(@"Section Weight", nil), NSLocalizedString(@"Section Repetitions", nil)];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.backgroundColor = [UIColor tableViewColor];
    
    self.title = self.exerciseName;
    [self.presenter findStatisticsForExerciseSetsWithName:self.exerciseName];
}

#pragma mark - Actions

- (void)displayStatisticsForExercises:(NSDictionary *)data {
    
    self.data = data;
    
    CGRect frame = CGRectMake(0,
                              self.navigationController.navigationBar.frame.size.height,
                              self.view.frame.size.width,
                              self.view.frame.size.height / 2);
    
    self.lineChartView = [[PCLineChartView alloc] initWithFrame:frame];
    self.lineChartView.autoscaleYAxis = YES;
    self.lineChartView.maxValue = [data[@"max"] floatValue] == 0 ? 100 : [data[@"max"] floatValue];
    
    UILabel *firstDateLabel = [UILabel new];
    firstDateLabel.text = data[@"firstDateText"];
    firstDateLabel.frame = CGRectMake(20, self.lineChartView.frame.size.height - 44, self.lineChartView.frame.size.width, 44);
    firstDateLabel.font = [UIFont boldSystemFontOfSize:12];
    
    UILabel *lastDateLabel = [UILabel new];
    lastDateLabel.text = data[@"lastDateText"];
    lastDateLabel.frame = CGRectMake(0, self.lineChartView.frame.size.height - 44, self.lineChartView.frame.size.width - 20, 44);
    lastDateLabel.font = [UIFont boldSystemFontOfSize:12];
    lastDateLabel.textAlignment = NSTextAlignmentRight;
    lastDateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.lineChartView addSubview:firstDateLabel];
    [self.lineChartView addSubview:lastDateLabel];
    
    NSMutableArray *components = [NSMutableArray array];
    
    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
    component.title = NSLocalizedString(@"kg", nil);
    [component setPoints:data[@"weights"]];
    [components addObject:component];
    
    PCLineChartViewComponent *repetitionComponent = [[PCLineChartViewComponent alloc] init];
    repetitionComponent.title = NSLocalizedString(@"reps", nil);
    repetitionComponent.colour = PCColorOrange;
    [repetitionComponent setPoints:data[@"reps"]];
    [components addObject:repetitionComponent];
    
    [self.lineChartView setComponents:components];
    [self.lineChartView setXLabels:data[@"labels"]];
    
    self.tableView.tableHeaderView = self.lineChartView;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self.lineChartView setNeedsDisplay];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        return 1;
    }
    
    if (section == 2) {
        return 4;
    }
    
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SBStatisticCell *cell = (SBStatisticCell *)[tableView dequeueReusableCellWithIdentifier:StatisticCellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBStatisticCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.headlineLabel.backgroundColor = [UIColor clearColor];
    cell.headlineLabel.textColor = [UIColor textColor];
    cell.headlineLabel.font = [UIFont systemFontOfSize:14];
    cell.headlineLabel.numberOfLines = 0;
    cell.valueLabel.textColor = [UIColor importantCellColor];
    cell.valueLabel.font = [UIFont boldSystemFontOfSize:22];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.headlineLabel.text = NSLocalizedString(@"Total times of making this exercise", nil);
            cell.valueLabel.text = self.data[@"exerciseCount"];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.headlineLabel.text = NSLocalizedString(@"Total amount of sets", nil);
            cell.valueLabel.text = self.data[@"statisticCountOfSets"];
        }
    }

    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.headlineLabel.text = NSLocalizedString(@"Your minimum weight", nil);
            cell.valueLabel.text = self.data[@"statisticMinWeight"];
        }
        
        if (indexPath.row == 1) {
            cell.headlineLabel.text = NSLocalizedString(@"Your maximum weight", nil);
            cell.valueLabel.text = self.data[@"statisticMaxWeight"];
        }
        
        if (indexPath.row == 2) {
            cell.headlineLabel.text = NSLocalizedString(@"Your Weight-Progress From First To Last Exercise", nil);
            cell.valueLabel.text = self.data[@"firstWeight"];
        }
        
        if (indexPath.row == 3) {
            cell.headlineLabel.text = NSLocalizedString(@"Your Averrage Weight-Progress From Set To Set", nil);
            cell.valueLabel.text = self.data[@"statisticProgress"];
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.headlineLabel.text = NSLocalizedString(@"Min Repetitions", nil);
            cell.valueLabel.text = self.data[@"minRepetitions"];
        }
        
        if (indexPath.row == 1) {
            cell.headlineLabel.text = NSLocalizedString(@"Max Repetitions", nil);
            cell.valueLabel.text = self.data[@"maxRepetitions"];
        }

        if (indexPath.row == 2) {
            cell.headlineLabel.text = NSLocalizedString(@"Average Repetitions", nil);
            cell.valueLabel.text = self.data[@"averageRepetitions"];
        }
        
        if (indexPath.row == 3) {
            cell.headlineLabel.text = NSLocalizedString(@"Total amount of repetitions", nil);
            cell.valueLabel.text = self.data[@"statisticRepetitions"];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeader = [UIView.alloc initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    UILabel *lblTitle = [UILabel.alloc initWithFrame:CGRectMake(5, 2, tableView.frame.size.width, 24)];
    
    [lblTitle setFont:[UIFont boldSystemFontOfSize:20]];
    [lblTitle setTextColor:[UIColor headlineColor]];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setText:[sectionTitles objectAtIndex:section]];
    [viewHeader addSubview:lblTitle];
    viewHeader.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1];
    return viewHeader;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.lineChartView removeFromSuperview];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

@end
