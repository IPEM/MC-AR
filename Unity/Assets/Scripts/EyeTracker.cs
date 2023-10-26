using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Microsoft.MixedReality.Toolkit.Input;
using Microsoft.MixedReality.Toolkit.Utilities;

namespace Microsoft.MixedReality.Toolkit.Input
{
    public class EyeTracker : MonoBehaviour
    {
        private static float timeStartFrame;
        private Vector3 gazeOrigin;
        private Vector3 gazeDirection;

        private string filename = "data_eye";
        private StreamWriter eyeWriter;

        void Start()
        {
            timeStartFrame = Time.realtimeSinceStartup;

            string path = string.Format("{0}/{1}.txt", Application.persistentDataPath, string.Concat(Application.productName, "_", System.DateTime.Now.ToString("_MMddyyyy_HHmmss"), "_", filename));
            eyeWriter = new StreamWriter(path);

            InvokeRepeating("logEyeGaze", 1.0f, 0.1f);
        }

        void Update()
        {


        }

        void logEyeGaze()
        {
            var eyeGazeProvider = CoreServices.InputSystem?.EyeGazeProvider;
            gazeOrigin = eyeGazeProvider.GazeOrigin;
            gazeDirection = eyeGazeProvider.GazeDirection;

            float timeSinceStart = Time.realtimeSinceStartup - timeStartFrame;
            string unityTime = timeSinceStart.ToString();
            string gazeLine = string.Concat(unityTime, ", ", gazeOrigin, ", ", gazeDirection);

            eyeWriter.WriteLine(gazeLine);
        }

        void onApplicationQuit()
        {
            eyeWriter.Close();
            Debug.Log("Quit Eye");
        }
    }
}