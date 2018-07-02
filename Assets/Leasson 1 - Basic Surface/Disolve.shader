//7. Disolve

//Objetivo: Crear un efecto de desvanecimiento mediante la funcion clip(float)

Shader "Custom/Disolve" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		//Textura guia del desvanecimiento
		_SliceGuide("Slice Guide (RGB)", 2D) = "white" {}
		//Cantidad de devanecimiento en %
		_SliceAmount("Slice Amount", Range(0.0, 1.0)) = 0

		//Añadimos una escala que rodeara los bordes que marcan el desvanecimiento
		_BurnSize("Burn Size", Range(0.0, 1.0)) = 0.15	//Longitud del borde
		_BurnRamp("Burn Ramp (RGB)", 2D) = "white" {}	//Paleta de colores que tendra la escala
		_BurnColor("Burn Color", Color) = (1,1,1,1)		//Color aplicado sobre esta escala
		_EmissionAmount("Emission amount", float) = 2.0 //Emision de luz que tendran los bordes (fuego like)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		Cull Off //if On -> Hides the back of the faces
		CGPROGRAM

		#pragma surface surf Lambert addshadow 
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
			//Cogemos el color de la textura principal
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			//La funcion clip(float) descarta el pixel actual si el valor del parametro que le pasamos
			//es menor que 0, por lo que la guia por si sola, que todos sus pixeles van de 0 a 1, no hara que
			//se descarte ningun pixel, el _SliceAmount es lo que hara que se desvanezca, ya que la suma del
			//valor de la guia mas este, puede dar un rango entre [-1,1], si _SliceAmount vale 1, ira de [-1,0)
			//haciendo que todo se descarte
			half test = tex2D(_SliceGuide, IN.uv_MainTex).rgb - _SliceAmount;
			clip(test);

			//Ahroa solo queda añadir el efecto en los bordes al desvanecer
			//Si tenemos desvanecimiento '_SliceAmount > 0'
			//Y test esta entre 0 y _BurnSize
			if(test < _BurnSize && _SliceAmount > 0) {
				//Cogemos el color de la escala:
				//La escala va de izquierda a derecha, solo nos interesa la X
				//X tiene que ir de 0..1, coordenadas de textura, entonces
				//test es siempre menor que _BurnSize, test/_BurnSize nos dara la coordenada
				fixed4 e = tex2D(_BurnRamp, float2(test * (1/_BurnSize), 0));
				e *= _BurnColor * _EmissionAmount; //Le aplicamos Color + Emission
				o.Emission = e; //Asignamos el valor al output
			}
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
