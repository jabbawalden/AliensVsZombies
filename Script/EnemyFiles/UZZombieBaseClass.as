class AUZZombieBaseClass : AActor
{
    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Print("Zombie base class detected", 5.f);
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        
    }
}