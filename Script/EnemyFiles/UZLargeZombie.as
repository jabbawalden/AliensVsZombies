import Components.UZHealthComp;
import Components.UZTraceCheckComp;
import Components.UZDealDamage;
import Components.UZMovementComp;
import GameFiles.UZGameMode;
import EnemyFiles.UZZombieBaseClass;

class AUZLargeZombie : AUZZombieBaseClass
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxComp;
    default BoxComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USceneComponent Spawn1;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USceneComponent Spawn2;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USceneComponent Spawn3;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USceneComponent Spawn4;

    UPROPERTY()
    TSubclassOf<AActor> ZombieClass;
    AActor ZombieRef;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        HealthComp.EventEnemyDeath.AddUFunction(this, n"LargeZombieDeathCall");
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode()); 

        Super::BeginPlay();

        if (MovementComp.CurrentTarget != nullptr)
        {
            TargetActor = MovementComp.CurrentTarget; 
        }
    }

    UFUNCTION(BlueprintOverride)
    void Tick (float DeltaSeconds)
    {
        Super::Tick(DeltaSeconds);
    }

    UFUNCTION()
    void LargeZombieDeathCall()
    {
        ZombieRef = SpawnActor(ZombieClass, Spawn1.GetWorldLocation());
        ZombieRef = SpawnActor(ZombieClass, Spawn2.GetWorldLocation());
        ZombieRef = SpawnActor(ZombieClass, Spawn3.GetWorldLocation());
        ZombieRef = SpawnActor(ZombieClass, Spawn4.GetWorldLocation());

        DestroyActor();
    }
}