//11. LocalWave

//Objetivo: Crear un anillo que escala en tamaño en el tiempo, todos los parametros que sean variables y con coordenadas
//locales

Shader "Custom/LocalWave" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		
		_Center("Wave center", Vector) = (0,0,0,0) //Origen relativo de la onda
		_Range("Wave max range", Float) = 0.5 //Alcance
		_Speed("Wave speed", Float) = 1 //Velocidad
		_Width("Wave width", Float) = 0.1 //Ancho de la onda
		_ColorW("Wave color", Color) = (1,1,0,1) //Color
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
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

		//Practicamente no hay diferencia con el Shader 3.Distance, solo que en vez de posiciones de mundo, en local
		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			//Calculamos la posicion local a partir de la posicion en mundo
			float3 localPos = IN.worldPos - mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz;
			//Calculamos el centro del contorno del anillo, es decir, el aro si el ancho de este fuera casi 0
			float cRange = abs(_Range * sin(_Time*_Speed));

			float d = distance(localPos, _Center);
			//Si la distancia esta entre cRange +- el ancho del anillo, lo dibujamos
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
