import EnemyFiles.UZZombieBaseClass;

class AUZZombie : AUZZombieBaseClass
{
    UPROPERTY(DefaultComponent, RootComponent)
    UCapsuleComponent CapsuleComp;
    default CapsuleComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    UPROPERTY(DefaultComponent, Attach = CapsuleComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY()
    int ResourceAmount = 3;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        HealthComp.EventDeath.AddUFunction(this, n"ZombieDeathCall");
        Super::BeginPlay(); 
    }

    UFUNCTION(BlueprintOverride)
    void Tick (float DeltaSeconds)
    {
        Super::Tick(DeltaSeconds);
    }

    UFUNCTION()
    void ZombieDeathCall()
    {
        if (GameMode != nullptr)
        {
            GameMode.AddRemoveResources(ResourceAmount);
            DestroyActor();
        }
    }

}