class UUZPlayerSoundComp : UActorComponent
{
    //these may need to be audio components instead
    UPROPERTY()
    USoundCue LaserBeamSound;
    UPROPERTY()
    USoundCue LaserActivatonSound;
    UPROPERTY()
    USoundCue LaserDeactivateSound;
    
    //these may need to be audio components instead
    UPROPERTY()
    USoundCue PullBeamSound;
    UPROPERTY()
    USoundCue PullActivatonSound;
    UPROPERTY()
    USoundCue PullDeactivateSound;

    UPROPERTY()
    USoundCue ResourcePickUpSound;
    
    UPROPERTY()
    USoundCue CitizenPickUpSound;

    float MinVol = 0.0001f;
    float MaxVol = 1.0f;

    float FadeInterpSpeed = 2.5f;

    bool bLaserBeamPlay;
    bool bPullBeamPlay;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {

    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        //VolumeUpdate(DeltaSeconds);
    }

    UFUNCTION()
    void PlayResourcePickUp()
    {

    }

    UFUNCTION()
    void PlayCitizenPickUpSound()
    {

    }

    //called by player to switch on or off
    UFUNCTION()
    void LaserBeamMode(bool Mode)
    {
        bLaserBeamPlay = Mode;
    }

    UFUNCTION()
    void PullBeamMode(bool Mode)
    {
        bPullBeamPlay = Mode;
    }

    UFUNCTION()
    void VolumeUpdate(float DeltaTime)
    {
        if (bLaserBeamPlay)
            LaserBeamSound.VolumeMultiplier = FMath::FInterpTo(LaserBeamSound.VolumeMultiplier, MaxVol, DeltaTime, FadeInterpSpeed);
        else
            LaserBeamSound.VolumeMultiplier = FMath::FInterpTo(LaserBeamSound.VolumeMultiplier, MinVol, DeltaTime, FadeInterpSpeed);  

        if (bPullBeamPlay)
            PullBeamSound.VolumeMultiplier = FMath::FInterpTo(PullBeamSound.VolumeMultiplier, MaxVol, DeltaTime, FadeInterpSpeed);
        else
            PullBeamSound.VolumeMultiplier = FMath::FInterpTo(PullBeamSound.VolumeMultiplier, MinVol, DeltaTime, FadeInterpSpeed);      
    }
}