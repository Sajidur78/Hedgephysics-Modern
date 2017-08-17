using UnityEngine.UI;
using UnityEngine;

public class Action07_Boost : MonoBehaviour {
    PlayerBhysics Player;
    ActionManager Actions;
    Quaternion CharRot;

    public Animator CharacterAnimator;
    public Image BoostBar;
    public float BoostPower;
    public float BoostDecrease;
    public float BoostFill;
    public AudioClip BoostStartClip;
    public ParticleSystem BoostParticle;
    public ParticleSystem BoostScreenParticle;

    void Start () {
        Player = GetComponent<PlayerBhysics>();
        Actions = GetComponent<ActionManager>();
	}
    public void InitialEvents() {
        SonicSoundsControl.Play(BoostStartClip);
        BoostScreenParticle.Play();
    }
	// Update is called once per frame
	void Update () {
        if (Player.Grounded) { CharacterAnimator.SetInteger("Action", 0); }
        CharacterAnimator.SetFloat("YSpeed", Player.rigidbody.velocity.y);
        CharacterAnimator.SetFloat("GroundSpeed", Player.rigidbody.velocity.magnitude);
        CharacterAnimator.SetBool("Grounded", Player.Grounded);

        if (Input.GetButton("A") && Player.Grounded)
        {
            Actions.Action01.InitialEvents();
            Actions.ChangeAction(1);
        }
        //Set Skin Rotation
        if (Player.Grounded)
        {
            Vector3 newForward = Player.rigidbody.velocity - transform.up * Vector3.Dot(Player.rigidbody.velocity, transform.up);

            if (newForward.magnitude < 0.1f)
            {
                newForward = CharacterAnimator.transform.forward;
            }

            CharRot = Quaternion.LookRotation(newForward, transform.up);
            CharacterAnimator.transform.rotation = Quaternion.Lerp(CharacterAnimator.transform.rotation, CharRot, Time.deltaTime * Actions.Action00.skinRotationSpeed);

            // CharRot = Quaternion.LookRotation( Player.rigidbody.velocity, transform.up);
            // CharacterAnimator.transform.rotation = Quaternion.Lerp(CharacterAnimator.transform.rotation, CharRot, Time.deltaTime * skinRotationSpeed);
        }
        else
        {
            Vector3 VelocityMod = new Vector3(Player.rigidbody.velocity.x, 0, Player.rigidbody.velocity.z);
            Quaternion CharRot = Quaternion.LookRotation(VelocityMod, -Player.Gravity.normalized);
            CharacterAnimator.transform.rotation = Quaternion.Lerp(CharacterAnimator.transform.rotation, CharRot, Time.deltaTime * Actions.Action00.skinRotationSpeed);
        }

        Player.AddVelocity(CharacterAnimator.transform.forward * BoostPower);
        BoostBar.fillAmount -= BoostDecrease * Time.deltaTime;
        if (BoostBar.fillAmount <= 0 || Input.GetButtonUp("X") || !Player.Grounded) {
            Actions.ChangeAction(0);
        }
        
	}

    private void OnEnable()
    {
        BoostParticle.Play(true);
    }
    private void OnDisable()
    {
        BoostParticle.Stop(true,ParticleSystemStopBehavior.StopEmitting);
    }
}
