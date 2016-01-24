using UnityEngine;
using System.Collections;

[System.Serializable]
public class TerrainTile
{
    public static float _widthAndLength = 1024f;
    public Terrain Terrain { get; private set; }
    public TerrainData TData { get; private set; }
    public TerrainCollider TCollider { get; private set; }
    public Vector3 Index { get; private set; }
    public bool InUse { get; private set; }

    public TerrainTile(Terrain terrain, TerrainData tData, Vector3 index)
    {
        Terrain = terrain;
        TData = tData;
        TCollider = terrain.GetComponent<TerrainCollider>();
        Index = index;
        InUse = false;

        Terrain.terrainData = TData;
        TCollider.terrainData = TData;
    }

    public void Place(Vector3 index)
    {
        Index = index;
        InUse = true;

        Terrain.transform.position = index * _widthAndLength;
    }
}
