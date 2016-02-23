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
        StartCoroutine(dotheting());
    }

    IEnumerator dotheting()
    {
        yield return StartCoroutine(TilePool.InitTerrainData());
        yield return null;
        yield return null;
        yield return null;
        //int sideCount = TileCreationDistance * 2;

        int fucker = 0;
        for(int x = 0; x < TileCreationDistance * 2 + 1; x++)
        {
            for (int z = TileCreationDistance * 2 + 1; z > 0; z--)
            {
                TerrainTile tile = TilePool.TerrainTiles[fucker];
                fucker++;
                tile.Place(new Vector3(x, 0, z));
                SetTerrainTileHeightmap(tile);
                Resources.UnloadUnusedAssets();
                yield return null;
            }
        }


        //for (int z = -TileCreationDistance; z <= TileCreationDistance; z++)
        //{
        //    //for (int x = -TileCreationDistance; x <= TileCreationDistance; x++)
        //    //{
        //        TerrainTile tile = TilePool.TerrainTiles.FirstOrDefault(t => !t.InUse);
        //        tile.Place(new Vector3(0, 0, z));
        //        SetTerrainTileHeightmap(tile);
        //        Resources.UnloadUnusedAssets();
        //        yield return null;
        //    //}
        //}

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
        for (int y = 0; y < tex.height; y++)
        {
            for (int x = 0; x < tex.width; x++)
            {
                heightmap[y, x] = DecodeFloatRGBA(tex.GetPixel(x, y));
            }
        }
        //TerrainData tData = GetComponent<Terrain>().terrainData;
        //GetComponent<TerrainCollider>().terrainData = tData;
        tile.TData.SetHeights(0, 0, heightmap);
        tile.Terrain.gameObject.name = "x:" + tile.Index.x + " z:" + tile.Index.z;
    }

    static float DecodeFloatRGBA(Color color)
    {
        Vector4 rgba = new Vector4(color.r, color.g, color.b, color.a);
        return Vector4.Dot(rgba, new Vector4(1.0f, 1 / 255.0f, 1 / 65025.0f, 1 / 160581375.0f));
        //Vector3 rgb = new Vector3(color.r, color.g, color.b);
        //return Vector3.Dot(rgb, new Vector3(1.0f, 1 / 255.0f, 1 / 65025.0f));
    }
}