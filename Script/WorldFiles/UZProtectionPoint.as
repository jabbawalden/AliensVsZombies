import GameFiles.UZGameMode;
import Components.UZHealthComp;
import GameFiles.UZStaticData;

class AUZProtectionPoint : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USphereComponent SphereComp;
    default SphereComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Block); 

    UPROPERTY(DefaultComponent, Attach = SphereComp)
    UStaticMeshComponent MeshComp;

    UPROPERTY(DefaultComponent)
    UUZHealthComp HealthComp;

    AUZGameMode GameMode;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode()); 

        // if (GameMode != nullptr)
        // {
        //     // GameMode.Life = HealthComp.MaxHealth;
        //     // GameMode.MaxLife = HealthComp.MaxHealth;
        //     // GameMode.Life = 5.f;
        //     // GameMode.MaxLife = 5.f;
        // }
        
        Tags.Add(UZTags::IsTracableByEnemy);       
        Tags.Add(UZTags::IsTracableByPlayer);     

        HealthComp.EventUpdateLife.AddUFunction(this, n"UpdateGameModeLife");
    }

    UFUNCTION()
    void UpdateGameModeLife()
    {
        GameMode.Life = HealthComp.CurrentHealth;
        GameMode.EventUpdateLife.Broadcast(); 
    }

}