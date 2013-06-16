//
//  GameScene.h
//
//  Created by Sander Vispoel on 4/8/13.
//  Revised by Yonggu Choi on 6/16/13.
//
//

#import "CCLayer.h"
#import "cocos2d.h"

@class GameBoard, Background;

@interface GameScene : CCLayer
{
    GameBoard *_gameBoard;
    Background *_background;
}

@property (nonatomic, assign) GameBoard* gameBoard;
@property (nonatomic, assign) Background *background;

+(CCScene *) scene;

@end
