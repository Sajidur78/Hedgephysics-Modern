using System.Collections;
using System.Collections.Generic;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

public class CircleSpawner : MonoBehaviour {

    public int numObjects = 10;
    public GameObject prefab;
    public float radius;
    public bool horizontal;

    public void Spawn() {
        Vector3 center = transform.position;
        for (int i = 0; i < numObjects; i++)
        {
            Vector3 pos;
            if (horizontal)
            {
                pos = CircleHoriz(center, radius, (i + 1) * (1.0f / numObjects));
            }
            else
            {
                pos = CircleVert(center, radius, (i + 1) * (1.0f / numObjects));
            }
            GameObject spawn = Instantiate(prefab, pos, Quaternion.identity);
            spawn.transform.parent = transform;
        }
    }

    public void ClearChildObjs() {
        Transform[] Childs = new Transform[transform.childCount];
        for (int i = 0; i < transform.childCount; i++)
        {
            Childs[i] = transform.GetChild(i);
        }
        foreach (Transform obj in Childs)
        {
            DestroyImmediate(obj.gameObject);
        }
    }

    Vector3 CircleVert(Vector3 center, float radius, float inter)
    {
        float ang = inter * 360;
        Vector3 pos;
        pos.x = center.x + radius * Mathf.Sin(ang * Mathf.Deg2Rad);
        pos.y = center.y + radius * Mathf.Cos(ang * Mathf.Deg2Rad);
        pos.z = center.z;
        return pos;
    }

    Vector3 CircleHoriz(Vector3 center, float radius, float inter)
    {
        float ang = inter * 360;
        Vector3 pos;
        pos.x = center.x + radius * Mathf.Sin(ang * Mathf.Deg2Rad);
        pos.y = center.y;
        pos.z = center.z + radius * Mathf.Cos(ang * Mathf.Deg2Rad);
        return pos;
    }
}
#if UNITY_EDITOR
[CustomEditor(typeof(CircleSpawner))]
public class CicleSpawnerEditor : Editor {
    CircleSpawner Spawner;

    public override void OnInspectorGUI()
    {
        Spawner = (CircleSpawner)target;
        DrawDefaultInspector();
        if (GUILayout.Button("Spawn Objects")) {
            Spawner.Spawn();
        }else if (GUILayout.Button("Clear Objects"))
        {
            Spawner.ClearChildObjs();
        }
    }
}
#endif
