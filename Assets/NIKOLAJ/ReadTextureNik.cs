using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;

public class ReadTextureNik : MonoBehaviour
{
    public RenderTexture renderTex;
    public Texture2D tex;
    public Material something; 
    int size = 1025;

    void Start()
    {

    }

    void Update()
    {
        ////TODO: Create new rendertexture here
        //if (Input.GetKeyDown(KeyCode.Space))
        //{
        //    RenderTexture.active = renderTex;
        //    DestroyImmediate(tex);
        //    tex = new Texture2D(size, size, TextureFormat.RGBAHalf, true);
        //    tex.wrapMode = TextureWrapMode.Clamp;
        //    tex.ReadPixels(new Rect(0, 0, size, size), 0, 0);
        //    tex.Apply();
        //    GetComponent<Renderer>().material.mainTexture = tex;

        //    Debug.Log("Generated heightmap...");

        //    tController.SetHeights(tex);
        //}
    }

    public void SetTextureOffset(Vector3 index)
    {
        Debug.Log("Setting texture offset..");
        //index *= size;
        something.SetVector("_Offset", new Vector4(index.x, index.y, index.z, 0));
    }

    public Texture2D GetTexture()
    {
        Debug.Log("Getting texture..");
        RenderTexture.active = renderTex;
        DestroyImmediate(tex);
        tex = new Texture2D(size, size, TextureFormat.RGBAFloat, false, true);
        tex.wrapMode = TextureWrapMode.Clamp;
        tex.ReadPixels(new Rect(0, 0, size, size), 0, 0);
        tex.Apply();
        GetComponent<Renderer>().material.mainTexture = tex;

        return tex;
    }
}
