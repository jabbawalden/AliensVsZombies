import GameFiles.UZGameMode;

class AUZCitizenPod : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxComp;
    default BoxComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);
    default BoxComp.SetCollisionEnabled(ECollisionEnabled::QueryOnly);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    AActor TargetRef;

    AUZGameMode GameMode;

    float MovementSpeed = 400.f;

    int CitizenAmount;

    int CitizenMinAmount = 15;
    int CitizenMaxAmount = 35;

    bool IsCollecting;

    UPROPERTY()
    float InterpSpeed = 19.5f;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GameMode);
        
        if (GameMode == nullptr)
        return;

        CitizenAmount = FMath::RandRange(CitizenMinAmount, CitizenMaxAmount);

    }

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
    void SetTargetReference(AActor TargetActor)
    {
        TargetRef = TargetActor;
    }
}