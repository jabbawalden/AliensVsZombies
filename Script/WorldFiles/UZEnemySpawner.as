import GameFiles.UZGameMode;

class AUZEnemySpawner : AActor
{
    float MaxSpawnDistance = 300.f;

    AUZGameMode GameMode;

    bool bCanSpawn;

    float NewSpawnTime;

    UPROPERTY()
    TSubclassOf<AActor> EnemySpawn1;
    AActor EnemySpawn1Ref;

    UPROPERTY()
    TSubclassOf<AActor> EnemySpawn2;
    AActor EnemySpawn2Ref;

    UPROPERTY()
    TSubclassOf<AActor> EnemySpawn3;
    AActor EnemySpawn3Ref;

    UPROPERTY()
    TSubclassOf<AActor> EnemySpawn4;
    AActor EnemySpawn4Ref;

    UPROPERTY()
    TSubclassOf<AActor> EnemySpawn5;
    AActor EnemySpawn5Ref;

    int MinRandom = 1;
    int MaxRandom = 8;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode());

        if (GameMode == nullptr)
        return;

        GameMode.EventEndGame.AddUFunction(this, n"EndSpawn");
        GameMode.EventStartGame.AddUFunction(this, n"StartSpawn");
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (bCanSpawn)
        {
            SpawnEnemyBehaviour();
        }
    }

    UFUNCTION()
    void SpawnEnemyBehaviour()
    {
        if (!bCanSpawn)
        return;

        if (NewSpawnTime <= Gameplay::TimeSeconds)
        {
            float NewRate = FMath::RandRange(GameMode.EnemyMinSpawnTime, GameMode.EnemyMaxSpawnTime);
            NewSpawnTime = Gameplay::TimeSeconds + NewRate;

            int SpawnIndexChance = FMath::RandRange(MinRandom, MaxRandom);


            //TODO see if a system with TMap would be better?
            
            switch(SpawnIndexChance)
            {
                case 1:
                    if (!GameMode.bCanSpawnEnemy5)
                        SpawnEnemy(EnemySpawn1Ref, EnemySpawn1);
                    else
                        SpawnEnemy(EnemySpawn5Ref, EnemySpawn5);
                    break;
                case 2:
                    if (!GameMode.bCanSpawnEnemy5)
                        SpawnEnemy(EnemySpawn1Ref, EnemySpawn1);
                    else
                        SpawnEnemy(EnemySpawn5Ref, EnemySpawn5);
                    break;
                case 3:
                    if (!GameMode.bCanSpawnEnemy4)
                        SpawnEnemy(EnemySpawn1Ref, EnemySpawn1);
                    else
                        SpawnEnemy(EnemySpawn4Ref, EnemySpawn4);
                    break;
                case 4:
                    if (!GameMode.bCanSpawnEnemy4)
                        SpawnEnemy(EnemySpawn1Ref, EnemySpawn1);
                    else
                        SpawnEnemy(EnemySpawn4Ref, EnemySpawn4);
                    break;
                case 5:
                    if (!GameMode.bCanSpawnEnemy4)
                        SpawnEnemy(EnemySpawn1Ref, EnemySpawn1);
                    else
                        SpawnEnemy(EnemySpawn4Ref, EnemySpawn4);
                    break;
                case 6:
                    if (GameMode.bCanSpawnEnemy2)
                        SpawnEnemy(EnemySpawn2Ref, EnemySpawn2);
                    break;
                case 7:
                    if (GameMode.bCanSpawnEnemy3)
                        SpawnEnemy(EnemySpawn3Ref, EnemySpawn3);
                    break;
                case 8:
                    if (GameMode.bCanSpawnEnemy3)
                        SpawnEnemy(EnemySpawn3Ref, EnemySpawn3);
                    break;

            }
        }
    }

    UFUNCTION()
    void SpawnEnemy(AActor SpawnRef, TSubclassOf<AActor> SpawnClass)
    {
        float XPosOffset = FMath::RandRange(-MaxSpawnDistance, MaxSpawnDistance);
        float YPosOffset = FMath::RandRange(-MaxSpawnDistance, MaxSpawnDistance);
        SpawnRef = SpawnActor(SpawnClass, FVector(ActorLocation.X + XPosOffset, ActorLocation.Y + YPosOffset, ActorLocation.Z));
    }

    UFUNCTION()
    void StartSpawn()
    {
        bCanSpawn = true;
    }

    UFUNCTION()
    void EndSpawn()
    {
        bCanSpawn = false;
    }
    
}