Shader "Unlit/Lambert"
{
    Properties
    {
         _MainColor("MainColor",Color) =(1,1,1,1)
    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct v2f
            {
            float4 pos : SV_POSITION;
            fixed4 dif : COLOR0;
            };
            fixed4  _MainColor;

            v2f vert(appdata_base v)
            {
                 v2f o;
                 o.pos=UnityObjectToClipPos(v.vertex);
                 //法线
                 float3 n=UnityObjectToWorldNormal(v.normal);
                 n=normalize(n);
                 //灯光方向
                 fixed3 l =normalize(_WorldSpaceLightPos0.xyz);
                 //计算漫反射
                 fixed ndotl = dot(n,l);
                 //o.dif = _LightColor0 * _MainColor * saturate(ndotl);
                 //Half-Lambert
                 o.dif = _LightColor0 * _MainColor * (0.5*ndotl+0.5);
                 return o;
            }
            fixed4 frag(v2f i):SV_Target
             {
             return i.dif;

             }
            ENDCG
        }
    }
}
