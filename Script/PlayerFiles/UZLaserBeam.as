import EnemyFiles.UZZombie;
class AUZLaserBeam : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UBoxComponent BoxComp;
    default BoxComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY()
    TArray<AUZZombie> ZombieArray;

    AActor TargetLocation;

    UPROPERTY()
    float Damage = 2.f;

    bool IsActive = true;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        BoxComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        BoxComp.OnComponentEndOverlap.AddUFunction(this, n"TriggerOnEndOverlap");
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (IsActive)
        {
            SetActorLocation(TargetLocation.ActorLocation);
            DamageEnemies();
        }
        else
        {
            DestroyActor();
        }
    }

    UFUNCTION()
    void SetFollowTarget(AActor TargetActor)
    {
        TargetLocation = TargetActor;
    }

    UFUNCTION()
    void DamageEnemies()
    {
        for (int i = 0; i < ZombieArray.Num(); i++)
        {
            ZombieArray[i].HealthComp.DamageHealth(Damage);
        }
    }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        AUZZombie ZombieTarget = Cast<AUZZombie>(OtherActor);

        if (ZombieTarget != nullptr)
        {
            ZombieArray.Add(ZombieTarget);
        }
    }

    UFUNCTION()
    void TriggerOnEndOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex) 
    {
        AUZZombie ZombieTarget = Cast<AUZZombie>(OtherActor);

        if (ZombieTarget != nullptr)
        {
            ZombieArray.Remove(ZombieTarget);
        }
    }

}