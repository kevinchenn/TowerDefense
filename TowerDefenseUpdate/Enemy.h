//
//  Enemy.h
//  TowerDefenseUpdate
//
//  Created by Vincent Oe on 12/1/13.
//  Copyright (c) 2013 Kevin Chen and Vincent Oe. All rights reserved.
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
    float currentSpeed;
    NSTimer* slowTimer;
    int animationIndex;
    NSTimer* animationTimer;
    NSMutableArray* spriteList;
}

@property (nonatomic,assign) HelloWorldLayer *theGame;
@property (nonatomic,assign) CCSprite *mySprite;

+(id)nodeWithTheGame:(HelloWorldLayer*)_game;
-(id)initWithTheGame:(HelloWorldLayer *)_game;
+(id)nodeWithTheGame:(HelloWorldLayer *)_game andMaxHP:(int)hp andWalkingSpeed:(float)speed andAttackPower:(int)power andSpriteFile:(NSMutableArray*)sprites;
-(id)initWithTheGame:(HelloWorldLayer *)_game andMaxHP:(int)hp andWalkingSpeed:(float)speed andAttackPower:(int)power andSpriteFile:(NSMutableArray*)sprites;
-(void)doActivate;
-(void)getRemoved;
-(void)getAttacked:(Tower *)attacker;
-(void)gotLostSight:(Tower *)attacker;
-(void)getDamaged:(int)damage;
-(void)changeSpeed:(float)difference;
-(void)resetSpeed;

@end
