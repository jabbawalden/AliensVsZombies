import GameFiles.UZGameMode;
import Components.UZHealthComp;
import Statics.UZStaticData;

class AUZProtectionPoint : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USphereComponent SphereComp;
    default SphereComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Block); 
    default SphereComp.SetCollisionObjectType(ECollisionChannel::ECC_WorldStatic);

    UPROPERTY(DefaultComponent, Attach = SphereComp)
    UStaticMeshComponent MeshComp;

    UPROPERTY(DefaultComponent)
    UUZHealthComp HealthComp;

    UPROPERTY(DefaultComponent, Attach = SphereComp)
    UWidgetComponent WidgetComp;

    AUZGameMode GameMode;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode()); 
        
        Tags.Add(UZTags::IsTracableByEnemy);       

        HealthComp.EventUpdateLife.AddUFunction(this, n"UpdateGameModeLife");
    }

    UFUNCTION()
    void UpdateGameModeLife()
    {
        GameMode.Life = HealthComp.CurrentHealth;
        GameMode.EventUpdateLife.Broadcast(); 
    }

}