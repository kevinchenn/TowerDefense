//
//  HelloWorldLayer.m
//  TowerDefenseUpdate
//
//  Created by Brian Broom on 4/7/13.
//  Copyright Brian Broom 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

#import "Tower.h"
#import "Waypoint.h"
#import "Enemy.h"

#import "SimpleAudioEngine.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize towers;
@synthesize waypoints;
@synthesize enemies;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		// 1 - initialize
        self.touchEnabled = YES;
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        NSString* levelName = @"level1";
        NSString* levelPath = [[NSBundle mainBundle] pathForResource:levelName ofType:@"plist"];
        levelInfo = [NSDictionary dictionaryWithContentsOfFile:levelPath];
        
        // 2 - set background
        CCSprite* background = [CCSprite spriteWithFile:@"bg1.png"];
        //CCSprite* background = [CCSprite spriteWithFile:[levelInfo valueForKey:@"background"]];
        [self addChild:background];
        [background setPosition:ccp(winSize.width/2, winSize.height/2)];
        
        // 3 - load tower positions
        [self loadTowerPositions];
        
        // 4 - add waypoints
        [self addWaypoints];
        
        // 5 - add enemies
        enemies = [[NSMutableArray alloc] init];
        [self loadWave];
        
        // 6 - create wave label
        ui_wave_lbl = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"WAVE: %d", wave]
                                             fntFile:@"font_red_14.fnt"];
        [self addChild:ui_wave_lbl z:100];
        [ui_wave_lbl setPosition:ccp(400, winSize.height-12)];
        [ui_wave_lbl setAnchorPoint:ccp(0,0.5)];
        
        // 7 - player lives
        //playerHP = 5;
        playerHP = [[levelInfo valueForKey:@"initialHealth"]integerValue];
        ui_hp_lbl = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"HP: %d",playerHP]
                                           fntFile:@"font_red_14.fnt"];
        [self addChild:ui_hp_lbl z:10];
        [ui_hp_lbl setPosition:ccp(35,winSize.height-12)];
        
        // 8 - gold
        //playerGold = 1000;
        playerGold = [[levelInfo valueForKey:@"initialGold"]integerValue];
        ui_gold_lbl = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"GOLD: %d",playerGold]
                                             fntFile:@"font_red_14.fnt"];
        [self addChild:ui_gold_lbl z:10];
        [ui_gold_lbl setPosition:ccp(135,winSize.height-12)];
        [ui_gold_lbl setAnchorPoint:ccp(0,0.5)];
        
        // 9 - sound
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[levelInfo valueForKey:@"music"] loop:YES];
	}
	return self;
}

-(void)loadTowerPositions
{
    //NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"towerPositions" ofType:@"plist"];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:[levelInfo valueForKey:@"towerPositions"] ofType:@"plist"];
    NSArray * towerPositions = [NSArray arrayWithContentsOfFile:plistPath];
    towerBases = [[NSMutableArray alloc] initWithCapacity:25];
    
    for(NSDictionary * towerPos in towerPositions)
    {
        
        //CAN MAKE THE BASE A TRANSPARENT BOX TO MAKE A GRID?
        CCSprite * towerBase = [CCSprite spriteWithFile:@"gridSpot.png"];
        [self addChild:towerBase];
        [towerBase setPosition:ccp([[towerPos objectForKey:@"x"] intValue],
                                   [[towerPos objectForKey:@"y"] intValue])];
        [towerBases addObject:towerBase];
    }
}

-(BOOL)canBuyTower
{
    if (playerGold - 300 >=0)
        return YES;
    return NO;
}

-(BOOL)canBuyTower:(Tower *) tower {
    if (playerGold - [tower towerCost] >=0)
        return YES;
    return NO;
}

