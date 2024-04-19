
# Zuri Health Finder
This application helps you get the hospitals near you and their associated information such as reviews and directions

## App Building Guide
## 1.Prerequisites
 
To run this project on your system you must have a stable flutter version greater than v3.3.1
## 2.Clone the project

Now clone this repository to your machine.
To do this, click on the green code button and then click the _copy to clipboard_ icon.

Open a terminal and run the following git command:

```
git clone "url you just copied"
```

where "url you just copied" (without the quotation marks) is the url to this repository



For example:

```
git clone https://github.com/dev-vickie/Zuri-Health-Finder.git
```


## 3.Running the project

Navigate to the cloned repository directory on your computer (if you are not already there) and open it using your flutter code editor e.g Android Studio or VSCode
### Pre-Run Changes:
You need to add the API KEY attached with the email as well as specifying the API meta tags in the project's mani before running it.
For the API key, open the `constants.dart` file inside the `project/lib/utils/` folder. Add the key inside the `API_KEY` string constant as shown:

>   class Constants {
> //other constants
> static  const API_KEY = "paste the api key here";
> 
> //the rest of the constants
> 
> 
> }

After that, open the `project/android/app/src/main/AndroidManifest.xml` file and paste the tag below,under the `android:icon` tag. Replace with actual API key:

> <meta-data  android:name="com.google.android.geo.API_KEY"
> 
> android:value="paste the api key here"/>

### Run the app:
The app is now ready to run using the `flutter run` command

