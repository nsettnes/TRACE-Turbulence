using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TerrainTilePool : MonoBehaviour
{
    const string _terrainDataPath = "TerrainData";

    public List<TerrainTile> TerrainTiles;
    public List<Terrain> Terrains;

    public IEnumerator InitTerrainData()
    {
        TerrainData[] tdatas = Resources.LoadAll<TerrainData>(_terrainDataPath);
        TerrainTiles = new List<TerrainTile>();
        for(int i = 0; i < tdatas.Length; i++)
        {
            TerrainTiles.Add(new TerrainTile(Terrains[i], (TerrainData)tdatas[i], Vector3.zero));
        }
        yield return null;
    }
}
