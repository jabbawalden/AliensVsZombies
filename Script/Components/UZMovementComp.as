import WorldFiles.UZProtectionPoint;
import GameFiles.UZGameMode;

class UUZMovementComp : UActorComponent
{
    float MoveSpeed;
    float DefaultMoveSpeed = 110.f;

    UPROPERTY()
    float InterpSpeed = 2.4f;

    UPROPERTY()
    AActor FinalTarget;

    UPROPERTY()
    AActor CurrentTarget;

    AUZGameMode GameMode;

    TArray<AUZProtectionPoint> ProtectionPointArray;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GameMode); 

        if (GameMode != nullptr)
        {
            DefaultMoveSpeed = GameMode.GlobalMovementSpeed;
            MoveSpeed = DefaultMoveSpeed;
        }

        GetFinalDestinationReferece();
        SetTargetToFinal();
    }

    UFUNCTION()
    void MoveAI(float DeltaTime)
    {
        if (FinalTarget != nullptr)
        {
            SetZombieLocation(DeltaTime);
            SetZombieRotation(DeltaTime);
        }
    }

    UFUNCTION()
    void GetFinalDestinationReferece()
    {
        AUZProtectionPoint::GetAll(ProtectionPointArray);
        FinalTarget = ProtectionPointArray[0]; 
    }

    UFUNCTION()
    void SetTargetToFinal()
    {
        CurrentTarget = FinalTarget; 
    }

    UFUNCTION()
    void SetZombieLocation(float DeltaTime)
    {
        FVector TargetLocation = Owner.GetActorForwardVector() * MoveSpeed * DeltaTime;
        FVector NextLocation = Owner.ActorLocation + TargetLocation;
        Owner.SetActorLocation(NextLocation);
    }

    UFUNCTION()
    void SetZombieRotation(float DeltaTime)
    {
        FVector RotationDirection = CurrentTarget.ActorLocation - Owner.ActorLocation;
        FRotator DesiredRotation = FRotator::MakeFromX(RotationDirection);
        float YawRot = FMath::FInterpTo(Owner.GetActorRotation().Yaw, DesiredRotation.Yaw, DeltaTime, InterpSpeed);
        //FRotator TargetRotation = FRotator(0, YawRot, 0);
        FRotator TargetRotation = FRotator(0, DesiredRotation.Yaw, 0);
        Owner.SetActorRotation(TargetRotation);

    }
}