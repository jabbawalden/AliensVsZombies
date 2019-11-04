import GameFiles.UZGameMode;

class AUZEnemySpawner : AActor
{
    float MaxSpawnDistance = 800.f;

    AUZGameMode GameMode;

    bool bCanSpawn = true;

    float NewSpawnTime;

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

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        SpawnEnemyBehaviour();
    }

    UFUNCTION()
    void SpawnEnemyBehaviour()
    {
        if (NewSpawnTime <= Gameplay::TimeSeconds)
        {
            float NewRate = FMath::RandRange(GameMode.EnemyMinSpawnTime, GameMode.EnemyMaxSpawnTime);
            NewSpawnTime = Gameplay::TimeSeconds + NewRate;

            int SpawnIndexChance = FMath::RandRange(1, 3);

            switch(SpawnIndexChance)
            {
                case 1:
                    //SpawnEnemy(EnemySpawn1Ref, EnemySpawn1);
                    SpawnEnemy(EnemySpawn2Ref, EnemySpawn2);
                    break;
                case 2:
                    if (GameMode.bCanSpawnEnemy2)
                    SpawnEnemy(EnemySpawn2Ref, EnemySpawn2);
                    break;
                case 3:
                    if (GameMode.bCanSpawnEnemy3)
                        SpawnEnemy(EnemySpawn2Ref, EnemySpawn2);
                    break;
            }
        }
    }

    UFUNCTION()
    void SpawnEnemy(AActor SpawnRef, TSubclassOf<AActor> SpawnClass)
    {
        float XPosOffset = FMath::RandRange(-MaxSpawnDistance, MaxSpawnDistance);
        float YPosOffset = FMath::RandRange(-MaxSpawnDistance, MaxSpawnDistance);
        SpawnRef = SpawnActor(SpawnClass, FVector(ActorLocation.X + XPosOffset, ActorLocation.Y + YPosOffset, ActorLocation.Z + 50.f));
    }


    UFUNCTION()
    void EndSpawn()
    {
        bCanSpawn = false;
    }
    
}