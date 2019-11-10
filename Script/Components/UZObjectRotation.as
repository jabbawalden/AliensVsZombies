class UUZObjectRotation : UActorComponent
{
    UPROPERTY()
    float InterpSpeed = 6.9f;

    UFUNCTION()
    void SetOwnerRotation(float DeltaTime, FVector TargetLocation)
    {
        FVector RotationDirection = TargetLocation - Owner.ActorLocation;
        FRotator DesiredRotation = FRotator::MakeFromX(RotationDirection);
        float YawRot = FMath::FInterpTo(Owner.GetActorRotation().Yaw, DesiredRotation.Yaw, DeltaTime, InterpSpeed);
        FRotator TargetRotation = FRotator(0, YawRot, 0); //still issues with 180 degree point
        Owner.SetActorRotation(TargetRotation);
    }
}