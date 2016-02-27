using UnityEngine;
using System.Collections;

[System.Serializable]
public class TerrainTile
{
    public static float _widthAndLength = 1024f;
    public Terrain Terrain { get; private set; }
    public TerrainData TData { get; private set; }
    public TerrainCollider TCollider { get; private set; }
    public int IndexX { get; private set; }
    public int IndexZ { get; private set; }

    public bool InUse { get; private set; }

    public TerrainTile(Terrain terrain, TerrainData tData, int x, int z)
    {
        Terrain = terrain;
        TData = tData;
        TCollider = terrain.GetComponent<TerrainCollider>();
        IndexX = x;
        IndexZ = z;
        InUse = false;

        Terrain.terrainData = TData;
        TCollider.terrainData = TData;
    }

    public void Place(int x, int z)
    {
        IndexX = x;
        IndexZ = z;
        InUse = true;
        Terrain.gameObject.SetActive(true);
        Terrain.transform.position = new Vector3(IndexX * _widthAndLength, 0, IndexZ * _widthAndLength); ;
    }

    public int GetDistance(int x, int z)
    {
        return Mathf.Abs(IndexX - x) + Mathf.Abs(IndexZ - z);
    }
}
