//
//  StartMenu.m
//  TowerDefenseUpdate
//
//  Created by Kevin Chen on 12/11/13.
//  Copyright (c) 2013 Brian Broom. All rights reserved.
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
        
//        CCMenuItemImage *startButton = [CCMenuItemImage
//                                        itemFromNormalImage:@"startButton.png"
//                                        selectedImage:@"startButtonSelected.png"
//                                        target:self
//                                        selector:@selector(startGame:)];
        
        startButton.position = ccp(200,200);
        CCMenu* menu = [CCMenu menuWithItems:startButton, nil];
        menu.position = CGPointZero;
        //menu.touchEnabled = YES;
        
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
