using System;
using System.Collections;
using System.Collections.Generic;
using Microsoft.MixedReality.Toolkit.UI;
using UnityEngine;
using UnityEngine.Video;

public class ControlVideo : MonoBehaviour
{
    public GameObject videoPanel;
    public GameObject dataLogger;

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

    void Awake()
    {
        videoPanel.SetActive(false);
    }
    
    void Start()
    {
        logger = dataLogger.GetComponent<LogActions>();
        videoPlayer = videoPanel.GetComponent<VideoPlayer>();
        fps = videoPlayer.frameRate;
        videoLength = videoPlayer.frameCount;

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
                videoPlayer.frame = Convert.ToInt64(playingPosition);

                Invoke("playVideo", 3.0f);
                StartCoroutine(SoundOut());
            }
        }
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

            videoPlayer.Pause();
            videoPlayer.Prepare();
            videoPlaying = false;

            playingPosition = eventData.NewValue * videoLength;

            videoPlayer.frame = Convert.ToInt64(playingPosition);
        }
    }
}
