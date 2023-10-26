using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class followCamera : MonoBehaviour
{
    public Transform camera;
    private Vector3 offset = new Vector3(-0.55f, 0, -0.2f);

    void Start()
    {
        
    }

    void FixedUpdate()
    {
        transform.position = Vector3.Lerp(transform.position, camera.position + offset, Time.deltaTime * 100);
    }
}
