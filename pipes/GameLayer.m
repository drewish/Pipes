//
//  GameLayer.m
//  pipes
//
//  Created by andrew morton on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "StartScreenLayer.h"

@implementation GameLayer

enum {
    kTagTileMap = 1,
};

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CCLayer *layer = [GameLayer node];
	
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
		self.isTouchEnabled = YES;
        
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

        
        map = [CCTMXTiledMap tiledMapWithTMXFile:@"Board.tmx"];
		[self addChild:map z:-1 tag:kTagTileMap];
		
		CGSize s = map.contentSize;
		NSLog(@"ContentSize: %f, %f", s.width,s.height);
		
		NSLog(@"----> Iterating over all the group objets");
		CCTMXObjectGroup *group = [map objectGroupNamed:@"Object Layer 1"];
		for( NSDictionary *dict in group.objects) {
			NSLog(@"object: %@", dict);
		}
        
        
		// Font Item
		CCMenuItemFont *itemQuit = [CCMenuItemFont itemFromString:@"Quit" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[StartScreenLayer scene]];
        }];
        itemQuit.fontSize = 20;
		
		CCMenu *menu = [CCMenu menuWithItems:itemQuit, nil];
        menu.position = ccp(size.width -50, size.height -50);
//		[menu alignItemsVertically];

        
        [self addChild: menu];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCTMXLayer *layer = [map layerNamed:@"Play"];
    CGPoint p = [map convertTouchToNodeSpace:touch];
    CGPoint q = {
        (int) (p.x / map.tileSize.width),
        // World origin is bottom left but map coordinates are top left so flip
        // the y.
        layer.layerSize.height - (int) (p.y / map.tileSize.height) - 1
    };
    //    NSLog(@"Touched %f, %f", q.x, q.y);
    //    CCSprite *s = [layer tileAt:q];
    if ([layer tileGIDAt:q] == 0) {
        [layer setTileGID:(arc4random_uniform(7)) + 2 at:q];
    }
//    NSLog(@"Touched %i", );
    //    [layer removeTileAt:q];

}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCDirector *director = [CCDirector sharedDirector];
    UIView *view = [touch view];
	CGPoint touchLocation = [director convertToGL:[touch locationInView: view]];
	CGPoint prevLocation = [director convertToGL:[touch previousLocationInView: view]];
	CGPoint diff = ccpSub(touchLocation, prevLocation);
	
	CGPoint currentPos = [map position];
	[map setPosition: ccpAdd(currentPos, diff)];
}

@end
