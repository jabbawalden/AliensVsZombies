import EnemyFiles.UZZombieBaseClass;

class AUZLargeZombie : AUZZombieBaseClass
{
    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UBoxComponent BoxComp;
    default BoxComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USceneComponent Spawn1;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USceneComponent Spawn2;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USceneComponent Spawn3;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USceneComponent Spawn4;

    UPROPERTY()
    TSubclassOf<AActor> ZombieClass;
    AActor ZombieRef;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        ResourceAmount = 8.f;

        HealthComp.EventDeath.AddUFunction(this, n"LargeZombieDeathCall");
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode()); 

        Super::BeginPlay();
    }

    UFUNCTION(BlueprintOverride)
    void Tick (float DeltaSeconds)
    {
        Super::Tick(DeltaSeconds);
    }

    UFUNCTION(BlueprintEvent)
    void LargeZombieDeathCall()
    {
        // ERROR - Causing issues with bomb traps - solve later.

        // ZombieRef = SpawnActor(ZombieClass, Spawn1.GetWorldLocation());
        // ZombieRef = SpawnActor(ZombieClass, Spawn2.GetWorldLocation());
        // ZombieRef = SpawnActor(ZombieClass, Spawn3.GetWorldLocation());
        // ZombieRef = SpawnActor(ZombieClass, Spawn4.GetWorldLocation());

        if (GameMode != nullptr)
        {
            GameMode.AddRemoveResources(ResourceAmount);
            // SpawnEmitterBPEvent();
            ParticleFXRef = SpawnActor(ParticleFX, ActorLocation); 
            ParticleFXRef.SetActorScale3D(FVector(2));

            if (HealthComp.bLaserBeam)
            {
                GameMode.EventEnemyKillFeedback.Broadcast();
                Print("Enemy Died from laser beam", 5.f);
            }

            DestroyActor();
        }
    }
}