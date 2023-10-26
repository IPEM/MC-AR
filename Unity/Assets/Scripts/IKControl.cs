using UnityEngine;
using System;
using System.Collections;

public class IKControl : MonoBehaviour
{
    public Transform leftHandForeArmSource;
    public Transform leftHandForeArmTarget;

    public Transform leftHandForeArm1Source;
    public Transform leftHandForeArm1Target;

    public Transform leftHandSource;
    public Transform leftHandTarget;

    public Transform finalPos;

    private Vector3 leftHandForeArmStartPos;
    private Vector3 leftHandForeArm1StartPos;
    private Vector3 leftHandStartPos;

    void Start()
    {
        leftHandForeArmStartPos = leftHandForeArmTarget.position;
        leftHandForeArm1StartPos = leftHandForeArm1Target.position;
        leftHandStartPos = leftHandTarget.position;
    }

    void LateUpdate()
    {
        if (leftHandForeArmTarget != null)
        {
            leftHandForeArmSource.position = leftHandForeArmSource.position + (leftHandForeArmTarget.position - leftHandForeArmStartPos);
            leftHandForeArmSource.rotation = leftHandForeArmSource.rotation * leftHandForeArmTarget.rotation;
        }

        if (leftHandForeArm1Target != null)
        {
            leftHandForeArm1Source.position = leftHandForeArm1Source.position + (leftHandForeArm1Target.position - leftHandForeArm1StartPos);
            leftHandForeArm1Source.rotation = leftHandForeArm1Source.rotation * leftHandForeArm1Target.rotation;
        }

        if (leftHandTarget != null)
        {
            leftHandSource.position = leftHandSource.position + (leftHandTarget.position - leftHandStartPos);
            leftHandSource.rotation = leftHandSource.rotation * leftHandTarget.rotation;
        }
    }

    void OnApplicationQuit()
    {
        Debug.Log(leftHandForeArmTarget.position - finalPos.position);
        Debug.Log(leftHandForeArm1Target.position - finalPos.position);
        Debug.Log(leftHandTarget.position - finalPos.position);
    }
}