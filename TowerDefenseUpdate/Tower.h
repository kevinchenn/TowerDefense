//
//  Tower.h
//  TowerDefenseUpdate
//
//  Created by Kevin Chen on 12/1/13.
//  Copyright (c) 2013 Brian Broom. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"
#import "HelloWorldLayer.h"

#define kTOWER_COST 300

@class HelloWorldLayer, Enemy;

@interface Tower: CCNode {
    int attackRange;
    int damage;
    float fireRate;
    BOOL attacking;
    Enemy *chosenEnemy;
}

@property (nonatomic,weak) HelloWorldLayer *theGame;
@property (nonatomic,strong) CCSprite *mySprite;

+(id)nodeWithTheGame:(HelloWorldLayer*)_game location:(CGPoint)location;
-(id)initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location;
-(void)targetKilled;

@end