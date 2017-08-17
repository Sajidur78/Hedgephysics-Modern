using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkinTrail : MonoBehaviour {
    SkinnedMeshRenderer Rend;
    public Material TrailMaterial;
	// Use this for initialization
	void Start () {
        Rend = GetComponent<SkinnedMeshRenderer>();
        foreach (Transform bone in Rend.bones)
        {
            var Trail = bone.gameObject.AddComponent<TrailRenderer>();
            Trail.widthMultiplier = 0.08f;
            Trail.material = TrailMaterial;
        }
    }
	
	// Update is called once per frame
	void Update () {

    }
}
