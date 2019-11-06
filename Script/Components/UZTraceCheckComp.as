enum TraceDirection {Up, Down, Forward}

class UUZTraceCheckComp : UActorComponent
{
    UPROPERTY()
    TraceDirection traceDirectionType; 

    UPROPERTY()
    float TraceDistance = 90.f;

    bool bIsInRangeOfTarget;

    UPROPERTY()
    AActor HitTargetActor;

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
        
        switch (traceDirectionType)
        {
            case TraceDirection::Up:
            EndLocation = Owner.ActorLocation + (Owner.GetActorUpVector() * TraceDistance);
            break;

            case TraceDirection::Down:
            EndLocation = Owner.ActorLocation + (Owner.GetActorUpVector() * -TraceDistance);
            break;

            case TraceDirection::Forward:
            EndLocation = Owner.ActorLocation + (Owner.GetActorForwardVector() * TraceDistance);
            break;
        }

        if (System::LineTraceSingle(StartLocation, EndLocation, ETraceTypeQuery::Visibility, true, IgnoredActors, EDrawDebugTrace::None, Hit, true))
        {
            bIsInRangeOfTarget = true;
            HitTargetActor = Hit.Actor;
            // Print("" + Hit.Actor.Name, 0.f);
        }
        else
        {
            bIsInRangeOfTarget = false;
        }
    }
}