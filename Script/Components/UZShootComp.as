import PlayerFiles.UZProjectile;

class UUZShootComp : UActorComponent
{
    UPROPERTY()
    float FireRate = 0.22f;

    float NewTime;

    UPROPERTY()
    TSubclassOf<AActor> ProjectileClass;
    AActor ProjectileRef;

    UPROPERTY()
    TSubclassOf<AActor> ParticleFX;
    AActor ParticleFXRef;

    AUZProjectile Projectile;

    UFUNCTION()
    void FireProjectile(TArray<USceneComponent> ShootOriginArray)
    {
        if (NewTime <= Gameplay::TimeSeconds)
        {
            NewTime = Gameplay::TimeSeconds + FireRate;

            for (int i = 0; i < ShootOriginArray.Num(); i++)
            {
                ProjectileRef = SpawnActor(ProjectileClass, ShootOriginArray[i].GetWorldLocation()); 
                Projectile = Cast<AUZProjectile>(ProjectileRef);

                if (Projectile != nullptr)
                {
                    Projectile.ShootDirection = Owner.GetActorForwardVector(); 
                }

                ParticleFXRef = SpawnActor(ParticleFX, ShootOriginArray[i].GetWorldLocation(), ShootOriginArray[i].GetWorldRotation());
            }
        }
    }
} 