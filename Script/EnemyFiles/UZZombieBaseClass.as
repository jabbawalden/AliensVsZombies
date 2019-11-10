import Components.UZHealthComp;
import Components.UZTraceCheckComp;
import Components.UZDealDamage;
import Components.UZMovementComp;
import GameFiles.UZGameMode;

class AUZZombieBaseClass : AActor
{
    AUZGameMode GameMode;

    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent)
    UUZHealthComp HealthComp;

    UPROPERTY(DefaultComponent)
    UUZTraceCheckComp TraceCheckComp;

    UPROPERTY(DefaultComponent)
    UUZDealDamage DamageComp;

    UPROPERTY(DefaultComponent)
    UUZMovementComp MovementComp;

    UPROPERTY()
    TSubclassOf<AActor> ParticleFX;
    AActor ParticleFXRef;

    UPROPERTY()
    int ResourceAmount = 1;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {        
        Tags.Add(n"Enemy");
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode()); 
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (!TraceCheckComp.bIsInRangeOfTarget)
        {
            if (MovementComp.bCanMove)
            {
                MovementComp.MoveAI(DeltaSeconds); 
            }

        }
        else if (TraceCheckComp.bIsInRangeOfTarget)
        {
            AttackBehaviour();
        }
    }

    UFUNCTION()
    void AttackBehaviour()
    {
        if (TraceCheckComp.HitTargetActor != nullptr)
        {
            UUZHealthComp OtherHealthComp = UUZHealthComp::Get(TraceCheckComp.HitTargetActor);
            
            if (OtherHealthComp != nullptr)
            {
                DamageComp.DealTargetDamage(OtherHealthComp); 
            }
        }
    }

    UFUNCTION(BlueprintEvent)
    void SpawnEmitterBPEvent()
    {

    }

}