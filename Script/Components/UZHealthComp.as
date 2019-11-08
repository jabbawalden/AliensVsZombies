import GameFiles.UZEvents;
import GameFiles.UZGameMode;

enum HealthType {ProtectionPoint, ZombieBasic, ZombieLarge, ZombieAdvanced, Turret};

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
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode());
        if (GameMode != nullptr)
        {
            switch (OurHealthType)
            {
                case HealthType::ProtectionPoint:
                MaxHealth = GameMode.MaxLife;
                break;

                case HealthType::ZombieBasic:
                MaxHealth = GameMode.ZombieBasicMaxHealth;
                break;

                case HealthType::ZombieLarge:
                MaxHealth = GameMode.ZombieLargeMaxHealth;
                break;

                case HealthType::ZombieAdvanced:
                MaxHealth = GameMode.ZombieAdvancedMaxHealth;
                break;
            }
            
            CurrentHealth = MaxHealth;
        }
    }

    // UFUNCTION(BlueprintOverride)
    // void Tick(float DeltaSeconds)
    // {

    // }

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