//
//  HelloWorldLayer.mm
//  t6mb
//
//  Created by Ricardo Quesada on 3/24/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "SpaceScene.h"
#import "Ship.h"
#import "GravityWell.h"
#import "Asteroid.h"
#import "Shot.h"
#import "Tracker.h"



class TestContactListener : public b2ContactListener {
public:
    
    SpaceScene *layer;
    
    TestContactListener(SpaceScene *layer) {
        this->layer = layer;
    }
    
    void BeginContact(b2Contact *contact) {
        NSLog(@"Contact!");
        

        b2Body *ba = contact->GetFixtureA()->GetBody();
        b2Body *bb = contact->GetFixtureB()->GetBody();
        
        Asteroid *a = nil;
        Shot *shot = nil;
        
        id oa = (id) ba->GetUserData();
        id ob = (id) bb->GetUserData();
        if (oa != nil && ob != nil) {
            if ([oa isKindOfClass:[Asteroid class]] && [ob isKindOfClass:[Shot class]]) {
                a = oa;
                shot = ob;
            }
            if ([ob isKindOfClass:[Asteroid class]] && [oa isKindOfClass:[Shot class]]) {
                a = ob;
                shot = oa;
            }
            
            if (a != nil) {
                [layer indicateShotCollision:shot withAsteroid:a];
            }
           
        }
        
        
        
        
        

    }
};



// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// HelloWorldLayer implementation
@implementation SpaceScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SpaceScene *layer = [SpaceScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// enable touches
		self.isMouseEnabled = YES;
        self.isKeyboardEnabled = YES;
        
        sprites = [[NSMutableArray alloc] init];
        gravitySource = [[NSMutableArray alloc] init];
        shots = [[NSMutableArray alloc] init];
        shotCollision = [[NSMutableArray alloc] init];
        trackers = [[NSMutableArray alloc] init];
        
				
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -0.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
        m_debugDraw->SetFlags(m_debugDraw->e_shapeBit | m_debugDraw->e_jointBit | m_debugDraw->e_centerOfMassBit);
		world->SetDebugDraw(m_debugDraw);
        world->SetContactListener(new TestContactListener(self));
        
	
		
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
        
		
		// Call the body factory which allocates memory for the ground body
		// from a pool and creates the ground box shape (also from a pool).
		// The body is also added to the world.
		b2Body* groundBody = world->CreateBody(&groundBodyDef);
        
    
		
		// Define the ground box shape.
		b2EdgeShape groundBox;		
        
		
		// bottom

		groundBox.Set(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0)->SetSensor(NO);
		
		// top
		groundBox.Set(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0)->SetSensor(NO);
		
		// left
		groundBox.Set(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
		groundBody->CreateFixture(&groundBox,0)->SetSensor(NO);
		
		// right
		groundBox.Set(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0)->SetSensor(NO);
		
		
		//Set up sprite
		
		CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:150];
		[self addChild:batch z:0 tag:kTagBatchNode];
		
        ship = [[Ship alloc] initWithLayer:self andWorld:world];
        [sprites addObject:ship];
        
        
        for (int i = 0; i < 5; i++) {
            [sprites addObject:[[[Asteroid alloc] initWithLayer:self andWorld:world withScale:3]autorelease]];
        }
		
		

		[self schedule: @selector(tick:)];
        
        thrusting = NO;
        rotateCW = NO;
        rotateCCW = NO;
        
	}
	return self;
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}

-(void) addNewSpriteWithCoords:(CGPoint)p
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);


    Tracker *tracker = [[Tracker alloc] initWithLayer:self andWorld:world atPoint:p];
    [sprites addObject:tracker];
    [trackers addObject:tracker];
    
    [tracker release];
    
    
    

}




