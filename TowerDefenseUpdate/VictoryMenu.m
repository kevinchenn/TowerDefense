//
//  VictoryMenu.m
//  TowerDefenseUpdate
//
//  Created by Vincent Oe on 12/12/13.
//  Copyright (c) 2013 Brian Broom. All rights reserved.
//

#import "VictoryMenu.h"
#import "StartMenu.h"
#import "HelloWorldLayer.h"
#import "cocos2d.h"

@implementation VictoryMenu

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    VictoryMenu *layer = [VictoryMenu node];
    
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    
    if( (self=[super init] )) {
        
        self.touchEnabled = YES;
        
        CCLabelTTF *gameOver = [CCLabelTTF labelWithString:@"You Win!" fontName:@"Courier" fontSize:60];
        CCLabelTTF *returnToMenu = [CCLabelTTF labelWithString:@"touch to return to menu" fontName:@"Courier" fontSize:20];
        gameOver.position =  ccp(240, 240);
        returnToMenu.position = ccp(240, 150);
        [self addChild: gameOver];
        [self addChild: returnToMenu];
    }
    return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self restartGame];
}

- (void) restartGame
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionRotoZoom transitionWithDuration:1 scene:[StartMenu scene]]];
}


@end
