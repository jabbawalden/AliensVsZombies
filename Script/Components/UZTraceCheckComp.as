class UUZTraceCheckComp : UActorComponent
{
    UPROPERTY()
    float SlamTraceDistance = 90.f;

    bool bIsInRangeOfTarget;

    UPROPERTY()
    TSubclassOf<AActor> FriendlyZombies;

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        TargetTraceCheck();
    }

    UFUNCTION()
    void TargetTraceCheck()
    {
        TArray<AActor> IgnoredActors;
		IgnoredActors.Add(Owner);
        // IgnoredActors.Add(FriendlyZombies);
        FHitResult Hit;
        
		FVector StartLocation = Owner.ActorLocation;
		FVector EndLocation = Owner.ActorLocation + (Owner.GetActorForwardVector() * SlamTraceDistance);

        if (System::LineTraceSingle(StartLocation, EndLocation, ETraceTypeQuery::Visibility, true, IgnoredActors, EDrawDebugTrace::None, Hit, true))
        {
            bIsInRangeOfTarget = true;
        }
        else
        {
            bIsInRangeOfTarget = false;
        }
    }
}