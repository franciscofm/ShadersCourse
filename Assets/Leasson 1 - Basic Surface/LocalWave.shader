Shader "Custom/LocalWave" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		_Center("Wave center", Vector) = (0,0,0,0)
		_Range("Wave max range", Float) = 0.5
		_Speed("Wave speed", Float) = 1
		_Width("Wave width", Float) = 0.1
		_ColorW("Wave color", Color) = (1,1,0,1)
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
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		float4 _Center;
		float _Width;
		float _Range;
		float _Speed;
		half4 _ColorW;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};


		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			float3 localPos = IN.worldPos - mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz;
			float cRange = abs(_Range * sin(_Time*_Speed));

			float d = distance(localPos, _Center);
			if(d > (cRange - _Width) && d < (cRange + _Width)) 
				o.Albedo = _ColorW.rgb;
			else
				o.Albedo = c.rgb;
			

			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
