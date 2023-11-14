# MC-AR - A software suite for comparative mocap analysis in an augmented reality environment

- Adriaan Campo, Institute for Psychoacoustics and Electronic Music (IPEM), Ghent University, Miriam Makebaplein 1, 9000, Ghent, Belgium, adriaan.campo@ugent.be
- Bavo Van Kerrebroeck, Sequence Production Lab and the Input Devices and Music Interaction Lab of McGill University, Montreal, Canada, bavo.vankerrebroeck@mail.mcgill.ca
- Marc Leman, Institute for Psychoacoustics and Electronic Music (IPEM), Ghent University, Miriam Makebaplein 1, 9000, Ghent, Belgium, marc.leman@ugent.be 

## 0. Abstract
Three different software packages are presented here: A Unity package for simulating a virtual violinist in augmented reality on a HoloLens. The virtual violinist plays a pre-recorded piece, either as a 2D or a 3D projection. The piece can be started, stopped, forwarded, or rewound using a dedicated user interface. During interaction, eye movements are tracked. A MATLAB motion capture package for analysing the kinematic data of a user while interacting with the virtual violinist. An R package for power analysis and Bayesian statistical analysis of the kinematic data. These software packages can be easily adapted to test the kinematic behaviour of music students interacting with virtual teachers.

## 1.	Description of the packages:
### 1.	The Unity Package:
#### 1.1.	Description:
This software package contains code, animations, sound, and documentation to build and deploy a Unity application to the augmented reality device Hololens 2. The application presents a virtual violinist and a minimal interface to start, stop, and fast-forward the playback of the violinist. In addition, implementations to set the ground level using gestures and to record eye gaze and user actions are provided. 
The purpose of the application is to investigate the benefits of 3-dimensional interfaces for motor learning of fine-grained gestures as compared to traditional 2-dimensional interfaces. Moreover, the minimal interface to control playback allows a student to focus on specific passages by pausing or repeating them, something not possible in real-life teacher-student situations. The application is ideally suited to be used in parallel with some low- or high-cost [1] motion-capture system, to capture and compare specific movements of the user to the movements in the animations using the MATLAB and R packages presented below.
#### 1.2.	Impact overview:
Key benefits of using virtual or augmented reality for research and education are its flexible control over stimuli, its potential to eliminate confounds of suggestion and for replicability. While the use of virtual and augmented reality is becoming widespread as a research and educational tool, only few implementations are publicly available, especially in the area of music [2]. However, to fully take advantage of these benefits, it is imperative for researchers to share their implementations, so others can further build on and improve on their work. 
To this end, while the Unity package here is small in size, it offers several features that are crucial for any future music motor learning research project that aims to leverage the advantages of virtual reality. Furthermore, the features are coded in a modular way to allow for easy extension. These features are:
-	Virtual human stimuli and its playback (human and male avatar with audiovisual data)
-	Minimal user interface with a button and slider to control playback
-	Gesture interaction (pinching gesture to set floor level)
-	Data logging (eye gaze and user actions)

#### 1.3.	Current use:
The software is currently primarily used at IPEM and has no commercial applications. At IPEM, it is extensively used within the CONBOTS project [3], in a first instance to compare and evaluate motor learning using traditional 2-dimensional interfaces with those of 3-dimensional augmented reality.
#### 1.4.	Future improvements:
While the application is built for the HoloLens platform, future versions will be made cross-platform to target other virtual and augmented reality devices. A first target will be novel mixed-reality devices such as the Meta Quest 3 to leverage its improved field-of-view and capability to switch between virtual and augmented reality.
#### 1.5.	Publications:
The code has been used in [4,5].
#### 1.6.   Source:
The code is not suited for the codeocean format, and can be downloaded at: https://github.com/IPEM/MC-AR

