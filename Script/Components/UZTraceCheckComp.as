import GameFiles.UZStaticData;
enum TraceDirection {Up, Down, Forward}
enum TraceOrigin {Enemy, Player}

class UUZTraceCheckComp : UActorComponent
{
    UPROPERTY()
    TraceDirection TraceDirectionType; 

    UPROPERTY()
    TraceOrigin TraceOriginType; 

    FName TagTarget;

    UPROPERTY()
    float TraceDistance = 90.f;

    bool bIsInRangeOfTarget;

    UPROPERTY()
    AActor HitTargetActor;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        switch (TraceOriginType)
        {
            case TraceOrigin::Enemy:
            TagTarget = UZTags::IsTracableByEnemy;
            break;

            case TraceOrigin::Player:
            TagTarget = UZTags::IsTracableByPlayer;
            break;
        }
    }

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
        
        switch (TraceDirectionType)
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
            //if tracable, have found target, else no target found
            if (Hit.Actor.Tags.Contains(TagTarget))
            {
                bIsInRangeOfTarget = true;
                HitTargetActor = Hit.Actor;
            }
            else
            {
                bIsInRangeOfTarget = false;
            }
        }
        else
        {
            bIsInRangeOfTarget = false;
        }
    }
}