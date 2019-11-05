import GameFiles.UZEvents;

class AUZGameMode : AGameModeBase
{
    UPROPERTY()
    int Resources = 0;

    FGameEndEvent EventEndGame;
    FGameStartEvent EventStartGame;
    FUpdateResources EventUpdateResources;
    FUpdateLife EventUpdateLife;
    FUpdateTurretBorder EventUpdateTurretBorder;
    FUpdateStunTrapBorder EventUpdateStunTrapBorder;
    FUpdateCitizenCountUI EventUpdateCitizenCountUI;

    //LIFE
    UPROPERTY()
    float Life;
    float MaxLife = 1500.f;

    //CITIZENS SAVED
    UPROPERTY()
    int CitizenSaveCount = 0;

    UPROPERTY()
    float CitizenUpRate = 0.5f;
    float NewCitizenUpTime;

    //COSTS
    UPROPERTY()
    float TurretCost = 200.f;

    UPROPERTY()
    float StunTrapCost = 50.f;

    //GAME STATE INFO
    bool bGameEnded;
    bool bGameNotStarted = true;

    float EnemyMinSpawnTime = 1.4f;
    float EnemyMaxSpawnTime = 1.8f;

    UPROPERTY()
    float SpawnIncreaseDivider = 1.05f;

    UPROPERTY()
    float IncreaseSpawnTimeRate = 11.f;
    float NewIncreaseSpawnTime;

    int SpawnDifficulty = 0;

    UPROPERTY()
    int Enemy2SpawnDifficulty = 15;
    UPROPERTY()
    int Enemy3SpawnDifficulty = 25;

    bool bCanSpawnEnemy2;
    bool bCanSpawnEnemy3;

    //ZOMBIE
    float ZombieBasicMaxHealth = 15.f;
    float ZombieLargeMaxHealth = 40.f;
    float ZombieHealthMultiplier = 1.05f;
;
    UPROPERTY()
    float ZombieNewHealthRate = 10.f;
    float ZombieNewHealthTime;

    //RESOURCES
    UPROPERTY()
    int MaxResourcesInLevel = 4;
    int CurrentResourcesInLevel;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Resources = 200;
        System::SetTimer(this, n"BroadCastWidgetEvents", 0.2f,false);
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        SetNewSpawnRates();
        SetNewZombieMaxHealth();
        SetNewCitizenCount();

        Print("" + Life, 0.f); 

        if (Life <= 0 && !bGameEnded)
        {
            bGameEnded = true;
            EndGame();
        }
    }

    UFUNCTION()
    void BroadCastWidgetEvents()
    {
        EventUpdateResources.Broadcast();
        EventUpdateLife.Broadcast();
        EventUpdateStunTrapBorder.Broadcast();
        EventUpdateTurretBorder.Broadcast();
        EventUpdateCitizenCountUI.Broadcast(CitizenSaveCount);
    }

    UFUNCTION()
    void AddRemoveResources(int InputResources)
    {
        Resources += InputResources;
        EventUpdateResources.Broadcast();
        EventUpdateStunTrapBorder.Broadcast();
        EventUpdateTurretBorder.Broadcast();
    }

    UFUNCTION()
    void StartGame()
    {
        EventStartGame.Broadcast();
        bGameNotStarted = false;
    }

    UFUNCTION()
    void EndGame()
    {
        EventEndGame.Broadcast();
        bGameEnded = true;
    }

    UFUNCTION()
    float LifePercent()
    {
        float Percent = Life / MaxLife;
        return Percent;
    }

    UFUNCTION()
    void SetNewSpawnRates()
    {
        if (NewIncreaseSpawnTime <= Gameplay::TimeSeconds)
        {
            NewIncreaseSpawnTime = Gameplay::TimeSeconds + IncreaseSpawnTimeRate;
            EnemyMinSpawnTime /= SpawnIncreaseDivider;
            EnemyMaxSpawnTime /= SpawnIncreaseDivider;
            SpawnDifficulty++;

            if (SpawnDifficulty >= Enemy2SpawnDifficulty)
            {
                bCanSpawnEnemy2 = true;
            }

            if (SpawnDifficulty >= Enemy3SpawnDifficulty)
            {
                bCanSpawnEnemy3 = true;
            }

        }
    }

    UFUNCTION()
    void SetNewZombieMaxHealth()
    {
        if (ZombieNewHealthTime <= Gameplay::TimeSeconds)
        {
            ZombieBasicMaxHealth *= ZombieHealthMultiplier;
            ZombieLargeMaxHealth *= ZombieHealthMultiplier;
            ZombieNewHealthTime = Gameplay::TimeSeconds + ZombieNewHealthRate; 
        }
    }

    UFUNCTION()
    void SetNewCitizenCount()
    {
        if (NewCitizenUpTime <= Gameplay::TimeSeconds)
        {
            NewCitizenUpTime = Gameplay::TimeSeconds + CitizenUpRate;
            CitizenSaveCount++;
            EventUpdateCitizenCountUI.Broadcast(CitizenSaveCount);
        }
    }
}