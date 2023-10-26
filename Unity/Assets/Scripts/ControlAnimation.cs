using System.Collections;
using System.Collections.Generic;
using Microsoft.MixedReality.Toolkit.UI;
using UnityEngine;

public class ControlAnimation : MonoBehaviour
{

    public Animator myAnimator;
    public AudioSource audioSource;
    private AudioClip audioClip;
    private float clipLength;
    public GameObject dataLogger;

    private AudioSource metronomeSource;
    public AudioClip metronomeClick;
    private LogActions logger;

    private bool animationPlaying = false;
    private AnimatorStateInfo animationState;
    private AnimatorClipInfo myAnimatorClip;

    private float playingPosition = 0.0f;
    private bool invoked = false;
    private int delay = 3;
    
    void Start()
    {
        animationState = myAnimator.GetCurrentAnimatorStateInfo(0);
        myAnimatorClip = myAnimator.GetCurrentAnimatorClipInfo(0)[0];
        myAnimator.speed = 0.0f;

        audioClip = audioSource.clip;
        clipLength = audioSource.clip.length;
        audioSource.Stop();

        GameObject.Find("Avatar").SetActive(false);

        logger = dataLogger.GetComponent<LogActions>();
        metronomeSource = GetComponent<AudioSource>();
    }

    void Update()
    {

    }

    public void PlayPauseAnimation()
    {
        if (animationPlaying)
        {
            audioSource.Pause();

            myAnimator.speed = 0.0f;
            animationPlaying = false;

            logger.writeAction("play, 0");
        } else
        {
            if (!invoked)
            {
                invoked = true;
                audioSource.time = playingPosition * clipLength;

                Invoke("playSound", 3);
                Invoke("playAnimation", 2.8f);
                StartCoroutine(SoundOut());
            }
        }

    }

    void playSound()
    {
        audioSource.Play();  
    }

    void playAnimation()
    {
        myAnimator.Play(animationState.nameHash, -1, playingPosition);
        myAnimator.speed = 1.0f;
        animationPlaying = true;

        logger.writeAction(string.Concat("position, ", playingPosition.ToString()));
        logger.writeAction("play, 1");
        invoked = false;
    }

    IEnumerator SoundOut()
    {
        for (int i = 0; i < delay; i++)
        {
            metronomeSource.PlayOneShot(metronomeClick, 1.0f);
            yield return new WaitForSeconds(1);
        }
    }

    public void SetPlayingPosition(SliderEventData eventData)
    {
        if (audioSource.isPlaying)
        {
            audioSource.Pause();
        }

        myAnimator.speed = 0.0f;
        animationPlaying = false;

        playingPosition = eventData.NewValue;
        audioSource.time = playingPosition * clipLength;
    }
}
