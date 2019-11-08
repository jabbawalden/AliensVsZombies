import WorldFiles.UZProtectionPoint;
import GameFiles.UZGameMode;
import GameFiles.UZStaticData;
import WorldFiles.UZObstacle;

enum MovementState {Forward, Left, Right}

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

    FVector NextPathLocation;

    float MinDistanceToNextLocation = 10.f;

    UPROPERTY()
    AActor PriorityTarget;

    UPROPERTY()
    float MovementTraceDistance = 250.f; 

    AUZGameMode GameMode;

    TArray<AUZProtectionPoint> ProtectionPointArray;

    float PriorityDistance;
    float PriorityMinDistance = 250.f;
    float PriorityActorCheckDistance = 1000000.f;

    bool bCanMove = true;

    // int PathPointIndex = 1;

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

        NextPathLocation = GetNextPathPoint();
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        // ForwardCheck();
        // CheckPriorityTargetDistance();

        if (Owner.LocalRole == ENetRole::ROLE_Authority)
        {
            float DistanceToTarget = (Owner.GetActorLocation() - NextPathPoint).Size();
            //Print("Distance to target = " + DistanceToTarget, 0.f);

            if(DistanceToTarget <= MinDistanceToNextLocation)
            {
                NextPathLocation = GetNextPathPoint();
                // PathPointIndex++;
                //Print("PathPointIndex is selected", 7.f);
                bCanMove = false;
            }
            else 
            {
                bCanMove = true;
            }

            System::DrawDebugArrow(Owner.GetActorLocation(), NextPathPoint, 32.0f, FLinearColor::Red, 1.0f, 2.0f);
        }
    }

    UFUNCTION()
    FVector GetNextPathPoint()
    {
        if(CurrentTarget == nullptr)
        return Owner.GetActorLocation();

        UNavigationPath NavPath = UNavigationSystemV1::FindPathToActorSynchronously(Owner.GetActorLocation(), CurrentTarget, MinDistanceToNextLocation);
            
        if (NavPath != nullptr && NavPath.PathPoints.Num() > 1)
        {
            return NavPath.PathPoints[1];
        }

        return Owner.GetActorLocation();
    }

    UFUNCTION()
    void MoveAI(float DeltaTime)
    {
        if (FinalTarget == nullptr)
        return;

        SetZombieLocation(DeltaTime);
        SetZombieRotation(DeltaTime);

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
        // FVector RotationDirection; 
        FVector RotationDirection = GetNextPathPoint() - Owner.ActorLocation;
        FRotator DesiredRotation = FRotator::MakeFromX(RotationDirection);
        float YawRot = FMath::FInterpTo(Owner.GetActorRotation().Yaw, DesiredRotation.Yaw, DeltaTime, InterpSpeed);
        //FRotator TargetRotation = FRotator(0, YawRot, 0);
        FRotator TargetRotation = FRotator(0, DesiredRotation.Yaw, 0);
        Owner.SetActorRotation(TargetRotation);

        //if priority target exists, send AI there, else move towards as per normal
        // if (PriorityTarget != nullptr)
        // {
        //     RotationDirection = PriorityTarget.ActorLocation - Owner.ActorLocation;
        //     FRotator DesiredRotation = FRotator::MakeFromX(RotationDirection);
        //     float YawRot = FMath::FInterpTo(Owner.GetActorRotation().Yaw, DesiredRotation.Yaw, DeltaTime, InterpSpeed);
        //     //FRotator TargetRotation = FRotator(0, YawRot, 0);
        //     FRotator TargetRotation = FRotator(0, DesiredRotation.Yaw, 0);
        //     Owner.SetActorRotation(TargetRotation);
        // }
        // else
        // {
        //     RotationDirection = CurrentTarget.ActorLocation - Owner.ActorLocation;
        //     FRotator DesiredRotation = FRotator::MakeFromX(RotationDirection);
        //     float YawRot = FMath::FInterpTo(Owner.GetActorRotation().Yaw, DesiredRotation.Yaw, DeltaTime, InterpSpeed);
        //     //FRotator TargetRotation = FRotator(0, YawRot, 0);
        //     FRotator TargetRotation = FRotator(0, DesiredRotation.Yaw, 0);
        //     Owner.SetActorRotation(TargetRotation);
        // }
    }

    // UFUNCTION()
    // void NullifyPriorityTarget()
    // {
    //     PriorityTarget = nullptr; 
    // }

    // UFUNCTION()
    // float PriorityTargetDistance()
    // {
    //     float Distance = 0.f;

    //     if (PriorityTarget == nullptr)
    //     return 0.f;

    //     Distance = Owner.GetDistanceTo(PriorityTarget); 

    //     return Distance;
    // }

    // UFUNCTION()
    // void CheckPriorityTargetDistance()
    // {
    //     if (PriorityTarget == nullptr)
    //     return;

    //     if (PriorityTargetDistance() <= PriorityMinDistance)
    //     {
    //         NullifyPriorityTarget();
    //         SetTargetToFinal();
    //     }
    // }

    // UFUNCTION()
    // void ForwardCheck()
    // {
    //     TArray<AActor> IgnoredActors;
	// 	IgnoredActors.Add(Owner);
    //     FHitResult Hit;
        
	// 	FVector StartLocation = Owner.ActorLocation + FVector(0,0, 50.f);
    //     FVector EndLocation;

    //     EndLocation = Owner.ActorLocation + (Owner.GetActorForwardVector() * MovementTraceDistance);

    //     if (System::LineTraceSingle(StartLocation, EndLocation, ETraceTypeQuery::Visibility, true, IgnoredActors, EDrawDebugTrace::ForDuration, Hit, true))
    //     {
    //         Print("" + Hit.Actor.Name, 0.f);

    //         if (Hit.Actor.Tags.Contains(UZTags::Obstacle))
    //         {
    //             AUZObstacle Obstacle = Cast<AUZObstacle>(Hit.Actor);

    //             if (Obstacle == nullptr)
    //             return;

    //             bCanMoveTest = false;

    //             if (PriorityTarget == nullptr)
    //                 HitObstacleResponse(Obstacle);
    //             else
    //                 Print("Found point to move to", 10.f);
    //         }
    //     }
    //     else
    //     {

    //     }
    // }

    // UFUNCTION()
    // void HitObstacleResponse(AUZObstacle Obstacle)
    // {
    //     for (int i = 0; i < Obstacle.PriorityLocationArray.Num(); i++)
    //     {
    //         RunPriorityCheck(Obstacle.PriorityLocationArray[i].ActorLocation);
    //         Print("running priority check " + i, 0.f);
    //     }
    // }

    // UFUNCTION()
    // void RunPriorityCheck(FVector DestinationLoc)
    // {
    //     Print("" + DestinationLoc, 0.f);
        
    //     TArray<AActor> IgnoredActors;
	// 	IgnoredActors.Add(Owner);
    //     FHitResult Hit;
        
	// 	FVector StartLocation = Owner.ActorLocation;
    //     FVector EndLocation;

    //     EndLocation.Normalize();

    //     EndLocation = DestinationLoc - Owner.ActorLocation * PriorityActorCheckDistance;

    //     if (System::LineTraceSingle(StartLocation, EndLocation, ETraceTypeQuery::Visibility, true, IgnoredActors, EDrawDebugTrace::ForDuration, Hit, true))
    //     {
    //         if (Hit.Actor.Tags.Contains(UZTags::PriorityTarget))
    //         {
    //             Print("We found our priority location", 15.f);
    //             PriorityTarget = Hit.Actor;
    //         }
    //         else 
    //         {
    //             Print("Priority not check found at " +  Hit.Actor.Name, 0.f);
    //         }
    //         //if our target, fire out a trace to each location point until one hits - then break out of the for loop
    //     }
    //     else
    //     {

    //     }
    // }
}