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
    
    _jsDateFormatter = [NSDateFormatter new];
    [_jsDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    _dateCellsController = [DateCellsController new];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    NSDate *date = [NSDate date];
    
    _dateCellsController.indexPathToDateMapping = [@{indexPath : date} mutableCopy];
    
    // Setup save reminder icon
    FAKIonIcons *saveReminderIcon = [FAKIonIcons ios7CheckmarkIconWithSize:28];
    [saveReminderIcon addAttribute:NSForegroundColorAttributeName value:SCHOOL_VERY_LIGHT_COLOR];
    
    UIButton *saveReminderButton = [UIButton new];
    saveReminderButton.frame = CGRectMake(276, 0, 44, 44);
    [saveReminderButton setBackgroundImage:[saveReminderIcon imageWithSize:CGSizeMake(44, 44)] forState:UIControlStateNormal];
    [saveReminderButton setShowsTouchWhenHighlighted:YES];
    [saveReminderButton addTarget:self action:@selector(saveReminderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -16;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:saveReminderButton];
    self.navigationItem.rightBarButtonItems = @[spacer, barItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_dateCellsController attachToTableView:_table withDelegate:self withMapping:_dateCellsController.indexPathToDateMapping];
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Save reminder

- (void)saveReminderButtonClicked:(id)sender
{
    YYTextFieldTableViewCell *messageCell = (YYTextFieldTableViewCell *) [_table cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UITableViewCell *dateCell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    [[YYHTTPManager I] POST:CREATE_REMINDER_API withJSONParameters:@{ @"signature" : @"tempkey", @"message" : messageCell.textInput.text, @"dueDate" : [self.jsDateFormatter stringFromDate:[self.dateFormatter dateFromString:dateCell.textLabel.text]] } success:^(AFHTTPRequestOperation *operation, id response) {
        [[NSNotificationCenter defaultCenter] postNotificationName:REMINDERS_DID_CHANGE_NOTIFICATION object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark - DateCellsControllerDelegate

- (void)dateCellsController:(DateCellsController *)controller
 willExpandTableViewContent:(UITableView *)tableView
                  forHeight:(CGFloat)expandHeight
{
    OLog(@"willExpandTableViewContent");
}

- (void)dateCellsController:(DateCellsController *)controller
willCollapseTableViewContent:(UITableView *)tableView
                  forHeight:(CGFloat)expandHeight
{
    OLog(@"willCollapseTableViewContent");
}

- (void)dateCellsController:(DateCellsController *)controller
            didSelectedDate:(NSDate *)date
               forIndexPath:(NSIndexPath *)path {
    OLog(@"didSelectedDate");
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
    
    static NSString *dateCellReuseID = @"dateCellReuseID";
    static NSString *msgCellReuseID = @"YYTextFieldTableViewCell";
    
    
    NSDate *correspondedDate = [self.dateCellsController.indexPathToDateMapping objectForKey:indexPath];
    if (correspondedDate) {
        UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:dateCellReuseID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dateCellReuseID];
        }
        
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.text = [self.dateFormatter stringFromDate:correspondedDate];
        
        return cell;
    } else {
        YYTextFieldTableViewCell *cell = [_table dequeueReusableCellWithIdentifier:msgCellReuseID];
        
        cell.textInput.placeholder = @"提醒信息";
        
        return cell;
    }
}

@end
