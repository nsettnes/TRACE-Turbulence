using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System;

public class TerrainManager : MonoBehaviour
{
    public List<TerrainTile> TileList;
    public List<TerrainData> DataList;

    void Start ()
    {
	    if(TileList == null)
            TileList = new List<TerrainTile>();
    }
	
	void Update ()
    {
	
	}
}

[System.Serializable]
public class TerrainTile
{
    public Terrain ThisTerrain;
}