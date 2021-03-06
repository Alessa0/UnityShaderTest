Shader "Unlit/Shader1"
{
    Properties
    { 
        _MainTex ("Texture", 2D) = "white" {}
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
            fixed4  _MainColor;
            sampler2D _MainTex;
            float4  _MainTex_ST;
            v2f_img vert(appdata_img v)
            {
                 v2f_img o;
                 o.pos=UnityObjectToClipPos(v.vertex);
                 o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);
                 return o;
            }
            fixed4 frag(v2f_img i):SV_Target
             {
             return tex2D(_MainTex,i.uv)* _MainColor;

             }
            ENDCG
        }
    }
}
