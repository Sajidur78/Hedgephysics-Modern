using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeRewind : MonoBehaviour {
    [HideInInspector]
    public List<Vector3> Positions;
    [HideInInspector]
    public List<Quaternion> Rotations;
    public float Kurac = 20;
    MonoBehaviour[] ScriptsAttached;
    public bool DisableScripts;

    public bool DisableCustomScripts;
    public MonoBehaviour[] ScriptsToDisable;

    Rigidbody Rb;
	// Use this for initialization
	void Start () {
        Rb = GetComponent<Rigidbody>();
        ScriptsAttached = GetComponents<MonoBehaviour>();
	}
	
	// Update is called once per frame
	void FixedUpdate () {
        if (Input.GetKey(KeyCode.Q))
        {
            Play();
            if (Rb != null) {
                Rb.isKinematic = true;
            }
            if (DisableScripts) {
                SetAttachedScripts(false);
            } else if (DisableCustomScripts) {
                SetCustomScripts(false);
            }
        }
        else {
            Record();
            if (Rb != null)
            {
                Rb.isKinematic = false;
            }
            if (DisableScripts)
            {
                SetAttachedScripts(true);
            }
            else if (DisableCustomScripts)
            {
                SetCustomScripts(true);
            }
        }
	}

    void Record() {
        if (Positions.Count > Mathf.Round(Kurac / Time.fixedDeltaTime)) {
            Positions.RemoveAt(Positions.Count - 1);
            Rotations.RemoveAt(Positions.Count - 1);
        }
        Positions.Insert(0, transform.position);
        Rotations.Insert(0, transform.rotation);
    }
    void Play() {
        if (Positions.Count <= 1) {
            Debug.Log("lol stop");
            return;
        }
        transform.position = Positions[0];
        transform.rotation = Rotations[0];
        Positions.RemoveAt(0);
        Rotations.RemoveAt(0);
    }
    void SetAttachedScripts(bool value) {
        foreach (var script in ScriptsAttached)
        {
            if (script != this) {
                script.enabled = value;
            }
        }
    }

    void SetCustomScripts(bool value)
    {
        foreach (var script in ScriptsToDisable)
        {
            if (script != this)
            {
                script.enabled = value;
            }
        }
    }
}
