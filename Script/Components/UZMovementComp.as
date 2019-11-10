import WorldFiles.UZProtectionPoint;
import GameFiles.UZGameMode;
import Statics.UZStaticData;
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


    TArray<AActor> TargetArray;

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
        TargetSelectionCheckAndSet();

        if (Owner.LocalRole == ENetRole::ROLE_Authority)
        {
            float DistanceToTarget = (Owner.GetActorLocation() - NextPathPoint).Size();

            if(DistanceToTarget <= MinDistanceToNextLocation)
            {
                NextPathLocation = GetNextPathPoint();
                bCanMove = false;
            }
            else 
            {
                bCanMove = true;
            }
            //System::DrawDebugArrow(Owner.GetActorLocation(), NextPathPoint, 32.0f, FLinearColor::Red, 1.0f, 2.0f);
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
    void TargetSelectionCheckAndSet()
    {
        if (TargetArray.Num() > 0)
        {
            float ShortestDistance = 450000;
            int TargetIndex;

            for (int i = 0; i < TargetArray.Num(); i++)
            {
                float DistanceCheck = (Owner.ActorLocation - TargetArray[i].ActorLocation).Size();

                if (DistanceCheck < ShortestDistance)
                {
                    ShortestDistance = DistanceCheck;
                    TargetIndex = i;
                }
            }

            CurrentTarget = TargetArray[TargetIndex];
        }
        else
        {
            SetTargetToFinal();
        }
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
        FVector RotationDirection = GetNextPathPoint() - Owner.ActorLocation;
        FRotator DesiredRotation = FRotator::MakeFromX(RotationDirection);
        float YawRot = FMath::FInterpTo(Owner.GetActorRotation().Yaw, DesiredRotation.Yaw, DeltaTime, InterpSpeed);
        //FRotator TargetRotation = FRotator(0, YawRot, 0);
        FRotator TargetRotation = FRotator(0, DesiredRotation.Yaw, 0);
        Owner.SetActorRotation(TargetRotation);
    }

}