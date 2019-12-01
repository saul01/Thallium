//
//  ShaderDefinitions.h
//  ThalliumApp
//
//  Created by Saul Rodriguez on 11/30/19.
//  Copyright © 2019 Saul Rodriguez. All rights reserved.
//

#ifndef ShaderDefinitions_h
#define ShaderDefinitions_h

#include <simd/simd.h>

//-----------------------------------------
//              Vertex_2D
//-----------------------------------------
struct Vertex_2D
{
    vector_float4 color;
    vector_float2 pos;
};

//-----------------------------------------
//              Vertex_3D
//-----------------------------------------
struct Vertex_3D
{
    vector_float4 color;
    vector_float3 pos;
};


#endif /* ShaderDefinitions_h */
