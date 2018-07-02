//3.Distance

//Objetivo: lo que se encuentre a una distancia variable de una localizacion de mundo, debe pintarse de negro
//el resto debe pintarse de un color variable
//Entenderemos a partir de ahora que cuando se hable de un parametro variable, nos referiremos a uno que puede modificarse
//mediante el Inspector o bien desde un script en runtime

Shader "Custom/Distance" {

	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		
		//La posicion desde la que calcularemos el centro
		_ClearCenter("Position", Vector) = (0,0,0,0)
		//El rango del area que pintaremos de negro
		_ClearRange("Range", Float) = 0.2
	}

	SubShader {
		Tags { "RenderType"="Opaque" }

		//LOD (Level of Detail) define que shaders se computaran
		//Por defecto su valor es infinito, haciendo que todos se computen, al añadir esta linea, definimos el
		//LOD individual del shader, si su valor esta por encima del general, no se computara, esto se hace por
		//temas de rendimiento que no trataremos por ahora (https://docs.unity3d.com/Manual/SL-ShaderLOD.html)
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float3 _ClearCenter;
		float _ClearRange;

		//Como que queremos saber a que distancia esta cada pixel del centro,
		//pedimos que el input contenga 'float3 worldPos;'
		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			//CG/HLSL tiene muchas funciones intrinsicas que podremos usar
			//(https://msdn.microsoft.com/es-es/library/windows/desktop/ff471376(v=vs.85).aspx)

			//En este caso nos interesa el calculo de la distancia,
			//queremos saber cuanta hay del '_ClearCenter' al pixel:
			float d = distance(_ClearCenter, IN.worldPos);

			//Si estamos fuera de rango, pintamos del color '_Color'
			if(d > _ClearRange) {
				// Albedo comes from a texture tinted by color
				fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = c.rgb;

				// Metallic and smoothness come from slider variables
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
				o.Alpha = c.a;
				
			//Si no, pintamos de negro
			} else {
				o.Albedo = 0;
			}
		}
		ENDCG
	}
	FallBack "Diffuse"
}
