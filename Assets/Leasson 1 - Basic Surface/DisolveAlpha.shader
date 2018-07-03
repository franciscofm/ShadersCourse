//8. DisolveAlpha

//Objetivo: Crear un efecto de desvanecimiento mediante el alpha del Albedo

Shader "Custom/DisolveAlpha" {
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
		//Como hemos dicho en 1.WhiteAll, los tags sirven para darle informacion a Unity
		//En total hay 7:
		//	Queue (Rendering Order)
		//	RenderType
		//	DisableBatching
		//	ForceNoShadowCasting
		//	IgnoreProjector
		//	CanUseSpriteAtlas
		//	PreviewType
		//Nos centraremos en Queue y RenderType, para mas informacion
		//https://docs.unity3d.com/Manual/SL-SubShaderTags.html

		//Queue le dice a Unity cuando toca pintar un objeto en camara, el orden por defecto
		//que tiene Unity es Background -> Geometry -> AlphaTest -> Overlay
		//El valor por defecto de cualquier Shader es Geometry
		//En si mismo, el valor del tag es un entero, que significa un valor de prioridad:
		//"Background is 1000, Geometry is 2000, AlphaTest is 2450, Transparent is 3000 and Overlay is 4000"
		//Se puede asignar un valor arbitrario, a valor mas bajo, antes se pinta, opacas son hasta 2500
		//Teniendo esto en cuenta hace que lo que este en Transparent se pinte, dentro del mismo objeto,
		//de la parte mas alejada de la camara a la mas cercana, haciendo que la superposicion de pixeles
		//sea correcta, en Geometry, no seria necesario pintar la parte alejada, ya que la cercana la taparia,
		//y al ser opaco, no se veria igualmente, lo que supondria una perdida de recursos

		//RenderType
		Tags { "Queue"="Transparent" "RenderType"="Opaque" }
		LOD 200
		CGPROGRAM

		#pragma surface surf Lambert alpha //addshadow 

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
			o.Albedo = c.rgb;
			o.Alpha = 1;
			if(test < 0) {
				o.Alpha = 0;
			} else {
				if(test < _BurnSize && _SliceAmount > 0) {
					fixed4 e = tex2D(_BurnRamp, float2(test * (1/_BurnSize), 0));
					e *= _BurnColor * _EmissionAmount;
					o.Albedo = e;
				}
			}
		}
		ENDCG
	}
	FallBack "Diffuse"
}
