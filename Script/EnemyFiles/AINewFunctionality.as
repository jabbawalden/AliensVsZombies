class AINewFunctionality : AActor
{
    float RequiredDistanceToTarget = 40.f;
    FVector NextPathLocation;
    float MovementForce = 100.f;
    float VelocityChange = 100.f;

    UPROPERTY(DefaultComponent, RootComponent)
    UStaticMeshComponent Mesh;

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (LocalRole == ENetRole::ROLE_Authority)
        {
            float DistanceToTarget = (GetActorLocation() - NextPathPoint).Size();
            
            if(DistanceToTarget <= RequiredDistanceToTarget)
            {
                NextPathLocation = GetNextPathPoint();
            }
            else
            {
                //Keep moving 
                FVector ForceDirection = NextPathPoint - GetActorLocation();
                ForceDirection.Normalize();

                ForceDirection *= MovementForce;

                // Mesh.AddForce(ForceDirection, NAME_None, VelocityChange);
                
                //Debug
                // if(CVar_DebugBots.GetInt() > 0)
                // {
                //     System::DrawDebugArrow(GetActorLocation(), GetActorLocation() + ForceDirection, 32.0f, FLinearColor::Red, 1.0f, 2.0f);
                // }
            }
            //Debug
            // if(CVar_DebugBots.GetInt() > 0)
            // {
            //     System::DrawDebugSphere(NextPathPoint, 20.0f, 12, FLinearColor::Green, 5.0f, 2.0f);
            // }
        }
    }

    UFUNCTION()
    FVector GetNextPathPoint()
    {
        //Get Player Location

        ACharacter PlayerPawn = Gameplay::GetPlayerCharacter(0);

        if(PlayerPawn != nullptr)
        {
            UNavigationPath NavPath = UNavigationSystemV1::FindPathToActorSynchronously(GetActorLocation(), PlayerPawn);
            
            if (NavPath != nullptr && NavPath.PathPoints.Num() > 1)
            {
                return NavPath.PathPoints[1];
            }
        }
        // Failed
        return GetActorLocation();

    }
}
   
