import EnemyFiles.UZZombie;
import Components.UZHealthComp;
import GameFiles.UZGameMode;

enum UpgradeType {MultiSpin, MassSuction, AfterBurn, Alliance}

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

    AUZGameMode GameMode;

    UPROPERTY()
    float Damage = 16.5f;

    UPROPERTY()
    float DamageRate = 0.07f;

    float NewDamageTime;

    bool bHasUpgrade;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GameMode);

        BoxComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        BoxComp.OnComponentEndOverlap.AddUFunction(this, n"TriggerOnEndOverlap");
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (NewDamageTime <= Gameplay::TimeSeconds)
        {
            NewDamageTime = Gameplay::TimeSeconds + DamageRate;
            DamageEnemies();
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
                HealthComp.bLaserBeam = true;
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
                HealthComp.bLaserBeam = false;
                ZombieArray.Remove(HealthComp);

            }
        }

    }

}