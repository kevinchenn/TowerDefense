//
//  Waypoint.h
//  TowerDefenseUpdate
//
//  Created by Kevin Chen on 12/1/13.
//  Copyright (c) 2013 Kevin Chen and Vincent Oe. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"
#import "HelloWorldLayer.h"

@interface Waypoint: CCNode {
    HelloWorldLayer *theGame;
}

@property (nonatomic,readwrite) CGPoint myPosition;
@property (nonatomic,assign) Waypoint *nextWaypoint;

+(id)nodeWithTheGame:(HelloWorldLayer*)_game location:(CGPoint)location;
-(id)initWithTheGame:(HelloWorldLayer *)_game location:(CGPoint)location;

@end