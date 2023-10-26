using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public static class TextWriter
{
    public static StreamWriter[] writers = new StreamWriter[1];
    
    private static float timeStartFrame;
    private static string[] paths = new string[2];

    public static void Initialize(string filename, int index)
    {
        timeStartFrame = Time.realtimeSinceStartup;

        paths[index] = string.Format("{0}/{1}.txt", Application.persistentDataPath, string.Concat(Application.productName, "_", System.DateTime.Now.ToString("_MMddyyyy_HHmmss"), "_", filename));
        writers[index] = System.IO.File.CreateText(paths[index]);
        writers[index].Close();
        Debug.Log(paths[index]);
    }

    public static void writeToText(int index, string line)
    {
        float timeSinceStart = Time.realtimeSinceStartup - timeStartFrame;
        string unityTime = timeSinceStart.ToString();
        string lineWithTime = string.Concat(unityTime, ", ", System.DateTime.Now.ToString("HHmmssffffff"), ", ", line, "\n");

        File.AppendAllText(paths[index], lineWithTime);
    }
}
