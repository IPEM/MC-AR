using Microsoft.MixedReality.Toolkit;
using Microsoft.MixedReality.Toolkit.Input;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GestureManager : MonoBehaviour, IMixedRealityPointerHandler
{
    public GameObject origin;

    private Vector3 leftPosition = Vector3.zero;
    private Vector3 rightPosition = Vector3.zero;

    void Awake()
    {
        CoreServices.InputSystem?.RegisterHandler<IMixedRealityPointerHandler>(this);
    }

    void Start()
    {
        
    }

    void Update()
    {

    }

    void IMixedRealityPointerHandler.OnPointerUp(MixedRealityPointerEventData eventData)
    {
        
    }

    void IMixedRealityPointerHandler.OnPointerDown(MixedRealityPointerEventData eventData)
    {
        
    }

    void IMixedRealityPointerHandler.OnPointerDragged(MixedRealityPointerEventData eventData)
    {
        
    }

    void IMixedRealityPointerHandler.OnPointerClicked(MixedRealityPointerEventData eventData)
    {

        if (eventData.MixedRealityInputAction.Description == "Select")
        {
            if (eventData.Handedness == Microsoft.MixedReality.Toolkit.Utilities.Handedness.Left)
            {
                var result = eventData.Pointer.Result;
                leftPosition = result.Details.Point;
            }
            else if (eventData.Handedness == Microsoft.MixedReality.Toolkit.Utilities.Handedness.Right)
            {
                var result = eventData.Pointer.Result;
                rightPosition = result.Details.Point;
            }

            if ((leftPosition != Vector3.zero) & (rightPosition != Vector3.zero) & (Vector3.Distance(leftPosition, rightPosition) < 0.15f))
            {
                disablePointers();

                origin.transform.position = leftPosition + (rightPosition - leftPosition)/2f;
                origin.SetActive(true);
            }
        }
    }

    private void disablePointers()
    {
        PointerUtils.SetGazePointerBehavior(PointerBehavior.AlwaysOff);
        PointerUtils.SetHandRayPointerBehavior(PointerBehavior.AlwaysOff);
    }
}
