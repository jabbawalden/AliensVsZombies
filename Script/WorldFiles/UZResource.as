import GameFiles.UZGameMode;

class AUZResource : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USphereComponent SphereComp;
    default SphereComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);
    default SphereComp.SetCollisionResponseToChannel(ECollisionChannel::ECC_WorldStatic, ECollisionResponse::ECR_Block);
    default SphereComp.SetCollisionEnabled(ECollisionEnabled::QueryAndPhysics);
    default SphereComp.SetSimulatePhysics(true);

    UPROPERTY(DefaultComponent, Attach = SphereComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    AUZGameMode GameMode;

    AActor TargetRef;

    float MovementSpeed = 450.f;

    int ResourceAmount = 15;

    bool IsCollecting;

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (IsCollecting)
        {
            if (TargetRef != nullptr)
            {
                Print("TargetActor has been set", 0.f);
                FVector NewLoc = FVector(TargetRef.GetActorLocation().X, TargetRef.GetActorLocation().Y, ActorLocation.Z + MovementSpeed * DeltaSeconds);
                SetActorLocation(NewLoc);
                SphereComp.SetSimulatePhysics(false);
            }
        }
        else 
        {
            SphereComp.SetSimulatePhysics(true);
        }

        // if (TargetRef != nullptr)
        // {
        //     Print("Target ref here", 0.f);
        // }
        // else 
        // {
        //     Print("Target ref NULL", 0.f);
        // }
    }

    UFUNCTION()
    void SetTargetReference(AActor TargetActor)
    {
        TargetRef = TargetActor;
    }
}