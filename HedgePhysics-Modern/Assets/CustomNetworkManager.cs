using TMPro;
using UnityEngine.Networking;
using System;
using UnityEngine;

public class CustomNetworkManager : NetworkManager {

    public TMP_InputField IP;
    public TMP_InputField Port;
    private void Start()
    {
        networkPort = 4444;
    }
    public void Connect() {
        networkAddress = IP.text;
        networkPort = Convert.ToInt32(Port.text);
        StartClient();
    }
    public void Host()
    {
        networkAddress = IP.text;
        networkPort = Convert.ToInt32(Port.text);
        StartHost();
    }
    public void Exit() {
        Application.Quit();
    }

}
