//
//  ClockViewController.h
//  LCDClock
//
//  Created by perrin cloutier on 6/28/16.
//  Copyright © 2016 ptcloutier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Digit.h"
#import "PreferencesViewController.h"

// This version of LCD Clock archives saved data to plist version

@interface ClockViewController : UIViewController<UIGestureRecognizerDelegate>

//properties for display
@property (strong, nonatomic) IBOutlet Digit *firstDigit;
@property (weak, nonatomic) IBOutlet Digit *secondDigit;
@property (weak, nonatomic) IBOutlet Digit *thirdDigit;
@property (weak, nonatomic) IBOutlet Digit *fourthDigit;
@property (weak, nonatomic) IBOutlet Digit *fifthDigit;
@property (weak, nonatomic) IBOutlet Digit *sixthDigit;
@property (weak, nonatomic) IBOutlet UIView *topBlink;
@property (weak, nonatomic) IBOutlet UIView *bottomBlink;
@property (weak, nonatomic) IBOutlet UILabel *am;
@property (weak, nonatomic) IBOutlet UILabel *pm;
@property (weak, nonatomic) IBOutlet UILabel *showCurrentDate;
@property (weak, nonatomic) IBOutlet UIButton *preferencesView;
@property (nonatomic) BOOL preferencesShown;
//view collections
@property (strong, nonatomic) NSMutableArray *digits;
@property (strong, nonatomic) NSArray *allTextLabels;
//values for time to send to Digits
@property (nonatomic) long firstDigitValue;
@property (nonatomic) long secondDigitValue;
@property (nonatomic) long thirdDigitValue;
@property (nonatomic) long fourthDigitValue;
@property (nonatomic) long fifthDigitValue;
@property (nonatomic) long sixthDigitValue;
@property( strong, nonatomic) NSMutableArray *timeValue;
//date and time properties
@property (nonatomic) NSDate *currentDate;
@property (nonatomic) NSDate *currentTime;
@property (nonatomic) NSTimer *updateTimer;
@property (nonatomic) UIColor *chosenColor;
@property (nonatomic) IBOutlet UIImageView *backgroundView;

//properties for archiving
@property (strong, nonatomic) NSNumber *pTextColor;
@property (strong, nonatomic) NSNumber *pHourFormat;
@property (strong, nonatomic) NSNumber *pTimeZone;
@property (strong, nonatomic) NSNumber *pBackground;

-(void)loadFromPList;
-(void)saveToPList;
-(IBAction)showPreferencesView:(id)sender;
-(void)colorPreference;
-(void)handleTapGesture:(UITapGestureRecognizer *)recognizer;
-(void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)recognizer;
-(void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)recognizer;



 @end
