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

    float EnemyMinSpawnTime = 1.f;
    float EnemyMaxSpawnTime = 2.5f;

    float IncreaseSpawnTimeRate = 2.f;
    float NewIncreaseSpawnTime;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Life = MaxLife;
        EventUpdateResources.Broadcast();
        EventUpdateLife.Broadcast();
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        Print("Life = " + Life, 0.f);
        Print("Resources = " + Resources, 0.f);
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
    void ReduceHealth(float Amount)
    {
        Life -= Amount;
        EventUpdateLife.Broadcast();
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
    void SetNewSpawnRates()
    {
        if (NewIncreaseSpawnTime <= Gameplay::TimeSeconds)
        {
            NewIncreaseSpawnTime = Gameplay::TimeSeconds + IncreaseSpawnTimeRate;
            Print("Spawntime rate increased", 5.f);
            EnemyMinSpawnTime /= 1.35f;
            EnemyMaxSpawnTime /= 1.35f;
        }
    }
}