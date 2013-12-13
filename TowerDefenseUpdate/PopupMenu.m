//
//  PopupMenu.m
//  TowerDefenseUpdate
//
//  Created by Kevin Chen on 12/7/13.
//  Copyright (c) 2013 Kevin Chen and Vincent Oe. All rights reserved.
//

#import "PopupMenu.h"
#import "HelloWorldLayer.h"
#define USE_CUSTOM_DRAWING 1

@implementation PopupMenu

@synthesize tableView;
@synthesize imageView;
@synthesize towers;

#if USE_CUSTOM_DRAWING

- (id) initWithTowers:(NSArray*)towerlist andTowerCosts:(NSDictionary*)costs
{
    if (self = [super init])
    {
        towers = towerlist;
        towerCosts = costs;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSLog(@"view did load logging");
    towerIndex = -1;
    //self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(10, 45, 320, 500)];
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(45, 50, 250, 230)];
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator=YES;
    [self.view addSubview:self.tableView];
}

//
// viewDidLoad
//
// Configures the table after it is loaded. NO IT DOESNT
//


#endif

//
// numberOfSectionsInTableView:
//
// Return the number of sections for the table.
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"number of sections called");
	return 1;
}

//
// tableView:numberOfRowsInSection:
//
// Returns the number of rows in a given section.
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"row count called");
    return [self.towers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellsForRow called");
    static NSString *simpleTableIdentifier = @"TowerItem";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.towers objectAtIndex:indexPath.row];
    NSString* imagePath = [NSString stringWithFormat:@"%@.png", [self.towers objectAtIndex:indexPath.row]];
    cell.imageView.image = [UIImage imageNamed:imagePath];
    UILabel* mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 10.0, 50.0, 20.0)];
    mainLabel.font = [UIFont systemFontOfSize:14.0];
    mainLabel.textColor = [UIColor blackColor];
    int cost = [[towerCosts objectForKey:[self.towers objectAtIndex:indexPath.row]]integerValue];
    mainLabel.text = [NSString stringWithFormat:@"%d", cost];
    [cell.contentView addSubview:mainLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Did select row");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    selectedTower = cell.textLabel.text;
//    UIAlertView *messageAlert = [[UIAlertView alloc]
//                                 initWithTitle:@"Row Selected" message:selectedTower delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//    // Display Alert Message
//    [messageAlert show];
//    [self toggleHidden];
    if (HWL != nil){
        [HWL placeTower:selectedTower atIndex:towerIndex];
    }
    self.tableView.hidden = YES;
    
}

- (NSString*) getSelectedTower
{
    return selectedTower;
}

- (BOOL) isHidden
{
    return self.tableView.hidden;
}

- (void) setTowerIndex: (NSInteger) index{
    towerIndex = index;
}

- (void) setHelloWorldLayer: (HelloWorldLayer*) temp
{
    HWL = temp;
}

- (void) toggleHidden
{
    if (self.tableView.hidden == YES)
    {
        self.tableView.hidden = NO;
    }
    else
    {
        self.tableView.hidden = YES;
    }
}

- (void) setHidden
{
    self.tableView.hidden = YES;
    //hidden = YES;
}
@end

