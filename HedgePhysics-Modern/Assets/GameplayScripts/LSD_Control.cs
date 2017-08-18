using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LSD_Control : MonoBehaviour {
    public GameObject GetClosestRing(float Distance)
    {
        GameObject[] Rings;
        Rings = GameObject.FindGameObjectsWithTag("Ring");
        GameObject Closest = null;
        foreach (var Ring in Rings)
        {
            float distance = Vector3.Distance(transform.position, Ring.transform.position);
            if (distance < Distance)
            {
                Closest = Ring;
            }
        }
        return Closest;
    }

    public float RingSeachDistance;
    public float LSDSpeed;
    [HideInInspector]
    public GameObject ClosestRing;
    public LayerMask RingLayer;
    Collider[] Deubg;

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        //ClosestRing = GetClosestRing(RingSeachDistance);
	}
    private void FixedUpdate()
    {
        Collider[] colliders = Physics.OverlapSphere(transform.position, RingSeachDistance,RingLayer,QueryTriggerInteraction.Collide);
        Deubg = colliders;
        if (colliders.Length > 0)
            ClosestRing = colliders[0].gameObject;
        else
            return;
    }
    private void OnDrawGizmosSelected()
    {
        Gizmos.DrawWireSphere(transform.position, RingSeachDistance);
    }
}
