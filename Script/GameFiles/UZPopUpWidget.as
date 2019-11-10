class UUZPopUpWidget : UUserWidget
{
    UFUNCTION(BlueprintEvent)
    UTextBlock GetText()
    {
        throw("You must use override GetHealthProgressBar from the widget blueprint to return the correct text widget.");
        return nullptr;
    }

    UFUNCTION()
    void UpdatePopUpText(FString TextInput)
    {
        UTextBlock OurText = GetText();
        OurText.Text = FText::FromString(TextInput);
    }
}