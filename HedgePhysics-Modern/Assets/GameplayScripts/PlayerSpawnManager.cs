using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.PostProcessing;

public class PlayerSpawnManager : NetworkBehaviour {
    public PostProcessingProfile PostProcessingProfile;
	// Use this for initialization
	void Start () {
        StartCoroutine(UpdatePosition());
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    public IEnumerator UpdatePosition() {
        yield return new WaitForSeconds(0.1f);
        if (!FindObjectOfType<NetworkIdentity>())
        {
            if (FindObjectOfType<PlayerBhysics>())
            {
                FindObjectOfType<PlayerBhysics>().transform.position = transform.position;
            }
        }
        else
        {
            GameObject.Find("PlayerObjects_SinglePlayer").SetActive(false);
            if (FindObjectOfType<PlayerBhysics>())
            {
                FindObjectOfType<PlayerBhysics>().transform.position = transform.position;
            }
        }
        if (FindObjectOfType<PostProcessingBehaviour>()) {
            FindObjectOfType<PostProcessingBehaviour>().profile = PostProcessingProfile;
        }
    }
}
