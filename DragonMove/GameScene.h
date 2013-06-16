//
//  GameScene.h
//
//  Created by Sander Vispoel on 4/8/13.
//  Reviesed by Yonggu Choi on 16/6/13.
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
