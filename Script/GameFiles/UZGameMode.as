import GameFiles.UZEvents;

class AUZGameMode : AGameModeBase
{
    UPROPERTY()
    int Resources = 0;

    FGameEndEvent EventEndGame;
    FGameStartEvent EventStartGame;

    UPROPERTY()
    float Health = 1000.f;

    bool bGameEnded;

    bool bGameNotStarted = true;

    UFUNCTION()
    void ReduceHealth(float Amount)
    {
        Health -= Amount;
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        Print("Health = " + Health, 0.f);
        if (Health <= 0 && !bGameEnded)
        {
            bGameEnded = true;
            EndGame();
        }
    }

    UFUNCTION()
    void AddRemoveResources(int InputResources)
    {
        Resources += InputResources;
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
}