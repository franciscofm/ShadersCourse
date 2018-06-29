Shader "Custom/Extrusion" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Amount ("Extrusion Amount", Range(-0.03, 0.03)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		CGPROGRAM

		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		float _Amount;

		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v) {
			v.vertex.xyz += v.normal * _Amount;
		}
		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
