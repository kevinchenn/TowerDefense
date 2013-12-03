//
//  Tower.h
//  TowerDefenseUpdate
//
//  Created by Vincent Oe on 11/30/13.
//  Copyright (c) 2013 Brian Broom. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "Enemy.h"

#define kTOWER_COST 300

@class HelloWorldLayer, Enemy;

@interface Tower : CCNode
{
    int attackRange;
    int damagePower;
    float fireRate;
    int towerCost;
    
    BOOL attacking;
    
    Enemy *chosenEnemy;
}

@property (nonatomic,weak) HelloWorldLayer *theGame;
@property (nonatomic,strong) CCSprite *mySprite;

+(id)nodeWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location;
-(id)initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location;
+(id)nodeWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location andAttackRange:(int)range andDamagePower:(int)power andFireRate:(float)rate andTowerCost:(int)cost andSpriteFile:(NSString*)file;
-(id)initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location andAttackRange:(int)range andDamagePower:(int)power andFireRate:(float)rate andTowerCost:(int)cost andSpriteFile:(NSString*)file;

-(void)targetKilled;
-(int)towerCost;

@end
