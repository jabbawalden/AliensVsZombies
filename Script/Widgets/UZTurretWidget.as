class UUZTurretWidget : UUserWidget
{
    UFUNCTION(BlueprintEvent)
    UProgressBar GetProgressBar()
    {
        throw("You must use override GetHealthProgressBar from the widget blueprint to return the correct text widget.");
        /*go to the widget blueprint that is inheriting this class
        override this function in blueprint and in the return node link the progress bar that you want to access
        when that is set up, every time you call this function inside angelscript, the override in BP will be called
        and it will return that progress bar.
        You can then alter it's values from here in Angelscript
        */
        return nullptr;
    }

    UFUNCTION()
    void UpdateLifeBar(float TargetPercent)
    {
        UProgressBar OurProgressBar = GetProgressBar();
        ProgressBar.Percent = TargetPercent;
    }

}