////////////////////////////////////////////////////////////////////////////////////////////////
//
//  full.fx ver2.0
//  作成: 舞力介入P
//  HgShadowで使用出来るように改変 by 針金P
//
////////////////////////////////////////////////////////////////////////////////////////////////
// パラメータ宣言

//////////////////// HgShadowでこれを追加します ///////////////////////
// ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

// HgShadowの必要なパラメータを取り込む
#include "Shader/HgShadow_ObjHeader.fxh"

// ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
///////////////////////////////////////////////////////////////////////

// 座標変換行列
float4x4 WorldViewProjMatrix : WORLDVIEWPROJECTION;
float4x4 WorldViewMatrix     : WORLDVIEW;
float4x4 WorldMatrix         : WORLD;

float4x4 unity_ObjectToWorld : WORLD;
float4x4 unity_MatrixVP      : VIEWPROJECTION;
float4x4 unity_MatrixV       : VIEW;

float4x4 ViewMatrix          : VIEW;
float4x4 LightWorldViewProjMatrix : WORLDVIEWPROJECTION < string Object = "Light"; >;

float3 LightDirection : DIRECTION < string Object = "Light"; >;
float3 CameraPosition : POSITION  < string Object = "Camera"; >;

// マテリアル色
float4 MaterialDiffuse   : DIFFUSE  < string Object = "Geometry"; >;
float3 MaterialAmbient   : AMBIENT  < string Object = "Geometry"; >;
float3 MaterialEmmisive  : EMISSIVE < string Object = "Geometry"; >;
float3 MaterialSpecular  : SPECULAR < string Object = "Geometry"; >;
float  SpecularPower     : SPECULARPOWER < string Object = "Geometry"; >;
float3 MaterialToon      : TOONCOLOR;
float4 EdgeColor         : EDGECOLOR;
float4 GroundShadowColor : GROUNDSHADOWCOLOR;
// ライト色
float3 LightDiffuse   : DIFFUSE   < string Object = "Light"; >;
float3 LightAmbient   : AMBIENT   < string Object = "Light"; >;
float3 LightSpecular  : SPECULAR  < string Object = "Light"; >;
static float4 DiffuseColor  = MaterialDiffuse  * float4(LightDiffuse, 1.0f);
static float3 AmbientColor  = MaterialAmbient  * LightAmbient + MaterialEmmisive;
static float3 SpecularColor = MaterialSpecular * LightSpecular;

// テクスチャ材質モーフ値
float4 TextureAddValue  : ADDINGTEXTURE;
float4 TextureMulValue  : MULTIPLYINGTEXTURE;
float4 SphereAddValue   : ADDINGSPHERETEXTURE;
float4 SphereMulValue   : MULTIPLYINGSPHERETEXTURE;

float _GlobalTime   : TIME;

bool use_subtexture;    // サブテクスチャフラグ

bool parthf;   // パースペクティブフラグ
bool transp;   // 半透明フラグ
bool spadd;    // スフィアマップ加算合成フラグ
#define SKII1  1500
#define SKII2  8000
#define Toon   3

#define cmp -

float4x4 head_bone : CONTROLOBJECT < string name = "(self)"; string item = "Bip001 Head"; >;
static float3 head_foward = head_bone._31_32_33;

