
float4x4 g_transforms : WORLDVIEWPROJECTION;
//============================================================================//
//  Base Structure  :
struct vs_in
{
  float4 Pos : POSITION0;
};
struct vs_out
{
  float4 Pos : SV_POSITION0;
};
//============================================================================//
//  Vertex Shader(s)  :
vs_out vs_model (vs_in i)
{
    vs_out o = (vs_out)0;

	o.Pos = mul(i.Pos, g_transforms);
    return o;
}
//============================================================================//
// Fragment Shader(s) :
float4 ps_model(vs_out i) : COLOR0
{
  return float4(0, 0, 0, 1);
}
//============================================================================//
//  Technique(s)  : 
technique MainTecBS  < string MMDPass = "object_ss"; > {
    pass Main {
        VertexShader = compile vs_3_0 vs_model();
		PixelShader  = compile ps_3_0 ps_model();
    }
}
technique MainTec <string MMDPASS = "object"; > {
	pass Main {
        VertexShader = compile vs_3_0 vs_model();
        PixelShader = compile ps_3_0 ps_model();
    }
}