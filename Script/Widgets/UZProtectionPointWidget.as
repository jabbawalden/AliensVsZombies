import GameFiles.UZGameMode;

class UUZProtectionPointWidget : UUserWidget
{
    AUZGameMode GameMode;

    UFUNCTION(BlueprintOverride)
    void Construct()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode());

        if (GameMode != nullptr)
        {
            GameMode.EventUpdateLife.AddUFunction(this, n"UpdateLifeBar");
            GameMode.EventUpdateCitizenCountUI.AddUFunction(this, n"UpdateCitizenCount");
        } 
    }

    UFUNCTION(BlueprintEvent)
    UTextBlock GetCitizenCountText()
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
    void UpdateLifeBar()
    {
        UProgressBar ProgressBar = GetHealthProgressBar();
        ProgressBar.Percent = GameMode.LifePercent();
    }

    UFUNCTION()
    void UpdateCitizenCount(int CitizenCount)
    {
        UTextBlock CitizenDisplay = GetCitizenCountText();
        CitizenDisplay.Text = FText::FromString("Citizens Saved: " + CitizenCount);
    }
}