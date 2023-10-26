// render image

using System;
using System.Collections;
using System.Collections.Generic;
using Microsoft.MixedReality.Toolkit.UI;
using UnityEngine;

public class RenderImage : MonoBehaviour
{
    public GameObject imagePanel;

    void Awake()
    {
        imagePanel.SetActive(false);
    }

    void Start()
    {

    }
}
