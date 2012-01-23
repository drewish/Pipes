//
//  Tile.h
//  pipes
//
//  Created by andrew morton on 12/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

extern const CGPoint GoNorth;
extern const CGPoint GoSouth;
extern const CGPoint GoEast;
extern const CGPoint GoWest;

static inline BOOL
isNorthOf(const CGPoint visitor, const CGPoint location)
{
	return (visitor.x == location.x && visitor.y + 1 == location.y);
}
static inline BOOL
isEastOf(const CGPoint visitor, const CGPoint location)
{
	return (visitor.x == location.x + 1 && visitor.y == location.y);
}
static inline BOOL
isSouthOf(const CGPoint visitor, const CGPoint location)
{
	return (visitor.x == location.x && visitor.y == location.y + 1);
}
static inline BOOL
isWestOf(const CGPoint visitor, const CGPoint location)
{
	return (visitor.x + 1 == location.x && visitor.y == location.y);
}


@interface Tile : NSObject {
  @protected
    CGPoint pos;
    
}
@property(readonly) CGPoint position;

+(BOOL)connectNorth;
+(BOOL)connectEast;
+(BOOL)connectSouth;
+(BOOL)connectWest;

-(id)initWithPosition:(CGPoint) pos;

-(BOOL)canFlowFrom:(CGPoint) source;
-(CGPoint)flowDirectionFrom:(CGPoint) source;

-(void)flowInFromNorth;
-(void)flowInFromEast;
-(void)flowInFromSouth;
-(void)flowInFromWest;
@end

@interface TileEmpty : Tile
@end

@interface TilePump : Tile
@end

@interface TileN : TilePump
@end

@interface TileS : TilePump
@end

@interface TileE : TilePump
@end

@interface TileW : TilePump
@end



@interface TileSE : Tile
@end

@interface TileSW : Tile
@end

@interface TileEW : Tile
@end

@interface TileNESW : Tile
@end

@interface TileNE : Tile
@end

@interface TileNW : Tile
@end

@interface TileNS : Tile
@end

