//
//  GamePlay.m
//  mirror
//
//  Created by Shinsaku Uesugi on 8/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlay.h"

@implementation GamePlay {
    int _level;
    CCLabelTTF *_levelLabel;
    
    CCLabelTTF *_num;
    
    CCLabelTTF *_answerLabel;
    int _answer;
    BOOL _isEven;
    
    CCLabelTTF *_evenOrOdd;
    CCButton *_even;
    CCButton *_odd;
    
    int _time;
    CCLabelTTF *_timerLabel;
    
    CCButton *_start;
    
    CCLabelTTF *_correct;
    CCLabelTTF *_incorrect;
    
    int _life;
    CCSprite *_lifeOne;
    CCSprite *_lifeTwo;
    
    CCLabelTTF *_difficultyLabel;
}

- (void)onEnter {
    [super onEnter];
    _level = 1;
    _life = 2;
    
    _even.enabled = false;
    _odd.enabled = false;
    _timerLabel.visible = false;
    _evenOrOdd.visible = false;
    
    [self bounce];
}

- (void)next {
    _answer = 0;
    
    if (_level < 5) {
        for (int i = 0; i < _level + 1; i++) {
            [self performSelector:@selector(generateNum) withObject:self afterDelay:i+1];
            [self performSelector:@selector(setVisibleFalse) withObject:self afterDelay:i+1.5];
            
            if (i == _level) {
                [self performSelector:@selector(enableButtons) withObject:self afterDelay:i+2];
            }
        }
    } else if (_level >= 5 && _level < 10) {
        for (int i = 0; i < _level + 1; i++) {
            [self performSelector:@selector(generateNum) withObject:self afterDelay:i+1];
            [self performSelector:@selector(setVisibleFalse) withObject:self afterDelay:i+1.3];
            
            if (i == _level) {
                [self performSelector:@selector(enableButtons) withObject:self afterDelay:i+1.8];
            }
        }
    } else if (_level >= 10 && _level < 15) {
        for (int i = 0; i < _level + 1; i++) {
            float x = i * 0.75;
            [self performSelector:@selector(generateNum) withObject:self afterDelay:x+1];
            [self performSelector:@selector(setVisibleFalse) withObject:self afterDelay:x+1.3];
            
            if (i == _level) {
                [self performSelector:@selector(enableButtons) withObject:self afterDelay:x+1.8];
            }
        }
    } else if (_level >= 15 && _level < 20) {
        for (int i = 0; i < _level + 1; i++) {
            float x = i * 0.6;
            [self performSelector:@selector(generateNum) withObject:self afterDelay:x+1];
            [self performSelector:@selector(setVisibleFalse) withObject:self afterDelay:x+1.3];
            
            if (i == _level) {
                [self performSelector:@selector(enableButtons) withObject:self afterDelay:x+1.8];
            }
        }
    } else if (_level >= 20 && _level < 25) {
        for (int i = 0; i < _level + 1; i++) {
            float x = i * 0.45;
            [self performSelector:@selector(generateNum) withObject:self afterDelay:x+1];
            [self performSelector:@selector(setVisibleFalse) withObject:self afterDelay:x+1.225];
            
            if (i == _level) {
                [self performSelector:@selector(enableButtons) withObject:self afterDelay:x+1.725];
            }
        }
    } else if (_level >= 25) {
        for (int i = 0; i < _level + 1; i++) {
            float x = i * 0.35;
            [self performSelector:@selector(generateNum) withObject:self afterDelay:x+1];
            [self performSelector:@selector(setVisibleFalse) withObject:self afterDelay:x+1.175];
            
            if (i == _level) {
                [self performSelector:@selector(enableButtons) withObject:self afterDelay:x+1.675];
            }
        }
    }
}

- (void)generateNum {
    _num.visible = true;
    int rng = arc4random() % 13 + 1;
    if (rng == 10) {
        rng = 2;
    } else if (rng == 11) {
        rng = 5;
    } else if (rng == 12) {
        rng = 6;
    } else if (rng == 13) {
        rng = 9;
    }
    _num.string = [NSString stringWithFormat:@"%i", rng];
    _answer += rng;
}

- (void)setVisibleFalse {
    _num.visible = false;
}

