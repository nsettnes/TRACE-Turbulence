using UnityEngine;
using System.Collections;

public class MiniMover : MonoBehaviour
{
    public float PushSpeed = 10f;

	void Start ()
    {
	
	}

    void Update ()
    {
	    if(Input.GetKey(KeyCode.W))
        {
            GetComponent<Rigidbody>().AddForce((Vector3.forward) * PushSpeed * Time.deltaTime, ForceMode.Impulse);
        }
        else if(Input.GetKey(KeyCode.S))
        {
            GetComponent<Rigidbody>().AddForce((Vector3.back) * PushSpeed * Time.deltaTime, ForceMode.Impulse);
        }
        else if (Input.GetKey(KeyCode.A))
        {
            GetComponent<Rigidbody>().AddForce((Vector3.left) * PushSpeed * Time.deltaTime, ForceMode.Impulse);
        }
        else if (Input.GetKey(KeyCode.D))
        {
            GetComponent<Rigidbody>().AddForce((Vector3.right) * PushSpeed * Time.deltaTime, ForceMode.Impulse);
        }

        GetComponent<Rigidbody>().AddForce((Vector3.down) * 100 * Time.deltaTime, ForceMode.Impulse);
    }
}
