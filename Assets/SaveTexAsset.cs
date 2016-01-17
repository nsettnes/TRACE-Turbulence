using UnityEngine;
using UnityEngine.UI;
using UnityEditor;
using System.Collections;
using System.IO;

public class SaveTexAsset : MonoBehaviour 
{
	public Image source, destination;

	void Start () 
	{
		
	}
	
	void Update () 
	{
		if(Input.GetKeyDown(KeyCode.Return))
			Create();
	}
	
	public void Create()
	{
		Texture tex = (Texture)GetComponent<Image>().mainTexture;
//		byte[] png = tex.EncodeToPNG();
//		File.WriteAllBytes(Application.persistentDataPath + "/terraintex.png", png);
		destination.material.mainTexture = tex;
//		var mat = new Material(shader);
//		var output = new RenderTexture(1024,1024,1);
//		Graphics.Blit(plane.GetComponent<Renderer>().material.mainTexture, GetComponent<RenderTexture>(), GetComponent<Renderer>().material);

//		Debug.Log( "material " + GetComponent<Renderer>().material );

//		Debug.Log( "texture " + GetComponent<Renderer>().material.GetTexture() );
//		Debug.Log( "Aniso " + GetComponent<Renderer>().material.mainTexture.anisoLevel );
//		Debug.Log( "width " + GetComponent<Renderer>().material.mainTexture.width );
//		Texture tex = (Texture) GetComponent<Renderer>().material.mainTexture;
//		byte[] png = tex.EncodeToPNG();
//		File.WriteAllBytes(Application.persistentDataPath + "/terraintex.png", png);
//		terr.terrainData.SetHeights(0,0, tex.GetPixels());

		Debug.Log("So far so bra");
	}
}
