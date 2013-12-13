//
//  HelloWorldLayer.m
//  TowerDefenseUpdate
//
//  Created by Kevin Chen and Vincent Oe on 12/12/13.
//  Copyright Kevin Chen and Vincent Oe 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller


#pragma mark - HelloWorldLayer

#import "Tower.h"
#import "Waypoint.h"
#import "Enemy.h"
#import "PopupMenu.h"
#import "AppDelegate.h"
#import "GameOverMenu.h"
#import "VictoryMenu.h"

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

+(CCScene *) sceneWithLevel:(NSString *)level
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer nodeWithLevel:level];
	
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
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:[levelInfo valueForKey:@"music"] loop:YES];
        
        // 10 - popup menu
        NSString* towerListPath = [[NSBundle mainBundle] pathForResource:[levelInfo valueForKey:@"towers"] ofType:@"plist"];
        NSDictionary* towersDictionary = [NSDictionary dictionaryWithContentsOfFile:towerListPath];
        NSArray* towerList = [towersDictionary allKeys];
        popupController = [[PopupMenu alloc] init];
        UIView* cocosView = [[CCDirector sharedDirector] openGLView];
        [cocosView addSubview: popupController.view];
	}
	return self;
}

+(id)nodeWithLevel:(NSString*)level
{
    return [[self alloc] initWithLevel:level];
}

// on "init" you need to initialize your instance
-(id) initWithLevel:(NSString *)level
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		// 1 - initialize
        self.touchEnabled = YES;
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        NSString* levelName = level;
        NSString* levelPath = [[NSBundle mainBundle] pathForResource:levelName ofType:@"plist"];
        levelInfo = [NSDictionary dictionaryWithContentsOfFile:levelPath];
        
        // 2 - set background
        CCSprite* background = [CCSprite spriteWithFile:[levelInfo valueForKey:@"background"]];
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
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:[levelInfo valueForKey:@"music"] loop:YES];
        
        // 10 - popup menu
        NSString* towerListPath = [[NSBundle mainBundle] pathForResource:[levelInfo valueForKey:@"towers"] ofType:@"plist"];
        NSDictionary* towersDictionary = [NSDictionary dictionaryWithContentsOfFile:towerListPath];
        NSArray* towerList = [towersDictionary allKeys];
        NSMutableDictionary* towerCostList = [[NSMutableDictionary alloc] init];
        for (NSString* t in towerList)
        {
            NSDictionary* towerInfo = [towersDictionary valueForKey:t];
            int cost = [[towerInfo valueForKey:@"towerCost"] integerValue];
            [towerCostList setObject:[NSNumber numberWithInteger:cost] forKey:t];
        }
        popupController = [[PopupMenu alloc] initWithTowers:towerList andTowerCosts:towerCostList];
        UIView* cocosView = [[CCDirector sharedDirector] openGLView];
        [cocosView addSubview: popupController.view];
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

-(BOOL)canBuyTowerOfCost:(int) cost
{
    if (playerGold - cost >=0)
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
        int count = 0;
        BOOL notBase = YES;
        for(CCSprite * tb in towerBases) {
            if (CGRectContainsPoint([tb boundingBox], location) && !tb.userData) { //tb.userData means that theres a tower there
                
                //NSString* towerListPath = [[NSBundle mainBundle] pathForResource:[levelInfo valueForKey:@"towers"] ofType:@"plist"];
                //NSDictionary* towersList = [NSDictionary dictionaryWithContentsOfFile:towerListPath];
                
                // MAKE MENU TO RETURN AN NSSTRING OF THE SELECTED TOWER
                notBase = NO;
                if ([popupController isHidden] == nil){
                    UIView* cocosView = [[CCDirector sharedDirector] openGLView];
                    [cocosView addSubview: popupController.view];
                }
                else{
                    
                }

                NSLog (@"Value of my BOOL = %@", [popupController isHidden] ? @"YES" : @"NO");
                [popupController setTowerIndex:count];
                [popupController setHelloWorldLayer:self];
                [popupController toggleHidden];
               

            } else if (CGRectContainsPoint([tb boundingBox], location) && tb.userData) {
                //bring up menu to remove or update
                notBase = NO;
                [towers removeObject:tb.userData];
                [self removeChild:tb.userData];
                tb.userData = Nil;
            }
            count += 1;
        }
        if (notBase)
        {
            NSLog(@"NOT A BASE SPOT");
            NSLog (@"Value of popupcontroller isHidden = %@", [popupController isHidden] ? @"YES" : @"NO");
            if (![popupController isHidden])
            {
                [popupController setHidden];
            }
        }
    }
}

-(void)placeTower: (NSString*) tName atIndex: (NSInteger)index
{
    NSString* towerListPath = [[NSBundle mainBundle] pathForResource:[levelInfo valueForKey:@"towers"] ofType:@"plist"];
    NSDictionary* towersList = [NSDictionary dictionaryWithContentsOfFile:towerListPath];
    
    NSDictionary* towerData =[towersList valueForKey:tName];
    int towerCost = [[towerData objectForKey:@"towerCost"]integerValue];
    
    if ([self canBuyTowerOfCost:towerCost])
    {
        
        CCSprite* tb = [towerBases objectAtIndex:index];
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
        
        playerGold -= [tower towerCost];
        
        [ui_gold_lbl setString:[NSString stringWithFormat:@"GOLD: %d",playerGold]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"tower_place.wav"];
        
        [towers addObject:tower];
        tb.userData = (__bridge void*)(tower);
    } else {
        // Message that you cant buy the tower?
        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You do not have enough gold" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // Display Alert Message
        [messageAlert show];
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
    for (Tower *t in towers)
    {
        [t clearEnemyQueue];
    }
    [enemies removeAllObjects];
    
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
        
        int enemyLevel = [[enemyData objectForKey:@"level"]integerValue];
        if (enemyLevel == 0)
        {
            enemyLevel = 1;
        }
            
        int maxHP = [[e objectForKey:@"maxHP"]integerValue] * enemyLevel;
        float walkingSpeed = [[e objectForKey:@"walkingSpeed"]floatValue];
        int attackPower = [[e objectForKey:@"attackPower"]integerValue];
        int goldReward = [[e objectForKey:@"goldReward"]integerValue];
        NSMutableArray* spriteFile = [e valueForKey:@"spriteFile"];
        
        Enemy* enemy = [Enemy nodeWithTheGame:self
                                     andMaxHP:maxHP
                              andWalkingSpeed:walkingSpeed
                               andAttackPower:attackPower
                                andGoldReward:goldReward
                                andSpriteFile:spriteFile];
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
            [popupController setHidden];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionSplitCols
                                                       transitionWithDuration:1
                                                       scene:[VictoryMenu scene]]];
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
        [popupController setHidden];
        [[CCDirector sharedDirector]
         replaceScene:[CCTransitionRotoZoom transitionWithDuration:2
                                                             scene:[GameOverMenu scene]]];
    }
}

-(void)awardGold:(int)gold
{
    playerGold = playerGold + gold;
    [ui_gold_lbl setString:[NSString stringWithFormat:@"HP: %d",playerGold]];
}


@end
