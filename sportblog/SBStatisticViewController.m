//
//  SBStatisticViewController.m
//  sportblog
//
//  Created by Marco Bullin on 16/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBStatisticViewController.h"
#import "SBExerciseSet.h"
#import "PCHalfPieChart.h"
#import "SBStatisticCell.h"
#import "UIColor+SBColor.h"

@interface SBStatisticViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

static NSString * const StatisticCellIdentifier = @"StatisticCell";

@implementation SBStatisticViewController

int count;
int statisticCountOfSets;
float statisticMinWeight;
float statisticMaxWeight;
int statisticRepetitions;
float statisticProgress;
float averageRepetitions;
NSDate *firstDate;
NSDate *lastDate;
int exerciseCount;
int minRepetitions;
int maxRepetitions;
float firstWeight;
float lastWeight;

NSArray *sectionTitles;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Statistic Screen";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sectionTitles = @[NSLocalizedString(@"Section Common", nil), NSLocalizedString(@"Section Sets", nil), NSLocalizedString(@"Section Weight", nil), NSLocalizedString(@"Section Repetitions", nil)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.backgroundColor = [UIColor tableViewColor];
    
    [self createDateFormatter];
    self.title = self.exerciseName;
    
    NSMutableArray *reps = [[NSMutableArray alloc] init];
    NSMutableArray *weights = [[NSMutableArray alloc] init];
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    
    RLMArray *exercises = [SBExerciseSet objectsWhere:[NSString stringWithFormat:@"name = '%@'", self.exerciseName]];
    
    count = 0;
    statisticCountOfSets = 0;
    statisticMinWeight = 0;
    statisticMaxWeight = 0;
    statisticRepetitions = 0;
    statisticProgress = 0;
    firstDate = nil;
    lastDate = nil;
    averageRepetitions = 0;
    exerciseCount = 0;
    minRepetitions = 0;
    maxRepetitions = 0;
    firstWeight = 0;
    lastWeight = 0;
    
    int prevWeight = 0;
    for (int i = 0; i < [exercises count]; i++) {
        SBExerciseSet *exercise = [exercises objectAtIndex:i];
        
        statisticCountOfSets += [exercise.sets count];
        
        for (int j = 0; j < [exercise.sets count]; j++) {
            SBSet *set = [exercise.sets objectAtIndex:j];
            
            if (firstDate == nil || exercise.date < firstDate) {
                firstDate = exercise.date;
            }
            
            if (lastDate == nil || exercise.date > lastDate) {
                lastDate = exercise.date;
            }
         
            if (statisticMinWeight == 0 || set.weight < statisticMinWeight) {
                statisticMinWeight = set.weight;
            }
            
            if (set.weight > statisticMaxWeight) {
                statisticMaxWeight = set.weight;
            }
            
            if (minRepetitions == 0 || set.repetitions < minRepetitions) {
                minRepetitions = set.repetitions;
            }
            
            if (set.repetitions > maxRepetitions) {
                maxRepetitions = set.repetitions;
            }
            
            if (prevWeight != 0) {
                statisticProgress += (((set.weight / prevWeight) * 100) - 100);
            }
            prevWeight = set.weight;
            
            if (firstWeight == 0) {
                firstWeight = set.weight;
            }
            
            lastWeight = set.weight;
            
            statisticRepetitions += set.repetitions;
            
            [reps addObject:[NSNumber numberWithInt:set.repetitions]];
            [weights addObject:[NSNumber numberWithFloat:set.weight]];
            [labels addObject:@""];//[self.dateFormatter stringFromDate:exercise.date]];
            count++;
        }
        
        exerciseCount++;
    }
    
    statisticProgress = statisticProgress / count;
    averageRepetitions = statisticRepetitions / count;
    
    CGRect frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/2);
    
    self.lineChartView = [[PCLineChartView alloc] initWithFrame:frame];
    //[self.lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.lineChartView setInterval:5.0];
    self.lineChartView.autoscaleYAxis = YES;
    
    UILabel *firstDateLabel = [UILabel new];
    firstDateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"from %@", nil), [self.dateFormatter stringFromDate:firstDate]];
    firstDateLabel.frame = CGRectMake(20, self.lineChartView.frame.size.height - 44, self.lineChartView.frame.size.width, 44);
    firstDateLabel.font = [UIFont boldSystemFontOfSize:12];
    
    UILabel *lastDateLabel = [UILabel new];
    lastDateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"to %@", nil), [self.dateFormatter stringFromDate:lastDate]];
    lastDateLabel.frame = CGRectMake(0, self.lineChartView.frame.size.height - 44, self.lineChartView.frame.size.width - 20, 44);
    lastDateLabel.font = [UIFont boldSystemFontOfSize:12];
    lastDateLabel.textAlignment = NSTextAlignmentRight;
    lastDateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.lineChartView addSubview:firstDateLabel];
    [self.lineChartView addSubview:lastDateLabel];
    
    NSMutableArray *components = [NSMutableArray array];

    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
    component.title = @"kg";
    if ([weights count] == 1) {
        [weights insertObject:[NSNumber numberWithFloat:0] atIndex:0];
        [labels insertObject:@"" atIndex:0];
    }
    
    [component setPoints:weights];
    [components addObject:component];
    
    [self.lineChartView setComponents:components];
    [self.lineChartView setXLabels:labels];
    
    self.tableView.tableHeaderView = self.lineChartView;
    
    [self.view addSubview:self.tableView];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)createDateFormatter {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
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
            cell.valueLabel.text = [NSString stringWithFormat:@"%d", exerciseCount];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.headlineLabel.text = NSLocalizedString(@"Total amount of sets", nil);
            cell.valueLabel.text = [NSString stringWithFormat:@"%d", statisticCountOfSets];
        }
    }

    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.headlineLabel.text = NSLocalizedString(@"Your minimum weight", nil);
            cell.valueLabel.text = [NSString stringWithFormat:@"%.01f kg", statisticMinWeight];
        }
        
        if (indexPath.row == 1) {
            cell.headlineLabel.text = NSLocalizedString(@"Your maximum weight", nil);
            cell.valueLabel.text = [NSString stringWithFormat:@"%.01f kg", statisticMaxWeight];
        }
        
        if (indexPath.row == 2) {
            cell.headlineLabel.text = NSLocalizedString(@"Your Weight-Progress From First To Last Exercise", nil);
            cell.valueLabel.text = [NSString stringWithFormat:@"%.01f%%", ((lastWeight / firstWeight) * 100) - 100];
        }
        
        if (indexPath.row == 3) {
            cell.headlineLabel.text = NSLocalizedString(@"Your Averrage Weight-Progress From Set To Set", nil);
            cell.valueLabel.text = [NSString stringWithFormat:@"%.01f%%", statisticProgress];
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.headlineLabel.text = NSLocalizedString(@"Min Repetitions", nil);
            cell.valueLabel.text = [NSString stringWithFormat:@"%d", minRepetitions];
        }
        
        if (indexPath.row == 1) {
            cell.headlineLabel.text = NSLocalizedString(@"Max Repetitions", nil);
            cell.valueLabel.text = [NSString stringWithFormat:@"%d", maxRepetitions];
        }

        if (indexPath.row == 2) {
            cell.headlineLabel.text = NSLocalizedString(@"Average Repetitions", nil);
            cell.valueLabel.text = [NSString stringWithFormat:@"%.01f", averageRepetitions];
        }
        
        if (indexPath.row == 3) {
            cell.headlineLabel.text = NSLocalizedString(@"Total amount of repetitions", nil);
            cell.valueLabel.text = [NSString stringWithFormat:@"%d", statisticRepetitions];
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
