import GameFiles.UZGameMode;

enum SpawnType {ResourceObject, CitizenObject};

class AUZPickUpObjectSpawner : AActor
{
    UPROPERTY()
    TSubclassOf<AActor> ObjectToSpawn;
    AActor ObjectToSpawnRef;

    UPROPERTY()
    float SpawnMaxDistance = 1900.f;

    bool bCanSpawn;

    UPROPERTY()
    float MinRate = 6.5f;

    UPROPERTY()
    float MaxRate = 13.5f;

    float NewSpawnTime;

    UPROPERTY()
    SpawnType OurSpawnType;

    AUZGameMode GameMode;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode()); 

        if(GameMode == nullptr)
        return;

        GameMode.EventStartGame.AddUFunction(this, n"StartSpawn");
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (GameMode == nullptr)
        return;

        //return to stop spawning
        if (GameMode.bGameEnded)
        return;

        if (!bCanSpawn)
        return;

        switch(OurSpawnType)
        {
            case SpawnType::ResourceObject:
            SpawnResourceObjects();
            break;

            case SpawnType::CitizenObject:
            SpawnCitizenObjects();
            break;
        }

    }

    UFUNCTION()
    void StartSpawn()
    {
        bCanSpawn = true;
    }

    UFUNCTION()
    void SpawnResourceObjects()
    {
        if (NewSpawnTime <= Gameplay::TimeSeconds && GameMode.CurrentResourcesInLevel < GameMode.MaxResourcesInLevel)
        {
            float XOffset = FMath::RandRange(-SpawnMaxDistance, SpawnMaxDistance);
            float YOffset = FMath::RandRange(-SpawnMaxDistance, SpawnMaxDistance);
            FVector SpawnLoc = FVector(ActorLocation.X + XOffset, ActorLocation.Y + YOffset, ActorLocation.Z);

            float CurrentSpawnRate = FMath::RandRange(MinRate, MaxRate);
            NewSpawnTime = Gameplay::TimeSeconds + CurrentSpawnRate;
            ObjectToSpawnRef = SpawnActor(ObjectToSpawn, SpawnLoc);
        }
    }

    UFUNCTION()
    void SpawnCitizenObjects()
    {
        if (NewSpawnTime <= Gameplay::TimeSeconds && GameMode.CurrentCitizenPods < GameMode.MaxCitizenPods)
        {
            float XOffset = FMath::RandRange(-SpawnMaxDistance, SpawnMaxDistance);
            float YOffset = FMath::RandRange(-SpawnMaxDistance, SpawnMaxDistance);
            FVector SpawnLoc = FVector(ActorLocation.X + XOffset, ActorLocation.Y + YOffset, ActorLocation.Z);

            float CurrentSpawnRate = FMath::RandRange(MinRate, MaxRate);
            NewSpawnTime = Gameplay::TimeSeconds + CurrentSpawnRate;
            ObjectToSpawnRef = SpawnActor(ObjectToSpawn, SpawnLoc);
        }
    }
}