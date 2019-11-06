import EnemyFiles.UZZombie;
import Components.UZHealthComp;

class AUZLaserBeam : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UBoxComponent BoxComp;
    default BoxComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);
    default BoxComp.SetCollisionResponseToChannel(ECollisionChannel::ECC_Vehicle, ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UStaticMeshComponent MeshComp2;
    default MeshComp2.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY()
    TArray<UUZHealthComp> ZombieArray;

    AActor TargetLocation;

    UPROPERTY()
    float Damage = 9.5f;

    float NewDamageTime;
    float DamageRate = 0.06f;

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
            if (NewDamageTime <= Gameplay::TimeSeconds)
            {
                NewDamageTime = Gameplay::TimeSeconds + DamageRate;
                DamageEnemies();
            }
        }
        else
        {
            DestroyActor();
        }
    }

    UFUNCTION()
    void SetFollowTarget(AActor TargetActor)
    {
        AttachToActor(TargetActor);
    }

    UFUNCTION()
    void DamageEnemies()
    {
        for (int i = 0; i < ZombieArray.Num(); i++)
        {
            ZombieArray[i].DamageHealth(Damage);
        }
    }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        if (OtherActor.Tags.Contains(n"Enemy"))
        {
            UUZHealthComp HealthComp = UUZHealthComp::Get(OtherActor);

            if (HealthComp != nullptr)
            {
                ZombieArray.Add(HealthComp);
            }
        }
    }

    UFUNCTION()
    void TriggerOnEndOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex) 
    {
        if (OtherActor.Tags.Contains(n"Enemy"))
        {
            UUZHealthComp HealthComp = UUZHealthComp::Get(OtherActor);

            if (HealthComp != nullptr)
            {
                ZombieArray.Remove(HealthComp);
            }
        }

    }

}