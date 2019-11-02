import GameFiles.UZGameMode;

class AUZEnemySpawner : AActor
{
    float SpawnDistance = 120.f;

    AUZGameMode GameMode;

    bool bCanSpawn = true;

    UPROPERTY()
    TSubclassOf<AActor> EnemySpawn1;
    AActor EnemySpawn1Ref;

    UPROPERTY()
    TSubclassOf<AActor> EnemySpawn2;
    AActor EnemySpawn2Ref;

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
    void SpawnEnemy()
    {
        //with some chance to spawn enemy 2
    }

    UFUNCTION()
    void EndSpawn()
    {
        bCanSpawn = false;
        Print("End Spawn Called", 5.f);
    }
    
}