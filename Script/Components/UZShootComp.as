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

    UPROPERTY()
    USoundCue SoundComp;

    UFUNCTION()
    void PlaySound()
    {
        Gameplay::PlaySoundAtLocation(SoundComp, Owner.ActorLocation, Owner.ActorRotation, 1.f); 
    }

    UFUNCTION()
    void FireProjectile(TArray<USceneComponent> ShootOriginArray)
    {
        if (NewTime <= Gameplay::TimeSeconds)
        {
            NewTime = Gameplay::TimeSeconds + FireRate;
            PlaySound();

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
            }
        }
    }
} 