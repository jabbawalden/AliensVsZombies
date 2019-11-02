import Components.UZHealthComp;

class AUZProjectile : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USphereComponent SphereComp;
    default SphereComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    UPROPERTY(DefaultComponent, Attach = SphereComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY()
    FVector ShootDirection;

    UPROPERTY()
    float Damage = 3.f;

    UPROPERTY()
    float MoveSpeed = 1960.f;

    float KillTime = 2.f;

    float NewTime;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        SphereComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        NewTime = Gameplay::TimeSeconds + KillTime;
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        ProjectileMove(DeltaSeconds);
        if (NewTime <= Gameplay::TimeSeconds)
        {
            DestroyActor();
        }
    }

    UFUNCTION()
    void ProjectileMove(float DeltaTime)
    {
        FVector NextLoc = ActorLocation + ShootDirection * MoveSpeed * DeltaTime;
        SetActorLocation(NextLoc);
    }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        UUZHealthComp HealthComp = UUZHealthComp::Get(OtherActor);

        if (HealthComp != nullptr)
        {
            HealthComp.DamageHealth(Damage);
        }
    }

}