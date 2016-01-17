using UnityEngine;
using System.Collections;

public class TerrainControllerNik : MonoBehaviour 
{
	void Start () 
	{
//		TerrainData tData = GetComponent<Terrain>().terrainData;
//		int hmWidth = tData.heightmapWidth;
//		float[,] heights = tData.GetHeights(0,0, hmWidth, hmWidth);
//
//		for (int y = 0; y < hmWidth; y++) 
//		{
//			for (int x = 0; x < hmWidth; x++) 
//			{
//				heights[x,y] = Random.value;
//			}
//		}
//		
//		SetHeights(heights);
	}

    public void SetHeights(Texture2D tex)
	{
        //Color[] colormap = tex.GetPixels(0,0,tex.width, tex.width);
        float[,] heightmap = new float[tex.width,tex.height];
		for(int x = 0; x < tex.width; x++)
		{
			for(int y = 0; y < tex.height; y++)
			{
                heightmap[x, y] = DecodeFloatRGBA( tex.GetPixel(x,y) );
			}
		}
		TerrainData tData = GetComponent<Terrain>().terrainData;

		Debug.Log("Setting heightmap...");
		tData.SetHeights(0, 0, heightmap);
		Debug.Log("... heightmap set.");
	}

    float DecodeFloatRGBA(Color color)
    {
        Vector4 rgba = new Vector4(color.r, color.g, color.b, color.a);
        return Vector4.Dot(rgba, new Vector4(1.0f, 1 / 255.0f, 1 / 65025.0f, 1 / 160581375.0f));
        //Vector3 rgb = new Vector3(color.r, color.g, color.b);
        //return Vector3.Dot(rgb, new Vector3(1.0f, 1 / 255.0f, 1 / 65025.0f));
    }
}
