import Components.UZHealthComp;
import GameFiles.UZGameMode;
import Components.UZTraceCheckComp;
import Components.UZDealDamage;
import Components.UZMovementComp;
import EnemyFiles.UZZombieBaseClass;

class AUZZombie : AUZZombieBaseClass
{
    UPROPERTY(DefaultComponent, RootComponent)
    UCapsuleComponent CapsuleComp;
    default CapsuleComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    UPROPERTY(DefaultComponent, Attach = CapsuleComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY()
    int ResourceAmount = 3;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        // HealthComp.EventEnemyDeath.AddUFunction(this, n"EventCheck");
        HealthComp.EventEnemyDeath.AddUFunction(this, n"ZombieDeathCall");
        Super::BeginPlay(); 


    }

    UFUNCTION(BlueprintOverride)
    void Tick (float DeltaSeconds)
    {
        Super::Tick(DeltaSeconds);
    }

    UFUNCTION()
    void EventCheck()
    {
        Print("Calling enemy death", 5.f);
    }

    UFUNCTION()
    void ZombieDeathCall()
    {
        if (GameMode != nullptr)
        {
            Print("Kill zombie", 5.f);
            GameMode.AddRemoveResources(ResourceAmount);
            DestroyActor();
        }
    }

}