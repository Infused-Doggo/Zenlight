
float _UseOverlayTex = 0.0;
	float _OverlayTexScale = 0.0;
	float _CharacterMatCapEnable = 1.0;
	
	float4 _PackedParams0 = 0;
	float4 _PackedParams1 = float4(0,0,0,1);
	
	float4 _AmbientGradientShape = float4(0,0,0,1);
	float4 _AmbientGradientColor = float4(0.70196, 0.77906, 0.83922, 0.20);
	
	float _RenderedEntityCount = 1;
	float _SkinMatId = 1;
	float _IsStencilReceiverPass = 0;
	float _RimGlowIntensityForChara = 1;
	float _is_main_light_shadows_on = 1;

	float4 _HeadSphereNormalCenter = float4(1,1,1,0);
	
	float3 _AvatarMainLightColor = LightAmbient * 1.5 + 0.1;
	float3 _PostShadowFadeTint = float3(0.70253, 0.67412, 0.74902);
	float3 _PostShadowTint = float3(0.776, 0.76, 0.80);
	float3 _PostShallowFadeTint = float3(0.80, 0.72, 0.74839);
	float3 _PostShallowTint = float3(1.00, 0.95, 0.966);
	float3 _PostFrontTint = float3(1.00, 0.985, 0.92);
	float3 _PostSssTint = float3(1.00, 0.875, 0.85);
	float4 _CharacterAmbient = float4(0.04672, 0.07053, 0.09434, 1.00);
	
	static float4 _MiddlePointPosition = float4(LightDirection.xyz * 36.81456, 1);
	
	float3 _WorldSpaceCameraPos = CameraPosition;
	
#if Shader_Type == 0 || Shader_Type == 3	

	//------------ Morphs ------------//
	
	_EmissionColor *= set(Emission_A, Emission_B);
	_EmissionColor2 *= set(Emission_A, Emission_B);
	_EmissionColor3 *= set(Emission_A, Emission_B);
	_EmissionColor4 *= set(Emission_A, Emission_B);
	_EmissionColor5 *= set(Emission_A, Emission_B);

	_SpecularColor *= set(Specular_A, Specular_B);
	_SpecularColor2 *= set(Specular_A, Specular_B);
	_SpecularColor3 *= set(Specular_A, Specular_B);
	_SpecularColor4 *= set(Specular_A, Specular_B);
	_SpecularColor5 *= set(Specular_A, Specular_B);
	
	_Metallic *= set(Metallic_A, Metallic_B);
	_Glossiness *= set(Glossiness_A, Glossiness_B);
	_BumpScale *= set(Bump_A, Bump_B);
	_CharacterAmbient *= set(Ambient_A, Ambient_B);

 static float _MatCapTexID_A[5] = {
  _MatCapTexID < 99.0f ? _MatCapTexID : 0,
  _MatCapTexID < 99.0f ? _MatCapTexID : 0,
  _MatCapTexID < 99.0f ? _MatCapTexID : 2,
  _MatCapTexID < 99.0f ? _MatCapTexID : 3,
  _MatCapTexID < 99.0f ? _MatCapTexID : 4};
  
  static float _MatCapRefract_A[5] = {
  _MatCapRefract,
  _MatCapRefract2,
  _MatCapRefract3,
  _MatCapRefract4,
  _MatCapRefract5};

  static float _RefractDepth_A[5] = {
  _RefractDepth,
  _RefractDepth2,
  _RefractDepth3,
  _RefractDepth4,
  _RefractDepth5};
  
  static float4 _RefractParamArray[5] = {
  _RefractParam,
  _RefractParam2,
  _RefractParam3,
  _RefractParam4,
  _RefractParam5};
  
  static float4 _MatCapColorTintArray[5] = {
  _MatCapColorTint,
  _MatCapColorTint2,
  _MatCapColorTint3,
  _MatCapColorTint4,
  _MatCapColorTint5};

  static float _MatCapUSpeed_A[5] = {
  _MatCapUSpeed,
  _MatCapUSpeed2,
  _MatCapUSpeed3,
  _MatCapUSpeed4,
  _MatCapUSpeed5};

  static float _MatCapVSpeed_A[5] = {
  _MatCapVSpeed,
  _MatCapVSpeed2,
  _MatCapVSpeed3,
  _MatCapVSpeed4,
  _MatCapVSpeed5};

  static float _MatCapColorBurst_A[5] = {
  _MatCapColorBurst,
  _MatCapColorBurst2,
  _MatCapColorBurst3,
  _MatCapColorBurst4,
  _MatCapColorBurst5};
  
  static float _MatCapAlphaBurst_A[5] = {
  	_MatCapAlphaBurst * set(Refract_A, Refract_B),
	_MatCapAlphaBurst2 * set(Refract_A, Refract_B),
	_MatCapAlphaBurst3 * set(Refract_A, Refract_B),
	_MatCapAlphaBurst4 * set(Refract_A, Refract_B),
	_MatCapAlphaBurst5 * set(Refract_A, Refract_B)};

  static float _MatCapBlendMode_A[5] = {
  _MatCapBlendMode,
  _MatCapBlendMode2,
  _MatCapBlendMode3,
  _MatCapBlendMode4,
  _MatCapBlendMode5};
  
#endif