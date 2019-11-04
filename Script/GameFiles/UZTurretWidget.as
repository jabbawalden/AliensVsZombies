class UUZTurretWidget : UUserWidget
{
    UFUNCTION(BlueprintEvent)
    UProgressBar GetProgressBar()
    {
        throw("You must use override GetHealthProgressBar from the widget blueprint to return the correct text widget.");
        return nullptr;
    }

    UFUNCTION()
    void UpdateLifeBar(float TargetPercent)
    {
        UProgressBar OurProgressBar = GetProgressBar();
        ProgressBar.Percent = TargetPercent;
    }

}