import WorldFiles.UZProtectionPoint;
import GameFiles.UZGameMode;
import GameFiles.UZStaticData;

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

    UPROPERTY()
    AActor PriorityTarget;

    UPROPERTY()
    float MovementTraceDistance = 200.f; 

    AUZGameMode GameMode;

    TArray<AUZProtectionPoint> ProtectionPointArray;

    float PriorityDistance;
    float PriorityMinDistance = 100.f;

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

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        ForwardCheck();
        CheckPriorityTargetDistance();
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
        FVector RotationDirection; 

        //if priority target exists, send AI there, else move towards as per normal
        if (PriorityTarget != nullptr)
        {
            RotationDirection = PriorityTarget.ActorLocation - Owner.ActorLocation;
            FRotator DesiredRotation = FRotator::MakeFromX(RotationDirection);
            float YawRot = FMath::FInterpTo(Owner.GetActorRotation().Yaw, DesiredRotation.Yaw, DeltaTime, InterpSpeed);
            //FRotator TargetRotation = FRotator(0, YawRot, 0);
            FRotator TargetRotation = FRotator(0, DesiredRotation.Yaw, 0);
            Owner.SetActorRotation(TargetRotation);
        }
        else
        {
            RotationDirection = CurrentTarget.ActorLocation - Owner.ActorLocation;
            FRotator DesiredRotation = FRotator::MakeFromX(RotationDirection);
            float YawRot = FMath::FInterpTo(Owner.GetActorRotation().Yaw, DesiredRotation.Yaw, DeltaTime, InterpSpeed);
            //FRotator TargetRotation = FRotator(0, YawRot, 0);
            FRotator TargetRotation = FRotator(0, DesiredRotation.Yaw, 0);
            Owner.SetActorRotation(TargetRotation);
        }
    }

    UFUNCTION()
    void NullifyPriorityTarget()
    {
        PriorityTarget = nullptr; 
    }

    UFUNCTION()
    float PriorityTargetDistance()
    {
        float Distance = 0.f;

        if (PriorityTarget == nullptr)
        return 0.f;

        Distance = Owner.GetDistanceTo(PriorityTarget); 

        return Distance;
    }

    UFUNCTION()
    void CheckPriorityTargetDistance()
    {
        if (PriorityTarget == nullptr)
        return;

        if (PriorityTargetDistance() <= PriorityMinDistance)
        {
            NullifyPriorityTarget();
            SetTargetToFinal();
        }
    }

    UFUNCTION()
    void ForwardCheck()
    {
        TArray<AActor> IgnoredActors;
		IgnoredActors.Add(Owner);
        FHitResult Hit;
        
		FVector StartLocation = Owner.ActorLocation;
        FVector EndLocation;

        EndLocation = Owner.ActorLocation + (Owner.GetActorForwardVector() * MovementTraceDistance);

        if (System::LineTraceSingle(StartLocation, EndLocation, ETraceTypeQuery::Visibility, true, IgnoredActors, EDrawDebugTrace::None, Hit, true))
        {
            if (Hit.Actor.Tags.Contains(UZTags::Obstacle))
            {
                Print("We found an obstacle", 0.f);
            }

            //if our target, fire out a trace to each location point until one hits - then break out of the for loop
        }
        else
        {

        }
    }

    UFUNCTION()
    void RunPriorityCheck()
    {
        TArray<AActor> IgnoredActors;
		IgnoredActors.Add(Owner);
        FHitResult Hit;
        
		FVector StartLocation = Owner.ActorLocation;
        FVector EndLocation;

        //get direction
        //fire traceline
        //if it hits the scene component, make that priority target
        //else continue firing

        EndLocation = Owner.ActorLocation + (Owner.GetActorUpVector() * MovementTraceDistance);

        if (System::LineTraceSingle(StartLocation, EndLocation, ETraceTypeQuery::Visibility, true, IgnoredActors, EDrawDebugTrace::None, Hit, true))
        {
            Print("" + Hit.Actor.Name, 0.f);
            //if our target, fire out a trace to each location point until one hits - then break out of the for loop
        }
        else
        {

        }
    }
}