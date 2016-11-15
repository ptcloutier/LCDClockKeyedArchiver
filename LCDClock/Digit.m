//
//  Digit.m
//  LCDClock
//
//  Created by perrin cloutier on 6/28/16.
//  Copyright © 2016 ptcloutier. All rights reserved.
//

#import "Digit.h"

@implementation Digit
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if ((self = [super initWithCoder:aDecoder])) {
//        
//        UIView *digit = [[[NSBundle mainBundle]loadNibNamed:@"Digit" owner:self options:kNilOptions]objectAtIndex:0];
//        digit.frame = self.bounds;
//        [self setClipsToBounds:true];
//        [self roundedCorners];
//        //add Nib to UIVIEW
//        [self addSubview:digit];
//    }
//    return self;
//}
//
//
//
//- (id)initWithFrame:(CGRect)frame {
//    if(self = [super initWithFrame:frame]) {
//        
//    }
//    return self;
//}


-(void)hideDigits {
    
    self.count = 0;
    [self setPartsArray:@[ self.top, self.topRight, self.middle, self.bottomRight, self.bottom, self.bottomLeft, self.topLeft ]];
    for (UIView *part in self.partsArray) {
        part.hidden = NO;
    }
}


-(void)roundedCorners {
    
    ++self.count;
    for (UIView *part in self.partsArray) {
        if(self.count < 4){
        part.layer.cornerRadius = 10;
        }else{
        part.layer.cornerRadius = 5;
        }
        part.layer.masksToBounds = YES;
    }
}


-(void)changeColor:(UIColor *)color {
    
    for (UIView *part in self.partsArray) {
        part.backgroundColor = color;
    }
}

 
-(void)showDigits:(long)value {
    
    [self hideDigits];
    [self roundedCorners];
     switch ((long)value) {
        case 0:
         for (UIView *part in self.partsArray) {
            if (part == self.middle){
                part.hidden = YES;
            }
        } break;
        case 1:
            for (UIView *part in self.partsArray) {
                if ((part != self.topRight)&&(part != self.bottomRight)){
                    part.hidden = YES;
                }
            } break;
        case 2:
            for (UIView *part in self.partsArray) {
                if ((part == self.bottomRight)||(part == self.topLeft)){
                    part.hidden =YES;
                }
            } break;
        case 3:
            for (UIView *part in self.partsArray) {
                if ((part == self.bottomLeft)||(part == self.topLeft)){
                    part.hidden = YES;
                }
            } break;
        case 4:
            for (UIView *part in self.partsArray) {
                if ((part == self.top)||(part == self.bottom)||(part == self.bottomLeft)){
                    part.hidden = YES;
                }
            } break;
        case 5:
            for (UIView *part in self.partsArray) {
                if ((part == self.bottomLeft)||(part == self.topRight)){
                    part.hidden = YES;
                }
            } break;
        case 6:
            self.topRight.hidden = YES;
            break;
        case 7:
            for (UIView *part in self.partsArray) {
                if ((part != self.top) && (part != self.topRight) && (part != self.bottomRight) && (part != self.topLeft)){
                    part.hidden = YES;
                }
            } break;
        case 8:
            break;
        case 9:
            self.bottomLeft.hidden = YES;
            break;
        default:
            break;
    }
}



@end
