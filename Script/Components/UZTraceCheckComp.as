enum TraceDirection {Up, Down, Forward}

class UUZTraceCheckComp : UActorComponent
{
    UPROPERTY()
    TraceDirection traceDirectionType; 

    UPROPERTY()
    float SlamTraceDistance = 90.f;

    bool bIsInRangeOfTarget;

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
        FHitResult Hit;
        
		FVector StartLocation = Owner.ActorLocation;
        FVector EndLocation;
        
        if (traceDirectionType == TraceDirection::Up)
            EndLocation = Owner.ActorLocation + (Owner.GetActorUpVector() * SlamTraceDistance);
        else if (traceDirectionType == TraceDirection::Down)
            EndLocation = Owner.ActorLocation + (Owner.GetActorUpVector() * -SlamTraceDistance);
        else if (traceDirectionType == TraceDirection::Forward)     
            EndLocation = Owner.ActorLocation + (Owner.GetActorForwardVector() * SlamTraceDistance);


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