texture MainTex: MATERIALTEXTURE;
sampler MainTex_s = sampler_state {
    texture = <MainTex>;
    MINFILTER = ANISOTROPIC;
    MAGFILTER = ANISOTROPIC;
    MIPFILTER = LINEAR;
    MAXANISOTROPY = 16;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

#ifdef _OtherDataTex
	texture2D OtherDataTex <string ResourceName = _OtherDataTex;>;
#else
	texture2D OtherDataTex;
#endif
sampler OtherDataTex_s = sampler_state {
    texture = <OtherDataTex>;
    ADDRESSU  = CLAMP;
    ADDRESSV  = CLAMP;
};

#ifdef _OtherDataTex2
	texture2D OtherDataTex2 <string ResourceName = _OtherDataTex2;>;
#else
	texture2D OtherDataTex2;
#endif
sampler OtherDataTex2_s = sampler_state {
    texture = <OtherDataTex2>;
    MINFILTER = ANISOTROPIC;
    MAGFILTER = ANISOTROPIC;
    MIPFILTER = LINEAR;
    MAXANISOTROPY = 16;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

#ifdef _LightTex
	texture2D LightTex <string ResourceName = _LightTex;>;
#else
	texture2D LightTex;
#endif
sampler LightTex_s = sampler_state {
    texture = <LightTex>;
    MINFILTER = ANISOTROPIC;
    MAGFILTER = ANISOTROPIC;
    MIPFILTER = LINEAR;
    MAXANISOTROPY = 16;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

#ifdef _ChannelMixTex
	texture2D ChannelMixTex <string ResourceName = _ChannelMixTex;>;
#else
	texture2D ChannelMixTex;
#endif
sampler ChannelMixTex_s = sampler_state {
    texture = <ChannelMixTex>;
    MINFILTER = ANISOTROPIC;
    MAGFILTER = ANISOTROPIC;
    MIPFILTER = LINEAR;
    MAXANISOTROPY = 16;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

#ifdef _EyeColorMap
	texture2D EyeColorMap <string ResourceName = _EyeColorMap;>;
#else
	texture2D EyeColorMap;
#endif
sampler EyeColorMap_s = sampler_state {
    texture = <EyeColorMap>;
    MINFILTER = ANISOTROPIC;
    MAGFILTER = ANISOTROPIC;
    MIPFILTER = LINEAR;
    MAXANISOTROPY = 16;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

texture2D OverlayTex;
sampler OverlayTex_s = sampler_state {
    texture = <OverlayTex>;
    MINFILTER = ANISOTROPIC;
    MAGFILTER = ANISOTROPIC;
    MIPFILTER = LINEAR;
    MAXANISOTROPY = 16;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

#define MatCapTX( Tex, Sample ) \
	sampler2D Sample = sampler_state { \
		texture = <Tex>; \
		MINFILTER = ANISOTROPIC; \
		MAGFILTER = ANISOTROPIC; \
		MIPFILTER = LINEAR; \
		MAXANISOTROPY = 16; \
		ADDRESSU  = WRAP; \
		ADDRESSV  = WRAP; \
	}; \
  
	#ifdef _MatCapTex
		texture2D MatCapTex < string ResourceName = _MatCapTex;>;
	#else
		texture2D MatCapTex;
	#endif
	#ifdef _MatCapTex2
		texture2D MatCapTex2 < string ResourceName = _MatCapTex2;>;
	#else
		texture2D MatCapTex2;
	#endif
	#ifdef _MatCapTex3
		texture2D MatCapTex3 < string ResourceName = _MatCapTex3;>;
	#else
		texture2D MatCapTex3;
	#endif
	#ifdef _MatCapTex4
		texture2D MatCapTex4 < string ResourceName = _MatCapTex4;>;
	#else
		texture2D MatCapTex4;
	#endif
	#ifdef _MatCapTex5
		texture2D MatCapTex5 < string ResourceName = _MatCapTex5;>;
	#else
		texture2D MatCapTex5;
	#endif
  
	MatCapTX( MatCapTex, MatCapTex_s )
	MatCapTX( MatCapTex2, MatCapTex2_s )
	MatCapTX( MatCapTex3, MatCapTex3_s )
	MatCapTX( MatCapTex4, MatCapTex4_s )
	MatCapTX( MatCapTex5, MatCapTex5_s )
	
float4x4 CTF(float3 frg_position, float4 frg_normal, float4 frg_texcoord) {
	float4x4 Out;
	frg_position = frg_position * float3(1, 1, 1);
	float3 p_dx = ddx(frg_position.xyz);
	float3 p_dy = ddy(frg_position.xyz);
	float2 tc_dx = ddx(frg_texcoord.xy);
	float2 tc_dy = ddy(frg_texcoord.xy);
	float direction = tc_dx.x * tc_dy.y - tc_dx.y * tc_dy.x > 0.0f ? 1.0f : -1.0f;
	float3 t = normalize(tc_dy.y * p_dx - tc_dx.y * p_dy) * direction;
	float3 b = normalize( (tc_dy.x * p_dx - tc_dx.x * p_dy) * direction );
	float3 n = normalize(frg_normal.xyz);
	float3 x = cross(n, t);
	t = cross(x, n);
	t = normalize(t);
	x = cross(b, n);
	b = cross(n, x);
	b = normalize(b);
	
	Out[0].xyz = t;
	Out[1].xyz = b;
	Out[2] = frg_normal;
	return Out;
}

#if Shader_Type == 0
	#include "Shader/NapAvatarUI.fxsub"
#elif Shader_Type == 1
	#include "Shader/NapAvatarUIEye.fxsub"
#elif Shader_Type == 2
	#include "Shader/NapAvatarUIFace.fxsub"
#elif Shader_Type == 3
	#include "Shader/NapAvatarUITransparent.fxsub"
#elif Shader_Type == 4
	#include "Shader/NapStencilShadowCaster.fxsub"
#endif