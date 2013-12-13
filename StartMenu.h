//
//  StartMenu.h
//  TowerDefenseUpdate
//
//  Created by Kevin Chen on 12/11/13.
//  Copyright (c) 2013 Kevin Chen and Vincent Oe. All rights reserved.
//

#import "cocos2d.h"

@interface StartMenu : CCLayer
{
    
}

+(id) scene;
-(void) startGame: (id) sender withLevel: (NSString *) level;
@end
