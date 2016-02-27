using UnityEngine;
using System.Collections;
using System;

public class TerrainCenter : MonoBehaviour {

    public static event Action<int,int> CenterChanged;
    [HideInInspector]
    public int currentX = int.MinValue, currentZ = int.MinValue;

	// Use this for initialization
	void Start () {
        GetXZ();
	}
	
	// Update is called once per frame
	void Update () {
        GetXZ();
	}

    private void GetXZ()
    {
        int newX = (int)(transform.position.x / 1024);
        if (transform.position.x < 0)
            newX -= 1;
        int newZ = (int)(transform.position.z / 1024);
        if (transform.position.z < 0)
            newZ -= 1;

        if (newX != currentX || newZ != currentZ)
        {
            currentX = newX;
            currentZ = newZ;
            Debug.Log("X:" + currentX + " Z:" + currentZ);
            if(CenterChanged != null)
                CenterChanged(currentX, currentZ);
        }
    }
}
