

class AUZMusicManager : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UAudioComponent AudioComp1;
    default AudioComp1.bAutoActivate = false;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UAudioComponent AudioComp2;
    default AudioComp2.bAutoActivate = false;

    float MinVol = 0.0001f;
    float MaxVol = 1.f;

    float L1Health;
    float L2Health;

    UPROPERTY()
    float FadeTimeInterp = 0.4f;

    bool bLayer1Active;
    bool bLayer2Active;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        L1Health = MinVol;
        L2Health = MinVol;
        AudioComp1.Play();
        AudioComp2.Play();
        FadeLayer(1, true);
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        VolumeHandler(DeltaSeconds);
    }

    UFUNCTION()
    void VolumeHandler(float DeltaTime)
    {
        Print("" + L1Health, 0.f);
        if (bLayer1Active)
            L1Health = FMath::FInterpTo(L1Health, MaxVol, DeltaTime, FadeTimeInterp);
        else
            L1Health = FMath::FInterpTo(L1Health, MinVol, DeltaTime, FadeTimeInterp);
        AudioComp1.VolumeMultiplier = L1Health;

        Print("" + L2Health, 0.f);
        if (bLayer2Active)
            L2Health = FMath::FInterpTo(L2Health, MaxVol, DeltaTime, FadeTimeInterp);
        else
            L2Health = FMath::FInterpTo(L2Health, MinVol, DeltaTime, FadeTimeInterp);
        AudioComp2.VolumeMultiplier = L2Health;
    }

    UFUNCTION()
    void FadeLayer(int LayerIndex, bool IsOn)
    {
        switch(LayerIndex)
        {
            case 1:
                if (IsOn)
                    bLayer1Active = true;
                else
                    bLayer1Active = false;
            break; 

            case 2:
                if (IsOn)
                    bLayer2Active = true;
                else
                    bLayer2Active = false;
            break;
        }
    }

}