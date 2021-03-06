Shader "Custom/Blinn_Phong"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1)
        _SpecularColor("Specular Color",Color)=(0,0,0,0)
        _Shininess("Shininess",Range(1,100))=1
    }
    SubShader
    {   
        pass
        {

        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
         
        struct v2f//由于不是在顶点着色器中计算光照颜色，要传到片段着色器中，所以无需保存颜色变量，添加了两个用于储存法向量和顶点坐标的变量
        {
        float4 pos : SV_POSITION;
        fixed3 normal : TEXCOORD0;
        float4 vertex : TEXCOORD1;
        };
        fixed4 _MainColor;
        fixed4 _SpecularColor;//控制光泽
        half _Shininess;

        v2f vert(appdata_base v)
        {
         v2f o;
                 o.pos=UnityObjectToClipPos(v.vertex);
                o.normal=v.normal;
                o.vertex=v.vertex;

                 return o;
        }

            fixed4 frag(v2f i):SV_Target
             {
              float3 n=UnityObjectToWorldNormal(i.normal);
                 n=normalize(n);
                 fixed3 l =normalize(_WorldSpaceLightPos0.xyz);
                 fixed3 view = normalize(WorldSpaceViewDir(i.vertex)); /*WorldSpaceViewDir输入一个模型空间中的顶点位置，返回世界空间中从该点到摄像机的观察方向
                                                                                                              WorldSpaceViewDir得到的是顶点指向灯光的方向  */
                //漫反射
                 fixed ndotl = saturate(dot(n,l));
                 fixed4 dif = _LightColor0*_MainColor*ndotl;
                 //镜面反射
                 fixed3 h= normalize(l+view);//h取决于视角方向和灯光方向，和表面曲率无关
                 fixed ndoth = saturate(dot(n,h));
                 fixed4 spec = _LightColor0 * _SpecularColor * pow(ndoth,_Shininess);
                 //环境光+漫反射+镜面
   
             return unity_AmbientSky+dif+spec;

             }
        ENDCG
        }

    }
    FallBack "Diffuse"
}
