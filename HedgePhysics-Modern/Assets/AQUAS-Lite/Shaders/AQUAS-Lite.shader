// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "AQUAS Lite" {
    Properties {
        [NoScaleOffset]_NormalTexture ("Normal Texture", 2D) = "white" {}
        _NormalTiling ("Normal Tiling", Float ) = 1
        _MainColor ("Main Color", Color) = (0,0.4627451,1,1)
        _DeepWaterColor ("Deep Water Color", Color) = (0,0.3411765,0.6235294,1)
        _Fade ("Fade", Float ) = 1.45
        _Density ("Density", Range(0, 10)) = 1.74
        _DepthTransparency ("Depth Transparency", Float ) = 1.5
        _ShoreFade ("Shore Fade", Float ) = 0.3
        _ShoreTransparency ("Shore Transparency", Float ) = 0.04
        [HideInInspector]_ReflectionTex ("Reflection Tex", 2D) = "white" {}
        [MaterialToggle] _EnableReflections ("Enable Reflections", Float ) = 0.6
        _ReflectionIntensity ("Reflection Intensity", Range(0, 1)) = 0.6
        _Distortion ("Distortion", Range(0, 2)) = 0.3
        _Specular ("Specular", Float ) = 1
        _SpecularColor ("Specular Color", Color) = (0.7205882,0.7311851,0.7311851,1)
        _Gloss ("Gloss", Float ) = 0.7
        _LightWrapping ("Light Wrapping", Float ) = 2
        _Refraction ("Refraction", Range(0, 1)) = 0.67
        _WaveSpeed ("Wave Speed", Float ) = 40
        [NoScaleOffset]_FoamTexture ("Foam Texture", 2D) = "white" {}
        _FoamTiling ("Foam Tiling", Float ) = 3
        _FoamBlend ("Foam Blend", Float ) = 0.15
        _FoamVisibility ("Foam Visibility", Range(0, 1)) = 0.3
        _FoamIntensity ("Foam Intensity", Float ) = 10
        _FoamContrast ("Foam Contrast", Range(0, 0.5)) = 0.25
        _FoamColor ("Foam Color", Color) = (0.3602941,0.3655925,0.3655925,1)
        _FoamSpeed ("Foam Speed", Float ) = 120
        [MaterialToggle] _UnderwaterMode ("Underwater Mode", Float ) = 0
        [MaterialToggle] _EnableCustomFog ("Enable Custom Fog", Float ) = 1.393589
        _FogColor ("Fog Color", Color) = (1,1,1,1)
        _FogDistance ("Fog Distance", Float ) = 1000
        _FogFade ("Fog Fade", Float ) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ "Refraction" }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma exclude_renderers d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D Refraction;
            uniform sampler2D _CameraDepthTexture;
            uniform float4 _TimeEditor;
            uniform float _Fade;
            uniform float4 _MainColor;
            uniform float _Density;
            uniform float4 _DeepWaterColor;
            uniform float _ReflectionIntensity;
            uniform fixed _EnableReflections;
            uniform sampler2D _ReflectionTex; uniform float4 _ReflectionTex_ST;
            uniform float _FoamBlend;
            uniform float _FoamIntensity;
            uniform float4 _FoamColor;
            uniform float _FoamVisibility;
            uniform float _FoamContrast;
            uniform sampler2D _FoamTexture; uniform float4 _FoamTexture_ST;
            uniform float _FoamTiling;
            uniform float _FoamSpeed;
            uniform float _Specular;
            uniform float _Gloss;
            uniform float4 _SpecularColor;
            uniform float _Refraction;
            uniform sampler2D _NormalTexture; uniform float4 _NormalTexture_ST;
            uniform float _LightWrapping;
            uniform float _NormalTiling;
            uniform float _WaveSpeed;
            uniform fixed _UnderwaterMode;
            uniform float _DepthTransparency;
            uniform float _ShoreFade;
            uniform float _ShoreTransparency;
            uniform float _Distortion;
            uniform fixed _EnableCustomFog;
            uniform float4 _FogColor;
            uniform float _FogDistance;
            uniform float _FogFade;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                float4 screenPos : TEXCOORD5;
                float4 projPos : TEXCOORD6;
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                float3 recipObjScale = float3( length(unity_WorldToObject[0].xyz), length(unity_WorldToObject[1].xyz), length(unity_WorldToObject[2].xyz) );
                float3 objScale = 1.0/recipObjScale;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                o.screenPos = o.pos;
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3 recipObjScale = float3( length(unity_WorldToObject[0].xyz), length(unity_WorldToObject[1].xyz), length(unity_WorldToObject[2].xyz) );
                float3 objScale = 1.0/recipObjScale;
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float _rotator1_ang = 1.5708;
                float _rotator1_spd = 1.0;
                float _rotator1_cos = cos(_rotator1_spd*_rotator1_ang);
                float _rotator1_sin = sin(_rotator1_spd*_rotator1_ang);
                float2 _rotator1_piv = float2(0.5,0.5);
                float2 _rotator1 = (mul(i.uv0-_rotator1_piv,float2x2( _rotator1_cos, -_rotator1_sin, _rotator1_sin, _rotator1_cos))+_rotator1_piv);
                float2 _division1 = ((objScale.rb*_NormalTiling)/1000.0);
                float4 _timer1 = _Time + _TimeEditor;
                float3 _multiplier3 = (float3((_WaveSpeed/_division1),0.0)*(_timer1.r/100.0));
                float2 _multiplier1 = ((_rotator1+_multiplier3)*_division1);
                float4 _texture1 = tex2D(_NormalTexture,TRANSFORM_TEX(_multiplier1, _NormalTexture));
                float2 _multiplier2 = ((i.uv0+_multiplier3)*_division1);
                float4 _texture2 = tex2D(_NormalTexture,TRANSFORM_TEX(_multiplier2, _NormalTexture));
                float3 _subtractor1 = (_texture1.rgb-_texture2.rgb);
                float _multiplier4 = (pow(saturate((sceneZ-partZ)/_DepthTransparency),_ShoreFade)*saturate((sceneZ-partZ)/_ShoreTransparency));
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5 + ((_subtractor1.rg*(_Refraction*0.2))*_multiplier4);
                float4 sceneColor = tex2D(Refraction, sceneUVs);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
