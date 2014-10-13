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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Statistic Screen";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    count = 1;
    statisticCountOfSets = 0;
    statisticMinWeight = 0;
    statisticMaxWeight = 0;
    statisticRepetitions = 0;
    statisticProgress = 0;
    
    int prevWeight = 0;
    for (int i = 0; i < [exercises count]; i++) {
        SBExerciseSet *exercise = [exercises objectAtIndex:i];
        
        statisticCountOfSets += [exercise.sets count];
        
        for (int j = 0; j < [exercise.sets count]; j++) {
            SBSet *set = [exercise.sets objectAtIndex:j];
            
         
            if (statisticMinWeight == 0 || set.weight < statisticMinWeight) {
                statisticMinWeight = set.weight;
            }
            
            if (set.weight > statisticMaxWeight) {
                statisticMaxWeight = set.weight;
            }
            
            
            if (prevWeight != 0) {
                statisticProgress += (100 - ((prevWeight / set.weight) * 100));
            }
            prevWeight = set.weight;
            
            statisticRepetitions += set.repetitions;
            
            [reps addObject:[NSNumber numberWithInt:set.repetitions]];
            [weights addObject:[NSNumber numberWithFloat:set.weight]];
            [labels addObject:[self.dateFormatter stringFromDate:exercise.date]];
            count++;
        }
    }
    
    CGRect frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/2);
    
    self.lineChartView = [[PCLineChartView alloc] initWithFrame:frame];
    //[self.lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.lineChartView setInterval:5.0];
    self.lineChartView.autoscaleYAxis = YES;
    
    if (count <= 4) {
        self.lineChartView.numXIntervals = 1;
    } else {
        self.lineChartView.numXIntervals = ceil(count/3) ;
    }
    
    NSMutableArray *components = [NSMutableArray array];

    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SBStatisticCell *cell = (SBStatisticCell *)[tableView dequeueReusableCellWithIdentifier:StatisticCellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBStatisticCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.headlineLabel.backgroundColor = [UIColor clearColor];
    cell.headlineLabel.textColor = [UIColor textColor];
    cell.valueLabel.textColor = [UIColor importantCellColor];
    
    //cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    if (indexPath.row == 0) {
        cell.headlineLabel.text = NSLocalizedString(@"Total amount of sets", nil);
        cell.valueLabel.text = [NSString stringWithFormat:@"%d", statisticCountOfSets];
    }
    
    if (indexPath.row == 1) {
        cell.headlineLabel.text = NSLocalizedString(@"Your minimum weight", nil);
        cell.valueLabel.text = [NSString stringWithFormat:@"%.01f kg", statisticMinWeight];
    }
    
    if (indexPath.row == 2) {
        cell.headlineLabel.text = NSLocalizedString(@"Your maximum weight", nil);
        cell.valueLabel.text = [NSString stringWithFormat:@"%.01f kg", statisticMaxWeight];
    }
    
    if (indexPath.row == 3) {
        cell.headlineLabel.text = NSLocalizedString(@"Your Weight-Progress", nil);
        cell.valueLabel.text = [NSString stringWithFormat:@"%.01f%%", statisticProgress];
    }
    
    if (indexPath.row == 4) {
        cell.headlineLabel.text = NSLocalizedString(@"Total amount of repetitions", nil);
        cell.valueLabel.text = [NSString stringWithFormat:@"%d", statisticRepetitions];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.lineChartView removeFromSuperview];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

@end