//NEED TO MAKE THIS BRING UP A MENU
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:[touch view]];
        
        location = [[CCDirector sharedDirector] convertToGL:location];
    
        for(CCSprite * tb in towerBases) {
            if (CGRectContainsPoint([tb boundingBox], location) && !tb.userData) { //tb.userData means that theres a tower there
                
                NSString* towerListPath = [[NSBundle mainBundle] pathForResource:[levelInfo valueForKey:@"towers"] ofType:@"plist"];
                NSDictionary* towersList = [NSDictionary dictionaryWithContentsOfFile:towerListPath];
                
                // MAKE MENU TO RETURN AN NSSTRING OF THE SELECTED TOWER
                
                NSString* tName = @"basicTower";
                //NSString* tName = @"rapidTower";
                //NSString* tName = @"slowTower";
                //NSString* tName = @"splashTower";
                //NSString* tName = @"rangeTower";
                
                NSDictionary* towerData =[towersList valueForKey:tName];
                                
                //Tower* tower = [Tower nodeWithTheGame:self location:tb.position];
                Tower* tower = [Tower nodeWithTheGame:self location:tb.position
                                       andAttackRange:[[towerData objectForKey:@"attackRange"]integerValue]
                                       andDamagePower:[[towerData objectForKey:@"damagePower"]integerValue]
                                          andFireRate:[[towerData objectForKey:@"fireRate"]floatValue]
                                         andTowerCost:[[towerData objectForKey:@"towerCost"]integerValue]
                                      andSplashRadius:[[towerData objectForKey:@"splashRadius"]floatValue]
                                        andSlowEffect:[[towerData objectForKey:@"slowEffect"]floatValue]
                                        andSpriteFile:[towerData valueForKey:@"spriteFile"]
                                        andBulletFile:[towerData valueForKey:@"bulletFile"]
                                       andBulletSpeed:[[towerData objectForKey:@"bulletSpeed"]floatValue]];
                
                if ([self canBuyTower:tower])
                {
                    playerGold -= [tower towerCost]; //NEEDS TO BE ABSTRACTED AWAY
                
                [ui_gold_lbl setString:[NSString stringWithFormat:@"GOLD: %d",playerGold]];
                [[SimpleAudioEngine sharedEngine] playEffect:@"tower_place.wav"];
                
                [towers addObject:tower];
                tb.userData = (__bridge void*)(tower);
                } else {
                    // Message that you cant buy the tower?
                }
            } else if (CGRectContainsPoint([tb boundingBox], location) && tb.userData) {
                //bring up menu to remove or update
                [towers removeObject:tb.userData];
                [self removeChild:tb.userData];
                tb.userData = Nil;
            }
        }
    }
}

-(void)addWaypoints
{
    NSString* waypointListPath = [[NSBundle mainBundle] pathForResource:[levelInfo valueForKey:@"waypoints"] ofType:@"plist"];
    NSMutableArray* waypointList = [NSMutableArray arrayWithContentsOfFile:waypointListPath];
    waypoints = [[NSMutableArray alloc] init];
    
    for (NSDictionary* wp in waypointList) {
        Waypoint * point = [Waypoint nodeWithTheGame:self location:ccp([[wp valueForKey:@"x"]integerValue],[[wp valueForKey:@"y"]integerValue])];
        [waypoints addObject:point];
    }
    
    NSInteger i = [waypoints count] - 1;
    while (i > 0) {
        Waypoint* wp = [waypoints objectAtIndex:i];
        wp.nextWaypoint = [waypoints objectAtIndex:i-1];
        i--;
    }

    //Waypoint * waypoint1 = [Waypoint nodeWithTheGame:self location:ccp(480,175)];
    //[waypoints addObject:waypoint1];
    
    //Waypoint * waypoint2 = [Waypoint nodeWithTheGame:self location:ccp(305,175)];
    //[waypoints addObject:waypoint2];
    //waypoint2.nextWaypoint =waypoint1;
    
    //Waypoint * waypoint3 = [Waypoint nodeWithTheGame:self location:ccp(305,112)];
    //[waypoints addObject:waypoint3];
    //waypoint3.nextWaypoint =waypoint2;
    
    //Waypoint * waypoint4 = [Waypoint nodeWithTheGame:self location:ccp(175,112)];
    //[waypoints addObject:waypoint4];
    //waypoint4.nextWaypoint =waypoint3;
    
    //Waypoint * waypoint5 = [Waypoint nodeWithTheGame:self location:ccp(175,235)];
    //[waypoints addObject:waypoint5];
    //waypoint5.nextWaypoint =waypoint4;
    
    //Waypoint * waypoint6 = [Waypoint nodeWithTheGame:self location:ccp(78,235)];
    //[waypoints addObject:waypoint6];
    //waypoint6.nextWaypoint =waypoint5;
    
    //Waypoint * waypoint7 = [Waypoint nodeWithTheGame:self location:ccp(78,140)];
    //[waypoints addObject:waypoint7];
    //waypoint7.nextWaypoint =waypoint6;
    
    //Waypoint * waypoint8 = [Waypoint nodeWithTheGame:self location:ccp(-40,140)];
    //[waypoints addObject:waypoint8];
    //waypoint8.nextWaypoint =waypoint7;
}

