import GameFiles.UZEvents;

class UUZHealthComp : UActorComponent
{
    FEnemyDeathEvent EventEnemyDeath;

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
            EventEnemyDeath.Broadcast(); 
        }
    }

    UFUNCTION()
    void DamageHealth(float Amount)
    {
        CurrentHealth -= Amount;
    }
}