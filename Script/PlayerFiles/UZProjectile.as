import Components.UZHealthComp;

class AUZProjectile : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USphereComponent SphereComp;
    default SphereComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);
    default SphereComp.SetCollisionResponseToChannel(ECollisionChannel::ECC_Vehicle, ECollisionResponse::ECR_Ignore); 

    UPROPERTY(DefaultComponent, Attach = SphereComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY()
    FVector ShootDirection;

    UPROPERTY()
    float Damage = 8.f;

    UPROPERTY()
    float MoveSpeed = 2960.f;

    float KillTime = 1.3f;

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

        if (OtherActor.Tags.Contains(n"Enemy"))
        {
            UUZHealthComp HealthComp = UUZHealthComp::Get(OtherActor);

            if (HealthComp == nullptr)
            {
                DestroyActor(); 
            }
            else if (HealthComp.OurHealthType != HealthType::ProtectionPoint)
            {
                HealthComp.DamageHealth(Damage);
                DestroyActor(); 
            }


        }
    }

}