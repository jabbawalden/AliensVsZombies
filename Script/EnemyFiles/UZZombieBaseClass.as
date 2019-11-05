import Components.UZHealthComp;
import Components.UZTraceCheckComp;
import Components.UZDealDamage;
import Components.UZMovementComp;
import GameFiles.UZGameMode;

class AUZZombieBaseClass : AActor
{
    AUZGameMode GameMode;

    UPROPERTY(DefaultComponent)
    UUZHealthComp HealthComp;

    UPROPERTY(DefaultComponent)
    UUZTraceCheckComp TraceCheckComp;

    UPROPERTY(DefaultComponent)
    UUZDealDamage DamageComp;

    UPROPERTY(DefaultComponent)
    UUZMovementComp MovementComp;

    UPROPERTY()
    int ResourceAmount = 1;

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
                DamageComp.DealTargetDamage(OtherHealthComp); 
            }
        }
    }
}