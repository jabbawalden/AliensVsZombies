import Components.UZHealthComp;
import Components.UZTraceCheckComp;
import Components.UZDealDamage;
import Components.UZMovementComp;

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

        if (MovementComp.CurrentTarget != nullptr)
        {
            TargetActor = MovementComp.CurrentTarget; 
        }

        Print("Zombie base class detected", 5.f);
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (!TraceCheckComp.bIsInRangeOfTarget)
        {
            MovementComp.MoveAI(DeltaSeconds); 
        }
        else if (GameMode != nullptr && TraceCheckComp.bIsInRangeOfTarget)
        {
            if (!GameMode.bGameEnded)
            {
                DamageComp.DealDamage(GameMode);
            }
        }
    }
}