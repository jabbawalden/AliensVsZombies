import PlayerFiles.UZProjectile;

class UUZShootComp : UActorComponent
{
    UPROPERTY()
    float FireRate = 0.3f;

    float NewTime;

    UPROPERTY()
    TSubclassOf<AActor> ProjectileClass;
    AActor ProjectileReference;

    AUZProjectile ProjectileCast;

    // UFUNCTION(BlueprintOverride)
    // void Tick(float DeltaSeconds)
    // {

    // }

    UFUNCTION()
    void FireProjectile(TArray<USceneComponent> ShootOriginArray)
    {
        if (NewTime <= Gameplay::TimeSeconds)
        {
            NewTime = Gameplay::TimeSeconds + FireRate;

            for (int i = 0; i < ShootOriginArray.Num(); i++)
            {
                ProjectileReference = SpawnActor(ProjectileClass, ShootOriginArray[i].GetWorldLocation()); 
                ProjectileCast = Cast<AUZProjectile>(ProjectileReference);

                if (ProjectileCast != nullptr)
                {
                    ProjectileCast.ShootDirection = Owner.GetActorForwardVector(); 
                }
            }

        }
    }
} 