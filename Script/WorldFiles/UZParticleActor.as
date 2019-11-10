class AUZParticleActor : AActor
{
    UPROPERTY()
    float ParticleTime = 1.f;

    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UParticleSystemComponent ParticleSystem;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        System::SetTimer(this, n"DestroyEmitter", ParticleTime, false);
    }

    UFUNCTION()
    void DestroyEmitter()
    {
        DestroyActor();
    }
}