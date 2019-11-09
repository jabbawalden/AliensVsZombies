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

        AddMainWidgetToHUD(PlayerController, MenuWidget);

        // BindStartInput();
    }

    // UFUNCTION()
    // void BindStartInput()
    // {
    //     Print("Bind Called", 5.f);
    //     InputComp.BindAction(n"StartButton", EInputEvent::IE_Pressed, FInputActionHandlerDynamicSignature(this, n"StartGame")); 
    // }

    // UFUNCTION()
    // void StartGame(FKey Key)
    // {
    //     Print("Start game called", 5.f);
    // }
}