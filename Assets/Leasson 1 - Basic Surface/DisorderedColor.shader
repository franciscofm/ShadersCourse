//5. DisorderedColor

//Objetivo: cambiar los canales de color de rgb a brg de un color variable

//Cuando piquemos un shader tenemos que pensar que la estructura 'Vector' no existe en CG
//En su lugar lo que tenemos son 'PackedArrays', estos se diferencian en:
//	Se cogen sus valores accediendo al nombre del campo, como un struct, en vez de posicion
//	Los campos que tiene un PackedArray son x,y,z,w (tambien acepta r,g,b,a)
//	Si se usa la nomenclatura xyzw, no se puede intercalar con rgba, ni viceversa
//	Se puede acceder a campos de forma agrupada y desordenada
//	Se le puede asignar un mismo valor a un grupo de campos

//Ejemplos:
//	Bien
//		fixed4 _MyPacked;
//		_MyPacked = (1,1,1,1)
//		_MyPacked.xyzw = (1,1,1,1)
//		_MyPacked.xy = (1,1)
//		_MyPacked = 1
//		_MyPacked.rb = 1
//		_MyPacked.arbg = _OtherPacked.rgba
//	Mal
//		_MyPacked.xyba
//		_MyPacked.xy = (1,1,1,1)

Shader "Custom/DisorderedColor" {

	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0


		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _Color;
		sampler2D _MainTex;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			//Como hemos visto anteriormente cogemos el color y lo asignamos
			//La unica diferencia es cambiar el orden del '_Color' de rgb a brg:
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex) * _Color.brg;
			o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
