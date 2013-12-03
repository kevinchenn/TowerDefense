//
//  Enemy.h
//  TowerDefenseUpdate
//
//  Created by Vincent Oe on 12/1/13.
//  Copyright (c) 2013 Brian Broom. All rights reserved.
//

#import "cocos2d.h"
#import "HelloWorldLayer.h"

@class HelloWorldLayer, Waypoint, Tower;

@interface Enemy: CCNode {
    CGPoint myPosition;
    int maxHp;
    float walkingSpeed;
    int attackPower;
    int currentHp;
    Waypoint *destinationWaypoint;
    BOOL active;
    NSMutableArray *attackedBy;
    NSString* spriteFile;
}

@property (nonatomic,assign) HelloWorldLayer *theGame;
@property (nonatomic,assign) CCSprite *mySprite;

+(id)nodeWithTheGame:(HelloWorldLayer*)_game;
-(id)initWithTheGame:(HelloWorldLayer *)_game;
+(id)nodeWithTheGame:(HelloWorldLayer *)_game andMaxHP:(int)hp andWalkingSpeed:(float)speed andAttackPower:(int)power andSpriteFile:(NSString*)file;
-(id)initWithTheGame:(HelloWorldLayer *)_game andMaxHP:(int)hp andWalkingSpeed:(float)speed andAttackPower:(int)power andSpriteFile:(NSString*)file;
-(void)doActivate;
-(void)getRemoved;
-(void)getAttacked:(Tower *)attacker;
-(void)gotLostSight:(Tower *)attacker;
-(void)getDamaged:(int)damage;

@end
