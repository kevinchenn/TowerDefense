//
//  Tower.h
//  TowerDefenseUpdate
//
//  Created by Vincent Oe on 11/30/13.
//  Copyright (c) 2013 Kevin Chen and Vincent Oe. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "Enemy.h"

@class HelloWorldLayer, Enemy;

@interface Tower : CCNode
{
    int attackRange;
    int damagePower;
    float fireRate;
    int towerCost;
    float splashRadius;
    float slowEffect;
    NSString* spriteName;
    NSString* bulletName;
    float bulletSpeed;
    
    BOOL attacking;
    
    Enemy *chosenEnemy;
}

@property (nonatomic,weak) HelloWorldLayer *theGame;
@property (nonatomic,strong) CCSprite *mySprite;

+(id)nodeWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location;
-(id)initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location;
+(id)nodeWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location andAttackRange:(int)range andDamagePower:(int)power andFireRate:(float)rate andTowerCost:(int)cost andSplashRadius:(float)radius andSlowEffect:(float)slow andSpriteFile:(NSString*)sfile andBulletFile:(NSString*)bfile andBulletSpeed:(float)bSpeed;
-(id)initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location andAttackRange:(int)range andDamagePower:(int)power andFireRate:(float)rate andTowerCost:(int)cost andSplashRadius:(float)radius andSlowEffect:(float)slow andSpriteFile:(NSString*)sfile andBulletFile:(NSString*)bfile andBulletSpeed:(float)bSpeed;

-(void)targetKilled;
-(int)towerCost;

@end
