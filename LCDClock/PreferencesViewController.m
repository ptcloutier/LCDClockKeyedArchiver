//
//  PreferencesViewController.m
//  LCDClock
//
//  Created by perrin cloutier on 7/5/16.
//  Copyright © 2016 ptcloutier. All rights reserved.
//

#import "PreferencesViewController.h"
#import "ClockViewController.h"

@interface PreferencesViewController ()

@end

@implementation PreferencesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeZoneData = @[@"Honolulu", @"San Francisco", @"Albuquerque", @"New Orleans", @"New York", @"Rio De Janeiro", @"Lisbon", @"London", @"Paris", @"Lagos", @"Istanbul", @"Addis Ababa", @"Moscow", @"Bankok", @"Tokyo"];
    self.timeZone.dataSource = self;
    self.timeZone.delegate = self;
    self.backgroundView.image = self.backImage;
}


-(void)viewWillAppear:(BOOL)animated{

    [self loadFromPList];
    
    if (self.pHourFormat == [NSNumber numberWithInteger:0] ){ //Standard time
        [self.hourFormat setOn:NO];
    }
    else if (self.pHourFormat == [NSNumber numberWithInteger:1]){ // Military time
        [self.hourFormat setOn:YES];
    }
    NSInteger savedTimeZone = [self.pTimeZone intValue];
    [self.timeZone selectRow:savedTimeZone inComponent:0 animated:YES];
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


- (IBAction)hourFormat:(UISwitch *)sender {
    
    if (sender.on == 0) {
        self.pHourFormat = [NSNumber numberWithInt:0]; // Standard time
    }
    else if (sender.on == 1) {
        self.pHourFormat = [NSNumber numberWithInt:1]; // Military time
    }
    [self saveToPList];
}


- (IBAction)colorSettingsChanged:(UIButton *)sender {
    //replace with this?
    //self.pTextColor = [NSNumber numberWithInt:(int)sender.tag];
    
    if (sender.tag == 0) {
        self.pTextColor = [NSNumber numberWithInt:(int)sender.tag ];
     }
    else if (sender.tag == 1) {
        self.pTextColor = [NSNumber numberWithInt:1];
    }
    else if (sender.tag == 2) {
        self.pTextColor = [NSNumber numberWithInt:2];
    }
    else if (sender.tag == 3) {
        self.pTextColor = [NSNumber numberWithInt:3];
    }
    [self saveToPList];
}


#pragma mark - UIPickerView Delegate Methods


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    // The number of columns of data
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    // The number of rows of data
    return [self.timeZoneData count];
}


- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    // The data to return for the row and component (column) that's being passed in
    return self.timeZoneData[row];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    //Update user defaults
    self.pTimeZone = [NSNumber numberWithInteger:row];
    [self saveToPList];
    
}


-(IBAction)done:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
 }


@end
