Shader "GAT350/UnlitMultiTexture"
{
    Properties
    {
        _MainTex1 ("Texture 1", 2D) = "white" {}
        _Scroll("Scroll 1", Vector) = (0,0,0,0)

        _MainTex2 ("Texture 2", 2D) = "white" {}
        _Scroll("Scroll 2", Vector) = (0,0,0,0)

        _Blend("Blend", Range(0,1)) = 0.5
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
 
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
 
            struct v2f //vertex to fragment (pixel)
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };
 
            sampler2D _MainTex1;
            sampler2D _MainTex2;
            float4 _MainTex1_ST;
            float4 _MainTex2_ST;
 
            fixed4 _Tint;
            float _Intensity;
            float4 _Scroll;
            float _Blend;
 
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex1);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex1);

                o.uv.x = o.uv.x + (_Time.y * _Scroll.x);
                o.uv.y = o.uv.y + (_Time.y * _Scroll.y);

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
 
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 colour1 = tex2D(_MainTex1, i.uv);
                fixed4 colour2 = tex2D(_MainTex2, i.uv);

                fixed4 colour = lerp(colour1, colour2, _Blend);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return colour;
            }
            ENDCG
        }
    }
}