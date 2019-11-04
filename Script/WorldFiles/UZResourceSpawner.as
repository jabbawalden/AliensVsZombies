class AUZResourceSpawner : AActor
{
    UPROPERTY()
    TSubclassOf<AActor> ResourceToSpawn;
    AActor ResourceToSpawnRef;

    UPROPERTY()
    float SpawnMaxDistance = 1800.f;

    UPROPERTY()
    float MinRate = 6.f;

    UPROPERTY()
    float MaxRate = 10.f;

    float NewSpawnTime;

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (NewSpawnTime <= Gameplay::TimeSeconds)
        {
            float XOffset = FMath::RandRange(-SpawnMaxDistance, SpawnMaxDistance);
            float YOffset = FMath::RandRange(-SpawnMaxDistance, SpawnMaxDistance);
            FVector SpawnLoc = FVector(ActorLocation.X + XOffset, ActorLocation.Y + YOffset, ActorLocation.Z);

            float CurrentSpawnRate = FMath::RandRange(MinRate, MaxRate);
            NewSpawnTime = Gameplay::TimeSeconds + CurrentSpawnRate;
            ResourceToSpawnRef = SpawnActor(ResourceToSpawn, SpawnLoc);
        }
    }
}