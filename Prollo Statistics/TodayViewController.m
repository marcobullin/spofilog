#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "SBTodayTableViewCell.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"group.widget.statistics"];
    self.exercises = [ud objectForKey:@"statistics"];
    int height = [self.exercises count] * 44;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    self.preferredContentSize = CGSizeMake(0, height);
    
    [self.view addSubview:self.tableView];
}

- (void)displayExercises:(NSArray *)exercises {
    self.exercises = exercises;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SBTodayTableViewCell *cell = (SBTodayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBTodayTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *exercise = [self.exercises objectAtIndex:indexPath.row];
    cell.labelName.text = exercise[@"name"];
    float value = [exercise[@"value"] floatValue];
    cell.labelValue.text = [NSString stringWithFormat:@"%.01f%%", value];
    
    if (value >= 0) {
        cell.labelValue.textColor = [UIColor greenColor];
    } else {
        cell.labelValue.textColor = [UIColor redColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *url = [NSURL URLWithString:@"statisticExerciseList://" ];
    [self.extensionContext openURL:url completionHandler:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.exercises count];
}

@end
