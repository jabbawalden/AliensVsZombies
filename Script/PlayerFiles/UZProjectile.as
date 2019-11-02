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
        // HealthCompRef = OtherActor.GetComponent<UUZHealthComp>(HealthCompRef);
        // HealthCompRef = OtherActor.GetComponentByClass(HealthCompRef);

        Print("" + OtherComponent.Name, 5.f); 


        // UUZHealthComp HealthCompRef = Cast<UUZHealthComp>(OtherComponent);

        // if (HealthCompRef != nullptr)
        // {
        //     Print("health comp is here", 5.f);
        // }

    }

}