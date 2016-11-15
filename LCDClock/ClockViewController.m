//
//  ClockViewController.m
//  LCDClock
//
//  Created by perrin cloutier on 6/28/16.
//  Copyright © 2016 ptcloutier. All rights reserved.
//

#import "ClockViewController.h"
#import "Digit.h"

 
@interface ClockViewController ()

@end

@implementation ClockViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [self loadFromPList];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // this not DRY
    Digit *firstDigit = [[[NSBundle mainBundle] loadNibNamed:@"Digit" owner:self
                                                     options:nil] objectAtIndex:0];
    firstDigit.frame = self.firstDigit.bounds;
    [self.firstDigit addSubview:firstDigit];
    self.firstDigit = firstDigit;
    
    Digit *secondDigit = [[[NSBundle mainBundle] loadNibNamed:@"Digit" owner:self
                                                      options:nil] objectAtIndex:0];
    secondDigit.frame = self.secondDigit.bounds;
    [self.secondDigit addSubview:secondDigit];
    self.secondDigit = secondDigit;
    
    Digit *thirdDigit = [[[NSBundle mainBundle] loadNibNamed:@"Digit" owner:self
                                                     options:nil] objectAtIndex:0];
    thirdDigit.frame = self.thirdDigit.bounds;
    [self.thirdDigit addSubview:thirdDigit];
    self.thirdDigit = thirdDigit;
    
    Digit *fourthDigit = [[[NSBundle mainBundle] loadNibNamed:@"Digit" owner:self
                                                      options:nil] objectAtIndex:0];
    fourthDigit.frame = self.fourthDigit.bounds;
    [self.fourthDigit addSubview:fourthDigit];
    self.fourthDigit = fourthDigit;
    Digit *fifthDigit = [[[NSBundle mainBundle] loadNibNamed:@"Digit" owner:self
                                                     options:nil] objectAtIndex:0];
    fifthDigit.frame = self.fifthDigit.bounds;
    [self.fifthDigit addSubview:fifthDigit];
    self.fifthDigit = fifthDigit;
    
    Digit *sixthDigit = [[[NSBundle mainBundle] loadNibNamed:@"Digit" owner:self
                                                     options:nil] objectAtIndex:0];
    sixthDigit.frame = self.sixthDigit.bounds;
    [self.sixthDigit addSubview:sixthDigit];
    self.sixthDigit = sixthDigit;
    
    
    self.digits = [[NSMutableArray alloc]initWithObjects:self.firstDigit, self.secondDigit, self.thirdDigit, self.fourthDigit, self.fifthDigit, self.sixthDigit, nil];
    
    self.allTextLabels = @[self.am, self.pm, self.showCurrentDate, self.topBlink, self.bottomBlink];
    [self initializePreferencesButton];
    
    //initialize gesture recognizers
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    tap.numberOfTapsRequired = 1;
    [self.backgroundView addGestureRecognizer:tap];
    tap.delegate = self;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeLeftGesture:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.backgroundView addGestureRecognizer:swipeLeft];
    swipeLeft.delegate = self;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRightGesture:)];
    [self.backgroundView addGestureRecognizer:swipeRight];
    swipeRight.delegate = self;
    
    [self sendTimeToView];
    
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(blinkSeconds) userInfo:nil repeats:YES];

    [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(sendTimeToView) userInfo:nil repeats:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Archiver Methods


-(void)saveToPList {
    
    NSMutableDictionary *dataForPlist = [[NSMutableDictionary alloc] initWithCapacity:4];
    
        if (self.pTextColor != nil) {
            [dataForPlist setObject:self.pTextColor forKey:@"pTextColor"];
        }
        if (self.pHourFormat != nil) {
            [dataForPlist setObject:self.pHourFormat forKey:@"pHourFormat"];
        }
        if (self.pTimeZone != nil) {
            [dataForPlist setObject:self.pTimeZone forKey:@"pTimeZone"];
        }
        if (self.pBackground != nil) {
            [dataForPlist setObject:self.pBackground forKey:@"pBackground"];
        }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"userSettings.plist"];
 
    [dataForPlist writeToFile:filePath atomically:YES];
}


