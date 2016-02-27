using UnityEngine;
using System.Collections;

public class CameraFollow : MonoBehaviour {

    public Vector3 offset;

	// Use this for initialization
	void Start () {
	    
	}
	
	// Update is called once per frame
	void Update () {
        Camera.main.transform.position = transform.position + offset;
        Camera.main.transform.LookAt(transform.position);
	}
}
