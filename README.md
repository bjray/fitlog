Welcome to fitlog
======

fitlog is a simple, intuitive fitness tracking application for individuals that have a love of many different sports and are looking for an easy way to quickly track their activities.  Unlike other fitness apps, fitlog focuses on the 10 second use case.  In other words, just tracking that you did your workout.  Now, like any great infomercial, **_That's not all_**.  Using fitlog, you will be able to select your favorite activities, record sessions, enter additional detail, follow friends, request and obtain validation of activities, among other things.

In the end there are many, many (and many and many...) fitness apps.  We hope this one proves interesting due to its sheer simplicity.  Thank you for stopping by.

# Project Setup
fitlog is built using Parse for the backend services and uses CocoaPods for all frameworks EXCEPT for Parse.  Therefore, it may be necessary for you to manually include the Parse framework.  After you clone / fork the repo, you will need to install the required frameworks by using [CocoaPods](http://cocoapods.org).  Once you have run `pod install`, be sure to always use the .xcworkspace file when opening the project in Xcode.

Now, because the app uses Facebook authentication and Parse, you must follow one of the two methods described below before you can start using the app.

1. If you know me, just ping me on Facebook and I'll add you as a developer to my fitlog app and then you should be good to go.

2. If you don't know me, you will need to setup your own Parse account and Facebook app.  
  1. Parse has some basic instructions [here](https://parse.com/tutorials/integrating-facebook-in-ios).  
  2. Once that is complete, be sure to add your Parse app id and client key to `PF_APP_ID` and `PF_CLIENT_KEY` respectively in AppDelegate.m.
  3. In the fitlog-info.plist file, add a key, `FacebookAppID`, and it's value as well as a key, `URL types` that contains the following structure:
   `<array>
	<dict>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>fb<your_fb_app_id_here></string>
		</array>
	</dict>
</array>
</plist>`

# Roadmap
Well, its hard to say and I'm sure it will evolve, but here is what we are thinking...
* Bluetooth integration with a Polar HR monitor
* Integration with popular fitness tracking apps like Strava and Nike+.
* Leaderboards
