//4. Power

//Objetivo: simular suma de luz ambiente variable y color variable usando potencias

Shader "Custom/Power" {

	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_AmbientColor ("Ambient color", Color) = (1,1,1,1)
		_Power ("Power value", Range(0,10)) = 2.5
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _Color;
		fixed4 _AmbientColor;
		float _Power;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			//Lo unico a destacar es el uso de la funcion pow de las intrinsicas
			fixed4 c = pow((_Color + _AmbientColor), _Power);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	Fallback "Difusse"
}