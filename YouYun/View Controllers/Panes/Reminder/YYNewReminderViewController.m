//
//  YYNewReminderViewController.m
//  YouYun
//
//  Created by Ranchao Zhang on 4/13/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYNewReminderViewController.h"

@interface YYNewReminderViewController ()

@end

@implementation YYNewReminderViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _dateFormatter = [NSDateFormatter new];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    _dateCellsController = [DateCellsController new];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    NSDate *date = [NSDate date];
    
    _dateCellsController.indexPathToDateMapping = [@{indexPath : date} mutableCopy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_dateCellsController attachToTableView:_table withDelegate:self withMapping:_dateCellsController.indexPathToDateMapping];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DateCellsControllerDelegate

- (void)dateCellsController:(DateCellsController *)controller
 willExpandTableViewContent:(UITableView *)tableView
                  forHeight:(CGFloat)expandHeight {
    
}

- (void)dateCellsController:(DateCellsController *)controller
willCollapseTableViewContent:(UITableView *)tableView
                  forHeight:(CGFloat)expandHeight {
    
}

- (void)dateCellsController:(DateCellsController *)controller
            didSelectedDate:(NSDate *)date
               forIndexPath:(NSIndexPath *)path {
    [_table reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return @"提醒信息";
        case 1:
        default: return @"到期日期";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableViewInner cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellReuseId = @"id";
    
    UITableViewCell *cell = [tableViewInner dequeueReusableCellWithIdentifier:cellReuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseId];
    }
    
    NSDate *correspondedDate = [self.dateCellsController.indexPathToDateMapping objectForKey:indexPath];
    if (correspondedDate) {
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.text = [self.dateFormatter stringFromDate:correspondedDate];
    } else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.text = [NSString stringWithFormat:@"Section: %ld row: %ld", (long)indexPath.section, (long)indexPath.row];
    }
    return cell;
}

@end
