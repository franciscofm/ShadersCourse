//9. MovingTexture

//Objetivo: Desplazar las coordenadas de la textura en funcion de velocidades variables

Shader "Custom/MovingTexture" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		//Las velocidades en las dos coordenadas que usaremos
		_SpeedX ("Speed X", Float) = 2
		_SpeedY ("Speed Y", Float) = 2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		half _SpeedX;
		half _SpeedY;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			//Creamos un vector que incrementa en funcion del tiempo
			float2 movedUV = _Time * float2(_SpeedX, _SpeedY);
			//Le añadimos el offset de la textura original y aplicamos la textura
			movedUV += IN.uv_MainTex;
			fixed4 c = tex2D (_MainTex, movedUV) * _Color;
			//Este shader funciona debido a que automaticamente las coordenadas se modulan en
			//el rango de 0..1f

			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
