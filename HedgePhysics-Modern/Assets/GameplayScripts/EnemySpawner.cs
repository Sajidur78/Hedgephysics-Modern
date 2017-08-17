using UnityEngine;
using System.Collections;

public class EnemySpawner : MonoBehaviour {

    public float Distance;
    Transform Player;
    public GameObject TeleportSparkle;

    public GameObject Enemy;

    void Start()
    {
        GetComponent<MeshRenderer>().enabled = false;
    }

    void LateUpdate()
    {
        if (!Player)
        {
            Player = FindObjectOfType<PlayerBhysics>().transform;
            return;
        }
        if(Vector3.Distance(Player.position,transform.position) < Distance)
        {
            SpawnInNormal();
        }
    }

    void SpawnInNormal()
    {
        Instantiate(TeleportSparkle, transform.position, transform.rotation);
        Instantiate(Enemy, transform.position, transform.rotation,this.transform.parent);
        HomingAttackControl.UpdateHomingTargets();
        Destroy(gameObject);
    }

}
