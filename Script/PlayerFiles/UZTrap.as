import Components.UZMovementComp;

class AUZTrap : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxComp;
    default BoxComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Block);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent TrapAOE;
    default TrapAOE.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Block);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USphereComponent SphereCompActivation;
    default SphereCompActivation.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    TArray<UUZMovementComp> MovementCompArray;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        SphereCompActivation.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlapSphere");
        TrapAOE.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlapTrapAOE");
        TrapAOE.OnComponentEndOverlap.AddUFunction(this, n"TriggerOnEndOverlapTrapAOE");
    }

    UFUNCTION()
    void ActivateTrap()
    {
        for (int i = 0; i < MovementCompArray.Num(); i++)
        {
            MovementCompArray[i].MoveSpeed = 0.f;
        }
        
        System::SetTimer(this, n"DeActivateTrap", 4.f, false);
    }

    UFUNCTION()
    void DeActivateTrap()
    {
        for (int i = 0; i < MovementCompArray.Num(); i++)
        {
            MovementCompArray[i].MoveSpeed = MovementCompArray[i].DefaultMoveSpeed;
        }
        DestroyActor();
    }

    UFUNCTION()
    void TriggerOnBeginOverlapSphere(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        if (OtherActor.Tags.Contains(n"Enemy"))
        {
            ActivateTrap();
        }
    }

    UFUNCTION()
    void TriggerOnBeginOverlapTrapAOE(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        if (OtherActor.Tags.Contains(n"Enemy"))
        {
            UUZMovementComp MovementComp = UUZMovementComp::Get(OtherActor);

            if (MovementComp == nullptr)
            return;

            MovementCompArray.Add(MovementComp);
        }

    }

    UFUNCTION()
    void TriggerOnEndOverlapTrapAOE(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex) 
    {
        if (OtherActor.Tags.Contains(n"Enemy"))
        {
            UUZMovementComp MovementComp = UUZMovementComp::Get(OtherActor);

            if (MovementComp == nullptr)
            return;

            if (MovementCompArray.Contains(MovementComp))
            {
                MovementCompArray.Remove(MovementComp);
            }
        }
    }


}