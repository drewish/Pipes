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
        [self addChild:map z:-1];
        playLayer = [map layerNamed:@"Play"];
        fillLayer = [map layerNamed:@"Fill"];
        infoLayer = [map layerNamed:@"Background"];
        NSAssert(playLayer != nil && fillLayer != nil && infoLayer != nil, @"GameLayer: couldn't find the layers");

        // TODO: unhardcode this:
        uint pumpGid = 9;
        CGPoint pos = CGPointMake(2, 4);
        [playLayer setTileGID:pumpGid at:pos];
        flowingInTile = [[[self classOfGid:pumpGid] alloc] initWithPosition:pos];
        flowingFromTile = [[TileEmpty alloc] init];
        
        // Set the pump to start in 5 seconds.
        [self schedule:@selector(pumpNextTile) interval:3 repeat:100 delay:7];
        
        // Sidebar
        CCSprite *sidebar = [CCSprite spriteWithFile:@"Sidebar.png"];
        sidebar.anchorPoint = CGPointMake(0, 0);
        sidebar.position = CGPointMake(size.width - sidebar.contentSize.width, 0);
        [sidebar.texture setAliasTexParameters];
        [self addChild:sidebar];
        
        // Next piece
        CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:playLayer.tileset.sourceImage];
        [tex setAliasTexParameters];
        CGRect rect = [playLayer.tileset rectForGID:playLayer.tileset.firstGid];        
        nextPiece = [CCSprite spriteWithTexture:tex rect:rect];
        nextPiece.anchorPoint = CGPointZero;
        nextPiece.position = CGPointMake(400, 224);
        [self addChild:nextPiece];
        [self pickNextPiece];
        
        // Quit menu item
		CCSprite *spriteNormal = [CCSprite spriteWithFile:@"MenuItemQuit.png" rect:CGRectMake(0,12*0,34,12)];
        [spriteNormal.texture setAliasTexParameters];
        CCSprite *spriteSelected = [CCSprite spriteWithFile:@"MenuItemQuit.png" rect:CGRectMake(0,12*1,34,12)];
        CCMenuItemSprite *itemQuit = [CCMenuItemSprite itemWithNormalSprite:spriteNormal selectedSprite:spriteSelected block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[StartScreenLayer scene]];
        }];
        CCMenu *menu = [CCMenu menuWithItems:itemQuit, nil];
        menu.anchorPoint = CGPointMake(0.5, 0);
        menu.position = ccp(432, 16);
        [menu alignItemsVertically];
        [self addChild:menu];
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
	CCDirector *director = [CCDirector sharedDirector];
	[[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(BOOL) isValidPosition:(CGPoint) pos
{
    return pos.x >= 0 && pos.y >= 0 && pos.x < map.mapSize.width && pos.y < map.mapSize.height;
}

-(CGPoint) tilePositionFromTouch:(UITouch*) touch
{
    CGPoint inPoints = [map convertTouchToNodeSpace:touch];
    CGPoint q = {
        (int) (inPoints.x / map.tileSize.width),
        // World origin is bottom left but map coordinates are top left so flip
        // the y.
        map.mapSize.height - (int) (inPoints.y / map.tileSize.height) - 1
    };
    return q;
}

-(Class)classOfGid:(uint) gid
{
    NSString *class = [[map propertiesForGID:gid] objectForKey:@"Class"];
    // It's always going to be a tile.
    return (class != nil && [class length] > 0) ? NSClassFromString(class) : [TileEmpty class];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // TODO figure out the right way to know that the game is over
    if (!nextPiece.visible) {
        return;
    }
    
    CGPoint pos = [self tilePositionFromTouch:touch];    
    if ([self isValidPosition:pos] == false || [infoLayer tileGIDAt:pos] != 14) {
        return;
    }
    
    CGPoint tileStart = nextPiece.position;
    [nextPiece runAction:[CCSequence 
                          actions:[CCMoveTo actionWithDuration: 0.25 position: [playLayer tileAt:pos].position], 
                          [CCCallBlock actionWithBlock:^{
                                [playLayer setTileGID:nextTileGid at:pos];
                                [self pickNextPiece];
                                nextPiece.position = tileStart;
                           }], nil]];
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
//    CCDirector *director = [CCDirector sharedDirector];
//    UIView *view = [touch view];
//    CGPoint touchLocation = [director convertToGL:[touch locationInView: view]];
//    CGPoint prevLocation = [director convertToGL:[touch previousLocationInView: view]];
//    CGPoint diff = ccpSub(touchLocation, prevLocation);
//
//    CGPoint currentPos = [map position];
//    [map setPosition: ccpAdd(currentPos, diff)];
}


-(Class)classNorthOf:(CGPoint) pos
{
    return [self classOfGid:[playLayer tileGIDAt:ccpAdd(pos, GoNorth)]];
}
-(Class)classEastOf:(CGPoint) pos
{
    return [self classOfGid:[playLayer tileGIDAt:ccpAdd(pos, GoEast)]];
}
-(Class)classSouthOf:(CGPoint) pos
{
    return [self classOfGid:[playLayer tileGIDAt:ccpAdd(pos, GoSouth)]];
}
-(Class)classWestOf:(CGPoint) pos
{
    return [self classOfGid:[playLayer tileGIDAt:ccpAdd(pos, GoWest)]];
}

-(BOOL) couldPlay:(Class) nextTileClass at:(CGPoint) pos
{
    CGSize size = map.mapSize;
    Class adjacentClass;
    
    // TODO I think this logic could be simplified quite a bit.
    
    // Make sure there's not already a piece there.
    if ([playLayer tileGIDAt:pos] > 1) {
        return false;
    }
    return true;
    
    // North
    if ([nextTileClass connectNorth] && pos.y == 0) {
        return false;
    }
    if (pos.y > 0) {
        adjacentClass = [self classNorthOf:pos];
        if (adjacentClass != [TileEmpty class] && [nextTileClass connectNorth] != [adjacentClass connectSouth]) {
            return false;
        }
    }
    // East
    if ([nextTileClass connectEast] && pos.x == size.width - 1) {
        return false;
    }
    if (pos.x < size.width - 1) {
        adjacentClass = [self classEastOf:pos];
        if (adjacentClass != [TileEmpty class] && [nextTileClass connectEast] != [adjacentClass connectWest]) {
            return false;
        }
    }
    // South
    if ([nextTileClass connectSouth] && pos.y == size.height - 1) {
        return false;
    }
    if (pos.y < size.height - 1) {
        adjacentClass = [self classSouthOf:pos];
        if (adjacentClass != [TileEmpty class] && [nextTileClass connectSouth] != [adjacentClass connectNorth]) {
            return false;
        }
    }
    // West
    if ([nextTileClass connectWest] && pos.x == 0) {
        return false;
    }
    if (pos.x > 0) {
        adjacentClass = [self classWestOf:pos];
        if (adjacentClass != [TileEmpty class] && [nextTileClass connectWest] != [adjacentClass connectEast]) {
            return false;
        }
    }
    return true;
}

-(void) pickNextPiece
{
    nextTileGid = (arc4random_uniform(7)) + 2;
    Class nextTileClass = [self classOfGid:nextTileGid];
    CGSize size = map.mapSize;
    CGPoint pos;
    
    CGRect rect = [playLayer.tileset rectForGID:nextTileGid];
    [nextPiece setTextureRect:rect rotated:NO untrimmedSize:rect.size];

    for (uint x = 0; x < size.width; x++) {
        for (uint y = 0; y < size.height; y++) {
            pos = ccp(x, y);
            uint tileGid ;
            // Make sure there's not already a piece there.
            if ([playLayer tileGIDAt:pos] > 1) {
                tileGid = 13; 
            }
            else {
                tileGid = [self couldPlay:nextTileClass at:pos] ? 14 : 15;
            }
            [infoLayer setTileGID:tileGid at:pos];
        }
    }
}

-(void) pumpNextTile
{
    [fillLayer setTileGID:20 at:flowingInTile.position];

    CGPoint direction = [flowingInTile flowDirectionFrom:flowingFromTile.position];
    NSAssert(!CGPointEqualToPoint(direction, CGPointZero), @"The tile doesn't give us a direction.");

    CGPoint nextPos = ccpAdd(flowingInTile.position, direction);
    if (![self isValidPosition:nextPos]) {
        [self endGame];
        return;
    }
    
    Tile *nextTile = [[[self classOfGid:[playLayer tileGIDAt:nextPos]] alloc] initWithPosition:nextPos];       
    if (![nextTile canFlowFrom:flowingInTile.position]) {
        [self endGame];
        return;
    }
    flowingFromTile = flowingInTile;
    flowingInTile = nextTile;
}


-(void) endGame
{
    [self unschedule:@selector(pumpNextTile)];
    nextPiece.visible = false;
}
@end