- (void)enableButtons {
    _time = 5;
    _timerLabel.string = [NSString stringWithFormat:@"%i",_time];
    if (_answer % 2 == 0) {
        _isEven = true;
    } else {
        _isEven = false;
    }
    _even.enabled = true;
    _odd.enabled = true;
    _timerLabel.visible = true;
    [self schedule:@selector(timer) interval:1.f];
}

- (void)answered {
    [self unschedule:@selector(timer)];
    
    _even.enabled = false;
    _odd.enabled = false;
    _timerLabel.visible = false;
    _evenOrOdd.visible = false;
    
    if (_life > 0) {
        [self bounce];
    }
}

- (void)even {
    _answerLabel.string = [NSString stringWithFormat:@"%i",_answer];
    _answerLabel.visible = true;
    if (_isEven) {
        [self addAndMoveLabel];
        [self correct:_even];
        [self answered];
    } else {
        [self incorrect:_even];
        [self answered];
    }
}

- (void)odd {
    _answerLabel.string = [NSString stringWithFormat:@"%i",_answer];
    _answerLabel.visible = true;
    if (!_isEven) {
        [self addAndMoveLabel];
        [self correct:_odd];
        [self answered];
    } else {
        [self incorrect:_odd];
        [self answered];
    }
}

- (void)addAndMoveLabel {
    _level++;
    _levelLabel.string = [NSString stringWithFormat:@"%i",_level];
    if (_level == 5) {
        _difficultyLabel.string = @"2";
    } else if (_level == 10) {
        _difficultyLabel.string = @"3";
        _levelLabel.position = ccp(_levelLabel.position.x+0.02,_levelLabel.position.y);
    } else if (_level == 15) {
        _difficultyLabel.string = @"4";
        _levelLabel.position = ccp(_levelLabel.position.x+0.02,_levelLabel.position.y);
    } else if (_level == 20) {
        _difficultyLabel.string = @"5";
        _levelLabel.position = ccp(_levelLabel.position.x+0.02,_levelLabel.position.y);
    } else if (_level == 25) {
        _difficultyLabel.string = @"6";
        _levelLabel.position = ccp(_levelLabel.position.x+0.02,_levelLabel.position.y);
    }
}

- (void)timer {
    _time--;
    _timerLabel.string = [NSString stringWithFormat:@"%i",_time];
    if (_time == 0) {
        _answerLabel.string = [NSString stringWithFormat:@"%i",_answer];
        _answerLabel.visible = true;
        [self loseLife];
        [self answered];
    }
}

- (void)start {
    _start.position = ccp(_start.position.x,1.33);
    _answerLabel.visible = false;
    _correct.visible = false;
    _incorrect.visible = false;
    _evenOrOdd.visible = true;
    [self next];
}

- (void)correct:(CCButton*)button {
    CCParticleSystem *particle = (CCParticleSystem *)[CCBReader load:@"Particle"];
    particle.positionInPoints = ccp(button.positionInPoints.x, button.positionInPoints.y);
    [self addChild:particle];
    particle.autoRemoveOnFinish = TRUE;
    _correct.position = ccp(button.position.x,0.05);
    _correct.visible = true;
}

- (void)incorrect:(CCButton*)button {
    _incorrect.position = ccp(button.position.x,0.05);
    _incorrect.visible = true;
    [self loseLife];
}

- (void)loseLife {
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:0.25f];
    if (_life == 2) {
        [_lifeOne runAction:fadeOut];
        _life--;
    } else {
        [_lifeTwo runAction:fadeOut];
        _life--;
        _even.enabled = false;
        _odd.enabled = false;
        [self recap];
    }
}

- (void)bounce {
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.8f position:ccp(_start.position.x, 0.33)];
    CCActionEaseBounceOut *bounceOut = [CCActionEaseBounceOut actionWithAction:moveTo];
    [_start runAction:bounceOut];
}

- (void)recap {
    NSUserDefaults *gameState = [NSUserDefaults standardUserDefaults];
    [gameState setInteger:_level forKey:@"score"];
    if ([gameState integerForKey:@"score"] > [gameState integerForKey:@"highscore"]) {
        [gameState setInteger:[gameState integerForKey:@"score"] forKey:@"highscore"];
    }
    CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:1.5f];
    [[CCDirector sharedDirector] presentScene:recapScene withTransition:transition];
}

@end
