// 1.AllWhite

//Objetivo: pintar un objeto de blanco

//Esta cabecera 'Shader' sirve para marcar el principio de un shader, como una clase
//El texto '"Custom/All White"' sirve para darle un nombre a este shader, si hay dos
//shaders con el mismo nombre, Unity no se quejara, y los materiales que usen este
//identificador de shader en un material, usaran el que se haya creado primero
Shader "Custom/All White" {

	//Un shader se puede componer de varios subshaders, por el momento trabajaremos con
	//uno solo, necesitamos definir uno por lo menos
	//Lo que hay dentro del tag SubShader se encarga de definir el comportamiento del 
	//shader sobre el material
	SubShader {
		//Dentro de un SubShader encontraremos varios elementos:
		//		- Tags: sirven para decirle a unity como tratar varios comportamientos
		//		- pragmas e includes: definen que acciones haremos posteriomente y metodos a los que poder acceder
		//		- variables/propiedades: variables que recogen su valor desde fuera del material (scripts externos,
		//		  Inspector, etc...)
		//		- structs: informacion que recogemos del modelo/texturas/mundo
		//		- metodos: tratan la informacion de los structs y modifican la apariencia del material del shader

		//En este caso explicaremos: pragmas, structs y metodos

		//Tags...
		Tags { "RenderType" = "Opaque" }

		//pragmas/includes...
		CGPROGRAM
		//El pragma definira 2 cosas:
		//	- que tipo de shader estamos escribiendo (surface | vertex | fragment)
		//	- que metodo se tiene que llamar (surf [por convencion: surf|vert|frag])
		//	- que sistema de luz usaremos (Lambert | Standard)
		//Se pueden definir otros muchos parametros que iremos viendo con el resto de ejemplos
		#pragma surface surf Lambert

		//Un surface shader se evalua en cada pixel de la textura, ergo, tenemos informacion asociada a este
		//el nombre del struct debe coincidir con el de la funcion que aplicamos (surf en este caso)
		//los structs no pueden ser vacios, asi que "pedimos" que tenga un parametro aunque no lo usemos
		struct Input {
			float2 uv_MainTex;
		};

		//La nomenclatura de las funciones viene predefinido, se tiene que entender como una funcion que se asigna
		//a un evento, por lo que deben coincidir los parametros con los de este, en un SurfaceShader, el primer 
		//parametros de la funcion es el struct que recibe, y, como segundo parametro, se aceptan tres objetos, con
		//diferente informacion asociada:
		//	- SurfaceOutput
		//	- SurfaceOutputStandard
		//	- SurfaceOutputStandardSpecular
		//Que parametros contiene cada uno de los structs en StreamingAssets/Surface.txt
		void surf (Input IN, inout SurfaceOutput o) {
			//Ya que lo que queremos hacer es pintar el objeto entero de blanco, IN no nos interesa,
			//"o" representa el pixel final de la textura, entonces lo que debemos hacer es cambiar el color
			//del pixel (Albedo) a blanco:
			o.Albedo = (1,1,1);
		}
		ENDCG
	}
	//Fallback -> si el dispositivo no es capaz de usar el shader, que shader puede usar en sustitucion
	Fallback "Difusse"
}