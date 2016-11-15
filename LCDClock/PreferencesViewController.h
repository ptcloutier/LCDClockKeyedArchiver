//
//  PreferencesViewController.h
//  LCDClock
//
//  Created by perrin cloutier on 7/5/16.
//  Copyright © 2016 ptcloutier. All rights reserved.
//

#import <UIKit/UIKit.h>
 
 
@interface PreferencesViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *red;
@property (weak, nonatomic) IBOutlet UIButton *blue;
@property (weak, nonatomic) IBOutlet UIButton *brightGreen;
@property (weak, nonatomic) IBOutlet UIButton *darkGreen;
@property (weak, nonatomic) IBOutlet UIPickerView *timeZone;
@property (weak, nonatomic) IBOutlet UISwitch *hourFormat;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (nonatomic) UIImage *backImage;
@property (nonatomic) NSArray *timeZoneData;
-(IBAction)hourFormat:(id)sender;
-(IBAction)colorSettingsChanged:(UIButton *)sender;
//properties for archiving
@property (strong, nonatomic) NSNumber *pTextColor;
@property (strong, nonatomic) NSNumber *pHourFormat;
@property (strong, nonatomic) NSNumber *pTimeZone;
@property (strong, nonatomic) NSNumber *pBackground;
//methods for archiving
-(void)loadFromPList;
-(void)saveToPList;
//returns to Clock View Controller
- (IBAction)done:(id)sender;

@end
