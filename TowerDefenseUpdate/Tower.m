//
//  Tower.m
//  TowerDefenseUpdate
//
//  Created by Vincent Oe on 11/30/13.
//  Copyright (c) 2013 Kevin Chen and Vincent Oe. All rights reserved.
//

#import "Tower.h"
#import "Enemy.h"

@implementation Tower

@synthesize mySprite,theGame;

//need way to pick a tower with specific values
+(id) nodeWithTheGame:(HelloWorldLayer*)_game location:(CGPoint)location
{
    return [[self alloc] initWithTheGame:_game location:location];
}

-(id) initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location
{
	if(self=[super init]) {
		theGame = _game;
        attackRange = 70;
        damagePower = 10;
        fireRate = 1;
        towerCost = 300;
        splashRadius = 0;
        slowEffect = 0;
        spriteName = @"tower.png";
        bulletName = @"bullet.png";
        bulletSpeed = .01;
        
        mySprite = [CCSprite spriteWithFile:@"tower.png"];
		[self addChild:mySprite];
        
        [mySprite setPosition:location];
        [theGame addChild:self];
        [self scheduleUpdate];
	}
	return self;
}

+(id)nodeWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location andAttackRange:(int)range andDamagePower:(int)power andFireRate:(float)rate andTowerCost:(int)cost andSplashRadius:(float)radius andSlowEffect:(float)slow andSpriteFile:(NSString*)sFile andBulletFile:(NSString*)bFile andBulletSpeed:(float)bSpeed
{
    return [[self alloc] initWithTheGame:_game location:location andAttackRange:range andDamagePower:power andFireRate:rate andTowerCost:cost andSplashRadius:radius andSlowEffect:slow andSpriteFile:sFile andBulletFile:bFile andBulletSpeed:bSpeed];
}

-(id)initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location andAttackRange:(int)range andDamagePower:(int)power andFireRate:(float)rate andTowerCost:(int)cost andSplashRadius:(float)radius andSlowEffect:(float)slow andSpriteFile:(NSString*)sFile andBulletFile:(NSString*)bFile andBulletSpeed:(float)bSpeed
{
    if(self=[super init]) {
		theGame = _game;
        attackRange = range;
        damagePower = power;
        fireRate = rate;
        towerCost = cost;
        splashRadius = radius;
        slowEffect = slow;
        spriteName = sFile;
        bulletName = bFile;
        bulletSpeed = bSpeed;
        
        mySprite = [CCSprite spriteWithFile:spriteName];
		[self addChild:mySprite];
        
        [mySprite setPosition:location];
        [theGame addChild:self];
        [self scheduleUpdate];
	}
	return self;
}

-(void)update:(ccTime)dt
{
    //NSLog(@"Update");
    if (chosenEnemy){
        
        //We make it turn to target the enemy chosen
        CGPoint normalized = ccpNormalize(ccp(chosenEnemy.mySprite.position.x-mySprite.position.x,
                                              chosenEnemy.mySprite.position.y-mySprite.position.y));
        mySprite.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y,-normalized.x))+90;
        
        //NSLog(@"x: %f, y: %f", chosenEnemy.mySprite.position.x, chosenEnemy.mySprite.position.y);
        
        if(![theGame circle:mySprite.position withRadius:attackRange
            collisionWithCircle:chosenEnemy.mySprite.position collisionCircleRadius:1])
        {
            //NSLog(@"@about to call lostSightOfEnemy");
            [self lostSightOfEnemy];
        }
    } else {
        for(Enemy * enemy in theGame.enemies)
        {
            if([theGame circle:mySprite.position withRadius:attackRange
                collisionWithCircle:enemy.mySprite.position collisionCircleRadius:1])
            {
                //NSLog(@"about to choose enemy for attack");
                [self chosenEnemyForAttack:enemy];
                break;
            }
        }
    }
}

-(void)attackEnemy
{
    //NSLog(@"Tower: attackEnemy");
    [self schedule:@selector(shootWeapon) interval:fireRate];
}

-(void)chosenEnemyForAttack:(Enemy *)enemy
{
    //NSLog(@"Tower: chosenEnemyForAttack");
    chosenEnemy = nil;
    chosenEnemy = enemy;
    //NSLog(@"chosenEnemy == nil: %d", chosenEnemy == nil);
    [self attackEnemy];
    [enemy getAttacked:self];
}

-(void)shootWeapon
{
    //NSLog(@"Tower: shootWeapon");
    CCSprite * bullet = [CCSprite spriteWithFile:bulletName];
    [theGame addChild:bullet];
    [bullet setPosition:mySprite.position];
    [bullet runAction:[CCSequence actions:
                       [CCMoveTo actionWithDuration:bulletSpeed position:chosenEnemy.mySprite.position],
                       [CCCallFunc actionWithTarget:self selector:@selector(damageEnemy)],
                       [CCCallFuncN actionWithTarget:self selector:@selector(removeBullet:)], nil]];
}

-(void)removeBullet:(CCSprite *)bullet
{
    [bullet.parent removeChild:bullet cleanup:YES];
}

-(void)damageEnemy
{
    //NSLog(@"Tower: damageEnemy");
    // look within the circle radius and also damage those enemies
    NSMutableArray* inRange = [[NSMutableArray alloc] init];
    if (splashRadius > 0) {
        for (Enemy* e in theGame.enemies) {
            if([theGame circle:chosenEnemy.mySprite.position withRadius:splashRadius collisionWithCircle:e.mySprite.position collisionCircleRadius:1]) {
                [inRange addObject:e];
            }
        }
        for (Enemy* e in inRange) {
            if (slowEffect > 0) {
                [e changeSpeed:slowEffect];
            }
            [e getDamaged:damagePower];
        }
    } else {
        if (slowEffect > 0) {
            [chosenEnemy changeSpeed:slowEffect];
        }
        [chosenEnemy getDamaged:damagePower];
    }
    
    // if slow effect !0 and they are not already slowed: slow them
}

-(void)targetKilled
{
    //NSLog(@"Tower: targetKilled");
    if(chosenEnemy)
        chosenEnemy = nil;
    
    [self unschedule:@selector(shootWeapon)];
}

-(void)lostSightOfEnemy
{
    //NSLog(@"Tower: lostSightOfEnemy");
    //NSLog(@"Inside TOWER-LOSTSIGHTOFENEMY x: %f, y: %f", chosenEnemy.mySprite.position.x, chosenEnemy.mySprite.position.y);
    [chosenEnemy gotLostSight:self];
    if(chosenEnemy)
        chosenEnemy = nil;
    
    [self unschedule:@selector(shootWeapon)];
}

-(int)towerCost
{
    return towerCost;
}

-(void)clearEnemyQueue
{
    chosenEnemy = Nil;
}

-(void)draw
{
    ccDrawColor4B(255, 255, 255, 255);
    ccDrawCircle(mySprite.position, attackRange, 360, 30, false);
    [super draw];
}

@end