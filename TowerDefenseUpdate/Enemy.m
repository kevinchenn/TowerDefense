//
//  Enemy.m
//  TowerDefenseUpdate
//
//  Created by Vincent Oe on 12/1/13.
//  Copyright (c) 2013 Brian Broom. All rights reserved.
//

#import "Enemy.h"
#import "Tower.h"
#import "Waypoint.h"
#import "SimpleAudioEngine.h"

#define HEALTH_BAR_WIDTH 20
#define HEALTH_BAR_ORIGIN -10

@implementation Enemy

@synthesize mySprite, theGame;

+(id)nodeWithTheGame:(HelloWorldLayer*)_game {
    return [[self alloc] initWithTheGame:_game];
}

-(id)initWithTheGame:(HelloWorldLayer *)_game {
	if ((self=[super init])) {
		theGame = _game;
        maxHp = 40;
        currentHp = maxHp;
        walkingSpeed = 0.5;
        currentSpeed = walkingSpeed;
        attackedBy = [[NSMutableArray alloc] initWithCapacity:5];
        active = NO;
        slowTimer = Nil;
        
        mySprite = [CCSprite spriteWithFile:@"enemy.png"];
		[self addChild:mySprite];
       
        
        Waypoint * waypoint = (Waypoint *)[theGame.waypoints objectAtIndex:([theGame.waypoints count]-1)];
        destinationWaypoint = waypoint.nextWaypoint;
        CGPoint pos = waypoint.myPosition;
        myPosition = pos;
        
        [mySprite setPosition:pos];
        [theGame addChild:self];
        [self scheduleUpdate];
	}
	return self;
}

+(id)nodeWithTheGame:(HelloWorldLayer *)_game andMaxHP:(int)hp andWalkingSpeed:(float)speed andAttackPower:(int)power andSpriteFile:(NSString*)file
{
    return [[self alloc] initWithTheGame:_game andMaxHP:hp andWalkingSpeed:speed andAttackPower:power andSpriteFile:file];
}

-(id)initWithTheGame:(HelloWorldLayer *)_game andMaxHP:(int)hp andWalkingSpeed:(float)speed andAttackPower:(int)power andSpriteFile:(NSString*)file
{
    if ((self=[super init])) {
		theGame = _game;
        maxHp = hp;
        walkingSpeed = speed;
        currentSpeed = walkingSpeed;
        attackPower = power;
        currentHp = maxHp;
        attackedBy = [[NSMutableArray alloc] initWithCapacity:5];
        active = NO;
        slowTimer = Nil;
        
        mySprite = [CCSprite spriteWithFile:file];
		[self addChild:mySprite];
        
        Waypoint * waypoint = (Waypoint *)[theGame.waypoints objectAtIndex:([theGame.waypoints count]-1)];
        destinationWaypoint = waypoint.nextWaypoint;
        CGPoint pos = waypoint.myPosition;
        myPosition = pos;
        
        [mySprite setPosition:pos];
        [theGame addChild:self];
        [self scheduleUpdate];
	}
	return self;
}

-(void)doActivate
{
    active = YES;
}

-(void)update:(ccTime)dt
{
    if(!active)return;
    
    if([theGame circle:myPosition withRadius:1 collisionWithCircle:destinationWaypoint.myPosition
 collisionCircleRadius:1])
    {
        if(destinationWaypoint.nextWaypoint)
        {
            destinationWaypoint = destinationWaypoint.nextWaypoint;
        }else
        {
            //Reached the end of the road. Damage the player
            [theGame getHpDamage];
            [self getRemoved];
        }
    }
    
    CGPoint targetPoint = destinationWaypoint.myPosition;
    float movementSpeed = currentSpeed;
    
    CGPoint normalized = ccpNormalize(ccp(targetPoint.x-myPosition.x,targetPoint.y-myPosition.y));
    mySprite.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y,-normalized.x));
    
    myPosition = ccp(myPosition.x+normalized.x * movementSpeed,
                     myPosition.y+normalized.y * movementSpeed);
    
    [mySprite setPosition:myPosition];
    
    
}

-(void)getRemoved
{
    for(Tower* attacker in attackedBy)
    {
        [attacker targetKilled];
    }
    [self.parent removeChild:self cleanup:YES];
    [theGame.enemies removeObject:self];
    //Notify the game that we killed an enemy so we can check if we can send another wave
    [theGame enemyGotKilled];
}

// Add the following methods
-(void)getAttacked:(Tower *)attacker
{
    [attackedBy addObject:attacker];
}

-(void)gotLostSight:(Tower *)attacker
{
    [attackedBy removeObject:attacker];
}

-(void)getDamaged:(int)damage
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"laser_shoot.wav"];
    currentHp -=damage;
    if(currentHp <=0)
    {
        [theGame awardGold:200];
        [self getRemoved];
    }
}

-(void)changeSpeed:(float)difference
{
    if ((walkingSpeed * difference) < currentSpeed)
    {
        currentSpeed = (walkingSpeed * difference);
        if (slowTimer) {
            [slowTimer invalidate];
            slowTimer = Nil;
            
        }
        slowTimer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(resetSpeed) userInfo:nil repeats:NO];
    } else {
        if (slowTimer) {
            [slowTimer invalidate];
            slowTimer = Nil;
        }
        slowTimer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(resetSpeed) userInfo:nil repeats:NO];
    }
}

-(void)resetSpeed
{
    currentSpeed = walkingSpeed;
    slowTimer = Nil;
}

-(void)draw
{
    ccDrawSolidRect(ccp(myPosition.x+HEALTH_BAR_ORIGIN,
                        myPosition.y+16),
                    ccp(myPosition.x+HEALTH_BAR_ORIGIN+HEALTH_BAR_WIDTH,
                        myPosition.y+14),
                    ccc4f(1.0, 0, 0, 1.0));
    
    ccDrawSolidRect(ccp(myPosition.x+HEALTH_BAR_ORIGIN,
                        myPosition.y+16),
                    ccp(myPosition.x+HEALTH_BAR_ORIGIN + (float)(currentHp * HEALTH_BAR_WIDTH)/maxHp,
                        myPosition.y+14),
                    ccc4f(0, 1.0, 0, 1.0));
}

@end