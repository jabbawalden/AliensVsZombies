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
    float MaxLife = 3500.f;

    //CITIZENS SAVED
    UPROPERTY()
    int CitizenSaveCount = 0;

    UPROPERTY()
    float CitizenUpRate = 0.5f;
    float NewCitizenUpTime;

    //RESOURCE COSTS
    UPROPERTY()
    float TurretCost = 350.f;

    UPROPERTY()
    float StunTrapCost = 100.f;

    //GAME STATE INFO
    bool bGameEnded;
    bool bGameNotStarted = true;

    float EnemyMinSpawnTime = 1.9f;
    float EnemyMaxSpawnTime = 2.6f;

    UPROPERTY()
    float SpawnIncreaseDivider = 1.03f;

    UPROPERTY()
    float IncreaseSpawnTimeRate = 11.f;
    float NewIncreaseSpawnTime;

    int SpawnDifficulty = 0;

    UPROPERTY()
    int Enemy2SpawnDifficulty = 8;
    UPROPERTY()
    int Enemy3SpawnDifficulty = 16;

    bool bCanSpawnEnemy2;
    bool bCanSpawnEnemy3;

    //ZOMBIE VALUES
    UPROPERTY()
    float ZombieBasicMaxHealth = 15.f;
    UPROPERTY()
    float ZombieLargeMaxHealth = 50.f;
    UPROPERTY()
    float ZombieHealthMultiplier = 1.03f;

    UPROPERTY()
    float ZombieNewHealthRate = 10.f;
    float ZombieNewHealthTime;

    float GlobalMovementSpeed = 100.f;

    UPROPERTY()
    float GlobalMovementSpeedMultiplier = 1.03f;

    UPROPERTY()
    float ZombieNewMoveSpeedRate = 8.f;
    float ZombieNewMoveSpeedTime;


    //RESOURCE OBJECTS
    UPROPERTY()
    int MaxResourcesInLevel = 5;
    int CurrentResourcesInLevel;
    int MaxCitizenPods = 3;
    int CurrentCitizenPods;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Resources = 400;
        System::SetTimer(this, n"BroadCastWidgetEvents", 0.2f,false);
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (Life <= 0 && !bGameEnded)
        {
            bGameEnded = true;
            EndGame();
        }
        else
        {
            SetNewSpawnRates();
            SetNewZombieMaxHealth();
            SetNewCitizenCount();
            SetNewZombieSpeed();
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
    void AddCitizenCount(int Amount)
    {
        CitizenSaveCount += Amount;
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
    void SetNewZombieSpeed()
    {
        if (ZombieNewMoveSpeedTime <= Gameplay::TimeSeconds)
        {
            GlobalMovementSpeed *= GlobalMovementSpeedMultiplier;
            ZombieNewMoveSpeedTime = Gameplay::TimeSeconds + ZombieNewMoveSpeedRate; 
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