### 2.	The MATLAB Package:
#### 2.1.	Description:
This code analyzes motion capture data streams labeled using the most commonly used bony landmarks. This version is based on the 'Animation Marker Set' as prescribed in the Qualisys manual. However, the code can be easily adapted to other marker sets containing three-dimensional coordinate data, as long as the joint coordinate systems used align with those described in the ISB [6,7].
In the first step, the code estimates the locations of the glenohumeral joint and the femoral joint, assuming that these joints function as ball-and-socket joints [8].
Secondly, it estimates most of the joint angles, angular velocities, and accelerations of the neck (alpha, beta and gamma angles), shoulders (elevation, pronation/supination, adduction/abduction), elbows (flexion/extension, pronation/supination) , wrists (flexion/ extension, adduction/abduction), hips (flexion/ extension, adduction/abduction), knees (flexion), and feet (dorsiflexion/plantar- flexion, internal rotation/external rotation, inversion/eversion), with angle definitions and joint coordinate systems as described in [6,7].
Finally, specifically for the application in [4,5], functions are added to compare the kinematics of music performance between the student using the HoloLens app described in (1. The Unity package) and the violin instructor as rendered in the app.
#### 2.2.	Impact overview:
Following motion capture measurements, data need to be analyzed using time-expensive inverse kinematic approaches if clinically relevant information is required [9]. However, by adhering to the ISB standards, this code provides a quick and reliable solution for estimating joint angles for non-clinical purposes. This allows for a more meaningful and less abstract analysis of motion capture data, opening up possibilities for non-clinical research on kinematic data, such as studying interactions between musicians in augmented reality [5], rhythmic entrainment of dancers during performance [10], or educational purposes like real-time feedback on posture [11] or inter-joint coordination [12].
The need for a meaningful approach to motion capture data is evident in the success of the motion capture toolbox amongst non-clinical researchers [13]. However, this popular toolkit does not offer the capability to analyze joint angles, which is an important parameter, e.g., to study how musicians interact with their instruments [14], or to generate posture feedback on students [15], amongst a manifold of other non-clinical applications.
#### 2.3.	Current use:
The software is currently primarily used at IPEM and has no commercial applications. At IPEM, it is extensively used within the CONBOTS project [3], where motion capture-recorded joint angles are used to assess the learning effects of wearable exoskeletons and other cutting edge educational technology.
#### 2.4.	Future improvements:
In future versions, this code will be made available in R and Python, and it will include presets for other marker sets and other input formats.
#### 2.5.	Publications:
The code is used in [4,5,10] and in work in progress on exo-skeleton delivered haptic feedback for motor learning, and on longitudinal follow-up of skill acquisition in novice violin and drum students.
#### 2.6.   CodeOcean capsule:
The MATLAB codeocean capsule can be found at: https://codeocean.com/capsule/4877160/tree

### 3.	The R Package:
#### 3.1.	Description:
The R package tests four different models against four distinct hypotheses. 
In the initial two models, kinematic metrics describing the student's performance relative to the virtual teacher, as shown in (1. The Unity package), serve as response variables in the models. The predictors include conditions, participants, and trial information. These two models are referred to as Model_1 and Model_2, with the primary difference being the inclusion of perceived difficulty in the interaction with the condition in Model_2.
In the subsequent two models, behavioral metrics collected from questionnaires, specifically three presence questionnaires, are integrated. Model_3 and Model_4 are similar models, with the primary distinction being the inclusion of kinematic metrics in the interaction with the condition in Model_4.
The analysis proceeds in the following manner: 
Firstly, a comparison is made between Model_1 and Model_2 to determine whether perceived difficulty should be incorporated into the model. Subsequently, a more comprehensive diagnostic assessment of the best model is conducted, along with a contrast analysis of conditions and trials.
In the next step, the comparison commences with Model_3 and Model_4 to evaluate whether kinematic metrics should be incorporated into the model. The analysis proceeds with a more detailed diagnostic assessment of the superior model and a contrast analysis of conditions.
These models are eventually tested against four hypotheses:
- Hypothesis 1: It posits that students in the 3D condition will demonstrate superior violin performance compared to those in the 2D condition, as indicated by a higher degree of similarity in bow movements and increased movement smoothness. This assessment involves a comparison of Model_1 and Model_2 and an evaluation of the contrast among conditions.
- Hypothesis 2: This hypothesis suggests that learning effectiveness in violin performance will be greater in the 3D condition compared to the 2D condition. This is assessed by evaluating Model_1, conducting a contrast analysis involving conditions and trials.
- Hypothesis 3: The hypothesis proposes that the 3D condition will generate a heightened sense of presence compared to the 2D condition, specifically characterized by elevated levels of "physical presence" and "social presence." This is evaluated using Model_3 and a contrast analysis of conditions.
- Hypothesis 4: This hypothesis investigates the extent to which the degree of presence in augmented reality (AR) influences students' violin performance. This evaluation involves comparing Model_3 and Model_4.

#### 3.2.	Impact overview:
In this code and the associated work, we employ Bayesian statistics. Bayesian statistics can be especially valuable for small sample sizes and prove particularly advantageous in fields where collecting large datasets is challenging or expensive, such as multidisciplinary research projects involving non-user-friendly prototypes of new technology [16].
#### 3.3.	Current use:
The software was primarily used for 2 publications [4,5]. However, adaptations of the code will be used in future projects within the CONBOTS project [3], where performance of students relative to a teacher are being tested in other longitudinal studies.
#### 3.4.	Publications: 
The code is used in [4,5].
#### 3.5.   CodeOcean capsule:
The R codeocean capsule can be found at: https://codeocean.com/capsule/5921029/tree

