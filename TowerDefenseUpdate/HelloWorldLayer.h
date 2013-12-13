//
//  HelloWorldLayer.h
//  TowerDefenseUpdate
//
//  Created by Kevin Chen and Vincent Oe on 12/12/13.
//  Copyright Kevin Chen and Vincent Oe 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@class PopupMenu;
@interface HelloWorldLayer : CCLayer 
{
    NSMutableArray* towerBases;
    
    CCLabelBMFont* ui_wave_lbl;
    CCLabelBMFont* ui_hp_lbl;
    CCLabelBMFont* ui_gold_lbl;
    
    NSDictionary* levelInfo;
    
    int wave;
    int playerHP;
    int playerGold;
    
    BOOL gameEnded;
    
    PopupMenu* popupController;
}

@property (nonatomic, strong) NSMutableArray *towers;
@property (nonatomic, strong) NSMutableArray *waypoints;
@property (nonatomic, strong) NSMutableArray *enemies;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
+(CCScene *) sceneWithLevel:(NSString*)level;
+(id) nodeWithLevel:(NSString*)level;
-(id) initWithLevel:(NSString*)level;
-(BOOL)circle:(CGPoint)circlePoint withRadius:(float)radius
    collisionWithCircle:(CGPoint)circlePointTwo collisionCircleRadius:(float)radiusTwo;
//void ccFillPoly(CGPoint *poli, int points, BOOL closePolygon);
-(void) enemyGotKilled;
-(void) getHpDamage;
-(void) doGameOver;
-(void) awardGold:(int)gold;
-(void) placeTower: (NSString*) tName atIndex: (NSInteger) index;
@end
