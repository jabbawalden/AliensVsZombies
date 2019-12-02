import GameFiles.UZEvents;
import GameFiles.UZGameMode;

enum HealthType {ProtectionPoint, Zombie, Turret};

class UUZHealthComp : UActorComponent
{
    FEnemyDeathEvent EventDeath;
    
    FUpdateLife EventUpdateLife;

    AUZGameMode GameMode;

    UPROPERTY()
    HealthType OurHealthType; 

    UPROPERTY()
    float MaxHealth = 15.f;

    UPROPERTY()
    float CurrentHealth;


    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        if (OurHealthType == HealthType::ProtectionPoint)
        {
            GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode());
            if (GameMode != nullptr)
                MaxHealth = GameMode.MaxLife;
        }

        CurrentHealth = MaxHealth;

    }

    UFUNCTION()
    void DamageHealth(float Amount)
    {
        CurrentHealth -= Amount;
        EventUpdateLife.Broadcast();

        if (CurrentHealth <= 0.f)
        {
            EventDeath.Broadcast(); 
        }
    }

    UFUNCTION()
    void Heal(float Amount)
    {
        if (CurrentHealth < MaxHealth)
        {
            CurrentHealth += Amount;
            EventUpdateLife.Broadcast();
        }
    }

    UFUNCTION()
    float GetHealthPercent()
    {
        float Percent = CurrentHealth / MaxHealth;
        return Percent;
    }

}