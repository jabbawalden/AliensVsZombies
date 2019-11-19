class UUZObjectRotation : UActorComponent
{
    UPROPERTY()
    float InterpSpeed = 6.9f;

    UPROPERTY()
    float SlerpSpeed = 0.06f;

    UFUNCTION()
    void SetOwnerRotation(float DeltaTime, FVector TargetLocation)
    {
        FVector RotationDirection = TargetLocation - Owner.ActorLocation;
        FRotator DesiredRotation = FRotator::MakeFromX(RotationDirection);
        FRotator FinalRotation = FRotator(0, DesiredRotation.Yaw, 0);
        //float YawRot = FMath::FInterpTo(Owner.GetActorRotation().Yaw, DesiredRotation.Yaw, DeltaTime, InterpSpeed);
        //FRotator TargetRotation = FRotator(0, YawRot, 0); //still issues with 180 degree point

        FQuat NewRotation = FQuat::Slerp(Owner.GetActorRotation().Quaternion(), FinalRotation.Quaternion(), SlerpSpeed);

        Owner.SetActorRotation(NewRotation);
    }
}