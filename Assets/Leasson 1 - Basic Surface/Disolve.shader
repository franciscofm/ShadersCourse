Shader "Custom/Disolve" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SliceGuide("Slice Guide (RGB)", 2D) = "white" {}
		_SliceAmount("Slice Amount", Range(0.0, 1.0)) = 0

		_BurnSize("Burn Size", Range(0.0, 1.0)) = 0.15
		_BurnRamp("Burn Ramp (RGB)", 2D) = "white" {}
		_BurnColor("Burn Color", Color) = (1,1,1,1)

		_EmissionAmount("Emission amount", float) = 2.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		Cull Off //if On -> Hides the back of the faces
		CGPROGRAM

		#pragma surface surf Lambert addshadow //Standard (not Lambert) would draw the whole shadow always

		#pragma target 3.0

		fixed4 _Color;
		fixed4 _BurnColor;
		sampler2D _MainTex;
		sampler2D _SliceGuide;

		sampler2D _BurnRamp;
		float _BurnSize;
		float _SliceAmount;
		float _EmissionAmount;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			//Get normal texture
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			half test = tex2D(_SliceGuide, IN.uv_MainTex).rgb - _SliceAmount;
			clip(test);

			if(test < _BurnSize && _SliceAmount > 0) {
				fixed4 e = tex2D(_BurnRamp, float2(test * (1/_BurnSize), 0));
				e *= _BurnColor * _EmissionAmount;
				o.Emission = e;
			}
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			//o.Alpha = 0.5;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
