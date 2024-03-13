Open Source tracking algorithm 

Cross-Correlation based specific-feature tracking: Tracks a given feature in a video and generates relative positional data.
Example use case is for a three link robot with the feature-to-track mimicing spherical particles.


HOW TO USE


For the test run, simply execute "Tracking_Zaid.m" file. This will run the tracking algorithm for a sample video I took of the Three Link Swimmer robot, returning tracked video and data for each of the links


1. For your use-case, first run "Read_TLS_Vid.m" first
   
    i.  You will be prompted to select the bounds of your video (to crop)
   
    ii. You will then be prompted to select some properties of your feature in the video.
   
    iii. A matlab table will be generated which holds metadata making it easier to track your feature.
3. Then in the "Tracking_Zaid.m" file, input the video file to track and tabular data that was generated and run the script.

To implement real-time capability, first configure the tabular data to select the relavant feature in your camera's field of view. Then, simply implement the real-time capture function built in matlab, replacing the video file.