-(void)loadFromPList {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"userSettings.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        NSMutableDictionary *savedData =[[NSMutableDictionary alloc] initWithContentsOfFile:filePath];

        if ([savedData objectForKey:@"pTextColor"] != nil) {
            self.pTextColor = [savedData objectForKey:@"pTextColor"];
        }
        if ([savedData objectForKey:@"pHourFormat"] != nil) {
            self.pHourFormat = [savedData objectForKey:@"pHourFormat"];
        }
        if ([savedData objectForKey:@"pBackground"] != nil) {
            self.pBackground = [savedData objectForKey:@"pBackground"];
        }
        if ([savedData objectForKey:@"pTimeZone"] != nil) {
            self.pTimeZone = [savedData objectForKey:@"pTimeZone"];
        }
    }
}


-(void)sendTimeToView {
    
    [self getTime];
    [self getDate];
    [self ampmStatus];
    [self initializeTimeFormat];
    [self initializeColor];
    [self initializeBackgroundImage];
    [self.firstDigit showDigits:self.firstDigitValue];
    [self.secondDigit showDigits:self.secondDigitValue];
    [self.thirdDigit  showDigits:self.thirdDigitValue];
    [self.fourthDigit showDigits: self.fourthDigitValue];
    [self.fifthDigit showDigits:self.fifthDigitValue];
    [self.sixthDigit showDigits:self.sixthDigitValue];
    self.topBlink.hidden = NO;
    self.bottomBlink.hidden = NO;

}


- (void)blinkSeconds {
    self.topBlink.hidden = YES;
    self.bottomBlink.hidden = YES;
}


-(void)ampmStatus {
    
    if ((self.pHourFormat == [NSNumber numberWithInt:0])||(self.pHourFormat == nil)){  // Standard time
        if (((self.firstDigitValue == 1 ) && (self.secondDigitValue >= 2)) || (self.firstDigitValue == 2)){
            [self.am setHidden:YES];
            [self.pm setHidden:NO];
        }else{
            [self.am setHidden:NO];
            [self.pm setHidden:YES];
        }
    }else{
        [self.am setHidden:YES];  // Military time
        [self.pm setHidden:YES];
    }
}


-(void)initializeTimeFormat {

    if ((self.pHourFormat == [NSNumber numberWithInt:0])||(self.pHourFormat == nil)){
        [self standardTime];
    }else{
        [self militaryTime];
    }
}


-(void)getTime {
    
    NSArray *timeZones = @[ @"HST", @"PST", @"MST", @"CST", @"EST", @"BRT", @"WET", @"BST", @"WAT", @"CET", @"EET", @"EAT", @"MSK", @"ICT", @"JST"];
    NSMutableArray *valuesArray = [[NSMutableArray alloc]init];
    self.currentTime = [NSDate date];
    
    if(self.pTimeZone == nil) {
        
        self.pTimeZone = [NSNumber numberWithInt:4];
    }
    
    NSInteger timeZoneValue = [self.pTimeZone integerValue]; //archiver change
    NSString *timeZoneAbbr = [timeZones objectAtIndex:timeZoneValue];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [timeFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:timeZoneAbbr]];
    NSString *timeFormat = @"HH:mm:ss";
    [timeFormatter setDateFormat:timeFormat];
    NSString *time = [timeFormatter stringFromDate: self.currentTime];
    
    for (int i = 0; i < time.length; i++) {
        unichar character = [time characterAtIndex:i];
        if (isnumber(character)){
            [valuesArray addObject:[NSNumber numberWithInt:character - '0']]; // convert the ASCII value to integer
        }
    }
    self.firstDigitValue = [[valuesArray objectAtIndex:0]longValue];
    self.secondDigitValue = [[valuesArray objectAtIndex:1]longValue];
    self.thirdDigitValue = [[valuesArray objectAtIndex:2]longValue];
    self.fourthDigitValue = [[valuesArray objectAtIndex:3]longValue];
    self.fifthDigitValue = [[valuesArray objectAtIndex:4]longValue];
    self.sixthDigitValue = [[valuesArray objectAtIndex:5]longValue];
}


