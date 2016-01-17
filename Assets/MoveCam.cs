using UnityEngine;
using System.Collections;

public class MoveCam : MonoBehaviour 
{
	public float speed = 6f;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () 
	{
		if(Input.GetKey(KeyCode.W))
		{
			transform.position += transform.forward * speed * Time.deltaTime;
		}

		if(Input.GetKey(KeyCode.A))
		{
			transform.position -= transform.right * speed * Time.deltaTime;
		}

		if(Input.GetKey(KeyCode.S))
		{
			transform.position -= transform.forward * speed * Time.deltaTime;
		}

		if(Input.GetKey(KeyCode.D))
		{
			transform.position += transform.right * speed * Time.deltaTime;
		}

		if(Input.GetKey(KeyCode.Q))
		{
			transform.position -= transform.up * speed * Time.deltaTime;
		}

		if(Input.GetKey(KeyCode.E))
		{
			transform.position += transform.up * speed * Time.deltaTime;
		}
	}
}
