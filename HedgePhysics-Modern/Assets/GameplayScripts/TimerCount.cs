using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using TMPro;

public class TimerCount : MonoBehaviour {


    private TMP_Text count_text;
    private float startTime;

    public bool RunTimer;
	void Start () {
        startTime = Time.time;
        count_text = GetComponent<TMP_Text>();
	}
	
	void Update () {
        if (RunTimer)
        {
            float t = Time.time - startTime;

            string minutes = ((int)t / 60).ToString("00");
            string seconds = (t % 60).ToString("00");
            string milseconds = (t * 1000 % 100).ToString("00");


            count_text.text = minutes + ":" + seconds + "." + milseconds;
        }
	}
}
