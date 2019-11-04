import Components.UZHealthComp;
import Components.UZTraceCheckComp;
import Components.UZDealDamage;
import Components.UZMovementComp;
import GameFiles.UZGameMode;

class AUZZombieBaseClass : AActor
{
    AUZGameMode GameMode;

    UPROPERTY()
    AActor TargetActor;

    UPROPERTY(DefaultComponent)
    UUZHealthComp HealthComp;

    UPROPERTY(DefaultComponent)
    UUZTraceCheckComp TraceCheckComp;

    UPROPERTY(DefaultComponent)
    UUZDealDamage DamageComp;

    UPROPERTY(DefaultComponent)
    UUZMovementComp MovementComp;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {        
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode()); 
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (!TraceCheckComp.bIsInRangeOfTarget)
        {
            MovementComp.MoveAI(DeltaSeconds); 
        }
        else if (TraceCheckComp.bIsInRangeOfTarget)
        {
            AttackBehaviour();
        }
    }

    UFUNCTION()
    void AttackBehaviour()
    {
        if (MovementComp.CurrentTarget != nullptr)
        {
            UUZHealthComp OtherHealthComp = UUZHealthComp::Get(MovementComp.CurrentTarget);

            if (OtherHealthComp != nullptr)
            {
                Print("Detected turret and dealing damage", 0.f);
                DamageComp.DealTargetDamage(OtherHealthComp); 
            }

            if (GameMode != nullptr && !GameMode.bGameEnded)
            {
                DamageComp.DealProtectionPointDamage(GameMode);
            }
        }
    }
}