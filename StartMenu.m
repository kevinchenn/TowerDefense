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
        
        
        CCMenuItemImage *startButton = [CCMenuItemImage itemWithNormalImage:@"startButton.png" selectedImage:@"startButtonSelected.png" target:self selector:@selector(startGame:)];
        CCMenuItemFont *levelOne = [CCMenuItemFont itemFromString:@"Level 1" target:self selector:@selector(startGame:)];

        [levelOne setFontName:@"Courier"];
        startButton.position = ccp(230,150);
        levelOne.position = ccp(130, 75);
        CCMenu* menu = [CCMenu menuWithItems:startButton, levelOne, nil];
        menu.position = CGPointZero;
        
        [self addChild: menu];
    }
    return self;
}

- (void) startGame: (id) sender
{
    NSLog(@"game was started!");
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

@end
