#import "SBSetsViewController.h"
#import "SBSetViewController.h"
#import "SBAddEntryTableViewCell.h"
#import "SBSet.h"
#import "SBSmallTopBottomCell.h"
#import "UIColor+SBColor.h"
#import "SBHelperView.h"

@interface SBSetsViewController ()
@end

@implementation SBSetsViewController

#pragma mark - lifecycle methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Sets Screen";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.exercise[@"name"];
    
    if (self.exercise[@"sets"] == nil) {
        self.sets = [NSMutableArray new];
    } else {
        self.sets = self.exercise[@"sets"];
    }

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}

#pragma mark - Actions

- (void)deleteSetAtIndex:(int)index {
    [self.sets removeObjectAtIndex:index];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index+1 inSection:0];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    if ([self.sets count] == 0) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)displayCreatedSet:(NSDictionary *)set {
    [self.sets addObject:set];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[self.sets count] inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    if ([self.sets count] == 1) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = (int)[self.sets count] + 1;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"setCell";
    
    if (indexPath.row == 0) {
        cellIdentifier = @"addSetCell";
        
        SBAddEntryTableViewCell *addSetCell = (SBAddEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (addSetCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBAddEntryTableViewCell" owner:self options:nil];
            addSetCell = [nib objectAtIndex:0];
        }
        
        addSetCell.backgroundColor = [UIColor actionCellColor];
        
        if ([self.sets count] > 0) {
            addSetCell.addEntryLabel.text = NSLocalizedString(@"Add another set", nil);
        } else {
            addSetCell.addEntryLabel.text = NSLocalizedString(@"Add new set", nil);
        }
        addSetCell.addEntryLabel.textColor = [UIColor whiteColor];
        addSetCell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, addSetCell.bounds.size.width);
        addSetCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return addSetCell;
    }
    
    SBSmallTopBottomCell *setCell = (SBSmallTopBottomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (setCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBSmallTopBottomCell" owner:self options:nil];
        setCell = [nib objectAtIndex:0];
    }
    
    // standard -1 because of the add set cell
    int index = (int)indexPath.row - 1;
    
    NSDictionary *set = [self.sets objectAtIndex:index];
    
    setCell.backgroundColor = [UIColor clearColor];
    setCell.topLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Set - %d", nil), [set[@"number"] intValue]];
    setCell.bottomLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%.01fkg | %dreps", nil), [set[@"weight"] floatValue], [set[@"repetitions"] intValue]];
    setCell.topLabel.textColor = [UIColor headlineColor];
    setCell.bottomLabel.textColor = [UIColor textColor];
    
    return setCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int index = (int)indexPath.row - 1;
        [self.presenter deleteSet:[self.sets objectAtIndex:index] fromExercise:self.exercise atIndex:index];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // add new set
    if (indexPath.row == 0) {
        SBHelperView *helperView = [[SBHelperView alloc] initWithMessage:NSLocalizedString(@"Touch to change values", nil)
                                                                 onPoint:CGPointMake(20, 170)
                                                          andHintOnPoint:CGRectMake(0, 108, self.view.frame.size.width, 60)
                                                         andRenderOnView:self.parentViewController.view];
        
        helperView.frame = self.view.frame;
        
        if ([self.sets count] > 0) {
            [self.presenter createSetDependingOnSet:[self.sets lastObject] andAddToExercise:self.exercise];
            return;
        }
        
        int number = 1;
        float weight = 10.0;
        int repetitions = 10;
            
        [self.presenter createSetDependingOnLastExerciseWithNumber:number
                                                  andAddToExercise:self.exercise
                                                withFallbackWeight:weight
                                            andFallbackRepetitions:repetitions];
        return;
    }
    
    SBSetViewController *setViewController = [[SBSetViewController alloc] initWithNibName:@"SBSetViewController" bundle:nil];
    
    setViewController.currentSet = [self.sets objectAtIndex:(indexPath.row-1)];
    
    [self.navigationController pushViewController:setViewController animated:YES];
}

@end
