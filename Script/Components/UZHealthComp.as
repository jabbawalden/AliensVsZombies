import GameFiles.UZEvents;
import GameFiles.UZGameMode;

enum HealthType {ZombieBasic, ZombieLarge};

class UUZHealthComp : UActorComponent
{
    FEnemyDeathEvent EventDeath;
    FUpdateLife EventUpdateLife;

    AUZGameMode GameMode;

    UPROPERTY()
    HealthType OurHealthType; 

    UPROPERTY()
    float CurrentHealth;

    UPROPERTY()
    float MaxHealth = 15.f;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode());
        
        if (GameMode != nullptr)
        {
            if (OurHealthType == HealthType::ZombieBasic)
                MaxHealth = GameMode.ZombieBasicMaxHealth;
            else if(OurHealthType == HealthType::ZombieLarge)
                MaxHealth = GameMode.ZombieLargeMaxHealth;

            CurrentHealth = MaxHealth;
        }

    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (CurrentHealth <= 0.f)
        {
            EventDeath.Broadcast(); 
        }
    }

    UFUNCTION()
    void DamageHealth(float Amount)
    {
        CurrentHealth -= Amount;
        EventUpdateLife.Broadcast();
    }

    UFUNCTION()
    float GetHealthPercent()
    {
        float Percent = CurrentHealth / MaxHealth;
        return Percent;
    }

}