
# Jamf Billboard

Jamf Billboard is a tvOS app that cycles through a defined group of images 
on Apple TV devices with tvOS 12.0 or later that are managed by Jamf Pro. 
It can also display a watermark in the corners of the screen.

Configuring Jamf Billboard using Jamf Pro involves the following steps:

## Procedure

1. Log in to Jamf Pro.
2. Click **Devices** at the top of the page.
3. Click **Mobile Device Apps**.
4. Choose the Jamf Billboard app.
5. Configure settings on the General pane as needed.
	- **Note**: Ensure the Make App Managed when possible checkbox is selected so the App Configuration tab is displayed.
6. Click the **Scope** tab and configure the scope of the app.
7. Click the **App Configuration** tab and configure the preferences as needed. 
For example, enter the following code in the **Preferences** field to define image dictionaries and settings:
```xml
<dict>
<key>com.jamf.config.image.duration</key>
<real>7</real>
<key>com.jamf.config.watermark.url</key>
<string>https://insert-url-here.png</string>
<key>com.jamf.config.watermark.location</key>
<string>top_right</string>
<key>com.jamf.config.watermark.margin.x</key>
<real>10</real>
<key>com.jamf.config.watermark.margin.y</key>
<real>10</real>
<key>com.jamf.config.watermark.alpha</key>
<real>0.5</real>
<key>com.jamf.config.images</key>
<array>
	<dict>
		<key>com.jamf.config.image.url</key>
		<string>https://insert-url-here.jpg</string>
		<key>com.jamf.config.image.duration</key>
		<real>2</real>
		<key>com.jamf.config.watermark.location</key>
		<string>bottom_right</string>
	</dict>
	<dict>
		<key>com.jamf.config.image.url</key>
		<string>https://insert-url-here.jpg</string>
	</dict>
	<dict>
		<key>com.jamf.config.image.url</key>
		<string>https://insert-url-here.jpg</string>
		<key>com.jamf.config.watermark.location</key>
		<string>hidden</string>
	</dict>
</array>
</dict>
```
8. Click **Save**.

The app is distributed the next time tvOS devices in the scope contact Jamf Pro.

## Managed App Configuration for Jamf Billboard

Use Managed App Configuration to configure and personalize Jamf Billboard for your organization. 
Managed App Configuration is a set of key and value pairs used to configure applications. 
Images use the global setting by default unless an image specific setting is configured.

For more information, see the AppConfig Community website: http://appconfig.org

### Global Settings

#### Duration

The duration is how many seconds each image will display. 
By default, each image is displayed for 10 seconds. 
The minimum duration is one second. 
The value represents the duration.

```xml
<key>com.jamf.config.image.duration</key>
<real>7</real>
```

#### Watermark Image

The watermark image location must be a URL. 
The string value indicates the location of the image URL.

```xml
<key>com.jamf.config.watermark.url</key>
<string>https://image-url-here.png</string>
```


#### Watermark Location

By default, the watermark is located in the bottom-left corner. 
You can choose from the following locations:
- top_left
- top_right
- bottom_left
- bottom_right
- hidden

```xml
<key>com.jamf.config.watermark.location</key>
<string>top_right</string>
```


#### Watermark Margin

The watermark margin is defined by pixels. 
By default, the watermark margin is 20 pixels. 
You can define both the x and the y margins.

```xml
<key>com.jamf.config.watermark.margin.x</key>
<real>10</real>
<key>com.jamf.config.watermark.margin.y</key>
<real>10</real>
```

#### Watermark Alpha

The watermark alpha key defines the transparency of the watermark. 
By default, the watermark alpha is 100% opaque. 
The value must be a number between 0 and 1, with 0 being completely transparent and 1 being completely opaque. 
The values represent the transparency percentage.
For example, the value 0.5 sets the transparency to 50%.

```xml
<key>com.jamf.config.watermark.alpha</key>
<real>0.5</real>
```

#### Background Color

By default, the background color is black. 
Use a six digit hexadecimal color string to change the color. 
To configure a transparent background color, use eight digits, 
with the last two digits in the hexadecimal representing the transparency value. 
For example, "#0000FF80" is the color blue with 50% transparency.

```xml
<key>com.jamf.config.background.color</key>
<string>#0000FF</string>
<key>com.jamf.config.background.color</key>
<string>#0000FF80</string>
```

### Image Specific Settings

#### Images
The images Jamf Billboard will display are defined by an array of dictionaries. 
Each dictionary in the array contains settings for one image.
The following image specific settings in each dictionary override global settings:
- Duration
- Watermark
- Location

```xml
<key>com.jamf.config.images</key>
<array>
	<dict>
		<key>com.jamf.config.image.url</key>
		<string>https://image-url-here.jpg</string>
		<key>com.jamf.config.image.duration</key>
		<real>20</real>
		<key>com.jamf.config.watermark.location</key>
		<string>top_left</string>
	</dict>
</array>
```
