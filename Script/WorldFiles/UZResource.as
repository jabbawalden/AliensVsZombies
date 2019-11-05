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

    AActor TargetRef;

    float MovementSpeed = 450.f;

    int ResourceAmount = 50;

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
                float LocXInterp = FMath::FInterpTo(ActorLocation.X, TargetRef.GetActorLocation().X, DeltaSeconds, InterpSpeed);
                float LocYInterp = FMath::FInterpTo(ActorLocation.Y, TargetRef.GetActorLocation().Y, DeltaSeconds, InterpSpeed);
                FVector NewLoc = FVector(LocXInterp, LocYInterp, ActorLocation.Z + MovementSpeed * DeltaSeconds);

                SetActorLocation(NewLoc);
            }
        }
    }

    UFUNCTION()
    void SetPhysicsSimulation(bool bValue)
    {
        BoxComp.SetSimulatePhysics(bValue);
    }

    UFUNCTION()
    void SetTargetReference(AActor TargetActor)
    {
        TargetRef = TargetActor;
    }
}