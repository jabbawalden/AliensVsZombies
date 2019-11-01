import GameFiles.UZGameMode;

class UUZDealDamage : UActorComponent
{
    UPROPERTY()
    float Damage = 15.f;

    UPROPERTY()
    float NewDMGTime;

    UPROPERTY()
    float AttackRate = 0.35f;

    UFUNCTION()
    void DealDamage(AUZGameMode GameMode)
    {
        if (NewDMGTime <= Gameplay::GetTimeSeconds())
        {
            NewDMGTime = Gameplay::GetTimeSeconds() + AttackRate;
            GameMode.ReduceHealth(Damage);
        }

    }
} 