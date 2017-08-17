using UnityEngine;
using System.Collections;

public class CameraControl : MonoBehaviour {

    public HedgeCamera Cam;
    float InitialDistance;

    void Awake()
    {
        InitialDistance = Cam.CameraMaxDistance;
    }

	public void OnTriggerEnter(Collider col)
    {
        if(col.tag == "CameraTrigger")
        {
            if(col.GetComponent<CameraTriggerData>() != null)
            {
                if (col.GetComponent<CameraTriggerData>().Type == TriggerType.LockToDirection)
                {
                    Vector3 dir = col.transform.forward;
                    Cam.SetCamera(dir, 2f, col.GetComponent<CameraTriggerData>().CameraAltitude);
                    Cam.Locked = true;
                    if (col.GetComponent<CameraTriggerData>().changeDistance)
                    {
                        Cam.CameraMaxDistance = col.GetComponent<CameraTriggerData>().ChangeDistance;
                    }
                    else
                    {
                        Cam.CameraMaxDistance = InitialDistance;
                    }
                }
                else if (col.GetComponent<CameraTriggerData>().Type == TriggerType.SetFree)
                {
                    Cam.CameraMaxDistance = InitialDistance;
                    Cam.Locked = false;
                }
                else if (col.GetComponent<CameraTriggerData>().Type == TriggerType.SetFreeAndLookTowards)
                {
                    Vector3 dir = col.transform.forward;
                    Cam.SetCamera(dir, 2.5f, col.GetComponent<CameraTriggerData>().CameraAltitude);
                    if (!col.GetComponent<CameraTriggerData>().changeDistance)
                    {
                        Cam.CameraMaxDistance = InitialDistance;
                    }
                    else
                    {
                        Cam.CameraMaxDistance = col.GetComponent<CameraTriggerData>().ChangeDistance;
                    }
                    Cam.Locked = false;
                }
            }
        }

    }
    private void OnTriggerStay(Collider col)
    {
        if (col.transform.tag == "CameraTrigger") {
            if (col.GetComponent<CameraTriggerData>()) {
                if (col.GetComponent<CameraTriggerData>().Type == TriggerType.Pan) {
                    var data = col.GetComponent<CameraTriggerData>();
                    Cam.FollowPlayer = false;
                    Cam.transform.position = Vector3.MoveTowards(Cam.transform.position, data.Position.position, data.TransitionSpeed * Time.deltaTime);
                    Cam.transform.LookAt(Cam.Player.transform);
                }else if (col.GetComponent<CameraTriggerData>().Type == TriggerType.Static)
                {
                    var data = col.GetComponent<CameraTriggerData>();
                    Cam.FollowPlayer = false;
                    Cam.transform.position = Vector3.MoveTowards(Cam.transform.position, data.Position.position, data.TransitionSpeed * Time.deltaTime);
                    Cam.transform.rotation = data.Position.rotation;
                }
            }
        }
    }
    private void OnTriggerExit(Collider col)
    {
        if (col.transform.tag == "CameraTrigger")
        {
            Cam.FollowPlayer = true;
        }
    }
}
