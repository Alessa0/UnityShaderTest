Shader "Custom/Phong"
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
         
        struct v2f
        {
        float4 pos : SV_POSITION;
        fixed4 color : COLOR0;
        };
        fixed4 _MainColor;
        fixed4 _SpecularColor;//控制光泽
        half _Shininess;

        v2f vert(appdata_base v)
        {
         v2f o;
                 o.pos=UnityObjectToClipPos(v.vertex);
                 //法线
                 float3 n=UnityObjectToWorldNormal(v.normal);
                 n=normalize(n);
                 fixed3 l =normalize(_WorldSpaceLightPos0.xyz);
                 fixed3 view = normalize(WorldSpaceViewDir(v.vertex)); /*WorldSpaceViewDir输入一个模型空间中的顶点位置，返回世界空间中从该点到摄像机的观察方向
                                                                                                              WorldSpaceViewDir得到的是顶点指向灯光的方向  后面需要把L*-1*/
                 //漫反射
                 fixed ndotl = saturate(dot(n,l));
                 fixed4 dif = _LightColor0*_MainColor*ndotl;
                 //镜面反射
                 float3 ref = reflect(-l,n);
                 ref = normalize(ref);
                 fixed rdotv = saturate(dot(ref,view));
                 fixed4 spec = _LightColor0 * _SpecularColor * pow(rdotv,_Shininess);
                 //环境光+漫反射+镜面
                 o.color = unity_AmbientSky+dif+spec;
                 return o;
        }
            fixed4 frag(v2f i):SV_Target
             {
             return i.color;

             }
        ENDCG
        }

    }
    FallBack "Diffuse"
}
