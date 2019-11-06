import Components.UZTraceCheckComp;
import Components.UZMovementComp;
import Components.UZHealthComp;

class AUZStunTrap : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxComp;
    default BoxComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Block);
    default BoxComp.SetCollisionEnabled(ECollisionEnabled::QueryAndPhysics); 
    default BoxComp.SetCollisionResponseToChannel(ECollisionChannel::ECC_Visibility, ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UBoxComponent TrapAOE;
    default TrapAOE.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Block);
    default TrapAOE.SetCollisionResponseToChannel(ECollisionChannel::ECC_Visibility, ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USphereComponent SphereCompActivation;
    default SphereCompActivation.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);
    default SphereCompActivation.SetCollisionResponseToChannel(ECollisionChannel::ECC_Visibility, ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent)
    UUZTraceCheckComp TraceComp;

    UPROPERTY()
    float StunDamage = 10.f;

    TArray<UUZMovementComp> MovementCompArray;
    TArray<UUZHealthComp> HealthCompArray;

    bool bHaveActivated;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        SphereCompActivation.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlapSphere");
        TrapAOE.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlapTrapAOE");
        TrapAOE.OnComponentEndOverlap.AddUFunction(this, n"TriggerOnEndOverlapTrapAOE");
        BoxComp.SetSimulatePhysics(true);
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (TraceComp.bIsInRangeOfTarget)
        {
            Print("target detected", 0.f);
            BoxComp.SetSimulatePhysics(false);
        }
        else 
        {
            Print("target null", 0.f);
        }
    }

    UFUNCTION()
    void ActivateTrap()
    {
        if (!bHaveActivated)
        {
            bHaveActivated = true;
            
            for (int i = 0; i < MovementCompArray.Num(); i++)
            {
                MovementCompArray[i].MoveSpeed = 0.f;
            }

            for (int i = 0; i < HealthCompArray.Num(); i++)
            {
                HealthCompArray[i].DamageHealth(StunDamage);
            }
   
            System::SetTimer(this, n"DeActivateTrap", 4.f, false);
        }
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
            UUZHealthComp HealthComp = UUZHealthComp::Get(OtherActor);

            if (MovementComp == nullptr)
            return;
            MovementCompArray.Add(MovementComp);

            if (HealthComp == nullptr)
            return;
            HealthCompArray.Add(HealthComp); 
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
            UUZHealthComp HealthComp = UUZHealthComp::Get(OtherActor);

            if (MovementComp == nullptr)
            return;

            if (MovementCompArray.Contains(MovementComp))
            {
                MovementCompArray.Remove(MovementComp);
            }

            if (HealthComp == nullptr)
            return;

            if (HealthCompArray.Contains(HealthComp))
            {
                HealthCompArray.Remove(HealthComp);
            }
        }
    }
}