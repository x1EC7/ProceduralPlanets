Shader "Unlit/DrawPoints"
{
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct data
			{
				float4 vertex;
				float2 uv;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			StructuredBuffer<data> vertexBuffer;
			float4 _WorldPos;
			
			v2f vert (uint id : SV_VertexID)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(vertexBuffer[id].vertex + _WorldPos);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return fixed4(1,1,1,1);
			}
			ENDCG
		}
	}
}
