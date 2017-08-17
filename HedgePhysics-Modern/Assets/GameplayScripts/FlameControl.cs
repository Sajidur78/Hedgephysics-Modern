using UnityEngine;
using System.Collections;

public class FlameControl : MonoBehaviour {

    Transform Player;
    public float Distance;
    public ParticleSystem Particle;

	void Start () {
        InvokeRepeating("Flame", 0.1f, 1.0f);
    }

    void Flame()
    {
        if (!Player)
        {
            Player = FindObjectOfType<PlayerBhysics>().transform;
            return;
        }
        if (Vector3.Distance(Player.position, transform.position) < Distance)
        {
            Particle.Emit(1);
        }
    }
}
