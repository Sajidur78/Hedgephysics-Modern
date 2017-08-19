using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class EnemyEvent : MonoBehaviour {
    public GameObject[] Enemies;
    public UnityEvent OnDefeatAll;

    int count;
    void Start () {

	}
	
	// Update is called once per frame
	void Update () {
        count = 0;
        for (int i = 0; i < Enemies.Length; i++)
        {
            if (Enemies[i] == null) count++;
        }
        if (count == Enemies.Length)
        {
            OnDefeatAll.Invoke();
            this.enabled = false;
        }
    }
}
