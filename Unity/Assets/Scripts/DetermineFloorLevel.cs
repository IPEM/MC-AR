using Microsoft.MixedReality.Toolkit.Input;
using UnityEngine;

public class DetermineFloorLevel : MonoBehaviour
{
    public GameObject world;

    private bool movedFloor = false;

    public void DetectFloorLevel(MixedRealityPointerEventData eventData)
    {
        if (!movedFloor) {
            var result = eventData.Pointer.Result;
            world.transform.position = new Vector3(world.transform.position.x, result.Details.Point.y, world.transform.position.z);
            PointerUtils.SetHandRayPointerBehavior(PointerBehavior.AlwaysOff);

            world.transform.Find("Avatar").gameObject.SetActive(true);
            movedFloor = true;
        }
    }
}