//
//  HelloWorldLayer.h
//  t6mb
//
//  Created by Ricardo Quesada on 3/24/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "Box2D.h" 
#import "GLES-Render.h"
#import "Ship.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 16


// HelloWorldLayer
@interface SpaceScene : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    Ship *ship;
    
    BOOL thrusting;
    BOOL rotateCW;
    BOOL rotateCCW;
    NSMutableArray *sprites;
    NSMutableArray *gravitySource;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;

-(void) addNewGravitySource:(CGPoint) p;

@end
