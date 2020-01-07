import GameFiles.UZGameMode;

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

    AUZGameMode GameMode;

    UPROPERTY()
    float InterpSpeed = 1.5f;

    UPROPERTY()
    float CamShakeInterpSpeed = 2.3f;

    UPROPERTY()
    float ZOffset = -14450.f;
    
    UPROPERTY()
    float XOffset = -134250.f;

    UPROPERTY()
    float LocationFollowMultiplier = 0.75f;

    bool bCanCameraShake;
    float CurrentShakeMagnitude;

    float BombExplosionMagnitude = 370.f;
    float TurretExplosionMagnitude = 550.f;
    float BombExplosionTime = 0.5f;
    float TurretExplosionTime = 0.9f;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GameMode);

        if (GameMode == nullptr)
        return;

        GameMode.EventBombTrapExplosionFeedback.AddUFunction(this, n"CamBombExplosionFeedback");        
        GameMode.EventTurretExplosionFeedback.AddUFunction(this, n"CamTurretExplosionFeedback");

        //TurnCamShakeOn(ShakeMagnitude, ShakeTime); 
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        SetCameraLocation(DeltaSeconds); 

        if (bCanCameraShake)
        {
            CameraShake(DeltaSeconds);
        }
    }

    UFUNCTION()
    void SetCameraLocation(float DeltaTime)
    {
        //but keep closer to the middle - reference the cube runner
        FVector TargetLocation = FVector(PlayerRef.ActorLocation.X * LocationFollowMultiplier, PlayerRef.ActorLocation.Y * LocationFollowMultiplier, PlayerRef.ActorLocation.Z);

        float XInterp = FMath::FInterpTo(TargetLocation.X, ActorLocation.X, DeltaTime, InterpSpeed);
        float YInterp = FMath::FInterpTo(TargetLocation.Y, ActorLocation.Y, DeltaTime, InterpSpeed);
        float ZInterp = FMath::FInterpTo(TargetLocation.Z, ActorLocation.Z, DeltaTime, InterpSpeed);

        FVector FinalLocation = FVector(XInterp, YInterp, ZInterp);
        SetActorLocation(TargetLocation + FVector(-500.f,0.f,0.f));
    }

    UFUNCTION()
    void CameraShake(float DeltaTime)
    {
        float rX = FMath::RandRange(-CurrentShakeMagnitude, CurrentShakeMagnitude);
        float rY = FMath::RandRange(-CurrentShakeMagnitude, CurrentShakeMagnitude);
        float rZ = FMath::RandRange(-CurrentShakeMagnitude, CurrentShakeMagnitude);

        float XInterp = FMath::FInterpTo(CameraComp.RelativeLocation.X, rX, DeltaTime, CamShakeInterpSpeed);
        float YInterp = FMath::FInterpTo(CameraComp.RelativeLocation.Y, rY, DeltaTime, CamShakeInterpSpeed);
        float ZInterp = FMath::FInterpTo(CameraComp.RelativeLocation.Z, rZ, DeltaTime, CamShakeInterpSpeed);

        FVector NewRelativeLocation = FVector(XInterp, YInterp, ZInterp);
        CameraComp.SetRelativeLocation(NewRelativeLocation); 

        CurrentShakeMagnitude *= 0.993f;
    }

    UFUNCTION()
    void TurnCamShakeOn(float TargetMagnitude, float ShakeTime)
    {
        CurrentShakeMagnitude = TargetMagnitude;
        bCanCameraShake = true;
        System::SetTimer(this, n"TurnCamShakeOff", ShakeTime, false); 
    }

    UFUNCTION()
    void TurnCamShakeOff()
    {
        bCanCameraShake = false;
        CameraComp.SetRelativeLocation(FVector(0));
    }

    UFUNCTION()
    void CamTurretExplosionFeedback()
    {
        TurnCamShakeOn(TurretExplosionMagnitude, TurretExplosionTime);
    }

    UFUNCTION()
    void CamBombExplosionFeedback()
    {
        TurnCamShakeOn(BombExplosionMagnitude, BombExplosionTime);
    }

    //called by player once target view is set
    UFUNCTION()
    void GetPlayerReference(AActor ChosenActor)
    {
        PlayerRef = ChosenActor;
    }   



}