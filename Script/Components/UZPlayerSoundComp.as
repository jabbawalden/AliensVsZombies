class UUZPlayerSoundComp : UActorComponent
{
    //these may need to be audio components instead

    UPROPERTY()
    USoundCue LaserActivatonSound;
    UPROPERTY()
    USoundCue LaserDeactivateSound;
    
    //these may need to be audio components instead
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
    float FadeInterpSpeed = 12.5f;

    bool bLaserBeamPlay;
    bool bPullBeamPlay;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {

    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {

    }

    UFUNCTION()
    void PlayResourcePickUp()
    {
        Print("Resource Pick Up Sound Played", 5.f);
    }

    UFUNCTION()
    void PlayCitizenPickUpSound()
    {
        Print("Citizen Pick Up Sound Played", 5.f); 
    }

    UFUNCTION()
    void StructureReadyForBuildingNotify()
    {
        Print("Turret or Bomb ready to build", 5.f); 
    }

    //called by player to switch on or off
    UFUNCTION()
    void LaserBeamMode(bool Mode)
    {
        bLaserBeamPlay = Mode;

        if (Mode)
            Gameplay::PlaySound2D(LaserActivatonSound);
        else
            Gameplay::PlaySound2D(LaserDeactivateSound);
    }

    //called by player to switch on or off
    UFUNCTION()
    void PullBeamMode(bool Mode)
    {
        bPullBeamPlay = Mode;

        if (Mode)
            Gameplay::PlaySound2D(PullActivatonSound);
        else
            Gameplay::PlaySound2D(PullDeactivateSound);
    }


}