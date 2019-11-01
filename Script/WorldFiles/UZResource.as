import GameFiles.UZGameMode;

class AUZResource : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxComp;
    default BoxComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);
    default BoxComp.SetCollisionResponseToChannel(ECollisionChannel::ECC_WorldStatic, ECollisionResponse::ECR_Block);
    default BoxComp.SetCollisionEnabled(ECollisionEnabled::QueryAndPhysics);
    default BoxComp.SetSimulatePhysics(true);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    AUZGameMode GameMode;

    AActor TargetRef;

    float MovementSpeed = 450.f;

    int ResourceAmount = 15;

    bool IsCollecting;

    UPROPERTY()
    float InterpSpeed = 11.5f;

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (IsCollecting)
        {
            if (TargetRef != nullptr)
            {
                Print("TargetActor has been set", 0.f);
                float LocXInterp = FMath::FInterpTo(ActorLocation.X, TargetRef.GetActorLocation().X, DeltaSeconds, InterpSpeed);
                float LocYInterp = FMath::FInterpTo(ActorLocation.Y, TargetRef.GetActorLocation().Y, DeltaSeconds, InterpSpeed);
                FVector NewLoc = FVector(LocXInterp, LocYInterp, ActorLocation.Z + MovementSpeed * DeltaSeconds);

                SetActorLocation(NewLoc);
                BoxComp.SetSimulatePhysics(false);
            }
        }
        else 
        {
            BoxComp.SetSimulatePhysics(true);
        }
    }

    UFUNCTION()
    void SetTargetReference(AActor TargetActor)
    {
        TargetRef = TargetActor;
    }
}