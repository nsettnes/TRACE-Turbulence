using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

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
            TerrainTiles.Add(new TerrainTile(Terrains[i], (TerrainData)tdatas[i], 0, 0));
        }
        yield return null;
    }

    public TerrainTile GetUnused()
    {
        return TerrainTiles.FirstOrDefault(t => !t.InUse);
    }

    public TerrainTile GetFurthestTile(int x, int z)
    {
        return TerrainTiles.OrderByDescending(t => t.GetDistance(x, z)).First();
    }
    
    public bool IsIndexInUse(int x, int z)
    {
        return TerrainTiles.FirstOrDefault(t => t.InUse && t.IndexX == x && t.IndexZ == z) != null;
    }
}