##4.	References
1. 	Cao Z, Simon T, Wei SE, Sheikh Y. Realtime Multi-Person 2D Pose Estimation using Part Affinity Fields. Proceedings - 30th IEEE Conference on Computer Vision and Pattern Recognition, CVPR 2017 [Internet]. 2016 Nov 24 [cited 2023 Oct 25];2017-January:1302–10. Available from: https://arxiv.org/abs/1611.08050v2
2. 	Smutny P. Learning with virtual reality: a market analysis of educational and training applications. Interactive Learning Environments [Internet]. 2022 Feb 12 [cited 2023 Oct 25]; Available from: https://www.tandfonline.com/doi/abs/10.1080/10494820.2022.2028856
3. 	Home  CONBOTS [Internet]. Available from: https://www.conbots.eu/
4. 	Campo A, Michałko A, Van Kerrebroeck B, Leman M. Dataset for the assessment of presence and performance in an augmented reality environment for motor imitation learning: A case-study on violinists. Data Brief [Internet]. 2023 Dec 1 [cited 2023 Oct 17];51:109663. Available from: https://linkinghub.elsevier.com/retrieve/pii/S2352340923007485
5. 	Campo A, Michałko A, Van Kerrebroeck B, Stajic B, Pokric M, Leman M. The assessment of presence and performance in an AR environment for motor imitation learning: A case-study on violinists. Comput Human Behav [Internet]. 2023 Sep 1 [cited 2023 Oct 17];146. Available from: https://pubmed.ncbi.nlm.nih.gov/37663430/
6. 	Wu G, Siegler S, Allard P, Kirtley C, Leardini A, Rosenbaum D, et al. ISB recommendation on definitions of joint coordinate system of various joints for the reporting of human joint motion - Part I: Ankle, hip, and spine. J Biomech [Internet]. 2002;35(4):543–8. Available from: https://pubmed.ncbi.nlm.nih.gov/11934426/
7. 	Wu G, Van Der Helm FCT, Veeger HEJ, Makhsous M, Van Roy P, Anglin C, et al. ISB recommendation on definitions of joint coordinate systems of various joints for the reporting of human joint motion - Part II: Shoulder, elbow, wrist and hand. J Biomech [Internet]. 2005 May;38(5):981–92. Available from: https://pubmed.ncbi.nlm.nih.gov/15844264/
8. 	Stokdijk M, Nagels J, Rozing PM. The glenohumeral joint rotation centre in vivo. J Biomech [Internet]. 2000;33(12):1629–36. Available from: https://pubmed.ncbi.nlm.nih.gov/11006387/
9. 	Bodenheimer B, Rose C, Rosenthal S, Pella J. The Process of Motion Capture: Dealing with the Data. 1997 [cited 2023 Oct 17];3–18. Available from: https://link.springer.com/chapter/10.1007/978-3-7091-6874-5_1
10. 	Talebi M, Campo A, Aarts N, Leman M. Influence of musical context on sensorimotor synchronization in classical ballet solo dance. Jan YK, editor. PLoS One [Internet]. 2023 Apr 18 [cited 2023 Apr 27];18(4):e0284387. Available from: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0284387
11. 	Lorenzoni V, Staley J, Marchant T, Onderdijk KE, Maes PJ, Leman M. The sonic instructor: A music-based biofeedback system for improving weightlifting technique. PLoS One [Internet]. 2019 Aug 1 [cited 2023 Oct 17];14(8):e0220915. Available from: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0220915
12. 	Konczak J, Vander Velden H, Jaeger L. Learning to play the Violin: Motor control by freezing, not freeing degrees of freedom. J Mot Behav [Internet]. 2009 May;41(3):243–52. Available from: https://pubmed.ncbi.nlm.nih.gov/19366657/
13. 	Burger B;, Toiviainen P, Burger B, Toiviainen P. MoCap Toolbox - A Matlab toolbox for computational analysis of movement data. Proceedings of the Sound and Music Computing Conferences [Internet]. 2014 [cited 2023 Oct 17];715–21. Available from: https://jyx.jyu.fi/handle/123456789/42837
14. 	Moura N, Vidal M, Aguilera AM, Vilas-Boas JP, Serra S, Leman M. Knee flexion of saxophone players anticipates tonal context of music. npj Science of Learning 2023 8:1 [Internet]. 2023 Jun 27 [cited 2023 Oct 17];8(1):1–7. Available from: https://www.nature.com/articles/s41539-023-00172-z
15. 	Volta E, Mancini M, Varni G, Volpe G. Automatically measuring biomechanical skills of violin performance: an exploratory study. [cited 2023 Oct 17];18. Available from: https://doi.org/10.1145/3212721.3212840
16. 	Leman M. Co-regulated timing in music ensembles: A Bayesian listener perspective. J New Music Res. 2021;50(2):121–32. 
