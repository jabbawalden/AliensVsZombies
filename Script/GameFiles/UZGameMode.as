import GameFiles.UZEvents;

class AUZGameMode : AGameModeBase
{
    UPROPERTY()
    int Resources = 0;

    FGameEndEvent EventEndGame;
    FGameStartEvent EventStartGame;
    FUpdateResources EventUpdateResources;
    FUpdateLife EventUpdateLife;

    UPROPERTY()
    float Life;
    float MaxLife = 1000.f;

    bool bGameEnded;
    bool bGameNotStarted = true;

    float EnemyMinSpawnTime = 0.8f;
    float EnemyMaxSpawnTime = 2.1f;

    float SpawnIncreaseDivider = 1.1f;

    float IncreaseSpawnTimeRate = 10.f;
    float NewIncreaseSpawnTime;

    int SpawnDifficulty = 0;

    int Enemy2SpawnDifficulty = 5;
    int Enemy3SpawnDifficulty = 10;
    bool bCanSpawnEnemy2;
    bool bCanSpawnEnemy3;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Resources = 500;
        EventUpdateResources.Broadcast();
        EventUpdateLife.Broadcast();
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        SetNewSpawnRates();

        if (Life <= 0 && !bGameEnded)
        {
            bGameEnded = true;
            EndGame();
        }
    }

    UFUNCTION()
    void AddRemoveResources(int InputResources)
    {
        Resources += InputResources;
        EventUpdateResources.Broadcast();
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
                Print("Can spawn enemy 2", 5.f);
            }

            if (SpawnDifficulty >= Enemy3SpawnDifficulty)
            {
                bCanSpawnEnemy3 = true;
                Print("Can spawn enemy 3", 5.f);
            }

        }
    }
}