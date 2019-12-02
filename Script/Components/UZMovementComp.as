import WorldFiles.UZProtectionPoint;
import GameFiles.UZGameMode;
import Statics.UZStaticData;
import WorldFiles.UZObstacle;

enum MovementState {Forward, Left, Right}

class UUZMovementComp : UActorComponent
{
    UPROPERTY()
    float SlerpSpeed = 0.04f;

    UPROPERTY()
    AActor FinalTarget;

    UPROPERTY()
    AActor CurrentTarget;

    AUZGameMode GameMode;

    TArray<AUZProtectionPoint> ProtectionPointArray;

    FVector NextPathLocation;

    float MoveSpeed;

    float DefaultMoveSpeed = 110.f;

    UPROPERTY()
    float InterpSpeed = 2.4f;

    float MinDistanceToNextLocation = 10.f;

    UPROPERTY()
    float MovementTraceDistance = 250.f; 

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
        FRotator FinalRotation = FRotator(0, DesiredRotation.Yaw, 0);
        FQuat NewRotation = FQuat::Slerp(Owner.GetActorRotation().Quaternion(), FinalRotation.Quaternion(), SlerpSpeed);
        
        Owner.SetActorRotation(NewRotation);
    }

}