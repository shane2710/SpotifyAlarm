#import "common.h"

#define PLIST_PATH @"/var/mobile/Library/Preferences/com.spookybois.spotifyalarm.plist"
#define SAEnabled GetPrefBool(@"enabled")
#define SAShuffle GetPrefBool(@"shuffle")
#define SARandom GetPrefBool(@"random")
#define SAAlarm GetPrefBool(@"alarmonly")
#define PASSCODE @"555555"
#define DEBUG true

NSString *alarmID = NULL;
BOOL handleAlarm = 0;


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
// TODO: integrate the toggle with exisiting toggle panel
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


/*  hook into the fullscreen lockscreen notification handler to intercept
 *  alarms  */
%hook SBDashBoardFullscreenNotificationViewController

 -(void)loadView
{
    /*  i wish this wasn't a global variable but don't know how to reference
     *  the 'sharedInstance' existing object from another hooked function */
    // possible fix:
    // https://www.reddit.com/r/jailbreakdevelopers/comments/6vqw48/adding_a_sharedinstance_to_springboard_not_a/
    if (handleAlarm) {
        NSLog(@"SpotifyAlarm Silencing...");
        [self _handleSecondaryAction];      // ayee! it worked!!

        /*  unlock screen   */
        [[NSClassFromString(@"SBLockScreenManager") sharedInstance] attemptUnlockWithPasscode:PASSCODE];

        /*  open specified spotify URI  */
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"spotify:track:43cGYhbBwrY4vTF9ZpSeWi"]];

        /*  lock screen after spotify loads?  */
        // currently this prevents spotify from opening URI until unlocked
        // again, need a timer or hook appFinishedLaunching etc
        //
        // [[NSClassFromString(@"SBLockScreenManager") sharedInstance] _lockUI];
        // [[NSClassFromString(@"SpringBoard") sharedApplication] _simulateLockButtonPress];

        handleAlarm = 0;

    }

    // maybe add a settings input for the user to add their passcode?  and
    // then set a variable to know whether or not their passcode has been
    // saved before and check this on switch enable.  save in plist and
    // display in settigs as ***** or whatevs.  and use this to unlock,
    // allowing the springboard to launch spotify.. on launch, start
    // playlist, and lock screen!
    //
    // TODO: explore launching apps in background without screen unlocked
    // (currently I don't think that this is possible)

    //TODO:  launch spotify just like the DefaultPlayer application does,
    // try to find that source, or defaultspot, so that it is in the
    // bacjground and starts playing
    //
    // the above would be especially cool because if an alarm went off while
    // the phone was unlocked the music would just start playing, as the app
    // launches in the background..!  one possible implementation would be
    // launching the app with the background setting (second arg) set, and then
    // issuing a now playing application resume, as spotify would likely take
    // over as the now playing app
    //
    // TODO: allow user to paste in spotifyURI for morning playlist, or
    // have each alarm use a custom playlist, etc.... maybe even have a UI
    // like the choosing ringtone one that lists playlists??
    //
    // could be cool, can dynamically rename the 'choose song' cell and
    // hijack that whole selection pane!


    //TODO: dump spotify headers just like dumping mobiletimer headers and
    //find the useful ones for playing a certain URI.. actually now that
    //I've dumped them, just need to find the button to shuffle play a
    //currently viewed playlist...

    %orig;
}

%end


/*  used to explore how spotify actions are built   */
%hook SPAction

- (id)initWithOrder:(long long)arg1 logContext:(id)arg2
{
    NSLog(@"Debug init with order");
    %log(@"Debug", (NSString *)arg1, @"and ", (NSString *)arg2);
    return %orig(arg1, arg2);
}

%end



%hook SBClockDataProvider

-(BOOL)_isAlarmNotification:(id)arg1
{
    BOOL isAlarm = %orig(arg1);

    /*  cool, we've got an alarm notification   */
    if (isAlarm) {

        /*  capture notification request and extract alarmID    */
        UNNotificationRequest *req = [(UNNotification *)arg1 request];
        NSString *firedAlarmID = [self _alarmIDFromNotificationRequest:req];

        NSLog(@"SpotifyAlarm: _isAlarmNotification fired with alarmID: %@ and arg %@", firedAlarmID, arg1);

        /*  check if alarmID is in the enabled database */
        if (GetPrefBool(firedAlarmID)) {

            /*  check whether or not device is locked   */
            BOOL isLocked = [[NSClassFromString(@"SBLockScreenManager") sharedInstance] isUILocked];
            NSLog(@"SpotifyAlarm: device lock state: %d", (int)isLocked);

            if (isLocked) {
                /*  enable handling of fullscreen notification  */
                handleAlarm = 1;
            } else {
                /* dismiss alarm notification and launch spotify */
                //TODO: silence alarm sound, or set it to none on spot toggle
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"spotify:track:43cGYhbBwrY4vTF9ZpSeWi"]];
            }

        }

    } else {
        NSLog(@"[SpotifyAlarm]:_isAlarmNotification evaluated false");
    }

    return isAlarm;
}

%end

/*
 * If I better understood how to use the code below, could be a better way to
 * grab all alarm notifications?

CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), //center
	NULL, // observer
	alarmFired, // callback
	CFSTR("SBClockAlarmsDidFireNotification"), // event name
	NULL, // object
	CFNotificationSuspensionBehaviorDeliverImmediately);

    */
