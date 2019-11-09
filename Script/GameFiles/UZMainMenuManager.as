import GameFiles.UZStaticFunctions;

class AUZMainMenuManager : AActor
{
    UPROPERTY()
    TSubclassOf<UUserWidget> MenuWidget;

    UPROPERTY(DefaultComponent)
    UInputComponent InputComp;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        bBlockInput = false;

        APlayerController PlayerController = Gameplay::GetPlayerController(0); 

        if (PlayerController == nullptr)
        return;

        AddWidgetToHUD(PlayerController, MenuWidget);

    }
}