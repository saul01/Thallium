//
//  Shaders.metal
//  ThalliumApp
//
//  Created by Saul Rodriguez on 11/30/19.
//  Copyright © 2019 Saul Rodriguez. All rights reserved.
//

#include <metal_stdlib>
#include "ShaderDefinitions.h"
using namespace metal;

//--------------------------------------------------------
//
//--------------------------------------------------------
struct VertexOut2D
{
    float4 color;
    float4 pos [[position]];
};


//--------------------------------------------------------
//
//--------------------------------------------------------
struct VertexOut3D
{
    float4 color;
    float4 pos [[position]];
};


//--------------------------------------------------------
//
//--------------------------------------------------------
vertex VertexOut2D vertexShader2D(const device Vertex_2D *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]])
{
    // Get the data for the current vertex.
    Vertex_2D in = vertexArray[vid];
    VertexOut2D out;
    // Pass the vertex color directly to the rasterizer
    out.color = in.color;
    // Pass the already normalized screen-space coordinates to the rasterizer
    out.pos = float4(in.pos.x, in.pos.y, 0, 1);

    return out;
}


//--------------------------------------------------------
//
//--------------------------------------------------------
fragment float4 fragmentShader(VertexOut2D interpolated [[stage_in]])
{
    return interpolated.color;
}


//--------------------------------------------------------
//
//--------------------------------------------------------
vertex VertexOut3D vertexShader3D(const device Vertex_3D *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]])
{
    // Get the data for the current vertex.
    Vertex_3D in = vertexArray[vid];
    VertexOut3D out;
    // Pass the vertex color directly to the rasterizer
    out.color = in.color;
    // Pass the already normalized screen-space coordinates to the rasterizer
    out.pos = float4(in.pos.x, in.pos.y, in.pos.z, 1);

    return out;
}

