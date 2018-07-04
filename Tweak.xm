#import "common.h"

#define PLIST_PATH @"/var/mobile/Library/Preferences/com.spookybois.spotifyalarm.plist"
#define SAEnabled GetPrefBool(@"enabled")
#define SAShuffle GetPrefBool(@"shuffle")
#define SARandom GetPrefBool(@"random")
#define SAAlarm GetPrefBool(@"alarmonly")

NSString *alarmID = NULL;


/*  method to get plist variable state  */
inline bool GetPrefBool(NSString *key) {
    return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}

/*  method to set plist variable state  */
inline void SetPrefBool(NSString *key, bool state) {
    // get dictionary based on current settings
    NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];

    // change appropriate key
    [preferences setObject:[NSNumber numberWithBool:state] forKey:key];

    // write back out to plist
    [preferences writeToFile:PLIST_PATH atomically:YES];
}


@implementation MySpotifyView

/*  implement the adding / removing of an alarm to Spotify Alarm database   */
-(void)toggleSpotify:(id)sender {

    // boolean here is coupled with boolean state of switch
    SetPrefBool(alarmID, [sender isOn]);

}

/* add Spotify Alarm toggle in alarm edit view */
-(void)addToView:(NSString *)name :(BOOL)switchState
{
    // initialize toggle switch label
    toggleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,0,200,50)];
    [toggleLabel setTextColor:[UIColor whiteColor]];
    [toggleLabel setBackgroundColor:[UIColor clearColor]];
    toggleLabel.text = name;

    // initialize switch layout
    toggleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width,10,150,50)];
    toggleSwitch.frame = CGRectMake((self.frame.size.width + 250),10,150,50);

    // add target function and tint color
    [toggleSwitch addTarget:self action:@selector(toggleSpotify:) forControlEvents:UIControlEventValueChanged];
    toggleSwitch.onTintColor = [UIColor colorWithRed:46.0/255.0 green:160.0/255.0 blue:166.0/255.0 alpha:1.0];

    // set switch state
    [toggleSwitch setOn:switchState];

    // add to subviews to update interface
    [self addSubview: toggleLabel];
    [self addSubview: toggleSwitch];
    tableView.tableHeaderView = self;
}

@end


/*  hook into the alarm editing view to inject SpotifyAlarm enable slider   */
%hook EditAlarmViewController

-(void)loadView
{
    %orig;

    // grab the alarm we're currently editing...
    Alarm *spotAlarm = MSHookIvar<Alarm *>(self, "_alarm");

    // ...and save the unique alarmID
    alarmID = [spotAlarm alarmID];

    // now add a cool SpotifyAlarm selection button
    tableView = [self.view.subviews objectAtIndex:0];

    MySpotifyView *spotView = [[MySpotifyView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,60)];

    // check to see if the current alarm is Spotify enabled, dictating
    // position of the spotify slider switch on render
    if (GetPrefBool(alarmID)) {
        [spotView addToView:@"Spotify Shuffle:":true];
    } else {
        [spotView addToView:@"Spotify Shuffle:":false];
    }

    NSLog(@"[SpotifyAlarm]:[Variable Check] enabled: %d shuffle: %d random: %d  alarmonly: %d", (int)SAEnabled, (int)SAShuffle, (int)SARandom, (int)SAAlarm);
    %log((NSString *)@"[SpotifyAlarm]:[Alarm ID] current alarm ID: ", [spotAlarm alarmID]);

}

%end
