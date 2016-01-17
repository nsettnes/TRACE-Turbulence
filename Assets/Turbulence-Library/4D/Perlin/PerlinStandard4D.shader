Shader "Noise/PerlinStandard4D" 
{
	Properties 
	{
		_Octaves ("Octaves", Float) = 8.0
		_Frequency ("Frequency", Float) = 1.0
		_Amplitude ("Amplitude", Float) = 1.0
		_Lacunarity ("Lacunarity", Float) = 1.92
		_Persistence ("Persistence", Float) = 0.8
		_Offset ("Offset", Vector) = (0.0, 0.0, 0.0, 0.0)
		_Normalize ("Normalize", Range(0, 1)) = 1
		_Transparent ("Transparent", Range(0, 1)) = 0
		_Transparency ("Transparency", Range(0.0, 1.0)) = 1.0
		_Animated ("Animated (3D)", Range(0, 1)) = 0
		_AnimSpeed ("Animation Speed (3D)", Float) = 1.0
		_Displace ("Displace", Range(0, 1)) = 0
		_Height ("Height", Float) = 1.0
		_UseWorld ("Use world position", Range(0, 1)) = 0
		_Turbulence ("Turbulence Texture", 2D) = "black" {}
		_TurbulenceScale ("Turbulence Scale", Float) = 1.0
		_TurbulenceAmount ("Turbulence Amount", Float) = 1.0
		_LowColor("Low Color", Vector) = (0.0, 0.0, 0.0, 1.0)
		_HighColor("High Color", Vector) = (1.0, 1.0, 1.0, 1.0)
		_Texturing("Texturing", Range(0, 1)) = 0
		_LowTexture("Low Texture", 2D) = "" {} 
		_HighTexture("High Texture", 2D) = "" {}
	}

	// Direct3D 11
	SubShader 
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

		Alphatest Greater 0
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		#pragma glsl
		#pragma target 4.0
		#include "../Noise4D.cginc"
		
		fixed _Octaves;
		float _Frequency;
		float _Amplitude;
		float4 _Offset;
		float _Lacunarity;
		float _Persistence;
		fixed _Normalize;
		fixed _Transparent;
		fixed _Transparency;
		fixed _Animated;
		fixed _AnimSpeed;
		fixed _Height;
		fixed _Displace;
		fixed4 _LowColor;
		fixed4 _HighColor;
		fixed _Texturing;
		sampler2D _LowTexture;
		sampler2D _HighTexture;
		fixed _UseWorld;
		sampler2D _Turbulence;
		fixed _TurbulenceAmount;
		fixed _TurbulenceScale;

		struct Input 
		{
			float3 pos;
			float2 uv_LowTexture;
			float2 uv_HighTexture;
			float2 uv_Turbulence;
		};
		
		void vert (inout appdata_full v, out Input OUT)
		{
			UNITY_INITIALIZE_OUTPUT(Input, OUT);
			if(_UseWorld > 0.5)
				OUT.pos = mul (_Object2World, v.vertex).xyz;
			else
				OUT.pos = v.vertex.xyz;
			if(_Displace > 0.5)
			{
				float h = 0.0;
				float t = tex2Dlod(_Turbulence, float4(OUT.uv_Turbulence.xy * _TurbulenceScale, 0.0, 0.0)).a * _TurbulenceAmount;
				if (_Animated < 0.5)
					h = Perlin(float4(OUT.pos.xyz, t), _Octaves, _Offset, _Frequency, _Amplitude, _Lacunarity, _Persistence);
				else
					h = Perlin(float4(OUT.pos.xyz, t + _Time.y * _AnimSpeed), _Octaves, _Offset, _Frequency, _Amplitude, _Lacunarity, _Persistence);
				if (_Normalize > 0.5)
					h = h * 0.5 + 0.5;

				v.vertex.xyz += v.normal * h * _Height;
			}
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			float h = 0.0;
			float t = tex2D(_Turbulence, IN.uv_Turbulence.xy * _TurbulenceScale).a * _TurbulenceAmount;
			if (_Animated < 0.5)
				h = Perlin(float4(IN.pos.xyz, t), _Octaves, _Offset, _Frequency, _Amplitude, _Lacunarity, _Persistence);
			else
				h = Perlin(float4(IN.pos.xyz, t + _Time.y * _AnimSpeed), _Octaves, _Offset, _Frequency, _Amplitude, _Lacunarity, _Persistence);
			if (_Normalize > 0.5)
				h = h * 0.5 + 0.5;
			
			float4 color = float4(0.0, 0.0, 0.0, 0.0);
			float4 lowTexColor = tex2D(_LowTexture, IN.uv_LowTexture);
			float4 highTexColor = tex2D(_HighTexture, IN.uv_HighTexture);

			if(_Texturing > 0.5)
			{
				color = lerp(_LowColor * lowTexColor, _HighColor * highTexColor, h);
			}
			else
			{
				color = lerp(_LowColor, _HighColor, h);
			}

			o.Albedo = color.rgb;
			if (_Transparent > 0.5)
				o.Alpha = h * _Transparency;
			else
				o.Alpha = 1.0;
		}
		ENDCG
	}

	// Direct3D 9
	SubShader 
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

		Alphatest Greater 0
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		#pragma glsl
		#pragma target 3.0
		#include "../Noise4D.cginc"
		
		fixed _Octaves;
		float _Frequency;
		float _Amplitude;
		float4 _Offset;
		float _Lacunarity;
		float _Persistence;
		fixed _Normalize;
		fixed _Transparent;
		fixed _Transparency;
		fixed _Animated;
		fixed _AnimSpeed;
		fixed _Height;
		fixed _Displace;
		fixed _UseWorld;
		fixed4 _LowColor;
		fixed4 _HighColor;
		fixed _Texturing;
		sampler2D _LowTexture;
		sampler2D _HighTexture;
		sampler2D _Turbulence;
		fixed _TurbulenceAmount;
		fixed _TurbulenceScale;

		struct Input 
		{
			float3 pos;
			float2 uv_LowTexture;
			float2 uv_HighTexture;
			float2 uv_Turbulence;
		};
		
		void vert (inout appdata_full v, out Input OUT)
		{
			UNITY_INITIALIZE_OUTPUT(Input, OUT);
			if(_UseWorld > 0.5)
				OUT.pos = mul (_Object2World, v.vertex).xyz;
			else
				OUT.pos = v.vertex.xyz;
			if(_Displace > 0.5)
			{
				float h = 0.0;
				float t = tex2Dlod(_Turbulence, float4(OUT.uv_Turbulence.xy * _TurbulenceScale, 0.0, 0.0)).a * _TurbulenceAmount;
				if (_Animated < 0.5)
					h = Perlin(float4(OUT.pos.xyz, t), _Octaves, _Offset, _Frequency, _Amplitude, _Lacunarity, _Persistence);
				else
					h = Perlin(float4(OUT.pos.xyz, t + _Time.y * _AnimSpeed), _Octaves, _Offset, _Frequency, _Amplitude, _Lacunarity, _Persistence);
				if (_Normalize > 0.5)
					h = h * 0.5 + 0.5;

				v.vertex.xyz += v.normal * h * _Height;
			}
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			float h = 0.0;
			float t = tex2D(_Turbulence, IN.uv_Turbulence.xy * _TurbulenceScale).a * _TurbulenceAmount;
			if (_Animated < 0.5)
				h = Perlin(float4(IN.pos.xyz, t), _Octaves, _Offset, _Frequency, _Amplitude, _Lacunarity, _Persistence);
			else
				h = Perlin(float4(IN.pos.xyz, t + _Time.y * _AnimSpeed), _Octaves, _Offset, _Frequency, _Amplitude, _Lacunarity, _Persistence);
			if (_Normalize > 0.5)
				h = h * 0.5 + 0.5;
			
			float4 color = float4(0.0, 0.0, 0.0, 0.0);
			float4 lowTexColor = tex2D(_LowTexture, IN.uv_LowTexture);
			float4 highTexColor = tex2D(_HighTexture, IN.uv_HighTexture);

			if(_Texturing > 0.5)
			{
				color = lerp(_LowColor * lowTexColor, _HighColor * highTexColor, h);
			}
			else
			{
				color = lerp(_LowColor, _HighColor, h);
			}

			o.Albedo = color.rgb;
			if (_Transparent > 0.5)
				o.Alpha = h * _Transparency;
			else
				o.Alpha = 1.0;
		}
		ENDCG
	}

	FallBack "Diffuse"
}
