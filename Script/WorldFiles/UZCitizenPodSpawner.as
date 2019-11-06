class AUZCitizenPodSpawner : AActor
{
    UPROPERTY()
    TSubclassOf<AActor> PodToSpawn;
    AActor PodToSpawnRef;

    UPROPERTY()
    float SpawnMaxDistance = 2200.f;

    UPROPERTY()
    float MinRate = 16.f;

    UPROPERTY()
    float MaxRate = 20.f;

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
            PodToSpawnRef = SpawnActor(PodToSpawn, SpawnLoc);
        }
    }
}