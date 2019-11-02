import GameFiles.UZGameMode;

class UUZPlayerMainWidget : UUserWidget
{
    AUZGameMode GameMode;
    
    UFUNCTION(BlueprintOverride)
    void Construct()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode());

        if (GameMode != nullptr)
        {
            GameMode.EventUpdateLife.AddUFunction(this, n"UpdateLifeBar");
            GameMode.EventUpdateResources.AddUFunction(this, n"UpdateResourcesText");
        } 
    }

    UFUNCTION(BlueprintEvent)
    UTextBlock GetResourceWidgetText()
    {
        throw("You must use override GetResourceWidgetText from the widget blueprint to return the correct text widget.");
        return nullptr;
    }

    UFUNCTION(BlueprintEvent)
    UProgressBar GetHealthProgressBar()
    {
        throw("You must use override GetHealthProgressBar from the widget blueprint to return the correct text widget.");
        return nullptr;
    }

    UFUNCTION()
    void UpdateResourcesText()
    {
        UTextBlock ResourceDisplay = GetResourceWidgetText();
        ResourceDisplay.Text = FText::FromString("" + GameMode.Resources); 
    }

    UFUNCTION()
    void UpdateLifeBar()
    {
        UProgressBar ProgressBar = GetHealthProgressBar();
        ProgressBar.Percent = GameMode.LifePercent();
    }

}

UFUNCTION(Category = "Player HUD")
void AddMainWidgetToHUD(APlayerController PlayerController, TSubclassOf<UUserWidget> WidgetClass)
{
    UUserWidget UserWidget = WidgetBlueprint::CreateWidget(WidgetClass, PlayerController);
    UserWidget.AddToViewport();
}