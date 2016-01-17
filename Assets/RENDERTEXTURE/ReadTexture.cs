using UnityEngine;
using System.Collections.Generic;

public class ReadTexture : MonoBehaviour 
{
    public RenderTexture renderTex;
    public Texture2D tex;
    int size = 1025;

	public TerrainController tController;

    void Start()
    {
        
    }

    void Update()
    {

        //TODO: Create new rendertexture here
        if (Input.GetKeyDown(KeyCode.Space))
        {
            RenderTexture.active = renderTex;
            DestroyImmediate(tex);
            tex = new Texture2D(size, size, TextureFormat.RGBAHalf, true);
            tex.wrapMode = TextureWrapMode.Clamp;
            tex.ReadPixels(new Rect(0, 0, size, size), 0, 0);
            tex.Apply();
            GetComponent<Renderer>().material.mainTexture = tex;

			Debug.Log("Generated heightmap...");

			tController.SetHeights(tex);
        }
    }
}
