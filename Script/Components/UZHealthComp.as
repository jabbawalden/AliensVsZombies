import GameFiles.UZEvents;

class UUZHealthComp : UActorComponent
{
    FEnemyDeathEvent EventDeath;
    FUpdateLife EventUpdateLife;

    UPROPERTY()
    float CurrentHealth;

    UPROPERTY()
    float MaxHealth = 15.f;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        CurrentHealth = MaxHealth;
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