import WorldFiles.UZProtectionPoint;

class UUZMovementComp : UActorComponent
{
    UPROPERTY()
    float MoveSpeed;

    UPROPERTY()
    float DefaultMoveSpeed = 110.f;

    UPROPERTY()
    float InterpSpeed = 2.4f;

    UPROPERTY()
    AActor FinalTarget;

    UPROPERTY()
    AActor CurrentTarget;

    TArray<AUZProtectionPoint> ProtectionPointArray;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        MoveSpeed = DefaultMoveSpeed;
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