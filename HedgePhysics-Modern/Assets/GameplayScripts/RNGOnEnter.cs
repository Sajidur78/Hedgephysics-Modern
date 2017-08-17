using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RNGOnEnter : StateMachineBehaviour {
    public int Min = 0;
    public int Max = 5;
    public override void OnStateEnter(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
    {
        animator.SetInteger("RNG", Random.Range(Min, Max));
    }
}
