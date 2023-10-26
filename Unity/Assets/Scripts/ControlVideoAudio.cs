using System;
using System.Collections;
using System.Collections.Generic;
using Microsoft.MixedReality.Toolkit.UI;
using UnityEngine;
using UnityEngine.Video;

public class ControlVideoAudio : MonoBehaviour
{
    public GameObject videoPanel;
    public GameObject dataLogger;

    public AudioSource audioSource;
    private AudioClip audioClip;
    private float clipLength;

    public AudioClip metronomeClick;
    private AudioSource metronomeSource;

    private LogActions logger;
    private VideoPlayer videoPlayer;
    private bool videoPlaying = false;
    private float playingPosition = 0.0f;
    private float fps;
    private float videoLength;
    private bool invoked = false;
    private int delay = 3;
    private float sliderValue = 0.0f;

    void Awake()
    {
        videoPanel.SetActive(false);
    }
    
    void Start()
    {
        audioSource.Stop();

        logger = dataLogger.GetComponent<LogActions>();
        videoPlayer = videoPanel.GetComponent<VideoPlayer>();
        fps = videoPlayer.frameRate;
        videoLength = videoPlayer.frameCount;

        clipLength = audioSource.clip.length;

        metronomeSource = GetComponent<AudioSource>();
    }

    void Update()
    {

    }

    public void PlayPauseVideo()
    {
        if (!videoPanel.activeSelf) { videoPanel.SetActive(true); }

        if (videoPlaying)
        {
            audioSource.Pause();

            videoPlayer.Pause();
            videoPlayer.Prepare();
            videoPlaying = false;

            logger.writeAction("play, 0");
        }
        else
        {
            if (!invoked)
            {
                invoked = true;
                audioSource.time = sliderValue * clipLength;
                videoPlayer.frame = Convert.ToInt64(playingPosition);

                Invoke("playSound", 2.2f);
                Invoke("playVideo", 3.2f);
                StartCoroutine(SoundOut());
            }
        }
    }

    void playSound()
    {
        audioSource.Play();
    }

    void playVideo()
    {        
        videoPlayer.Play();
        videoPlaying = true;

        logger.writeAction(string.Concat("position, ", (playingPosition / fps).ToString()));
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
        if (videoPanel.activeSelf)
        {
            if (audioSource.isPlaying)
            {
                audioSource.Pause();
            }

            videoPlayer.Pause();
            videoPlayer.Prepare();
            videoPlaying = false;

            sliderValue = eventData.NewValue;
            playingPosition = eventData.NewValue * videoLength;

            videoPlayer.frame = Convert.ToInt64(playingPosition);
            audioSource.time = sliderValue * clipLength;
        }
    }
}
