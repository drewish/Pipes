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
        CCTMXLayer *layer = [map layerNamed:@"Play"];
        NSAssert( layer != nil, @"GameLayer: couldn't find the layer");

        // TODO: unhardcode this:
        uint startGid = 9;
        CGPoint pos = CGPointMake(0, 6);
        [layer setTileGID:startGid at:pos];
        CCSprite *tile = [layer tileAt:pos];
        NSString *class = [[map propertiesForGID:startGid] objectForKey:@"Class"];
        tile.userData = [[NSClassFromString(class) alloc] initWithSprite: tile];

        // Quit menu item
        CCMenuItemFont *itemQuit = [CCMenuItemFont itemFromString:@"Quit" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[StartScreenLayer scene]];
        }];
        itemQuit.fontSize = 20;
		
		CCMenu *menu = [CCMenu menuWithItems:itemQuit, nil];
        menu.position = ccp(size.width -10, size.height -50);
//		[menu alignItemsVertically];
        [self addChild: menu];
        
        [self pickNextPiece];
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

-(CGPoint) tilePositionFromTouch:(UITouch*) touch
{
    CGPoint inPoints = [map convertTouchToNodeSpace:touch];
    CCTMXLayer *layer = [map layerNamed:@"Play"];
    CGPoint q = {
        (int) (inPoints.x / map.tileSize.width),
        // World origin is bottom left but map coordinates are top left so flip
        // the y.
        layer.layerSize.height - (int) (inPoints.y / map.tileSize.height) - 1
    };
    return q;
}

-(Class)classOfGid:(uint) gid
{
    NSString *class = [[map propertiesForGID:gid] objectForKey:@"Class"];
    return ([class length] > 0) ? NSClassFromString(class) : nil;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCTMXLayer *playLayer = [map layerNamed:@"Play"];
    CCTMXLayer *infoLayer = [map layerNamed:@"Background"];

    CGPoint pos = [self tilePositionFromTouch:touch];
    Class nextTileClass = [self classOfGid:nextTileGid];
    
    NSLog(@"Touched %f, %f", pos.x, pos.y);
    //    CCSprite *s = [layer tileAt:q];
    if ([infoLayer tileGIDAt:pos] != 1) {
        return;
    }

//    CGPoint pos = CGPointMake(0, 6);
//    CCSprite *tile = [layer tileAt:pos];
//    tile.userData = [[NSClassFromString(class) alloc] initWithSprite: tile];
    
    [playLayer setTileGID:nextTileGid at:pos];
    [self pickNextPiece];

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

-(BOOL) gid:(uint) west canBeLeftOfGid:(uint) east
{
    if (east == 0 || west == 0) {
        return true;
    }
    return [[self classOfGid:west] connectEast] == [[self classOfGid:east] connectWest];
}

-(BOOL) couldPlay:(Class) nextTileClass at:(CGPoint) pos on: (CCTMXLayer*) playLayer
{
    CGSize size = playLayer.layerSize;
    uint adjacentGid;

    // North
    if ([nextTileClass connectNorth] && pos.y == 0) {
        return false;
    }
    else if (pos.y > 0) {
        adjacentGid = [playLayer tileGIDAt:CGPointMake(pos.x, pos.y - 1)];
        if (adjacentGid != 0 && [[self classOfGid:adjacentGid] connectSouth] != [nextTileClass connectNorth]) {
            return false;
        }
    }
    // East
    if ([nextTileClass connectEast] && pos.x == size.width - 1) {
        return FALSE;
    }
    else if (pos.x < size.width - 1) {
        adjacentGid = [playLayer tileGIDAt:CGPointMake(pos.x + 1, pos.y)];
        if (adjacentGid != 0 && [nextTileClass connectEast] != [[self classOfGid:adjacentGid] connectWest]) {
            return false;
        }
    }
    // South
    if ([nextTileClass connectSouth] && pos.y == size.height - 1) {
        return false;
    }
    else if (pos.y < size.height - 1) {
        adjacentGid = [playLayer tileGIDAt:CGPointMake(pos.x, pos.y + 1)];
        if (adjacentGid != 0 && [nextTileClass connectSouth] != [[self classOfGid:adjacentGid] connectNorth]) {
            return false;
        }
    }
    // West
    if ([nextTileClass connectWest] && pos.x == 0) {
        return false;
    }
    else if (pos.x > 0) {
        adjacentGid = [playLayer tileGIDAt:CGPointMake(pos.x - 1, pos.y)];
        if (adjacentGid != 0 && [nextTileClass connectWest] != [[self classOfGid:adjacentGid] connectEast]) {
            return false;
        }
    }
    return true;
}

-(void) pickNextPiece
{
    nextTileGid = (arc4random_uniform(7)) + 2;
    Class nextTileClass = [self classOfGid:nextTileGid];
    CCTMXLayer *playLayer = [map layerNamed:@"Play"];
    CCTMXLayer *infoLayer = [map layerNamed:@"Background"];
    CGSize size = infoLayer.layerSize;
    uint disabledGid = 14;
    CGPoint pos;
    
    NSLog(@"Next is %@", [[map propertiesForGID:nextTileGid] objectForKey:@"Class"]);
	for (uint x = 0; x < size.width; x++) {
		for (uint y = 0; y < size.height; y++) {
            pos = CGPointMake(x, y);
            [infoLayer setTileGID:([self couldPlay:nextTileClass at:pos on:playLayer] ? 1 : disabledGid) at:pos];
		}
	}
}


@end
