import GameFiles.UZEvents;
import GameFiles.UZGameMode;

enum HealthType {ProtectionPoint, ZombieBasic, ZombieLarge, Turret};

class UUZHealthComp : UActorComponent
{
    FEnemyDeathEvent EventDeath;
    FUpdateLife EventUpdateLife;

    AUZGameMode GameMode;

    UPROPERTY()
    HealthType OurHealthType; 

    float CurrentHealth;
    float MaxHealth = 15.f;

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
            }
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