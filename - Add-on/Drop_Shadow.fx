
//==============================//
float Script : STANDARDSGLOBAL <
	string ScriptOutput = "color";
	string ScriptClass = "scene";
	string ScriptOrder = "postprocess";
> = 0.8;
//==============================//

// オリジナルの描画結果を記録するためのレンダーターゲット
texture2D ScnMap : RENDERCOLORTARGET <
	float2 ViewportRatio = {1.0f, 1.0f};
	bool AntiAlias = true;
	int MipLevels = 1;
	string Format = "A16B16G16R16F";
>;

sampler2D ScnSamp = sampler_state {
	texture = <ScnMap>;
	MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
    MIPFILTER = LINEAR;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

//=== Hair Shadow ===//
shared texture2D DropShadow : OFFSCREENRENDERTARGET
<   string Description = "Load the Model's HairShadow.fx on it's respective mesh";
    float4 ClearColor = {0.0f, 0.0f, 0.0f, 0.0f};
    float ClearDepth = 1.0f;
	bool AntiAlias = true;
	int Miplevels = 1;
	string Format = "R8G8B8";
	string DefaultEffect = 
        "self = hide;"
        "*=Resources/Mask.fx;";
>;

sampler2D Debug = sampler_state {
	texture = <DropShadow>;
	MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
    MIPFILTER = LINEAR;
    ADDRESSU  = CLAMP;
    ADDRESSV  = CLAMP;
};

texture2D DepthBuffer : RENDERDEPTHSTENCILTARGET <
	string Format = "D24S8";
>;

// レンダリングターゲットのクリア値
float4 ClearColor = {0,0,0,0};
float ClearDepth  = 1.0;

float2 ViewportSize : VIEWPORTPIXELSIZE;
static float2 ViewportOffset = (float2(0.5,0.5)/ViewportSize.xy);

//============================================================================//
//  Base Structure  :
struct vs_in
{
  float4 Pos : POSITION0;
  float2 TX0 : TEXCOORD0;
};
struct vs_out
{
  float4 Pos : SV_POSITION0;
  float2 UV  : TEXCOORD0;
};
//============================================================================//
//  Vertex Shader(s)  :
vs_out vs_model (vs_in i)
{
    vs_out o = (vs_out)0;
		
	o.Pos = i.Pos;
	o.UV = i.TX0 + ViewportOffset;
    return o;
}
//============================================================================//
// Fragment Shader(s) :
float4 ps_screen(float2 UV : TEXCOORD0) : COLOR0
{	
  return tex2D(ScnSamp, UV).xyzw;
}
//============================================================================//
//  Technique(s)  : 
technique Bloom <
	string Script = 
		"RenderColorTarget0=;"
		"ClearSetColor=ClearColor;"
		"ClearSetDepth=ClearDepth;"
		
		"RenderColorTarget0=ScnMap;"
		"RenderDepthStencilTarget=DepthBuffer;"
		"Clear=Color;"
		"Clear=Depth;"
		"ScriptExternal=Color;"
			
		"RenderColorTarget0=;"
        "RenderDepthStencilTarget=;"
        "Pass=Screen;"
	;
> {
	pass Screen < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = false; AlphaTestEnable = false;
		VertexShader = compile vs_3_0 vs_model();
        PixelShader = compile ps_3_0 ps_screen();
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////
