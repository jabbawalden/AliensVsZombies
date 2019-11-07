import Components.UZObjectRotation;
import PlayerFiles.UZProjectile;
import Components.UZShootComp;
import Components.UZTraceCheckComp;
import GameFiles.UZGameMode;
import Components.UZHealthComp;
import Components.UZMovementComp;
import GameFiles.UZTurretWidget;
import GameFiles.UZStaticData;

class AUZRemoteCannon : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxComp;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);
    default MeshComp.SetCollisionResponseToChannel(ECollisionChannel::ECC_Visibility, ECollisionResponse::ECR_Block);
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
    default TraceCheckComp.TraceDistance = 80.f; 
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

    UPROPERTY()
    float MaxHealth = 200.f;

    int ShootTargetIndex;

    bool bCanShoot = true;

    float DestructionRate = 1.4f;
    float DestructionDamage = 0.22f;
    float NewDestructionTime;

    float TestNumber;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        HealthComp.EventDeath.AddUFunction(this, n"TurretDeath");
        HealthComp.EventUpdateLife.AddUFunction(this, n"UpdateHealth");
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode());

        // Print("Our Test Number is = ", 5.f);

        if (GameMode != nullptr)
        {
            GameMode.EventEndGame.AddUFunction(this, n"EndShoot");
        }

        Tags.Add(UZTags::Turret); 
        Tags.Add(UZTags::IsTraceCompVisible); 

        // Print("" + UZTags::Turret, 5.f);

        RemoteCannonSetup();
        WidgetCompSetup();
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        SetTarget();
        RotateTurret(DeltaSeconds);
        //GradualDestruction();

        if (EnemyArray.Num() > 0 && bCanShoot)
        {
            ShootComp.FireProjectile(ShootOriginArray);
        }

        if (TraceCheckComp.bIsInRangeOfTarget)
        {
            BoxComp.SetSimulatePhysics(false);
        }
    }

    UFUNCTION()
    void RemoteCannonSetup()
    {
        ShootOriginArray.Add(ShootOrigin1);
        ShootOriginArray.Add(ShootOrigin2);
        SphereComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        SphereComp.OnComponentEndOverlap.AddUFunction(this, n"TriggerOnEndOverlap");
        BoxComp.SetSimulatePhysics(true);
    }

    UFUNCTION()
    void WidgetCompSetup()
    {
        TurretWidgetClass = Cast<UUZTurretWidget>(TurretWidget.GetUserWidgetObject());

        if (TurretWidgetClass != nullptr)
        {
            UpdateHealth();
        }
    }

    UFUNCTION()
    void GradualDestruction()
    {
        if (NewDestructionTime <= Gameplay::TimeSeconds)
        {
            HealthComp.CurrentHealth -= DestructionDamage;
            UpdateHealth();
            NewDestructionTime = Gameplay::TimeSeconds + DestructionRate;
        }
    }

    UFUNCTION()
    void UpdateHealth()
    {
        TurretWidgetClass.UpdateLifeBar(HealthComp.GetHealthPercent());
    }

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
        //set target actor to final target again
        for(int i = 0; i < EnemyArray.Num(); i++)
        {
            UUZMovementComp EnemyMoveComp = UUZMovementComp::Get(EnemyArray[i]);
            if (EnemyMoveComp != nullptr)
            {
                EnemyMoveComp.SetTargetToFinal();
            }
        }

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