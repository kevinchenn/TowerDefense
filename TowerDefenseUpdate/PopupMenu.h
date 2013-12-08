//
//  PopupMenu.h
//  TowerDefenseUpdate
//
//  Created by Kevin Chen on 12/7/13.
//  Copyright (c) 2013 Brian Broom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelloWorldLayer.h"

@interface PopupMenu : UIViewController <UITableViewDelegate>
{
	UITableView *tableView;
	UIImageView *imageView;
    NSString* selectedTower;
    BOOL hidden;
    NSInteger towerIndex;
    HelloWorldLayer* HWL;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic,retain) NSArray *towers;

- (BOOL) isHidden;
- (NSString*) getSelectedTower;
- (void) toggleHidden;
- (void) setTowerIndex: (NSInteger) index;
- (void) setHelloWorldLayer: (HelloWorldLayer*) temp;
- (void) setHidden;
@end
