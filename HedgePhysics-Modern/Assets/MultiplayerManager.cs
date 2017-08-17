using UnityEngine.Networking;
using UnityEngine;

public class MultiplayerManager : NetworkBehaviour {

    public GameObject PlayerSonic;
    public GameObject SonicSkin;
    public GameObject[] UiStuff;


	void Start () {
        if (!isLocalPlayer)
        {
            MonoBehaviour[] PlayerScripts = PlayerSonic.GetComponents<MonoBehaviour>();
            MonoBehaviour[] SkinScripts = SonicSkin.GetComponents<MonoBehaviour>();
            foreach (var script in PlayerScripts)
            {
                script.enabled = false;
            }
            foreach (var script in SkinScripts)
            {
                script.enabled = false;
            }
            foreach (var ui in UiStuff)
            {
                ui.SetActive(false);
            }
        }
	}
}
