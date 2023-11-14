# MC-AR - A software suite for comparative mocap analysis in an augmented reality environment (Unity-part)

## 0. Introduction
This folder contains a Unity project to create, build, and display an interactive violinist and simple user interface to start, stop, and fast-forward animations playback in the Hololens 2. 
All files are included except the .fbx model and sound files as they are larger than the 25MB Github upload limit. One can download the .unitypackage with all files from CodeOcean (https://codeocean.com/capsule/1868603/tree).

## 1. Unity Version
Unity version: 2021.3.16f

## 2. Project demonstration
Brief demo: https://youtu.be/wvNUD60cC4w?si=cMILjP0t-OTKv-mR

<img width="525" alt="image" src="https://github.com/IPEM/MC-AR/assets/22716256/803932f7-c410-4978-aed2-aa65a1111be1"> 

## 3. Project set-up, launch, build, and deploy:
1.	Install XR plugin management (Project settings > XR Plugin Management)
    1. Install Open XR
3.	Switch to UWP build platform (File > Build settings > Universal Windows Platform)
4.	Install features from the Mixed Reality Feature Tool (MRTK2)
    1. Download from Microsoft software page: www.microsoft.com/en-us/download/details.aspx?id=102778
    2. Install the MRT Extensions 2.8.3, Foundation 2.8.3, Tools 2.8.3, OpenXR Plugin 1.9.0, WinRT Projections 0.5.2009, Standard Assets 2.8.3, Examples 2.8.3 into your Unity project
    3. Follow MRTK setup instructions in Unity and restart Unity
5.	Import CONTBOS Unity Package (Assets > Import Package > Custom Package) or, more bug-prone, copy the Assets folder from this Github repository over to your Unity project 
6.	To run app from a VR-ready PC:
    1. Assure you have “OpenXR” and “Holographic Remoting remote app feature group” enabled in XR Plug-in Management
    2. Open the Holographic Remoting window (Mixed Reality>Remoting>Holographic Remoting for Play Mode)
    3. On the Hololens, open the Holographic Remoting app until you see an IP address appearing
    4. In Unity, enter the IP address in the Holographic Remoting window
    5. In Unity, click Play
7.	To navigate the app:
    1. First indicate the ground level using the rays coming from your hand palms. Point them towards the floor, aim the left and right pointer close to each other, and pinch your index finger and thumb together. The avatar should appear on the position you just indicated.
    2. Look around, and notice the user interface (button and slider) that follows your head
    3. Grab and drag the slider to set the playing position
    4. Push the button to start or stop the animation playback
9.	To build the app and deploy on the Hololens:
    1. In Unity, build the app (File>Build Settings>Build)
    2. Double-click the “.sln” project file to open it in Visual Studio
    3. Connect your Hololens to the PC over a USB
    4. Set target as “Release”, “ARM64”, and “Device”
    5. Click on “Device” to launch compile and deployment (you might be asked to pair your your PC with your Hololens)

## 4. Scripts:
Scripts included in the Unity package should be self-explanatory. Some general description of their functionality is presented below.
-	GestureManager.cs: Collects pointer events, specifically, the pinch gesture to set the ground level and orient the violinist animation within the real space. An alternative way to collect pointer events is to use the PointerHandler.cs and DetermineFloorLevel.cs scripts.
-	ControlAnimation.cs: Collects action events from the button and slider user interface to start, stop, and fast-forward audio and the violinist animation. 
-	Data logging: The LogActions.cs and EyeTracker.cs each use a different way to write data to a .txt file. The first uses the static TextWriter class in TextWriter.cs, the second uses a writer object initialized in the script itself (“new StreamWriter(path)”). The reason for two approaches is to show a more elegant implementation with a Static class for the first, but a more efficient one for the second as eye gaze data is written every 100ms.

## 5. Animations:
The animations consist of a male or female virtual human with motion capture and audio recordings of four compositions (Dvorak 1st violin, Dvorak 2nd violin, Holst 1st violin, Brahms 2nd violin). 
