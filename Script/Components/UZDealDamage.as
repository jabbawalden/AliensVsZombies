import GameFiles.UZGameMode;
import Components.UZHealthComp;

class UUZDealDamage : UActorComponent
{
    UPROPERTY()
    float Damage = 10.f;
    
    float NewDMGTime;

    UPROPERTY()
    float AttackRate = 0.35f;

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