/////// Vectors:
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalLocal = lerp(float3(0,0,1),_subtractor1,_Refraction);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
///////// Gloss:
                float gloss = _Gloss;
                float specPow = exp2( gloss * 10.0+1.0);
////// Specular:
                float NdotL = max(0, dot( normalDirection, lightDirection ));
                float3 specularColor = (_Specular*_SpecularColor.rgb);
                float3 directSpecular = (floor(attenuation) * _LightColor0.xyz) * pow(max(0,dot(halfDirection,normalDirection)),specPow)*specularColor;
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = dot( normalDirection, lightDirection );
                float3 w = float3(_LightWrapping,_LightWrapping,_LightWrapping)*0.5; // Light wrapping
                float3 NdotLWrap = NdotL * ( 1.0 - w );
                float3 forwardLight = max(float3(0.0,0.0,0.0), NdotLWrap + w );
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = forwardLight * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float3 _vector31 = float3(0,0,0);
                float _value2 = 1.0;
                float3 _blend1 = saturate((_DeepWaterColor.rgb+(sceneColor.rgb*pow(saturate((_value2 + ( ((sceneZ-partZ) - _vector31) * (0.5 - _value2) ) / (((_MainColor.rgb*(10.0/_Density))+0.0) - _vector31))),_Fade))));
                float2 _mask1 = _subtractor1.rg;
                float2 _remap = ((i.screenPos.rg+(float2(_mask1.r,_mask1.g)*_Distortion))*0.5+0.5);
                float4 _ReflectionTex_var = tex2D(_ReflectionTex,TRANSFORM_TEX(_remap, _ReflectionTex));
                float _rotator2_ang = 1.5708;
                float _rotator2_spd = 1.0;
                float _rotator2_cos = cos(_rotator2_spd*_rotator2_ang);
                float _rotator2_sin = sin(_rotator2_spd*_rotator2_ang);
                float2 _rotator2_piv = float2(0.5,0.5);
                float2 _rotator2 = (mul(i.uv0-_rotator2_piv,float2x2( _rotator2_cos, -_rotator2_sin, _rotator2_sin, _rotator2_cos))+_rotator2_piv);
                float2 _division2 = ((objScale.rb*_FoamTiling)/1000.0);
                float4 _timer2 = _Time + _TimeEditor;
                float3 _multiplier7 = (float3((_FoamSpeed/_division2),0.0)*(_timer2.r/100.0));
                float2 _multiplier5 = ((_rotator2+_multiplier7)*_division2);
                float4 _texture3 = tex2D(_FoamTexture,TRANSFORM_TEX(_multiplier5, _FoamTexture));
                float2 _multiplier6 = ((i.uv0+_multiplier7)*_division2);
                float4 _texture4 = tex2D(_FoamTexture,TRANSFORM_TEX(_multiplier6, _FoamTexture));
                float _value1 = 0.0;
                float3 _multiplier8 = ((saturate((sceneZ-partZ)/_FoamBlend)*-1.0+1.0)*(((_value1 + ( (dot((_texture3.rgb-_texture4.rgb),float3(0.3,0.59,0.11)) - _FoamContrast) * (1.0 - _value1) ) / ((1.0 - _FoamContrast) - _FoamContrast))*_FoamColor.rgb)*(_FoamIntensity*(-1.0))));
                float3 _lerp1 = lerp(lerp( _blend1, lerp(_ReflectionTex_var.rgb,_blend1,(1.0 - _ReflectionIntensity)), _EnableReflections ),(_multiplier8*_multiplier8),_FoamVisibility);
                float3 diffuseColor = lerp( _lerp1, lerp(_lerp1,_FogColor.rgb,saturate(pow((distance(i.posWorld.rgb,_WorldSpaceCameraPos)/_FogDistance),_FogFade))), _EnableCustomFog );
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                fixed4 finalRGBA = fixed4(lerp(sceneColor.rgb, finalColor,lerp( _multiplier4, 0.2, _UnderwaterMode )),1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd
            #pragma multi_compile_fog
            #pragma exclude_renderers d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D Refraction;
            uniform sampler2D _CameraDepthTexture;
            uniform float4 _TimeEditor;
            uniform float _Fade;
            uniform float4 _MainColor;
            uniform float _Density;
            uniform float4 _DeepWaterColor;
            uniform float _ReflectionIntensity;
            uniform fixed _EnableReflections;
            uniform sampler2D _ReflectionTex; uniform float4 _ReflectionTex_ST;
            uniform float _FoamBlend;
            uniform float _FoamIntensity;
            uniform float4 _FoamColor;
            uniform float _FoamVisibility;
            uniform float _FoamContrast;
            uniform sampler2D _FoamTexture; uniform float4 _FoamTexture_ST;
            uniform float _FoamTiling;
            uniform float _FoamSpeed;
            uniform float _Specular;
            uniform float _Gloss;
            uniform float4 _SpecularColor;
            uniform float _Refraction;
            uniform sampler2D _NormalTexture; uniform float4 _NormalTexture_ST;
            uniform float _LightWrapping;
            uniform float _NormalTiling;
            uniform float _WaveSpeed;
            uniform fixed _UnderwaterMode;
            uniform float _DepthTransparency;
            uniform float _ShoreFade;
            uniform float _ShoreTransparency;
            uniform float _Distortion;
            uniform fixed _EnableCustomFog;
            uniform float4 _FogColor;
            uniform float _FogDistance;
            uniform float _FogFade;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                float4 screenPos : TEXCOORD5;
                float4 projPos : TEXCOORD6;
                LIGHTING_COORDS(7,8)
                UNITY_FOG_COORDS(9)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                float3 recipObjScale = float3( length(unity_WorldToObject[0].xyz), length(unity_WorldToObject[1].xyz), length(unity_WorldToObject[2].xyz) );
                float3 objScale = 1.0/recipObjScale;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                o.screenPos = o.pos;
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3 recipObjScale = float3( length(unity_WorldToObject[0].xyz), length(unity_WorldToObject[1].xyz), length(unity_WorldToObject[2].xyz) );
                float3 objScale = 1.0/recipObjScale;
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float _rotator1_ang = 1.5708;
                float _rotator1_spd = 1.0;
                float _rotator1_cos = cos(_rotator1_spd*_rotator1_ang);
                float _rotator1_sin = sin(_rotator1_spd*_rotator1_ang);
                float2 _rotator1_piv = float2(0.5,0.5);
                float2 _rotator1 = (mul(i.uv0-_rotator1_piv,float2x2( _rotator1_cos, -_rotator1_sin, _rotator1_sin, _rotator1_cos))+_rotator1_piv);
                float2 _division1 = ((objScale.rb*_NormalTiling)/1000.0);
                float4 _timer1 = _Time + _TimeEditor;
                float3 _multiplier3 = (float3((_WaveSpeed/_division1),0.0)*(_timer1.r/100.0));
                float2 _multiplier1 = ((_rotator1+_multiplier3)*_division1);
                float4 _texture1 = tex2D(_NormalTexture,TRANSFORM_TEX(_multiplier1, _NormalTexture));
                float2 _multiplier2 = ((i.uv0+_multiplier3)*_division1);
                float4 _texture2 = tex2D(_NormalTexture,TRANSFORM_TEX(_multiplier2, _NormalTexture));
                float3 _subtractor1 = (_texture1.rgb-_texture2.rgb);
                float _multiplier4 = (pow(saturate((sceneZ-partZ)/_DepthTransparency),_ShoreFade)*saturate((sceneZ-partZ)/_ShoreTransparency));
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5 + ((_subtractor1.rg*(_Refraction*0.2))*_multiplier4);
                float4 sceneColor = tex2D(Refraction, sceneUVs);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
/////// Vectors:
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalLocal = lerp(float3(0,0,1),_subtractor1,_Refraction);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
///////// Gloss:
                float gloss = _Gloss;
                float specPow = exp2( gloss * 10.0+1.0);
////// Specular:
                float NdotL = max(0, dot( normalDirection, lightDirection ));
                float3 specularColor = (_Specular*_SpecularColor.rgb);
                float3 directSpecular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow)*specularColor;
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = dot( normalDirection, lightDirection );
                float3 w = float3(_LightWrapping,_LightWrapping,_LightWrapping)*0.5; // Light wrapping
                float3 NdotLWrap = NdotL * ( 1.0 - w );
                float3 forwardLight = max(float3(0.0,0.0,0.0), NdotLWrap + w );
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = forwardLight * attenColor;
                float3 _vector31 = float3(0,0,0);
                float _value2 = 1.0;
                float3 _blend1 = saturate((_DeepWaterColor.rgb+(sceneColor.rgb*pow(saturate((_value2 + ( ((sceneZ-partZ) - _vector31) * (0.5 - _value2) ) / (((_MainColor.rgb*(10.0/_Density))+0.0) - _vector31))),_Fade))));
                float2 _mask1 = _subtractor1.rg;
                float2 _remap = ((i.screenPos.rg+(float2(_mask1.r,_mask1.g)*_Distortion))*0.5+0.5);
                float4 _ReflectionTex_var = tex2D(_ReflectionTex,TRANSFORM_TEX(_remap, _ReflectionTex));
                float _rotator2_ang = 1.5708;
                float _rotator2_spd = 1.0;
                float _rotator2_cos = cos(_rotator2_spd*_rotator2_ang);
                float _rotator2_sin = sin(_rotator2_spd*_rotator2_ang);
                float2 _rotator2_piv = float2(0.5,0.5);
                float2 _rotator2 = (mul(i.uv0-_rotator2_piv,float2x2( _rotator2_cos, -_rotator2_sin, _rotator2_sin, _rotator2_cos))+_rotator2_piv);
                float2 _division2 = ((objScale.rb*_FoamTiling)/1000.0);
                float4 _timer2 = _Time + _TimeEditor;
                float3 _multiplier7 = (float3((_FoamSpeed/_division2),0.0)*(_timer2.r/100.0));
                float2 _multiplier5 = ((_rotator2+_multiplier7)*_division2);
                float4 _texture3 = tex2D(_FoamTexture,TRANSFORM_TEX(_multiplier5, _FoamTexture));
                float2 _multiplier6 = ((i.uv0+_multiplier7)*_division2);
                float4 _texture4 = tex2D(_FoamTexture,TRANSFORM_TEX(_multiplier6, _FoamTexture));
                float _value1 = 0.0;
                float3 _multiplier8 = ((saturate((sceneZ-partZ)/_FoamBlend)*-1.0+1.0)*(((_value1 + ( (dot((_texture3.rgb-_texture4.rgb),float3(0.3,0.59,0.11)) - _FoamContrast) * (1.0 - _value1) ) / ((1.0 - _FoamContrast) - _FoamContrast))*_FoamColor.rgb)*(_FoamIntensity*(-1.0))));
                float3 _lerp1 = lerp(lerp( _blend1, lerp(_ReflectionTex_var.rgb,_blend1,(1.0 - _ReflectionIntensity)), _EnableReflections ),(_multiplier8*_multiplier8),_FoamVisibility);
                float3 diffuseColor = lerp( _lerp1, lerp(_lerp1,_FogColor.rgb,saturate(pow((distance(i.posWorld.rgb,_WorldSpaceCameraPos)/_FogDistance),_FogFade))), _EnableCustomFog );
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                fixed4 finalRGBA = fixed4(finalColor * lerp( _multiplier4, 0.2, _UnderwaterMode ),0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
