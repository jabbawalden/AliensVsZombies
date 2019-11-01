import WorldFiles.UZProtectionPoint;
import Components.UZHealthComp;
import GameFiles.UZGameMode;
import Components.UZTraceCheckComp;
import Components.UZDealDamage;
import Components.UZMovementComp;

class AUZZombie : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UCapsuleComponent CapsuleComp;
    default CapsuleComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    UPROPERTY(DefaultComponent, Attach = CapsuleComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent)
    UUZHealthComp HealthComp;

    UPROPERTY(DefaultComponent)
    UUZTraceCheckComp TraceCheckComp;

    UPROPERTY(DefaultComponent)
    UUZDealDamage DamageComp;

    UPROPERTY(DefaultComponent)
    UUZMovementComp MovementComp;

    UPROPERTY()
    int ResourceAmount = 3;

    AUZGameMode GameMode;

    UPROPERTY()
    TArray<AUZProtectionPoint> ProtectionPointArray;

    UPROPERTY()
    AActor TargetActor;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        HealthComp.EventEnemyDeath.AddUFunction(this, n"ZombieDeathCall");
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode()); 

        if (MovementComp.CurrentTarget != nullptr)
        {
            TargetActor = MovementComp.CurrentTarget; 
        }
    }

    UFUNCTION(BlueprintOverride)
    void Tick (float DeltaSeconds)
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

    UFUNCTION()
    void ZombieDeathCall()
    {
        if (GameMode != nullptr)
        {
            GameMode.AddRemoveResources(ResourceAmount);
            DestroyActor();
        }
    }

}