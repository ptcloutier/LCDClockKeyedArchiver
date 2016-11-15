//
//  Digit.h
//  LCDClock
//
//  Created by perrin cloutier on 6/28/16.
//  Copyright © 2016 ptcloutier. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Digit : UIView

@property (weak, nonatomic) IBOutlet UIView *top;
@property (weak, nonatomic) IBOutlet UIView *topRight;
@property (weak, nonatomic) IBOutlet UIView *middle;
@property (weak, nonatomic) IBOutlet UIView *bottomRight;
@property (weak, nonatomic) IBOutlet UIView *bottom;
@property (weak, nonatomic) IBOutlet UIView *bottomLeft;
@property (weak, nonatomic) IBOutlet UIView *topLeft;
@property (weak, nonatomic) IBOutlet UIView *background;
@property (nonatomic) int count;
@property (nonatomic) NSArray *partsArray;
-(void)showDigits:(long)value;
-(void)changeColor:(UIColor *)color;

@end
