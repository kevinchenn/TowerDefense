//
//  StartMenu.m
//  TowerDefenseUpdate
//
//  Created by Kevin Chen on 12/11/13.
//  Copyright (c) 2013 Kevin Chen and Vincent Oe. All rights reserved.
//

#import "StartMenu.h"
#import "HelloWorldLayer.h"
#import "cocos2d.h"

@implementation StartMenu

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    StartMenu *layer = [StartMenu node];
    
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    
    if( (self=[super init] )) {
        
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Bees vs. Ants" fontName:@"Courier" fontSize:60];
        title.position =  ccp(240, 240);
        [self addChild: title];
<<<<<<< HEAD

        CCMenuItemImage *startLevel1 = [CCMenuItemImage itemWithNormalImage:@"level1Button.png" selectedImage:@"level1ButtonSelected.png" block:^(id sender) { [self startGame:sender withLevel:@"level1"]; }];
        
        CCMenuItemImage *startLevel2 = [CCMenuItemImage itemWithNormalImage:@"level2Button.png" selectedImage:@"level2ButtonSelected.png" block:^(id sender) { [self startGame:sender withLevel:@"level2"]; }];
        
        CCMenuItemImage *startLevel3 = [CCMenuItemImage itemWithNormalImage:@"level3Button.png" selectedImage:@"level3ButtonSelected.png" block:^(id sender) { [self startGame:sender withLevel:@"level3"]; }];
=======
        
        
        //CCMenuItemImage *startButton = [CCMenuItemImage itemWithNormalImage:@"startButton.png" selectedImage:@"startButtonSelected.png" target:self selector:@selector(startGame:)];
        //CCMenuItemFont *levelOne = [CCMenuItemFont itemFromString:@"Level 1" target:self selector:@selector(startGame:)];

        //[levelOne setFontName:@"Courier"];
        //startButton.position = ccp(230,150);
        //levelOne.position = ccp(130, 75);
        //CCMenu* menu = [CCMenu menuWithItems:startButton, levelOne, nil];
        //menu.position = CGPointZero;
>>>>>>> a2c46040b1a6a409964fb768546f271a841e374f
        
        //startLevel1.position = ccp(10,150);
        //startLevel2.position = ccp(20,150);
        //startLevel2.position = ccp(30,150);
        //CCMenu* menu1 = [CCMenu menuWithItems:startLevel1, nil];
        //CCMenu* menu2 = [CCMenu menuWithItems:startLevel2, nil];
        //CCMenu* menu3 = [CCMenu menuWithItems:startLevel3, nil];
        //menu1.position = CGPointZero;
        //menu2.position = CGPointZero;
        //menu3.position = CGPointZero;
        //[self addChild: menu1];
        //[self addChild: menu2];
        //[self addChild: menu3];
        
        CCMenu* menu = [CCMenu menuWithItems:startLevel1, startLevel2, startLevel3, nil];
        [menu alignItemsHorizontally];
        menu.anchorPoint = ccp(0.0,0.0);
        [self addChild: menu];
        
    }
    return self;
}

- (void) startGame:(id)sender withLevel:(NSString*)level
{
    NSLog(@"game was started!");
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer sceneWithLevel:level]];
}

@end
