using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System;

public class TerrainManager : MonoBehaviour
{
    public int TileCreationDistance = 1;
    //public List<Terrain> TerrainList = new List<Terrain>();
    //public List<TerrainTile> TileList = new List<TerrainTile>();
    public ReadTextureNik ReadTexture, ReadTexture1;

    public TerrainTilePool TilePool;
    bool coroutineRunning;

    void Awake()
    {
        TerrainCenter.CenterChanged += TerrainCenter_CenterChanged;
    }

    void Start()
    {
        StartCoroutine(TilePool.InitTerrainData());
    }

    void TerrainCenter_CenterChanged(int x, int z)
    {
        StartCoroutine(GenerateTilesAround(x, z));
    }

    IEnumerator GenerateTilesAround(int centerX, int centerZ)
    {
        while (coroutineRunning)
            yield return null;
        
        coroutineRunning = true;

        yield return null;
        yield return null;
        yield return null;
        yield return null;
        yield return null;

        float t = Time.time;
        for (int z = centerZ - TileCreationDistance; z <= centerZ + TileCreationDistance; z++)
        {
            for (int x = centerX - TileCreationDistance; x <= centerX + TileCreationDistance; x++) 
            {
                Debug.Log("X: " + x + " Z: " + z);
                if (!TilePool.IsIndexInUse(x, z))
                {
                    Debug.Log("Something something");
                    TerrainTile tile = TilePool.GetUnused();
                    if (tile == null)
                        tile = TilePool.GetFurthestTile(centerX, centerZ);
                    tile.Place(x, z);
                    ReadTexture.SetTextureOffset(tile.IndexX, tile.IndexZ);
                    ReadTexture1.SetTextureOffset(tile.IndexX, tile.IndexZ);
                    yield return null;
                    SetTerrainTileHeightmap(tile);
                }
            }
        }

        Debug.Log(Time.time - t);
        Resources.UnloadUnusedAssets(); 
        coroutineRunning = false;
        yield return null;
    }

    void SetTerrainTileHeightmap(TerrainTile tile)
    {
        Texture2D tex = ReadTexture.GetTexture();
        Texture2D tex1 = ReadTexture1.GetTexture();
        SetHeights(tile, tex, tex1);
    }

    public static void SetHeights(TerrainTile tile, Texture2D tex, Texture2D tex1)
    {
        //Color[] colormap = tex.GetPixels(0,0,tex.width, tex.width);
        float[,] heightmap = new float[tex.width, tex.height];
        //int chunkSize = 256;
        for (int y = 0; y < tex.height; y++)
        {
            for (int x = 0; x < tex.width; x++)
            {
                heightmap[x, y] = (DecodeFloatRGBA(tex.GetPixel(y, x))*0.9f + DecodeFloatRGBA(tex1.GetPixel(y, x))*0.4f);
                //make coroutine and yield return each xxxx pixel analyzed
            }
        }
        //TerrainData tData = GetComponent<Terrain>().terrainData;
        //GetComponent<TerrainCollider>().terrainData = tData;

        //xBase and yBase parameters are x and y coordinate starting points/offset. Keep at 0, 0 to change the entire terrain
        tile.TData.SetHeights(0, 0, heightmap);

        tile.Terrain.gameObject.name = "x:" + tile.IndexX + " z:" + tile.IndexZ;
    }

    static float DecodeFloatRGBA(Color color)
    {
        Vector4 rgba = new Vector4(color.r, color.g, color.b, color.a);
        return Vector4.Dot(rgba, new Vector4(1.0f, 1 / 255.0f, 1 / 65025.0f, 1 / 160581375.0f));
        //Vector3 rgb = new Vector3(color.r, color.g, color.b);
        //return Vector3.Dot(rgb, new Vector3(1.0f, 1 / 255.0f, 1 / 65025.0f));
    }
}