-(void)getDate {
    
    NSArray *timeZones = @[ @"HST", @"PST", @"MST", @"CST", @"EST", @"BRT", @"WET", @"BST", @"WAT", @"CET", @"EET", @"EAT", @"MSK", @"ICT", @"JST"];
    self.currentDate = [NSDate date];
    NSInteger timeZoneValue = [self.pTimeZone integerValue]; //archiver change
    NSString *timeZoneAbbr = [timeZones objectAtIndex:timeZoneValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:timeZoneAbbr]];
    NSString *dateFormat = @"EEEE MMMM dd";
    [dateFormatter setDateFormat:dateFormat];
    NSString *date = [dateFormatter stringFromDate:self.currentDate];
    self.showCurrentDate.text = date;
}


-(void)standardTime { // subtract 12  
    
        if ((self.firstDigitValue == 1) && ( self.secondDigitValue > 2)){
            self.secondDigitValue -= 2;
            [self.firstDigit setHidden:YES];
        }
        else if ((self.firstDigitValue == 2) && (self.secondDigitValue <= 1)){
            self.secondDigitValue += 8;
            [self.firstDigit setHidden:YES];
        }
        else if ((self.firstDigitValue == 2) && (self.secondDigitValue >= 2 )){
            self.firstDigitValue -= 1;
            self.secondDigitValue -=2;
            [self.firstDigit setHidden:NO];
            [self.secondDigit setHidden:NO];
        }
        else if ((self.firstDigitValue == 0) && (self.secondDigitValue == 0)){
            self.firstDigitValue += 1;
            self.secondDigitValue += 2;
            [self.firstDigit setHidden:NO];
            [self.secondDigit setHidden:NO];
        }
        else if (self.firstDigitValue == 0){
            [self.firstDigit setHidden:YES];
        }
        else if ((self.firstDigitValue == 1) && ( self.secondDigitValue <= 2)){
            [self.firstDigit setHidden:NO];
            [self.secondDigit setHidden:NO];
        }
}


-(void)militaryTime {
    
        [self.firstDigit setHidden:NO];
        [self.secondDigit setHidden:NO];
}


-(void)initializePreferencesButton {
    
    UIImage *gear = [UIImage imageNamed:@"Gear.png"];
    [self.preferencesView setImage:gear forState:UIControlStateNormal];
    [self.preferencesView setHidden:YES];
}


-(void)initializeColor {
    
    if ( self.pTextColor == nil){
        
    self.pTextColor = [NSNumber numberWithInt:2];
    }
    [self colorPreference];
    UIColor *color = self.chosenColor;
    
    for ( Digit *digit in self.digits){ // set color in Digit class

        [digit changeColor:color];
    }
    // set color in text
    for (UIView *view in self.allTextLabels) {
        if ([view isKindOfClass:[UILabel class]]){ // Check if the view is of UILabel class, cast to UILabel
            UILabel *label = (UILabel *)view;
            label.textColor = color;
        }else if ([view isKindOfClass:[UIButton class]]){ // check if view is of UIButton class
            UIButton *button = (UIButton *)view;
            [button setTitleColor:color forState:UIControlStateNormal];
        }else{
            view.backgroundColor = color;
        }
    } // end of for loop
}


