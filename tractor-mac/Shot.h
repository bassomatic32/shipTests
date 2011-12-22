//
//  Shot.h
//  tractor-mac
//
//  Created by Michael Bass on 12/20/11.
//  Copyright (c) 2011 Macadamian. All rights reserved.
//

#import "Box2DSprite.h"
#import "Ship.h"

@interface Shot : Box2DSprite {
    time_t startTime;
}

-(id) initWithLayer:(CCLayer *)layer andWorld:(b2World *)world fromShip:(Ship *) ship;

-(BOOL) dead;




@end
