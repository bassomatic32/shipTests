//
//  Asteroid.h
//  tractor-mac
//
//  Created by Michael Bass on 12/20/11.
//  Copyright (c) 2011 Macadamian. All rights reserved.
//

#import "Box2DSprite.h"

@interface Asteroid : Box2DSprite {
    int _scale;
}

-(id) initWithLayer:(CCLayer *)layer andWorld:(b2World *)world withScale:(int) scale;


-(NSArray *) split;

@property int scale;

@end
