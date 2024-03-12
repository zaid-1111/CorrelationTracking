Cross-Correlation based specific-feature tracking algorithm. Tracks a given feature in a video and generates relative positional data.
Exacmple use case is for a three link robot with the feature-to-track mimicing spherical particles.


HOW TO USE

1. For your use-case, first run "Read_TLS_Vid.m" 
    i.  You will be prompted to select the bounds of your video (to crop)
    ii. You will then be prompted to select some properties of your feature in the video.
    iii. A matlab table will be generated which holds metadata making it easier to track your feature.
2. Then in the "Tracling_Zaid.m" file, input the video file to track and tabular data that was generated and run the script.
