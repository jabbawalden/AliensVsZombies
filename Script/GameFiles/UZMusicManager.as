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

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        //AudioComp1.Play();

    }

}