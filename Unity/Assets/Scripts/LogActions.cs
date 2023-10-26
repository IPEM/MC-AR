using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LogActions : MonoBehaviour
{

    private int writerIndex = 0;
    private string filename = "data_actions";

    void Start()
    {
        TextWriter.Initialize(filename, writerIndex);
    }

    void Update()
    {

    }

    public void writeAction(string action)
    {
        TextWriter.writeToText(writerIndex, action);
    }
}
