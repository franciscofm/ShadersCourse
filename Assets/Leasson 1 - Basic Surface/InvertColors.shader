// 2.InvertColors

//Objetivo: invertir los colores de un objeto con textura+color

Shader "Custom/InvertColor" {

	//Los shaders pueden depender de valores que se definan fuera de el mismo, esto se realiza mediante
	//el struct/apartado Properties.
	//Como que el tipo de variables primitivas que podemos usar depende del lenguaje, estas seran las de CG/HLSL
	//Pero en este segmento, es lo que se recibe de Unity, entonces es una especie de paso intermedio, con otro tipo
	//de variables:
	//	Range(min, max) - Crea un slider con un float en Inspector (se clampea se se excede en runtime)
	//	Color			- Igual que Vector, pero en el inspector se muestra un ColorPicker
	//	Cube			- Cube map
	//	Float			- Un valor en coma flotante, duh... 
	//	Vector			- Un Vector4 de floats

	//	2D				- Tipo textura
	//	Rect			- Textura pensada para GUI
	Properties {

		//Cuando queremos definir una propiedad se hace tal que:
		// NombreVariable ( "Nombre en inspector", Tipo) = ValorPorDefecto
		//En caso de querer modificar la propiedad desde script, se tiene que hacer referencia
		//con un SetProperty al NombreVariable, y este como string

		//Como que el objetivo es que el material parta de textura y color, añadimos lo necesario:
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		//En el shader 1.AllWhite, haciamos uso de Lambert, ahora del Standard por defecto
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		//Hasta este punto tenemos el apartado Properties con las variables (y valores) que queremos usar,
		//y SubShader, que es donde definimos el comportamiento, lo que necesitamos hacer ahora, es pasar el valor
		//de estas variables al SubShader para que las pueda usar, para hacer esto, lo que debemos hacer es volver
		//a definir las Propiedades que queremos en el subshader, con el mismo NombreVariable y con un tipo de variable,
		//esta vez del lenguaje CG que sea compatible con el previo
		sampler2D _MainTex;
		fixed4 _Color;

		//En el primer shader, debido a que no necesitabamos ningun tipo de informacion de las propiedades, el struct
		//que recibia la funcion Surface podia ir vacio, asi que no importa donde se define o que valores tenga.
		//En este caso, nuestro objetivo es el de invertir los colores de textura+color, por lo que necesitamos
		//informacion de la textura que estamos usando, por lo que el struct que pasemos, se tiene que definir DESPUES
		//de las propiedades que depende, en este caso del _MainTex
		struct Input {
			//Todos los parametros que puede llevar estan explicados en StreamingAssets/Surface.txt
			//El caso de querer coger informacion de una textura es especial, se debe nombrar "uv" seguido del
			//NombreVaraible de la textura que queremos coger de referencia
			float2 uv_MainTex;

			//En esta estructura se pueden declarar variables valores adicionales, esto lo veremos mas adelante
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			//Lo que estamos haciendo en esta linea es: 
			//Coger el pixel al que se corresponde el objeto en la textura "tex2D (_MainTex, IN.uv_MainTex)"
			//Aplicarle el color "* _Color"
			//Calcular el inverso restandole este valor al blanco "(1,1,1) -"

			//Equiscú funciona:
			//En 'IN.uv_MainTex' tenemos un fixed2, en que sus dos valores van de 0.0 a 1.0, este fixed2 representa
			//las coordenadas de la textura que estamos evaluando en este momento, entonces con la funcion lo que hacemos
			//es, coger el color de la textura _MainTex, en la coordenada que toca.
			//Un ejemplo seria:
			//En el output de la posicion 0.5,0.5 en el modelo, asigno el color Blanco menos el valor en la misma posicion
			//de la textura _MainTex multiplicado por el color
			o.Albedo = (1,1,1) - tex2D (_MainTex, IN.uv_MainTex) * _Color;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