-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    NSMutableArray *deadShots = [[NSMutableArray alloc] init];
    for (Shot *s in shots) {
        if ([s dead]) {
            [deadShots addObject:s];
        }
    }
    for (Shot *s in deadShots) {
        
        [shots removeObject:s];
    }
    [deadShots release];
    [self processCollisions];

    for (Tracker *t in trackers) {
        [t track:ship];
    }
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{

        
        for (b2Fixture *f = b->GetFixtureList(); f; f = f->GetNext()) {
            if (f->GetUserData()) {
                CCParticleSystem *emitter = (CCParticleSystem *) f->GetUserData();
                emitter.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
            }
        }
        
        // apply gravity forces to body 
        for (GravityWell *well in gravitySource) {
            b2Body *g = well.body;
            

            
			b2CircleShape* circle = (b2CircleShape*)g->GetFixtureList()->GetShape();
			b2Vec2 center = g->GetWorldPoint(circle->m_p);
            
			b2Vec2 position = b->GetPosition();
            
			b2Vec2 d = center - position;
            float32 gf = (400.0f / d.LengthSquared()) * b->GetMass();
            
			if (d.LengthSquared() < FLT_EPSILON * FLT_EPSILON)
			{
				continue;
			}
            
			d.Normalize();
			b2Vec2 F = gf * d;
			b->ApplyForce(F, position);
        }
        
	}
    
    
  

    
    
    
    if (thrusting) [ship thrust];
    if (rotateCCW) [ship rotateCCW];
    if (rotateCW) [ship rotateCW];
}

- (BOOL) ccMouseDown:(NSEvent *)event
{
	CGPoint location = [(CCDirectorMac*)[CCDirector sharedDirector] convertEventToGL:event];
	[self addNewGravitySource: location];
	
	return YES;
}

- (BOOL) ccRightMouseDown:(NSEvent *)event {
    CGPoint location = [(CCDirectorMac*)[CCDirector sharedDirector] convertEventToGL:event];
	[self addNewSpriteWithCoords: location];
	
	return YES;
}



-(BOOL) ccKeyDown:(NSEvent *)event
{
	NSLog(@"key down: %d", [event keyCode] );
    short keyCode = [event keyCode];
    switch (keyCode) {
        case 124: rotateCW = YES;
            break;
        case 123:
            rotateCCW = YES;
            break;
        case 126:
            if (!thrusting) {
                thrusting = YES;
                [ship beginThrust];
            }
            break;
        case 49:
            [self addShot];
            break;
            
            
    }
	return YES;
}

-(BOOL) ccKeyUp:(NSEvent *)event
{
	//NSLog(@"key down: %d", [event keyCode] );
    short keyCode = [event keyCode];
    switch (keyCode) {
        case 124: rotateCW = NO;
            break;
        case 123:
            rotateCCW = NO;
            break;
        case 126:
            thrusting = NO;
            [ship endThrust];
            break;
            
    }
	return YES;
}

-(void) addNewGravitySource:(CGPoint)p {
    
    GravityWell *wellWorld = [[[GravityWell alloc] initWithLayer:self andWorld:world atPos:p] autorelease];
    [gravitySource addObject:wellWorld];
    
}

-(void) addShot {
    
    [shots addObject:[[[Shot alloc] initWithLayer:self andWorld:world fromShip:ship] autorelease]];
    
}

-(void) indicateShotCollision:(Shot *)shot withAsteroid:(Asteroid *)asteroid {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
    [dict setValue:shot forKey:@"shot"];
    [dict setValue:asteroid forKey:@"asteroid"];
    [shotCollision addObject:dict];
    [dict release];
}

-(void) processCollisions {
    for (NSDictionary *d in shotCollision) {
        Asteroid *a =  [d objectForKey:@"asteroid"];
        Shot *s = [d objectForKey:@"shot"];
        [sprites addObjectsFromArray:[a split]];
        [sprites removeObject:a];
        [shots removeObject:s];
        
    }
    [shotCollision removeAllObjects];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;


    [sprites release];
    [gravitySource release];
    [shots release];
    [shotCollision release];
    [trackers release];
    
	// don't forget to call "super dealloc"
	[super dealloc];
    
    
}
@end
