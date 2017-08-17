using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Action06_LSD : MonoBehaviour {

    public Animator CharacterAnimator;
    LSD_Control Lsd_Control;
    ActionManager Actions;

	// Use this for initialization
	void Start () {
        Lsd_Control = GetComponent<LSD_Control>();
        Actions = GetComponent<ActionManager>();
	}
	
	// FixedUpdate is called every Physics step
	void FixedUpdate () {
        CharacterAnimator.SetInteger("Action",6);
        if (Lsd_Control.ClosestRing != null)
        {
            transform.position = Vector3.MoveTowards(transform.position, Lsd_Control.ClosestRing.transform.position, Lsd_Control.LSDSpeed * Time.deltaTime);
            CharacterAnimator.transform.LookAt(Lsd_Control.ClosestRing.transform);
        }
        else {
            CharacterAnimator.SetInteger("Action", 0);
            Actions.ChangeAction(0);
        }
	}
}
