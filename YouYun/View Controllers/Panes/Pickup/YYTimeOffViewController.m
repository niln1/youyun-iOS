//
//  YYTimeOffViewController.m
//  YouYun
//
//  Created by Ranchao Zhang on 6/18/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYTimeOffViewController.h"

@interface YYTimeOffViewController ()

@end

@implementation YYTimeOffViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _children = @[];
    [self fetchChildren];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchChildren
{
    [[YYHTTPManager I] GET:GET_CHILDREN_API withURLEncodedParameters:@{@"userId": [YYUser I].userID, @"signature": @"tempkey"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            OLog(responseObject);
            NSAssert(responseObject != nil && responseObject[@"result"] != nil , @"Response from server should be valid.");
            NSArray *children = responseObject[@"result"];
            _children = children;
            [_table reloadData];
        }
        @catch (NSException *exception) {
            OLog(exception);
        }
        @finally {
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UI_DEFAULT_CELL_ID forIndexPath:indexPath];
    NSDictionary *child = _children[indexPath.item];
    NSAssert(child[@"username"] != nil, @"Child should have a username");
    cell.textLabel.text = child[@"username"];
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
    UIView *selectedBgView = [[UIView alloc] initWithFrame:cell.frame];
    selectedBgView.backgroundColor = UI_SELECTION_COLOR;
    cell.selectedBackgroundView = selectedBgView;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _children.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYTimeOffDetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:[YYTimeOffDetailViewController identifier]];
    detail.child = _children[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
