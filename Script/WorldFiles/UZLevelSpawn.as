class AUZLevelSpawner : AActor
{
    UPROPERTY()
    TSubclassOf<AActor> ActorToSpawn;
    AActor ActorToSpawnRef;

    UPROPERTY(DefaultComponent)
    UNavModifierComponent NavModifier;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        // BuildLevel();
        // System::ExecuteConsoleCommand("RebuildNavigation");
    }

    UFUNCTION(BlueprintCallable)
    void BuildLevel()
    {
        float XPos = FMath::RandRange(-1000.f, 1000.f);
        float YPos = FMath::RandRange(-1000.f, 1000.f);
        ActorToSpawnRef = SpawnActor(ActorToSpawn, FVector(XPos, YPos, ActorLocation.Z));
    }
}