using UnityEngine;
using System.Collections;

public class TerrainControllerBen : MonoBehaviour 
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
        float f = 0;
        //Color[] colormap = tex.GetPixels(0,0,tex.width, tex.width);
        float[,] heightmap = new float[tex.width,tex.height];
        Terrain t = GetComponent<Terrain>();
        TerrainData tData = t.terrainData;
        
        tData.alphamapResolution = 1025;
        float[,,] maps = t.terrainData.GetAlphamaps(0, 0, t.terrainData.alphamapWidth, t.terrainData.alphamapHeight);
        Debug.Log(tData.alphamapWidth + " " + tData.alphamapHeight);
		for(int x = 0; x < tex.width; x++)
		{
            for (int y = 0; y < tex.height; y++)
            {
                f = DecodeFloatRGBA(tex.GetPixel(x, y));
                heightmap[x, y] = f;

                

            }
		}
        

        
        
        GetComponent<TerrainCollider>().terrainData = tData;
		Debug.Log("Setting heightmap...");
		tData.SetHeights(0, 0, heightmap);
		Debug.Log("... heightmap set.");

        for(int x = 0; x < tex.width; x++)
		{
            for (int y = 0; y < tex.height; y++)
            {
                float steepness = tData.GetSteepness((float)x/tex.width, (float)y/tex.height);
                maps[y, x, 0] = steepness / 90;
                maps[y, x, 1] = ((90-steepness)/90);
            }
        }
        tData.SetAlphamaps(0, 0, maps);
	}

    float DecodeFloatRGBA(Color color)
    {
        Vector4 rgba = new Vector4(color.r, color.g, color.b, color.a);
        return Vector4.Dot(rgba, new Vector4(1.0f, 1 / 255.0f, 1 / 65025.0f, 1 / 160581375.0f));
        //Vector3 rgb = new Vector3(color.r, color.g, color.b);
        //return Vector3.Dot(rgb, new Vector3(1.0f, 1 / 255.0f, 1 / 65025.0f));
    }
}
