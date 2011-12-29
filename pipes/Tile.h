//
//  Tile.h
//  pipes
//
//  Created by andrew morton on 12/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Tile : NSObject {
  @protected
    CCSprite *sprite;
}
@property(readonly) CCSprite *sprite;

+(BOOL)connectNorth;
+(BOOL)connectEast;
+(BOOL)connectSouth;
+(BOOL)connectWest;
-(id)initWithSprite:(CCSprite*) s;

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

@interface TileN : Tile
@end

@interface TileS : Tile
@end

@interface TileE : Tile
@end

@interface TileW : Tile
@end
