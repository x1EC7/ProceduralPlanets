using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlanetGenerator : MonoBehaviour {

    public ComputeShader compute;

    ComputeBuffer vertexBuffer;
    ComputeBuffer indexBuffer;

    const int _ThreadGroupSize = 8;

    public int squareSize = 2;

    public Shader shader;
    Material material;

    // Use this for initialization
    void Start() {

        int _Size = squareSize * _ThreadGroupSize;
        float _HalfSize = (_Size - 1) / 2f; // TODO * scale ?
        int CSKernel = compute.FindKernel("CSMain");

        vertexBuffer = new ComputeBuffer(_Size * _Size, sizeof(float) * 6);
        indexBuffer = new ComputeBuffer((_Size - 1) * (_Size - 1) * 6, sizeof(uint));

        compute.SetInt("_Size", _Size);
        compute.SetFloat("_HalfSize", _HalfSize);
        compute.SetBuffer(CSKernel, "_Vertices", vertexBuffer);
        compute.SetBuffer(CSKernel, "_Indices", indexBuffer);

        compute.Dispatch(CSKernel, squareSize, squareSize, 1);

        material = new Material(shader);
    }

    void OnRenderObject() {
            material.SetVector("_WorldPos", transform.localPosition);
            material.SetBuffer("vertexBuffer", vertexBuffer);
            material.SetBuffer("indexBuffer", indexBuffer);
            material.SetPass(0);

            Graphics.DrawProcedural(MeshTopology.Triangles, indexBuffer.count);
    }

    private void OnDisable() {
        vertexBuffer.Release();
        indexBuffer.Release();
    }
}

public struct data {
    public Vector4 vertex;
    public Vector2 uv;
};