-(void)colorPreference { // make dictionary set values for keys
    
    UIColor *color;
    UIColor *blue = [UIColor colorWithRed:66.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *red = [UIColor colorWithRed:248.0/255.0 green:69.0/255.0 blue:71.0/255.0 alpha:1.0];
    UIColor *pink = [UIColor colorWithRed:255.0/255.0 green:213.0/255.0 blue:214.0/255.0 alpha:1.0];
    UIColor *yellow = [UIColor colorWithRed:242.0/255.0 green:239.0/255.0 blue:195.0/255.0 alpha:1.0];
    
    if ( [self.pTextColor integerValue] == 0 ){
        color = pink;
    }
    else if ( [self.pTextColor integerValue] == 1 ){
        color = red;
             }
    else if ( [self.pTextColor integerValue] == 2 ){
        color = blue;
              }
    else if ( [self.pTextColor integerValue] == 3 ){
        color = yellow;
    }
    self.chosenColor = color; // dictionary value for key
}


-(void)changeTextColor:(UIColor *)color
{   // change color in Digit class
    color = self.chosenColor;
    
    for ( Digit *digit in self.digits){
        [digit changeColor:color];
    }
    // change color in text
    for (UIView *view in self.allTextLabels) {
        if ([view isKindOfClass:[UILabel class]]){ // Check if the view is of UILabel class, cast to UILabel
            UILabel *label = (UILabel *)view;
            label.textColor = color;
        }
        else if  ([view isKindOfClass:[UIButton class]]){ // check if view is of UIButton class
            UIButton *button = (UIButton *)view;
            [button setTitleColor:color forState:UIControlStateNormal];
        }
        else {
            view.backgroundColor = color;
        }
    } // end of for loop
    [self saveToPList];
}


-(void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    if ( recognizer.state == UIGestureRecognizerStateEnded ){
        if (self.preferencesShown == FALSE){
            self.preferencesShown = TRUE;
            [self.preferencesView setHidden:NO];
        }
        else if (self.preferencesShown == TRUE){
            [self.preferencesView setHidden:YES];
            self.preferencesShown = FALSE;
        }
    }
}


-(IBAction)showPreferencesView:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        PreferencesViewController *preferencesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"preferencesViewController"];
        preferencesViewController.backImage = self.backgroundView.image;
        [self presentViewController:preferencesViewController animated:YES completion:nil];
        [self.preferencesView setHidden:YES];
        self.preferencesShown = FALSE;
    });
}


-(void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)recognizer {
   
    if (recognizer.state == UIGestureRecognizerStateEnded ){
        [self changeBackgroundImage:@"backward"];
    }
}



-(void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateEnded ){
        [self changeBackgroundImage:@"forward"];
    }
}


-(void)initializeBackgroundImage {
    
    NSString *imageName;
    NSArray *imageNames = @[ @"Default.png", @"newYork2.jpeg", @"sunset.jpeg", @"undersea.jpeg", @"hubble_25-jumbo.jpg"];
    
    if (self.pBackground == nil){
    self.pBackground = [NSNumber numberWithInt:0];
    imageName = [imageNames objectAtIndex:[self.pBackground integerValue]];
    self.backgroundView.image = [UIImage imageNamed:imageName];
    }
    else {
         imageName = [imageNames objectAtIndex:[self.pBackground integerValue]];
        self.backgroundView.image = [UIImage imageNamed:imageName];
    }
}


-(void)changeBackgroundImage:(NSString *)direction // archiver version
{
    NSString *imageName;
    long imageNumber = 0;
    long imageCount = 0;
    long imageSum = 0;
    NSArray *imageNames = @[ @"Default.png", @"newYork2.jpeg", @"sunset.jpeg", @"undersea.jpeg", @"hubble_25-jumbo.jpg"];
    
    if ( [direction isEqualToString:@"forward"] ){
        if (( [self.pBackground intValue] + 1) == [imageNames count]){
            imageNumber = 0;
            imageName = [imageNames objectAtIndex:imageNumber];
        }
        else if ( [self.pBackground integerValue] >= 0){
            imageNumber = [self.pBackground intValue] + 1;
            imageName = [imageNames objectAtIndex:imageNumber];
        }
    }
    else if ( [direction isEqualToString:@"backward"] ) {
        imageCount = (int) [imageNames count];
        if ( [self.pBackground intValue] == imageCount){
            imageNumber = [self.pBackground intValue] - 2;  // minus one to make up for array indexing, and minus one for scrolling through images
            imageName = [imageNames objectAtIndex:imageNumber];
        }
        else if ( [self.pBackground intValue] > 0 ){
            imageNumber = [self.pBackground intValue] - 1;
            imageName = [imageNames objectAtIndex:imageNumber];
        }
        else if ( [self.pBackground intValue] == 0){
            imageCount = (int)[imageNames count];
            imageSum = [self.pBackground intValue] + imageCount;
            imageNumber = imageSum - 1;
            imageName = [imageNames objectAtIndex:imageNumber];
        }
    }
    self.backgroundView.image = [UIImage imageNamed:imageName];
    self.pBackground = [NSNumber numberWithLong:imageNumber]; //plist archive
    [self saveToPList];
}


@end