-(BOOL)circle:(CGPoint)circlePoint withRadius:(float)radius collisionWithCircle:(CGPoint)circlePointTwo collisionCircleRadius:(float)radiusTwo
{
    float xdif = circlePoint.x - circlePointTwo.x;
    float ydif = circlePoint.y - circlePointTwo.y;
    
    float distance = sqrt(xdif*xdif+ydif*ydif);
    
    if(distance <= radius+radiusTwo)
        return YES;
    
    return NO;
}

-(BOOL)loadWave
{
    //NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"waves" ofType:@"plist"];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:[levelInfo valueForKey:@"waves"] ofType:@"plist"];
    NSArray* waveData = [NSArray arrayWithContentsOfFile:plistPath];
    
    if(wave >= [waveData count])
    {
        return NO;
    }
    
    NSArray* currentWaveData =[NSArray arrayWithArray:[waveData objectAtIndex:wave]];
    
    for(NSDictionary* enemyData in currentWaveData)
    {
        NSString* enemyType = [[NSBundle mainBundle] pathForResource:[enemyData valueForKey:@"enemyType"] ofType:@"plist"];
        NSDictionary* e = [NSDictionary dictionaryWithContentsOfFile:enemyType];
        
        Enemy* enemy = [Enemy nodeWithTheGame:self
                                     andMaxHP:[[e objectForKey:@"maxHP"]integerValue]
                              andWalkingSpeed:[[e objectForKey:@"walkingSpeed"]floatValue]
                               andAttackPower:[[e objectForKey:@"attackPower"]integerValue]
                                andSpriteFile:[e valueForKey:@"spriteFile"]];
        [enemies addObject:enemy];
        [enemy schedule:@selector(doActivate) interval:[[enemyData objectForKey:@"spawnTime"]floatValue]];
    }
    
    wave++;
    [ui_wave_lbl setString:[NSString stringWithFormat:@"WAVE: %d",wave]];
    
    return YES;
}

-(void) enemyGotKilled {
    if ([enemies count]<=0) //If there are no more enemies.
    {
        if(![self loadWave])
        {
            NSLog(@"You win!");
            [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitCols
                                                       transitionWithDuration:1
                                                       scene:[HelloWorldLayer scene]]];
        }
    }
}

//CHANGE CALL TO GETHPDAMAGE
-(void)getHpDamage:(int) value {
    [[SimpleAudioEngine sharedEngine] playEffect:@"life_lose.wav"];
    playerHP = playerHP - value;
    [ui_hp_lbl setString:[NSString stringWithFormat:@"HP: %d",playerHP]];
    if (playerHP <=0) {
        [self doGameOver];
    }
}

-(void)getHpDamage
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"life_lose.wav"];
    playerHP--;
    [ui_hp_lbl setString:[NSString stringWithFormat:@"HP: %d",playerHP]];
    if (playerHP <=0) {
        [self doGameOver];
    }
}

-(void)doGameOver {
    if (!gameEnded) {
        gameEnded = YES;
        [[CCDirector sharedDirector]
         replaceScene:[CCTransitionRotoZoom transitionWithDuration:1
                                                             scene:[HelloWorldLayer scene]]];
    }
}

-(void)awardGold:(int)gold
{
    playerGold = playerGold + gold;
    [ui_gold_lbl setString:[NSString stringWithFormat:@"HP: %d",playerGold]];
}

@end
