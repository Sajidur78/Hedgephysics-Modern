using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;

public class Replay : MonoBehaviour {
    [HideInInspector]
    public List<Vector3> Positions;
    [HideInInspector]
    public List<Quaternion> Rotations;
    int kys;
    Rigidbody Rigid;
    public MonoBehaviour[] ScriptsToDisable;
	// Use this for initialization
	void Start () {
        Rigid = GetComponent<Rigidbody>();
	}
	
	// Update is called once per frame
	void FixedUpdate () {
        if (!Input.GetKey(KeyCode.E))
        {
            Positions.Add(transform.position);
            Rotations.Add(transform.rotation);
            kys = 0;
            SetScripts(true);
            Rigid.isKinematic = false;
        }
        else {
            SetScripts(false);
            Rigid.isKinematic = true;
            if (kys != Positions.Count - 1){
                ++kys;
                transform.position = Positions[kys];
                transform.rotation = Rotations[kys];
            }
            else if(kys == Positions.Count-1){
                return;
            }
        }
	}
    void SetScripts(bool value) {
        foreach (var script in ScriptsToDisable)
        {
            if(script != this)
            script.enabled = value;
        }
    }
}
