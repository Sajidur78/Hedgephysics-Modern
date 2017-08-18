using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerSpawnManager : MonoBehaviour {

	// Use this for initialization
	void Start () {
        if (FindObjectOfType<PlayerBhysics>()) {
            FindObjectOfType<PlayerBhysics>().transform.position = transform.position;
        }
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
