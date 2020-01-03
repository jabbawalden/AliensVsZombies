import EnemyFiles.UZZombieBaseClass;

class AUZZombie : AUZZombieBaseClass
{
    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UCapsuleComponent CapsuleComp;
    default CapsuleComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    UPROPERTY(DefaultComponent, Attach = CapsuleComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    FVector CurrentTargetActor;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        ResourceAmount = 2;
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
            ParticleFXRef = SpawnActor(ParticleFX, ActorLocation);

            if (HealthComp.bLaserBeam)
            {
                GameMode.EventEnemyKillFeedback.Broadcast();
                Print("Enemy Died from laser beam", 5.f);
            }
            
            DestroyActor();
        }
    }
}