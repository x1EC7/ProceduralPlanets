Shader "Unlit/DrawPlanet"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct data
			{
				float4 vertex;
				float2 uv;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			StructuredBuffer<data> vertexBuffer;
			StructuredBuffer<uint> indexBuffer;
			float4 _WorldPos;
			
			v2f vert (uint id : SV_VertexID)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(vertexBuffer[indexBuffer[id]].vertex + _WorldPos);
				o.uv = TRANSFORM_TEX(vertexBuffer[indexBuffer[id]].uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
