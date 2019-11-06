import GameFiles.UZGameMode;

class AUZPickUpObjectSpawner : AActor
{
    UPROPERTY()
    TSubclassOf<AActor> ObjectToSpawn;
    AActor ObjectToSpawnRef;

    UPROPERTY()
    float SpawnMaxDistance = 1900.f;

    UPROPERTY()
    float MinRate = 8.5f;

    UPROPERTY()
    float MaxRate = 14.f;

    float NewSpawnTime;

    AUZGameMode GameMode;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode()); 
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (GameMode == nullptr)
        return;
        
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
}