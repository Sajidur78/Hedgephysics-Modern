using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Action08_Stomping : MonoBehaviour {
    public float StompPower = 500;
    PlayerBhysics Player;
    ActionManager Actions;
    public Animator CharacterAnimator;
    public AudioClip StompLandClip;

	void Start () {
        Player = GetComponent<PlayerBhysics>();
        Actions = GetComponent<ActionManager>();
	}
	

	void Update () {
        CharacterAnimator.SetInteger("Action", 8);
        Player.AddVelocity(Vector3.down * StompPower);
        if (Player.Grounded) {
            SonicSoundsControl.Play(StompLandClip);
            Player.rigidbody.velocity = Vector3.zero;
            Actions.ChangeAction(0);
        }
	}
}
