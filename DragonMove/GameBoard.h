//
//  Created by Sander Vispoel on 4/8/13.
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CCLayer.h"

@class Snake;

@interface GameBoard : CCLayer
{
    CCNode *_tails; // CCNode에 tail(꼬리)를 위한 빈 노드 선언.
    CCSprite *_candy; // 캔디(Candy) 스프라이트 이미지 선언.
    InterfaceLayer *_interface;
    // 점수를 다루기 위한 InterfaceLayer의 객체 선언.
    
    NSMutableArray *_fieldOpen;
    // 게임 영역에 삽입하기 위해 미리 읽어들이는 배열
    NSMutableArray *_fieldTaken;
    // 게임 영역으로부터 가져오는 것을 배열의 원소에 할당.
    
    int _maxPartTag;
    SimpleAudioEngine *sae;
    CCSprite *_dpad;
}

@property (nonatomic, assign) int maxPartTag;
@property (readonly) CCSprite *dpad;

-(void)onEnter; // 실행할 때
-(void)onExit; // 종료될 때

-(void)startGame; // 게임 시작 함수
-(void)gameOver; // 게임 종료 함수
-(void)setupSnake; // 뱀 설정을 위한 함수
-(void)removeFromFieldOpen:(Snake *)snake;
// 게임 영역에 열린 뱀의 객체를 제거
-(void)addToFieldTaken:(Snake *)snake;
// 게임 영역에 취한 좌표값을 이용하여 뱀의 객체를 삽입.
-(void)addSnakePartToField;
// 게임 영역에 뱀 부분(꼬리)을 삽입.
-(void)placeCandy;
// 사탕 위치 설정.
-(void)changeDirectionPoint:(int)directionFlag coords:(CGPoint)coords from:(Snake *)head;
// 뱀의 머리 객체로부터 받은 좌표값을 통해 방향 flag값에 해당하는 방향으로 전환.
-(int)collisionCheck:(CGPoint)pos DirectionFlag:(int)flag For:(Snake *)head;
// 뱀의 머리 객체로부터 좌표값을 통해 방향 flag을 이용하여 벽에 부딪침을 확인하면 1을, 사탕을 먹은 경우 2를 반환.
-(void)gameTick:(ccTime)dt;
// 게임 로직이 진행되는 함수

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

@end
