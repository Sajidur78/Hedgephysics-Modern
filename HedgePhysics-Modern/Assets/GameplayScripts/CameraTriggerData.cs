using UnityEngine;
using System.Collections;

public enum TriggerType
{
    LockToDirection, SetFree, SetFreeAndLookTowards,Pan,Static
}

public class CameraTriggerData : MonoBehaviour {

    public TriggerType Type;
    public float CameraAltitude;
    public float ChangeDistance;
    public bool changeDistance = false;
    [Header("For Pan or Static Camera")]
    public Transform Position;
    public float TransitionSpeed;

}
