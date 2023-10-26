using Microsoft.MixedReality.Toolkit.Input;
using UnityEngine;

public class DisablePointers : MonoBehaviour
{

    void Start()
    {
        PointerUtils.SetHandRayPointerBehavior(PointerBehavior.AlwaysOff);
    }
}