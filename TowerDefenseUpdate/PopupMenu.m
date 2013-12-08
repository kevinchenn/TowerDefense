//
//  PopupMenu.m
//  TowerDefenseUpdate
//
//  Created by Kevin Chen on 12/7/13.
//  Copyright (c) 2013 Brian Broom. All rights reserved.
//

#import "PopupMenu.h"
#import "HelloWorldLayer.h"
#define USE_CUSTOM_DRAWING 1

@implementation PopupMenu

@synthesize tableView;
@synthesize imageView;
@synthesize towers;

#if USE_CUSTOM_DRAWING

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //load name of towers
    NSString* levelName = @"level1";
    NSString* levelPath = [[NSBundle mainBundle] pathForResource:levelName ofType:@"plist"];
    NSDictionary* levelInfo = [NSDictionary dictionaryWithContentsOfFile:levelPath];
    NSString* towerListPath = [[NSBundle mainBundle] pathForResource:[levelInfo valueForKey:@"towers"] ofType:@"plist"];
    NSDictionary* towersList = [NSDictionary dictionaryWithContentsOfFile:towerListPath];
    self.towers = [towersList allKeys];
    NSLog(@"array: %@", towers);
    
    //load tableView
    NSLog(@"view did load logging");
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(10, 45, 320, 500)];
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.tableView];
}

//
// viewDidLoad
//
// Configures the table after it is loaded.
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    hidden = YES;
    towerIndex = -1;
}

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
    return hidden;
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
    if (hidden == YES)
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
    hidden = YES;
}
@end

