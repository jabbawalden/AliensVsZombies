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

    UPROPERTY()
    USoundCue AlertSound;

    bool bAlertSoundPlaying;

    AUZGameMode GameMode;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode()); 
        
        Tags.Add(UZTags::IsTracableByEnemy);       

        HealthComp.EventUpdateLife.AddUFunction(this, n"UpdateGameModeLife");
    }

    //perhaps life should be set in this comp instead properly - then when it reaches 0, call end game event instead.
    UFUNCTION()
    void UpdateGameModeLife()
    {
        GameMode.Life = HealthComp.CurrentHealth;
        GameMode.EventUpdateLife.Broadcast();
        PlayAlert();
        //if life equal or below 0, call EndGame event from game mode
    }

    UFUNCTION() 
    void PlayAlert()
    {
        if (!bAlertSoundPlaying)
        {
            Gameplay::PlaySound2D(AlertSound);
            bAlertSoundPlaying = true; 
            System::SetTimer(this, n"SetAlertToFalse", 1.2f, false);

            Print("Alert Sound Play", 5.f); 
        }
    }

    UFUNCTION()
    void SetAlertToFalse()
    {
        bAlertSoundPlaying = false;
    }

}