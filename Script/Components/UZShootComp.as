import PlayerFiles.UZProjectile;

enum ShootType {ShortBursts, SteadySingleShot}

class UUZShootComp : UActorComponent
{
    UPROPERTY()
    TSubclassOf<AActor> ProjectileClass;
    AActor ProjectileRef;

    UPROPERTY()
    TSubclassOf<AActor> ParticleFX;
    AActor ParticleFXRef;

    UPROPERTY()
    ShootType ShootSettings; 

    AUZProjectile Projectile;

    UPROPERTY()
    float FireRate = 0.22f;

    UPROPERTY()
    float BurstRate = 0.08f;

    float NewTime;

    float BurstTime;

    int CurrentBurst;

    UPROPERTY()
    int BurstMin = 4;

    UPROPERTY()
    int BurstMax = 6;

    FPlayShootCompSound PlayShootSound;

    UFUNCTION()
    void FireProjectile(TArray<USceneComponent> ShootOriginArray)
    {

        switch(ShootSettings)
        {
            case ShootType::ShortBursts:
            ShortBurstsBehaviour(ShootOriginArray);
            break;

            case ShootType::SteadySingleShot:
            SingleShotBehaviour(ShootOriginArray);
            break; 
        }
    }

    UFUNCTION()
    void ShortBurstsBehaviour(TArray<USceneComponent> ShootOriginArray)
    {
        int BurstNumber = FMath::RandRange(BurstMin, BurstMax);

        if (NewTime <= Gameplay::TimeSeconds)
        {
            if (BurstTime <= Gameplay::TimeSeconds)
            {
                if (CurrentBurst < BurstNumber)
                {
                    BurstTime = Gameplay::TimeSeconds + BurstRate;
                    CurrentBurst++;

                    for (int i = 0; i < ShootOriginArray.Num(); i++)
                    {
                        ProjectileRef = SpawnActor(ProjectileClass, ShootOriginArray[i].GetWorldLocation()); 
                        Projectile = Cast<AUZProjectile>(ProjectileRef);

                        if (Projectile != nullptr)
                        {
                            Projectile.ShootDirection = Owner.GetActorForwardVector(); 
                        }
                        
                        ParticleFXRef = SpawnActor(ParticleFX, ShootOriginArray[i].GetWorldLocation(), ShootOriginArray[i].GetWorldRotation());
                        ParticleFXRef.AttachToComponent(ShootOriginArray[i]);

                        PlayShootSound.Broadcast();
                    }
                }
                else 
                {
                    CurrentBurst = 0;
                    NewTime = Gameplay::TimeSeconds + FireRate;
                }
            }
        }

    }

    UFUNCTION()
    void SingleShotBehaviour(TArray<USceneComponent> ShootOriginArray)
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
                ParticleFXRef.AttachToComponent(ShootOriginArray[i]);

                PlayShootSound.Broadcast();
            }
        }
    }
} 