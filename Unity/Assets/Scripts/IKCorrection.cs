using UnityEngine;
using System;
using System.Collections;

public class IKCorrection : MonoBehaviour
{
    public Transform leftHandForeArm;
    public Transform leftHandForeArm1;
    public Transform leftHand;

    public Vector3 lefHandForeArmEuler = new Vector3(0, 0, 0);
    public Vector3 lefHandForeArm1Euler = new Vector3(0, 0, 0);
    public Vector3 lefHandEuler = new Vector3(0, 0, 0);

    private Quaternion lefHandForeArmQuat = new Quaternion(0, 0, 0, 1);
    private Quaternion lefHandForeArm1Quat = new Quaternion(0, 0, 0, 1);
    private Quaternion leftHandQuat = new Quaternion(0, 0, 0, 1);

    private Quaternion leftHandForeArmStart = new Quaternion(0, 0, 0, 1);
    private Quaternion leftHandForeArm1Start = new Quaternion(0, 0, 0, 1);
    private Quaternion leftHandStart = new Quaternion(0, 0, 0, 1);

    private Quaternion leftHandForeArmEnd = new Quaternion(0, 0, 0, 1);
    private Quaternion leftHandForeArm1End = new Quaternion(0, 0, 0, 1);
    private Quaternion leftHandEnd = new Quaternion(0, 0, 0, 1);

    void Start()
    {
        leftHandForeArmStart = leftHandForeArm.rotation;
        leftHandForeArm1Start = leftHandForeArm1.rotation;
        leftHandStart = leftHand.rotation;

        leftHandForeArmEnd = new Quaternion(0.4f, 0.2f, 0.6f, 0.6f);
        leftHandForeArm1End = new Quaternion(0.7f, 0.4f, 0.3f, 0.4f);
        leftHandEnd = new Quaternion(0.7f, 0.4f, 0.3f, 0.4f);

        lefHandForeArmQuat = Quaternion.Euler(lefHandForeArmEuler);
        lefHandForeArm1Quat = Quaternion.Euler(lefHandForeArm1Euler);
        leftHandQuat = Quaternion.Euler(lefHandEuler);

        Debug.Log(Quaternion.Inverse(leftHandForeArmStart));
        Debug.Log(leftHandForeArmStart);

        leftHandForeArm.rotation = leftHandForeArm.rotation * Quaternion.Inverse(leftHandForeArmStart);
        leftHandForeArm1.rotation = leftHandForeArm1.rotation * Quaternion.Inverse(leftHandForeArm1Start);
        leftHand.rotation = leftHand.rotation * Quaternion.Inverse(leftHandStart);

        Debug.Log(leftHandForeArm.rotation);
        Debug.Log(leftHandForeArm1.rotation);
        Debug.Log(leftHand.rotation);
    }

    void LateUpdate()
    {

        leftHandForeArm.rotation = leftHandForeArm.rotation * Quaternion.Inverse(leftHandForeArmStart);
        leftHandForeArm1.rotation = leftHandForeArm1.rotation * Quaternion.Inverse(leftHandForeArm1Start);
        leftHand.rotation = leftHand.rotation * Quaternion.Inverse(leftHandStart);
        
        leftHandForeArm.rotation = leftHandForeArm.rotation * leftHandForeArmEnd;
        leftHandForeArm1.rotation = leftHandForeArm1.rotation * leftHandForeArm1End;
        leftHand.rotation = leftHand.rotation * leftHandEnd;

        leftHandForeArm.rotation = leftHandForeArm.rotation * lefHandForeArmQuat;
        leftHandForeArm1.rotation = leftHandForeArm1.rotation * lefHandForeArm1Quat;
        leftHand.rotation = leftHand.rotation * leftHandQuat;
    }
}