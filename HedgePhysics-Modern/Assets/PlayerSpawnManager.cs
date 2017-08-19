using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerSpawnManager : MonoBehaviour {

	// Use this for initialization
	void Start () {
        StartCoroutine(UpdatePosition());
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    public IEnumerator UpdatePosition() {
        yield return new WaitForSeconds(0.1f);
        if (FindObjectOfType<PlayerBhysics>())
        {
            FindObjectOfType<PlayerBhysics>().transform.position = transform.position;
        }
    }
}
