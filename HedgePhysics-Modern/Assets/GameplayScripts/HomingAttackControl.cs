using UnityEngine;
using System.Collections;

public class HomingAttackControl : MonoBehaviour {

    public bool HasTarget { get; set; }
    public static GameObject TargetObject { get; set; }
    public ActionManager Actions;

    public float TargetSearchDistance = 10;
    public Transform Icon;
    public float IconScale;
    public AudioClip HomingIconSFX;

    public static GameObject[] Targets;
    public GameObject[] TgtDebug;

    public Transform MainCamera;
    public float IconDistanceScaling;
    public Transform Skin;

    float Dot(Vector3 a,Vector3 b)
    {
        return Vector3.Dot(a, b);
    }

    float facingAmount;

    int HomingCount;
    public bool HomingAvailable { get; set; }
    PlayerBhysics Player;

    bool firstime = false;

    void Awake()
    {
        Actions = GetComponent<ActionManager>();
        Player = GetComponent<PlayerBhysics>();
    }

    void Start()
    {
        var tgt = GameObject.FindGameObjectsWithTag("HomingTarget");
        Targets = tgt;
        TgtDebug = tgt;

        Icon.parent = null;
        UpdateHomingTargets();
    }

    void LateUpdate()
    {
        if (!firstime)
        {
            firstime = true;
            UpdateHomingTargets();
        }
    }

    void FixedUpdate()
    {
        if (TargetObject)
        {
            facingAmount = Dot((TargetObject.transform.localPosition - transform.position).normalized, Skin.forward);
            if (!Physics.Linecast(transform.position, TargetObject.transform.position)){
                HasTarget = true;
                Debug.DrawLine(transform.position, TargetObject.transform.position);
            }
            else{
                HasTarget = false;
            }
        }
        else
        {
            facingAmount = 0;
            HasTarget = false;
        }
        UpdateHomingTargets();
        //Prevent Homing attack spamming

        HomingCount += 1;

        if(Actions.Action == 2)
        {
            HomingAvailable = false;
            HomingCount = 0;
        }
        if(HomingCount > 3)
        {
            HomingAvailable = true;
        }

        //SetIconPosition

        TargetObject = GetClosestTarget(Targets, TargetSearchDistance);

        if (HasTarget && !Player.Grounded && TargetObject)
        {
            Icon.position = TargetObject.transform.position;
            float camDist = Vector3.Distance(transform.position, MainCamera.position);
            Icon.gameObject.SetActive(true);
            SonicSoundsControl.Play(HomingIconSFX);
        }
        else
        {
            Icon.gameObject.SetActive(false);
        }

    }

    //This function will look for every possible homing attack target in the whole level. 
    //And you can call it from other scritps via [ HomingAttackControl.UpdateHomingTargets() ]
    public static void UpdateHomingTargets()
    {
        var tgt = GameObject.FindGameObjectsWithTag("HomingTarget");
        Targets = tgt;
    }

    GameObject GetClosestTarget(GameObject[] tgts, float maxDistance)
    {
        GameObject[] gos = tgts;
        GameObject closest = null;
        float distance = maxDistance;
        Vector3 position = transform.position;
        foreach (GameObject go in gos)
        {
            Vector3 diff = go.transform.position - position;
            float curDistance = diff.sqrMagnitude;
            
            if (curDistance < distance)
            {
                closest = go;
                distance = curDistance;
            }
        }
        //Debug.Log(closest);
        return closest;
    }


}
