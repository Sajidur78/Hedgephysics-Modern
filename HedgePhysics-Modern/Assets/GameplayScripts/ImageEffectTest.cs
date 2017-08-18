using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ImageEffectTest : MonoBehaviour {
    public Material Mat;
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, Mat);
    }
}
