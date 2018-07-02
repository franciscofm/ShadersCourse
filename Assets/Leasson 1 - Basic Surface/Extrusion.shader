//6. Extrusion

//Objetivo: "adelgazar" o "engordar" un modelo mediante un valor variable

Shader "Custom/Extrusion" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Amount ("Extrusion Amount", Range(-0.03, 0.03)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		CGPROGRAM

		//Esta sera la primera vez que veamos dos funciones en un mismo shader,
		//las funciones adicionales ('vertex:vert' en este caso) se definen despues del sistema de luz
		//las funciones adicionales necesitan la nomenclatura de tipo:nombrefuncion
		//En este caso, el orden de ejecucion sera vertex --> surface --> render
		//Esto nos permite pasar informacion de la funcion 'vert' a la 'surf', cosa que no haremos por el momento
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		float _Amount;

		struct Input {
			float2 uv_MainTex;
		};

		//La funcion vert puede recibir varios tipos de estructuras al igual que la surf:
		//	appdata_base
		//	appdata_tan
		//	appdata_full
		//Se pueden ver las especificaciones de cada estructura en StreamingAssets/Vertex.txt
		void vert (inout appdata_full v) {
			//La funcion vert nos permite modificar los valores asociados a los vertices de un modelo
			//En este caso, cogemos la posicion original del vertice 'v.vertex.xyz'
			//Miramos la normal 'v.normal' aplicandole un multiplicador que es la distancia que lo queremos desplazar '* _Amount'
			//Como que nuestro rango '_Amount' tiene negativos nos permitira "adelgazar la forma"
			v.vertex.xyz += v.normal * _Amount;
		}
		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
