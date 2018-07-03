using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OscilateProperty : MonoBehaviour {

	public string property;
	public float minValue = 0f;
	public float maxValue = 1f;
	public float speed = 1f;

	Material mat;
	// Use this for initialization
	void Start () {
		mat = GetComponent<MeshRenderer>().material;
	}
	
	// Update is called once per frame
	void Update () {
		mat.SetFloat (property, Mathf.Lerp(minValue,maxValue, Mathf.PingPong (Time.time * speed, 1f)));
	}
}
