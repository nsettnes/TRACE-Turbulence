using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System;

public class TerrainManager : MonoBehaviour
{
    public int TileCreationDistance = 1;
    public List<Terrain> TerrainList = new List<Terrain>();
    public List<TerrainTile> TileList = new List<TerrainTile>();
    public ReadTextureNik ReadTexture;
    public TerrainTilePool TilePool; 

    void Start()
    {
        TilePool.InitTerrainData();
        StartCoroutine(dotheting());
    }

    IEnumerator dotheting()
    {
        int count = 1;
        if (TileCreationDistance > 0)
            count = (TileCreationDistance * 2 + 1) * (TileCreationDistance * 2 + 1);
        int quart = (int)Math.Sqrt(count);

        for (int x = 0; x < quart; x++)
        {
            for (int z = 0; z < quart; z++)
            {
                TerrainTile tile = TilePool.TerrainTiles.FirstOrDefault(t => !t.InUse);
                tile.Place(new Vector3(x, 0, z));
                SetTerrainTileHeightmap(tile);
                Resources.UnloadUnusedAssets();
                yield return null;
            }
        }

        //TerrainTile tile = TilePool.TerrainTiles.FirstOrDefault(t => !t.InUse);
        //tile.Place(new Vector3(1, 0, 1));
        //SetTerrainTileHeightmap(tile);
        Resources.UnloadUnusedAssets();
        yield return null;
    }

    void SetTerrainTileHeightmap(TerrainTile tile)
    {
        ReadTexture.SetTextureOffset(tile.Index);
        Texture2D tex = ReadTexture.GetTexture();
        SetHeights(tile, tex);
    }

    public static void SetHeights(TerrainTile tile, Texture2D tex)
    {
        //Color[] colormap = tex.GetPixels(0,0,tex.width, tex.width);
        float[,] heightmap = new float[tex.width, tex.height];
        for (int x = 0; x < tex.width; x++)
        {
            for (int y = 0; y < tex.height; y++)
            {
                heightmap[x, y] = DecodeFloatRGBA(tex.GetPixel(x, y));
            }
        }
        //TerrainData tData = GetComponent<Terrain>().terrainData;
        //GetComponent<TerrainCollider>().terrainData = tData;
        Debug.Log("Setting heightmap on tile..");
        tile.TData.SetHeights(0, 0, heightmap);
        Debug.Log("... heightmap set.");
    }

    static float DecodeFloatRGBA(Color color)
    {
        Vector4 rgba = new Vector4(color.r, color.g, color.b, color.a);
        return Vector4.Dot(rgba, new Vector4(1.0f, 1 / 255.0f, 1 / 65025.0f, 1 / 160581375.0f));
        //Vector3 rgb = new Vector3(color.r, color.g, color.b);
        //return Vector3.Dot(rgb, new Vector3(1.0f, 1 / 255.0f, 1 / 65025.0f));
    }
}