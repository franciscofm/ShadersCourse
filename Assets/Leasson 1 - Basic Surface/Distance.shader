Shader "Custom/Distance" {

	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_ClearCenter("Position", Vector) = (0,0,0,0)
		_ClearRange("Range", Float) = 0.2
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
			float3 worldPos;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float3 _ClearCenter;
		float _ClearRange;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float d = distance(_ClearCenter, IN.worldPos);
			if(d > _ClearRange) {
				// Albedo comes from a texture tinted by color
				fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = c.rgb;
				// Metallic and smoothness come from slider variables
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
				o.Alpha = c.a;
			} else {
				//o.Albedo = fixed4(1,1,1,1) - tex2D (_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = 0;
			}
		}
		ENDCG
	}
	FallBack "Diffuse"
}
