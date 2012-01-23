//
//  Tile.m
//  pipes
//
//  Created by andrew morton on 12/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tile.h"
#import "StartScreenLayer.h"

const CGPoint GoNorth = {0, -1};
const CGPoint GoSouth = {0, 1};
const CGPoint GoEast = {1, 0};
const CGPoint GoWest = {-1, 0};

@implementation Tile
+(BOOL)connectNorth { return false; }
+(BOOL)connectEast { return false; }
+(BOOL)connectSouth { return false; }
+(BOOL)connectWest { return false; }

@synthesize position=pos;

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;    
}

-(id)initWithPosition:(CGPoint) p
{
    self = [self init];
    if (self) {
        pos.x = p.x;
        pos.y = p.y;
    }
    return self;
}

-(BOOL)canFlowFrom:(CGPoint) source
{
    return FALSE;
}

-(CGPoint)flowDirectionFrom:(CGPoint) source
{
    return CGPointZero;
}

-(void)endGame
{
    [[CCDirector sharedDirector] replaceScene:[StartScreenLayer scene]];
}

-(void)flowInFromNorth
{
    [self endGame];
}

-(void)flowInFromEast
{
    [self endGame];    
}

-(void)flowInFromSouth
{
    [self endGame];
}

-(void)flowInFromWest
{
    [self endGame];    
}
@end


@implementation TileEmpty : Tile
@end


@implementation TilePump
// Pumps can always start.
-(BOOL)canFlowFrom:(CGPoint) source { return true; }
@end

@implementation TileN
+(BOOL)connectNorth { return true; }
-(CGPoint)flowDirectionFrom:(CGPoint) source { return GoNorth; }
@end

@implementation TileS
+(BOOL)connectSouth { return true; }
-(CGPoint)flowDirectionFrom:(CGPoint) source { return GoSouth; }
@end

@implementation TileE
+(BOOL)connectEast { return true; }
-(CGPoint)flowDirectionFrom:(CGPoint) source { return GoEast; }
@end

@implementation TileW
+(BOOL)connectWest { return true; }
-(CGPoint)flowDirectionFrom:(CGPoint) source { return GoWest; }
@end



@implementation TileSE
+(BOOL)connectEast { return true; }
+(BOOL)connectSouth { return true; }
-(BOOL)canFlowFrom:(CGPoint) source
{
    return isEastOf(source, pos) || isSouthOf(source, pos);
}
-(CGPoint)flowDirectionFrom:(CGPoint) source 
{
    if (isEastOf(source, pos)) return GoSouth;
    if (isSouthOf(source, pos)) return GoEast;
    return CGPointZero;
}
@end

@implementation TileSW
+(BOOL)connectSouth { return true; }
+(BOOL)connectWest { return true; }
-(BOOL)canFlowFrom:(CGPoint) source
{
    return isSouthOf(source, pos) || isWestOf(source, pos);
}
-(CGPoint)flowDirectionFrom:(CGPoint) source 
{
    if (isSouthOf(source, pos)) return GoWest;
    if (isWestOf(source, pos)) return GoSouth;
    return CGPointZero;
}
@end

@implementation TileEW
+(BOOL)connectEast { return true; }
+(BOOL)connectWest { return true; }
-(BOOL)canFlowFrom:(CGPoint) source
{
    return isEastOf(source, pos) || isWestOf(source, pos);
}
-(CGPoint)flowDirectionFrom:(CGPoint) source 
{
    if (isEastOf(source, pos)) return GoWest;
    if (isWestOf(source, pos)) return GoEast;
    return CGPointZero;
}
@end

@implementation TileNESW
+(BOOL)connectNorth { return true; }
+(BOOL)connectEast { return true; }
+(BOOL)connectSouth { return true; }
+(BOOL)connectWest { return true; }
-(BOOL)canFlowFrom:(CGPoint) source
{
    return isNorthOf(source, pos) || isEastOf(source, pos) || isSouthOf(source, pos) || isWestOf(source, pos);
}
-(CGPoint)flowDirectionFrom:(CGPoint) source 
{
    if (isNorthOf(source, pos)) return GoSouth;
    if (isEastOf(source, pos)) return GoWest;
    if (isSouthOf(source, pos)) return GoNorth;
    if (isWestOf(source, pos)) return GoEast;
    return CGPointZero;
}
@end

@implementation TileNE
+(BOOL)connectNorth { return true; }
+(BOOL)connectEast { return true; }
-(BOOL)canFlowFrom:(CGPoint) source
{
    return isNorthOf(source, pos) || isEastOf(source, pos);
}
-(CGPoint)flowDirectionFrom:(CGPoint) source 
{
    if (isNorthOf(source, pos)) return GoEast;
    if (isEastOf(source, pos)) return GoNorth;
    return CGPointZero;
}
@end

@implementation TileNW
+(BOOL)connectNorth { return true; }
+(BOOL)connectWest { return true; }
-(BOOL)canFlowFrom:(CGPoint) source
{
    return isNorthOf(source, pos) || isWestOf(source, pos);
}
-(CGPoint)flowDirectionFrom:(CGPoint) source 
{
    if (isNorthOf(source, pos)) return GoWest;
    if (isWestOf(source, pos)) return GoNorth;
    return CGPointZero;
}
@end

@implementation TileNS
+(BOOL)connectNorth { return true; }
+(BOOL)connectSouth { return true; }
-(BOOL)canFlowFrom:(CGPoint) source
{
    return isNorthOf(source, pos) || isSouthOf(source, pos);
}
-(CGPoint)flowDirectionFrom:(CGPoint) source 
{
    if (isNorthOf(source, pos)) return GoSouth;
    if (isSouthOf(source, pos)) return GoNorth;
    return CGPointZero;
}
@end
