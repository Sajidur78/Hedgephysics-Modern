using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrickHandler : MonoBehaviour {

    public int AnimCount;
    public Animator CharacterAnimator;

    public void NewAnim() {
        int Rng = Random.Range(0, AnimCount);
        CharacterAnimator.SetFloat("Trick",Rng);
    }
}
