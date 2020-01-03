import Components.UZTraceCheckComp;
import Components.UZMovementComp;
import Components.UZHealthComp;
import Statics.UZStaticData;
import GameFiles.UZGameMode;

class AUZBombTrap : AActor
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
    UBoxComponent BoxCompActivation;
    default BoxCompActivation.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);
    default BoxCompActivation.SetCollisionResponseToChannel(ECollisionChannel::ECC_Visibility, ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent)
    UUZTraceCheckComp TraceComp;

    UPROPERTY()
    TSubclassOf<AActor> BombExplosion;
    AActor BombExplosionRef; 

    bool bHaveActivated;

    AUZGameMode GameMode;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GameMode); 

        BoxCompActivation.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlapSphere");
        BoxComp.SetSimulatePhysics(true);
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (TraceComp.bIsInRangeOfTarget)
        {
            BoxComp.SetSimulatePhysics(false);
        }
    }

    UFUNCTION()
    void ActivateTrap()
    {
        FVector Spawnloc = ActorLocation;
        BombExplosionRef = SpawnActor(BombExplosion, Spawnloc);

        if (GameMode != nullptr)
            GameMode.EventBombTrapExplosionFeedback.Broadcast();

        DestroyActor();
    }


    UFUNCTION()
    void TriggerOnBeginOverlapSphere(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        if (OtherActor.Tags.Contains(UZTags::Enemy))
        {
            ActivateTrap();
        }
    }

}