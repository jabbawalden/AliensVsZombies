import GameFiles.UZGameMode;

class AUZEnemySpawner : AActor
{
    float SpawnDistance = 120.f;

    AUZGameMode GameMode;

    bool bCanSpawn = true;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode());

        if (GameMode != nullptr)
        {
            GameMode.EventEndGame.AddUFunction(this, n"EndSpawn");
        }
    }

    UFUNCTION()
    void EndSpawn()
    {
        bCanSpawn = false;
        Print("End Spawn Called", 5.f);
    }
    
}