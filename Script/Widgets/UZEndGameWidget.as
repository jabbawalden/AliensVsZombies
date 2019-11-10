import GameFiles.UZGameMode;

class UUZEndgameWidget : UUserWidget
{
    AUZGameMode GameMode;

    UFUNCTION(BlueprintOverride)
    void Construct()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode());

        //construct does not seem to be adding funcs to events in time before they're broadcasted
        // if (GameMode != nullptr)
        // {
        //     GameMode.EventEndGame.AddUFunction(this, n"SetCitizensDisplayText");
        //     GameMode.EventEndGame.AddUFunction(this, n"TextFunc");
        // }
    }

    UFUNCTION(BlueprintEvent)
    UTextBlock GetCitizensDisplayText()
    {
        throw("You must use override GetCitizensDisplayText from the widget blueprint to return the correct text widget.");
        return nullptr;
    }

    UFUNCTION()
    void SetCitizensDisplayText()
    {
        UTextBlock CitizenDisplay = GetCitizensDisplayText();
        CitizenDisplay.Text = FText::FromString("" + GameMode.CitizenSaveCount + " Citizens were saved!!");
    }
}

