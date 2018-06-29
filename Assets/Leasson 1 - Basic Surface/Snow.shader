﻿Shader "Custom/Snow" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_MainNormal("Main normal", 2D) = "bump" {}

		[Header(Snow stuff)]
		_SnowColor("Snow color", Color) = (1,1,1,1)
		_SnowTexture("Snow texture", 2D) = "white" {}
		_SnowNormal("Snow normal", 2D) = "bump" {}
		_SnowDirection("Snow direction", Vector) = (0,1,0)
		_SnowLevel("Snow level (inverse)", Range(-1,1)) = 0.5
		_SnowGlossiness ("Snow smoothness", Range(0,1)) = 0.5
		_SnowMetallic ("Snow metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_MainNormal;
			float2 uv_SnowNormal;
			float2 uv_SnowTexture;
			float3 worldNormal;
			INTERNAL_DATA
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		sampler2D _MainNormal;

		sampler2D _SnowTexture;
		sampler2D _SnowNormal;
		fixed4 _SnowColor;
		fixed4 _SnowDirection;
		float _SnowLevel;
		float _SnowGlossiness;
		float _SnowMetallic;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			float3 normals = UnpackNormal(tex2D(_MainNormal, IN.uv_MainNormal));

			fixed4 snowColor = tex2D(_SnowTexture, IN.uv_SnowTexture) * _SnowColor;
			float3 snowNormals = UnpackNormal(tex2D(_SnowNormal, IN.uv_SnowNormal));

			half snowDot = step(_SnowLevel, dot(WorldNormalVector(IN, normals), normalize(_SnowDirection)));

			o.Normal = lerp(normals, snowNormals, snowDot);
			o.Albedo = lerp(c.rgb, snowColor.rgb, snowDot);
			// Metallic and smoothness come from slider variables
			o.Metallic = lerp(_Metallic, _SnowMetallic, snowDot);
			o.Metallic = lerp(_Glossiness, _SnowGlossiness, snowDot);
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
