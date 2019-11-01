class AUZCameraActor : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USpringArmComponent SpringArm;
    default SpringArm.TargetArmLength = 1700.f;

    UPROPERTY(DefaultComponent, Attach = SpringArm)
    UCameraComponent CameraComp;

    UPROPERTY()
    AActor PlayerRef;

    UPROPERTY()
    float InterpSpeed = 1.5f;

    UPROPERTY()
    float ZOffset = -14450.f;
    
    UPROPERTY()
    float XOffset = -134250.f;

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        SetCameraLocation(DeltaSeconds); 
    }

    UFUNCTION()
    void SetCameraLocation(float DeltaTime)
    {
        //but keep closer to the middle - reference the cube runner
        FVector TargetLocation = FVector(PlayerRef.ActorLocation.X / 2.f, PlayerRef.ActorLocation.Y / 2.f, PlayerRef.ActorLocation.Z);

        float XInterp = FMath::FInterpTo(TargetLocation.X, ActorLocation.X, DeltaTime, InterpSpeed);
        float YInterp = FMath::FInterpTo(TargetLocation.Y, ActorLocation.Y, DeltaTime, InterpSpeed);
        float ZInterp = FMath::FInterpTo(TargetLocation.Z, ActorLocation.Z, DeltaTime, InterpSpeed);

        FVector FinalLocation = FVector(XInterp, YInterp, ZInterp);
        SetActorLocation(TargetLocation);
    }

    //called by player once target view is set
    UFUNCTION()
    void GetPlayerReference(AActor ChosenActor)
    {
        PlayerRef = ChosenActor;
    }   

}