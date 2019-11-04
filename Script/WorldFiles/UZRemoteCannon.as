import Components.UZObjectRotation;
import PlayerFiles.UZProjectile;
import Components.UZShootComp;
import Components.UZTraceCheckComp;
import GameFiles.UZGameMode;
import Components.UZHealthComp;
import Components.UZMovementComp;
import GameFiles.UZTurretWidget;

class AUZRemoteCannon : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxComp;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);
    default MeshComp.SetCollisionObjectType(ECollisionChannel::ECC_Vehicle); 

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USphereComponent SphereComp;
    default SphereComp.SphereRadius = 800.f; 
    default SphereComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);
    default SphereComp.SetCollisionResponseToChannel(ECollisionChannel::ECC_Visibility, ECollisionResponse::ECR_Ignore);
    default SphereComp.SetCollisionResponseToChannel(ECollisionChannel::ECC_Camera, ECollisionResponse::ECR_Ignore);
    default SphereComp.SetCollisionObjectType(ECollisionChannel::ECC_Vehicle); 

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USceneComponent ShootOrigin1;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USceneComponent ShootOrigin2;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UWidgetComponent TurretWidget;

    UUZTurretWidget TurretWidgetClass;

    TArray<USceneComponent> ShootOriginArray;

    UPROPERTY(DefaultComponent)
    UUZObjectRotation ObjectRotationComp;

    UPROPERTY(DefaultComponent)
    UUZShootComp ShootComp;

    UPROPERTY(DefaultComponent)
    UUZHealthComp HealthComp;

    FUpdateLife EventUpdateLife;

    UPROPERTY(DefaultComponent)
    UUZTraceCheckComp TraceCheckComp;
    default TraceCheckComp.SlamTraceDistance = 80.f; 
    default TraceCheckComp.traceDirectionType = TraceDirection::Down; 

    UPROPERTY()
    AActor TargetActor;

    UPROPERTY()
    TArray<AActor> EnemyArray;

    AUZProjectile ProjectileCast;

    AUZGameMode GameMode;

    UPROPERTY()
    FRotator LookAtRotation;

    UPROPERTY()
    float InterpSpeed = 2.5f;

    int ShootTargetIndex;

    bool bCanShoot = true;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        HealthComp.EventDeath.AddUFunction(this, n"TurretDeath");

        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode());

        if (GameMode != nullptr)
        {
            GameMode.EventEndGame.AddUFunction(this, n"EndShoot");
        }

        ShootOriginArray.Add(ShootOrigin1);
        ShootOriginArray.Add(ShootOrigin2);
        SphereComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        SphereComp.OnComponentEndOverlap.AddUFunction(this, n"TriggerOnEndOverlap");
        BoxComp.SetSimulatePhysics(true);

        // TurretWidget.

        TurretWidgetClass = Cast<UUZTurretWidget>(TurretWidget); 
        // TurretWidgetClass = UUZTurretWidget::Get(TurretWidget);

        if (TurretWidgetClass != nullptr)
        {
            Print("Turret class found", 5.f);
        }
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        SetTarget();
        RotateTurret(DeltaSeconds);

        Print("" + HealthComp.CurrentHealth, 0.f);

        if (EnemyArray.Num() > 0 && bCanShoot)
        {
            ShootComp.FireProjectile(ShootOriginArray);
        }

        if (TraceCheckComp.bIsInRangeOfTarget)
        {
            BoxComp.SetSimulatePhysics(false);
        }
        else
        {
            Print("Remote Cannon Detecting Ground is: " + TraceCheckComp.bIsInRangeOfTarget, 0.f);
        }
    }

    // UFUNCTION(BlueprintEvent)
    // UWidgetComponent GetWidgetClass()
    // {
    //     throw("You must use override GetWidgetClass from the widget blueprint to return the correct text widget.");
    //     return nullptr;
    // }

    UFUNCTION()
    void RotateTurret(float DeltaTime)
    {
        if (TargetActor != nullptr)
        {
            ObjectRotationComp.SetOwnerRotation(DeltaTime, TargetActor.ActorLocation); 
        }
        else
        {
            ObjectRotationComp.SetOwnerRotation(DeltaTime, FVector(0)); 
        }
    }

    UFUNCTION()
    void SetTarget()
    {
        float ClosestDistance = 15000.f;

        for(int i = 0; i < EnemyArray.Num(); i++)
        {
            float DistanceTo = GetDistanceTo(EnemyArray[i]);

            if(DistanceTo < ClosestDistance)
            {
                ClosestDistance = DistanceTo;
                TargetActor = EnemyArray[i];
            }
        }
    }

    UFUNCTION()
    void EndShoot()
    {
        bCanShoot = false;
    }

    UFUNCTION()
    void TurretDeath()
    {
        DestroyActor();
    }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        if (OtherActor.Tags.Contains(n"Enemy"))
        {
            EnemyArray.Add(OtherActor);

            UUZMovementComp EnemyMoveComp = UUZMovementComp::Get(OtherActor);
            if (EnemyMoveComp != nullptr)
            {
                EnemyMoveComp.CurrentTarget = this; 
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
            EnemyArray.Remove(OtherActor);

            UUZMovementComp EnemyMoveComp = UUZMovementComp::Get(OtherActor);
            if (EnemyMoveComp != nullptr)
            {
                EnemyMoveComp.SetTargetToFinal();
            }
        }
    }
}