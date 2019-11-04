import GameFiles.UZGameMode;
import Components.UZHealthComp;

class UUZDealDamage : UActorComponent
{
    UPROPERTY()
    float Damage = 12.f;

    UPROPERTY()
    float NewDMGTime;

    UPROPERTY()
    float AttackRate = 0.35f;

    UFUNCTION()
    void DealProtectionPointDamage(AUZGameMode GameMode)
    {
        if (NewDMGTime <= Gameplay::GetTimeSeconds())
        {
            NewDMGTime = Gameplay::GetTimeSeconds() + AttackRate;
            GameMode.ReduceHealth(Damage);
        }
    }

    UFUNCTION()
    void DealTargetDamage(UUZHealthComp THealthComp)
    {
        if (NewDMGTime <= Gameplay::GetTimeSeconds())
        {
            NewDMGTime = Gameplay::GetTimeSeconds() + AttackRate;
            THealthComp.DamageHealth(Damage);
        }
    }
} 